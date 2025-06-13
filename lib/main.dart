import 'package:fitness_app/features/exercise_tracker/presentation/blocs/scheduled_workout/scheduled_workout_bloc.dart';
import 'package:fitness_app/features/exercise_tracker/presentation/blocs/workout_history_bloc/workout_history_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

import 'package:fitness_app/core/cubits/cubit/app_user_cubit.dart';
import 'package:fitness_app/core/hive/local_user_data.dart';
import 'package:fitness_app/core/local_remote_connection/local_remote_connection.dart';
import 'package:fitness_app/core/local_remote_connection/meal_push_remote.dart';
import 'package:fitness_app/core/theme/theme.dart';
import 'package:fitness_app/core/utilities/loader.dart';
import 'package:fitness_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:fitness_app/features/auth/presentation/pages/register_2_ui.dart';
import 'package:fitness_app/features/auth/presentation/pages/signin_ui.dart';
import 'package:fitness_app/features/auth/presentation/pages/signup_ui.dart';
import 'package:fitness_app/features/calorie_tracker/data/hive_models/hive_daily_meal.dart';
import 'package:fitness_app/features/calorie_tracker/data/hive_models/hive_meal_item.dart';
import 'package:fitness_app/features/calorie_tracker/presentation/bloc/meal_track_bloc/meal_track_bloc.dart';
import 'package:fitness_app/features/calorie_tracker/presentation/bloc/meal_utility_bloc/meal_utilities_bloc.dart';
import 'package:fitness_app/home_page.dart';
import 'package:fitness_app/init_dependency.dart'; // Make sure this defines `final sl = GetIt.instance;`

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final dir = await getApplicationDocumentsDirectory();
  Hive.init(dir.path);

  Hive.registerAdapter(HiveMealItemAdapter());
  Hive.registerAdapter(HiveDailyMealAdapter());
  Hive.registerAdapter(LocalUserDataAdapter());

  await Hive.openBox<HiveDailyMeal>('daily_meals');
  await Hive.openBox<HiveMealItem>('daily_meal_box');
  await Hive.openBox<LocalUserData>('userBox');
  await Hive.openBox<List>('workout_history');

  await initDependency();
  await initializeUserData(sl());
  await pushMealToSupabase(sl(), sl());

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => sl<AuthBloc>()),
        BlocProvider(create: (context) => sl<AppUserCubit>()),
        BlocProvider(create: (context) => sl<MealTrackBloc>()),
        BlocProvider(create: (context) => sl<MealUtilitiesBloc>()),
        BlocProvider(create: (context) => sl<WorkoutHistoryBloc>()),
        BlocProvider(create: (context) => sl<ScheduledWorkoutBloc>()),
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
