import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  List<Object?> get props => [];
}

class AuthSubcriptionRequested extends AuthEvent {}

class AuthSignInWithEmailSubmitted extends AuthEvent {
  final String email;
  final String password;
  AuthSignInWithEmailSubmitted(this.email, this.password);
}

class AuthSignUpWithEmailSubmitted extends AuthEvent {
  final String email;
  final String password;
  final String? displayName;
  AuthSignUpWithEmailSubmitted(this.email, this.password, {this.displayName});
}

class AuthSendResetPasswordRequested extends AuthEvent {
  final String email;
  AuthSendResetPasswordRequested(this.email);
}

class AuthGoogleSignInRequested extends AuthEvent {}

class AuthSignedOut extends AuthEvent {}
