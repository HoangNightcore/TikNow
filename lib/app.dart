import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tix_now/features/auth/bloc/auth_bloc.dart';
import 'package:tix_now/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:tix_now/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:tix_now/features/auth/domain/repositories/auth_repository.dart';
import 'package:tix_now/features/auth/presentation/pages/login_page.dart';
import 'package:tix_now/features/auth/presentation/pages/register_page.dart';
import 'package:tix_now/features/auth/presentation/pages/login_page.dart';
import 'package:tix_now/features/auth/presentation/pages/splash_screen.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    final authRepo = AuthRepositoryImpl(
      AuthRemoteDataSource(FirebaseAuth.instance, FirebaseFirestore.instance),
    );

    return RepositoryProvider<AuthRepository>.value(
      value: authRepo,
      child: BlocProvider<AuthBloc>(
        create: (_) => AuthBloc(authRepo),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          routes: {
            '/splash': (_) => const SplashScreen(),
            '/login': (_) => const LoginPage(),
            '/register': (_) => const RegisterPage(),
            // '/home':(_)=>const HomePage(),
          },
          initialRoute: '/splash',
        ),
      ),
    );
  }
}
