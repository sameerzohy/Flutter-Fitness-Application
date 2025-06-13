import 'package:fitness_app/features/exercise_tracker/presentation/blocs/scheduled_workout/scheduled_workout_bloc.dart';
import 'package:fitness_app/features/exercise_tracker/presentation/blocs/workout_history_bloc/workout_history_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:hive_flutter/hive_flutter.dart';

import 'package:fitness_app/core/cubits/cubit/app_user_cubit.dart';
import 'package:fitness_app/core/theme/theme.dart'; // Assuming AppTheme is here
import 'package:fitness_app/core/utilities/loader.dart'; // Assuming Loader is here
import 'package:fitness_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:fitness_app/features/auth/presentation/pages/register_2_ui.dart';
import 'package:fitness_app/features/auth/presentation/pages/signin_ui.dart';
import 'package:fitness_app/features/auth/presentation/pages/signup_ui.dart';
import 'package:fitness_app/home_page.dart';
import 'package:fitness_app/init_dependency.dart';




void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  await Hive.openBox('userBox');
  await Hive.openBox<List>('workout_history');

  await initDependency();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => sl<AuthBloc>()),
        BlocProvider(create: (context) => sl<AppUserCubit>()),
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
      home:  AppScreen(),
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
          return  HomePage(); // Your main app home page
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