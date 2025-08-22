import 'package:firebase_auth/firebase_auth.dart';
import '../../domain/entities/app_user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';
import '../models/app_user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remote;
  AuthRepositoryImpl(this.remote); // Dependency Injection

  @override
  Stream<AppUser?> authStateChanges() => remote.authStateChanges().map(
    (u) => u == null ? null : AppUserModel.fromFirebaseUser(u),
  );

  @override
  Future<AppUser> signInWithEmailPassword(String email, String password) async {
    try {
      final u = await remote.signInWithEmail(email, password);
      return AppUserModel.fromFirebaseUser(u);
    } on FirebaseAuthException catch (e) {
      throw Exception(_mapCode(e.code));
    }
  }

  @override
  Future<AppUser> signUpWithEmailPassword(
    String email,
    String password, {
    String? displayName,
  }) async {
    try {
      final u = await remote.signUpWithEmail(
        email,
        password,
        displayName: displayName,
      );
      return AppUserModel.fromFirebaseUser(u);
    } on FirebaseAuthException catch (e) {
      throw Exception(_mapCode(e.code));
    }
  }

  @override
  Future<AppUser> signInWithGoogle() =>
      remote.signInWithGoogle().then(AppUserModel.fromFirebaseUser);

  @override
  Future<void> sendPasswordResetEmail(String email) =>
      remote.sendPasswordResetEmail(email);

  @override
  Future<void> signOut() => remote.signOut();

  @override
  Future<void> updateProfile({
    String? displayName,
    String? photoUrl,
    String? phone,
  }) => remote.updateProfile(
    displayName: displayName,
    photoUrl: photoUrl,
    phone: phone,
  );

  @override
  Future<AppUser?> currentUser() async => remote.currentUser == null
      ? null
      : AppUserModel.fromFirebaseUser(remote.currentUser!);

  String _mapCode(String code) {
    switch (code) {
      case 'user-not-found':
      case 'wrong-password':
        return 'Email hoặc mật khẩu không chính xác';
      case 'email-already-in-use':
        return 'Email này đã được sử dụng';
      case 'weak-password':
        return 'Mật khẩu quá yếu, hãy chọn mật khẩu mạnh hơn';
      case 'invalid-email':
        return 'Email không hợp lệ';
      case 'user-disabled':
        return 'Tài khoản này đã bị vô hiệu hóa';
      case 'operation-not-allowed':
        return 'Chức năng đăng nhập bằng Email/Password chưa được bật';
      case 'too-many-requests':
        return 'Bạn đã thử quá nhiều lần, vui lòng thử lại sau';
      case 'network-request-failed':
        return 'Không thể kết nối mạng, vui lòng kiểm tra Internet';
      case 'requires-recent-login':
        return 'Vui lòng đăng nhập lại để thực hiện thao tác này';
      default:
        return 'Đã xảy ra lỗi ($code)';
    }
  }
}
