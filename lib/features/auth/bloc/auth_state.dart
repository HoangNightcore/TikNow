import 'package:equatable/equatable.dart';
import '../domain/entities/app_user.dart';

enum AuthStatus { unknow, authenticated, unauthenticated, loading, failure }

class AuthState extends Equatable {
  final AuthStatus status;
  final AppUser? user;
  final String? error;

  const AuthState({this.status = AuthStatus.unknow, this.user, this.error});

  AuthState copyWith({AuthStatus? status, AppUser? user, String? error}) =>
      AuthState(
        status: status ?? this.status,
        user: user ?? this.user,
        error: error ?? this.error,
      );

  @override
  // TODO: implement props
  List<Object?> get props => [status, user ?? AppUser.empty, error];
}
