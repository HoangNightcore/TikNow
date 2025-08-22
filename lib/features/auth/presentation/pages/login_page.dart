import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tix_now/features/auth/bloc/auth_event.dart';
import 'package:tix_now/features/auth/presentation/widgets/custom_button.dart';
import 'package:tix_now/features/auth/presentation/widgets/custom_checkbox.dart';
import 'package:tix_now/features/auth/presentation/widgets/custom_text_field.dart';
import 'package:tix_now/features/auth/presentation/widgets/gradient_background.dart';
import '../../bloc/auth_bloc.dart';
import '../../bloc/auth_state.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _rememberMe = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<AuthBloc>().add(AuthSubcriptionRequested());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state.status == AuthStatus.failure && state.error != null) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.error!)));
          }
        },
        builder: (context, state) {
          final loading = state.status == AuthStatus.loading;
          return GradientBackground(
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),

                    // Back button and title
                    Row(
                      children: [
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(
                            Icons.arrow_back_ios,
                            color: Colors.white,
                          ),
                        ),
                        const Spacer(),
                        const Text(
                          'Sign In',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const Spacer(),
                        const SizedBox(width: 48), // Balance the back button
                      ],
                    ),

                    const SizedBox(height: 60),

                    // Username field
                    CustomTextField(
                      label: 'Enter Username',
                      hintText: 'Username',
                      controller: _email,
                    ),

                    const SizedBox(height: 75),

                    // Password field
                    CustomTextField(
                      label: 'Enter Password',
                      hintText: 'Password',
                      isPassword: true,
                      controller: _password,
                    ),

                    const SizedBox(height: 70),

                    // Remomber me and forgot password
                    Row(
                      children: [
                        CustomCheckbox(
                          value: _rememberMe,
                          onChanged: (value) {
                            setState(() {
                              _rememberMe = value ?? false;
                            });
                          },
                          text: 'Remember me',
                        ),
                        const Spacer(),
                        GestureDetector(
                          onTap: () {
                            // Handle forgot password
                          },
                          child: const Text(
                            'Forgot password?',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color.fromRGBO(252, 196, 52, 1),
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const Spacer(),

                    // Sign in button
                    CustomButton(
                      text: 'Sign In',
                      onPressed: loading
                          ? null
                          : () => context.read<AuthBloc>().add(
                              AuthSignInWithEmailSubmitted(
                                _email.text.trim(),
                                _password.text.trim(),
                              ),
                            ),
                    ),

                    const SizedBox(height: 24),

                    // Sign up link
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Dont have account? ',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pushNamed('/register');
                          },
                          child: const Text(
                            'Sign up',
                            style: TextStyle(
                              color: Color.fromRGBO(252, 196, 52, 1),
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 50),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
