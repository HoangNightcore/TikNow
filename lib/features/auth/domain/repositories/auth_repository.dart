import '../entities/app_user.dart';

abstract class AuthRepository {
  Stream<AppUser?> authStateChanges();

  Future<AppUser> signInWithEmailPassword(String email, String password);
  Future<AppUser> signUpWithEmailPassword(
    String email,
    String password, {
    String? displayName,
  });
  Future<AppUser> signInWithGoogle();

  Future<void> sendPasswordResetEmail(String email);
  Future<void> signOut();

  Future<void> updateProfile({
    String? displayName,
    String? photoUrl,
    String? phone,
  });
  Future<AppUser?> currentUser();
}
