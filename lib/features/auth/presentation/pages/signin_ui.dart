import 'package:fitness_app/core/cubits/cubit/app_user_cubit.dart';
import 'package:fitness_app/core/entities/user.dart';
import 'package:fitness_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:fitness_app/features/auth/presentation/pages/signup_ui.dart';
import 'package:fitness_app/features/auth/presentation/widgets/auth_gradient_button.dart';
import 'package:fitness_app/features/auth/presentation/widgets/auth_textfied.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginInPage extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (context) => LoginInPage());

  const LoginInPage({super.key});

  @override
  State<LoginInPage> createState() => _LoginInPageState();
}

class _LoginInPageState extends State<LoginInPage> {
  final passwordController = TextEditingController();
  final emailController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(actions: []),
      body: Container(
        height: double.infinity,
        margin: EdgeInsets.symmetric(horizontal: 25),
        child: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthFailure) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.message)));
            }
          },
          builder: (context, state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
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
                  'Welcome Back',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 27, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                Form(
                  key: formKey,
                  child: Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Container(
                          child: Column(
                            children: [
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
                              TextButton(
                                onPressed: () {},
                                child: Text('Forgot Password?'),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        AuthGradientButton(
                          buttonText: 'Log In',
                          onPressed: () {
                            // context.read<AppUserCubit>().appUserLoader();
                            print('Hello from SignIn Page');
                            context.read<AuthBloc>().add(
                              AuthLogIn(
                                email: emailController.text.trim(),
                                password: passwordController.text.trim(),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Don't have an account?"),
                            ElevatedButton(
                              onPressed: () {
                                context.read<AppUserCubit>().appSignupPage();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                padding: EdgeInsets.only(left: -5),
                              ),

                              child: Text(
                                'Register',
                                style: TextStyle(color: Color(0xFF6B50F6)),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
