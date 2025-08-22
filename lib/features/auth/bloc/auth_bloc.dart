import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../domain/repositories/auth_repository.dart';
import '../domain/entities/app_user.dart';
import 'auth_event.dart';
import 'auth_state.dart';

/// Bloc quản lý Authentication (login, signup, logout, reset password)
/// - Input: [AuthEvent] (UI phát event vào)
/// - Output: [AuthState] (UI lắng nghe để hiển thị)
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _repo;

  /// Subscription tới stream `authStateChanges` của Firebase
  StreamSubscription<AppUser?>? _sub;

  AuthBloc(this._repo) : super(const AuthState()) {
    // Đăng ký handler cho từng loại event
    on<AuthSubcriptionRequested>(
      _onSubscriptionRequested,
    ); // theo dõi trạng thái đăng nhập
    on<AuthSignInWithEmailSubmitted>(_onSignInEmail); // login bằng email
    on<AuthSignUpWithEmailSubmitted>(_onSignUpEmail); // đăng ký bằng email
    on<AuthSendResetPasswordRequested>(_onSendReset); // gửi mail reset pass
    on<AuthGoogleSignInRequested>(_onGoogleSignIn); // login Google (chưa code)
    on<AuthSignedOut>(_onSignOut); // đăng xuất
  }

  /// Khi user mở app → lắng nghe stream trạng thái auth từ Firebase
  /// Nếu có user → phát event nội bộ [_AuthInternalAuthenticated]
  /// Nếu null → phát event [AuthSignedOut]
  Future<void> _onSubscriptionRequested(
    AuthSubcriptionRequested event,
    Emitter<AuthState> emit,
  ) async {
    await _sub?.cancel();
    _sub = _repo.authStateChanges().listen((user) {
      add(user == null ? AuthSignedOut() : _AuthInternalAuthenticated(user));
    });
  }

  /// Xử lý event đăng nhập email
  /// - Phát state loading
  /// - Gọi repo signIn
  /// - Thành công: state = authenticated + user
  /// - Thất bại: state = failure → quay về unauthenticated
  Future<void> _onSignInEmail(
    AuthSignInWithEmailSubmitted e,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthStatus.loading, error: null));
    try {
      final user = await _repo.signInWithEmailPassword(e.email, e.password);
      emit(state.copyWith(status: AuthStatus.authenticated, user: user));
    } catch (err) {
      emit(state.copyWith(status: AuthStatus.failure, error: err.toString()));
      emit(state.copyWith(status: AuthStatus.unauthenticated));
    }
  }

  /// Xử lý event đăng ký email
  Future<void> _onSignUpEmail(
    AuthSignUpWithEmailSubmitted e,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthStatus.loading, error: null));
    try {
      final user = await _repo.signUpWithEmailPassword(
        e.email,
        e.password,
        displayName: e.displayName,
      );
      emit(state.copyWith(status: AuthStatus.authenticated, user: user));
    } catch (err) {
      emit(state.copyWith(status: AuthStatus.failure, error: err.toString()));
      emit(state.copyWith(status: AuthStatus.unauthenticated));
    }
  }

  /// Gửi email reset password (không cập nhật state)
  Future<void> _onSendReset(
    AuthSendResetPasswordRequested e,
    Emitter<AuthState> emit,
  ) async {
    try {
      await _repo.sendPasswordResetEmail(e.email);
    } catch (_) {}
  }

  /// Login bằng Google (sẽ viết sau)
  Future<void> _onGoogleSignIn(
    AuthGoogleSignInRequested e,
    Emitter<AuthState> emit,
  ) async {
    // TODO: triển khai Google sign-in
  }

  /// Đăng xuất user
  /// - Gọi repo.signOut()
  /// - Phát state unauthenticated
  Future<void> _onSignOut(AuthSignedOut e, Emitter<AuthState> emit) async {
    await _repo.signOut();
    emit(state.copyWith(status: AuthStatus.unauthenticated, user: null));
  }

  /// Hủy subscription stream khi Bloc bị dispose
  @override
  Future<void> close() {
    _sub?.cancel();
    return super.close();
  }
}

/// Event nội bộ (chỉ dùng trong Bloc)
/// - Được phát khi FirebaseAuth trả về 1 user hợp lệ
class _AuthInternalAuthenticated extends AuthEvent {
  final AppUser user;
  _AuthInternalAuthenticated(this.user);
}
