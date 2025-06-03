import 'package:fitness_app/core/cubits/cubit/app_user_cubit.dart';
import 'package:fitness_app/core/utilities/loader.dart';
import 'package:fitness_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:fitness_app/features/auth/presentation/widgets/auth_gradient_button.dart';
import 'package:fitness_app/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SuccessfulRegister extends StatelessWidget {
  final Map<String, dynamic> details;
  const SuccessfulRegister({super.key, required this.details});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppUserCubit, AppUserState>(
      listener: (context, state) {
        if (state is AppUserIsLoggedIn) {
          Navigator.of(context).popUntil((route) => route.isFirst);
        }
      },
      builder: (context, state) {
        if (state is AppUserLoading) {
          return const Loader();
        }
        if (state is AppUserIsLoggedIn) {
          return HomePage();
        }
        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 30,
                vertical: 8.0,
              ),
              child: Column(
                children: [
                  const SizedBox(height: 30),
                  Image.asset('assets/images/successful_registration.png'),
                  const SizedBox(height: 20),
                  Text(
                    'Welcome, Stefani',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'You are all set now, let\'s reach your goals together with us',
                    style: TextStyle(fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  const Spacer(),
                  AuthGradientButton(
                    buttonText: 'Go To Home',
                    onPressed: () {
                      context.read<AuthBloc>().add(
                        UpdateUser(
                          dob: details['dob'],
                          gender: details['gender'],
                          height: details['height'],
                          weight: details['weight'],
                          goal: details['goal'],
                          bmi: details['bmi'],
                        ),
                      );
                      context.read<AppUserCubit>().appUserLoader();
                      // Then recheck user status to emit AppUserIsLoggedIn
                      // context.read<AppUserCubit>().checkUserStatus(); // Make sure this is defined
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
