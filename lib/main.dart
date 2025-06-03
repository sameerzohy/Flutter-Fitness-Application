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
// import 'package:fitness_app/features/auth/presentation/pages/signup_ui.dart';
import 'package:fitness_app/init_dependency.dart';
import 'package:flutter/material.dart';
// import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final dir = await getApplicationDocumentsDirectory();
  Hive.init(dir.path);

  Hive.registerAdapter(HiveMealItemAdapter());
  Hive.registerAdapter(HiveDailyMealAdapter());
  Hive.registerAdapter(LocalUserDataAdapter());

  // ✅ Open both boxes BEFORE DI is initialized
  await Hive.openBox<HiveDailyMeal>('daily_meals');
  await Hive.openBox<HiveMealItem>('daily_meal_box');
  await Hive.openBox<LocalUserData>('userBox');

  await initDependency();

  // await refreshSession(serviceLocator());

  await initializeUserData(serviceLocator());

  await pushMealToSupabase(serviceLocator(), serviceLocator());
  // ✅ Safe to initialize dependencies now

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => serviceLocator<AuthBloc>()),
        BlocProvider(create: (context) => serviceLocator<AppUserCubit>()),
        BlocProvider(create: (context) => serviceLocator<MealTrackBloc>()),
        BlocProvider(create: (context) => serviceLocator<MealUtilitiesBloc>()),
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
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: AppTheme.lightThemeMode,
      home: AppScreen(),
      // AnimatedSplashScreen(
      //   splash: 'assets/gifs/homescreenGIF.gif',
      //   splashIconSize: 500,
      //   nextScreen: AppScreen(),
      // ),
    );
  }
}

class AppScreen extends StatelessWidget {
  const AppScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppUserCubit, AppUserState>(
      listener: (context, state) {},
      builder: (context, state) {
        if (state is AppUserLoading) {
          return Loader();
        } else if (state is AppGetUserInfo) {
          return Register2Ui();
        } else if (state is AppUserIsLoggedIn) {
          return HomePage();
        } else if (state is AppLogInPage) {
          return LoginInPage(); // Not logged in
        } else if (state is AppSignUpPage) {
          return SignUpPage();
        } else {
          return Scaffold(body: Center(child: Text('Loading...')));
        }
      },
    );
  }
}
