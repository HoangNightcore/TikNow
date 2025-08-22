import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tix_now/features/auth/bloc/auth_event.dart';
import 'package:tix_now/features/auth/presentation/widgets/custom_button.dart';
import 'package:tix_now/features/auth/presentation/widgets/custom_checkbox.dart';
import 'package:tix_now/features/auth/presentation/widgets/custom_text_field.dart';
import 'package:tix_now/features/auth/presentation/widgets/gradient_background.dart';
import '../../bloc/auth_bloc.dart';
import '../../bloc/auth_state.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _displayName = TextEditingController();

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
                          'Sign Up',
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

                    // Email field
                    CustomTextField(
                      label: 'Enter Email',
                      hintText: 'Email',
                      controller: _email,
                    ),

                    const SizedBox(height: 75),

                    // Password field
                    CustomTextField(
                      label: 'Enter Passsword',
                      isPassword: true,
                      hintText: 'Password',
                      controller: _password,
                    ),

                    const SizedBox(height: 75),

                    // DisplayName field
                    CustomTextField(
                      label: 'Enter Display Name',
                      hintText: 'DisplayName',
                      controller: _displayName,
                    ),

                    const Spacer(),

                    // Register button
                    CustomButton(
                      text: 'Sign up',
                      onPressed: loading
                          ? null
                          : () => context.read<AuthBloc>().add(
                              AuthSignUpWithEmailSubmitted(
                                _email.text.trim(),
                                _password.text.trim(),
                                displayName: _displayName.text.trim(),
                              ),
                            ),
                    ),

                    const SizedBox(height: 24),

                    // Login link
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Have an account?',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pushNamed('/login');
                          },
                          child: const Text(
                            'Sign In',
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
