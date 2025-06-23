import 'package:fitness_app/features/exercise_tracker/presentation/blocs/scheduled_workout/scheduled_workout_bloc.dart';
import 'package:fitness_app/features/exercise_tracker/presentation/blocs/workout_history_bloc/workout_history_bloc.dart';
import 'package:fitness_app/features/home_screen/presentation/bloc/sleep_tracker_bloc/sleep_tracker_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

import 'package:fitness_app/core/cubits/cubit/app_user_cubit.dart';
import 'package:fitness_app/core/hive/local_user_data.dart';
import 'package:fitness_app/core/local_remote_connection/local_remote_connection.dart';
import 'package:fitness_app/core/local_remote_connection/meal_push_remote.dart';
import 'package:fitness_app/core/notifications/local_push_notifications.dart';
import 'package:fitness_app/core/theme/theme.dart';
import 'package:fitness_app/core/utilities/init_other_tracker.dart';
import 'package:fitness_app/core/utilities/loader.dart';
import 'package:fitness_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:fitness_app/features/auth/presentation/pages/register_2_ui.dart';
import 'package:fitness_app/features/auth/presentation/pages/signin_ui.dart';
import 'package:fitness_app/features/auth/presentation/pages/signup_ui.dart';
import 'package:fitness_app/features/calorie_tracker/data/hive_models/hive_daily_meal.dart';
import 'package:fitness_app/features/calorie_tracker/data/hive_models/hive_meal_item.dart';
import 'package:fitness_app/features/calorie_tracker/presentation/bloc/meal_track_bloc/meal_track_bloc.dart';
import 'package:fitness_app/features/calorie_tracker/presentation/bloc/meal_utility_bloc/meal_utilities_bloc.dart';
import 'package:fitness_app/features/home_screen/data/hive_models/other_tracker_hive.dart';
import 'package:fitness_app/features/home_screen/presentation/bloc/other_tracker_bloc/other_tracker_bloc.dart';
import 'package:fitness_app/home_page.dart';
// import 'package:fitness_app/features/auth/presentation/pages/signup_ui.dart';
import 'package:fitness_app/init_dependency.dart';
// import 'package:animated_splash_screen/animated_splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await NotificationService.setupNotifications();

  final dir = await getApplicationDocumentsDirectory();
  Hive.init(dir.path);

  Hive.registerAdapter(HiveMealItemAdapter());
  Hive.registerAdapter(HiveDailyMealAdapter());
  Hive.registerAdapter(LocalUserDataAdapter());
  Hive.registerAdapter(OtherTrackerHiveAdapter());

  await Hive.openBox<HiveDailyMeal>('daily_meals');
  await Hive.openBox<HiveMealItem>('daily_meal_box');
  await Hive.openBox<LocalUserData>('userBox');
  await Hive.openBox<List>('workout_history');
  await Hive.openBox<OtherTrackerHive>('other_tracker_hive');
  await Hive.openBox('meta_box');

  await initDependency();

  // await refreshSession(serviceLocator());

  await initializeUserData(sl());

  await pushMealToSupabase(sl(), sl());
  // ✅ Safe to initialize dependencies now

  await initOtherTracker(sl());

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => sl<AuthBloc>()),
        BlocProvider(create: (context) => sl<AppUserCubit>()),
        BlocProvider(create: (context) => sl<MealTrackBloc>()),
        BlocProvider(create: (context) => sl<MealUtilitiesBloc>()),
        BlocProvider(create: (context) => sl<WorkoutHistoryBloc>()),
        BlocProvider(create: (context) => sl<ScheduledWorkoutBloc>()),
        BlocProvider(create: (context) => sl<OtherTrackerBloc>()),
        BlocProvider(create: (context) => sl<SleepTrackerBloc>()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    context.read<AuthBloc>().add(AuthUserIsLoggedIn());
  }

  @override
  void dispose() {
    Hive.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: AppTheme.lightThemeMode,
      home: const AppScreen(),
    );
  }
}

class AppScreen extends StatelessWidget {
  const AppScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppUserCubit, AppUserState>(
      listener: (context, state) {
        debugPrint('Bloc State Changed: $state');
      },
      builder: (context, state) {
        debugPrint('Current AppUserState: $state');
        if (state is AppUserLoading) {
          return const Loader();
        } else if (state is AppGetUserInfo) {
          return const Register2Ui();
        } else if (state is AppUserIsLoggedIn) {
          return const HomePage();
        } else if (state is AppLogInPage) {
          return const LoginInPage();
        } else if (state is AppSignUpPage) {
          return const SignUpPage();
        } else {
          return const Scaffold(body: Center(child: Text('Loading...')));
        }
      },
    );
  }
}
