import 'package:fitness_app/core/cubits/cubit/app_user_cubit.dart';
import 'package:fitness_app/core/utilities/loader.dart';
import 'package:fitness_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:fitness_app/features/auth/presentation/pages/signin_ui.dart';
import 'package:fitness_app/features/auth/presentation/widgets/auth_gradient_button.dart';
import 'package:fitness_app/features/auth/presentation/widgets/auth_textfied.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUpPage extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (context) => SignUpPage());
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    return Scaffold(
      // appBar: AppBar(actions: []),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 25),
        child: SafeArea(
          child: BlocConsumer<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is AuthFailure) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(state.message)));
              }
              if (state is AuthSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Verify your email and login with your credentials',
                    ),
                  ),
                );
                Navigator.pushReplacement(context, LoginInPage.route());
              }
            },
            builder: (context, state) {
              if (state is AuthLoading) {
                return const Loader();
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 50),
                  SizedBox(
                    width: double.infinity,
                    child: Text(
                      'Hey there,',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 22),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Create an account',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 27, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  Form(
                    key: formKey,
                    child: Column(
                      children: [
                        AuthTextField(
                          hintText: 'Full Name',
                          controller: nameController,
                        ),
                        const SizedBox(height: 20),
                        AuthTextField(
                          hintText: 'Email',
                          controller: emailController,
                        ),
                        const SizedBox(height: 20),
                        AuthTextField(
                          hintText: 'Password',
                          isObscureText: true,
                          controller: passwordController,
                        ),
                        const SizedBox(height: 40),
                        AuthGradientButton(
                          buttonText: 'Sign Up',
                          onPressed: () {
                            context.read<AppUserCubit>().appUserLoader();
                            context.read<AuthBloc>().add(
                              AuthSignUp(
                                email: emailController.text.trim(),
                                password: passwordController.text.trim(),
                                name: nameController.text.trim(),
                              ),
                            );
                          },
                        ),

                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Already have an account?'),
                            ElevatedButton(
                              onPressed: () {
                                context.read<AppUserCubit>().appLogInPage();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                padding: EdgeInsets.all(0),
                              ),

                              child: Text(
                                'Login    ',
                                style: TextStyle(color: Color(0xFF6B50F6)),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
