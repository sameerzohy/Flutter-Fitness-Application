import 'package:fitness_app/core/cubits/cubit/app_user_cubit.dart';
import 'package:fitness_app/core/theme/theme.dart';
import 'package:fitness_app/core/utilities/loader.dart';
import 'package:fitness_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:fitness_app/features/auth/presentation/pages/register_2_ui.dart';
import 'package:fitness_app/features/auth/presentation/pages/signin_ui.dart';
import 'package:fitness_app/features/auth/presentation/pages/signup_ui.dart';
import 'package:fitness_app/home_page.dart';
// import 'package:fitness_app/features/auth/presentation/pages/signup_ui.dart';
import 'package:fitness_app/init_dependency.dart';
import 'package:flutter/material.dart';
// import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDependency();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => serviceLocator<AuthBloc>()),
        BlocProvider(create: (context) => serviceLocator<AppUserCubit>()),
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
      listener: (context, state) {
        print('Bloc State Changed: $state');
      },
      builder: (context, state) {
        print('hello $state');
        if (state is AppUserLoading) {
          return Loader();
        } else if (state is AppGetUserInfo) {
          return Register2Ui();
        } else if (state is AppUserIsLoggedIn) {
          print('Cuurent Updated State: AppUserIsLoggedIn');
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
