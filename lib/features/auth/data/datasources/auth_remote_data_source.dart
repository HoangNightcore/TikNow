import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthRemoteDataSource {
  final FirebaseAuth _auth;
  final FirebaseFirestore _db;
  AuthRemoteDataSource(this._auth, this._db);

  // Trả về Stream (luồng dữ liệu) theo dõi trạng thái đăng nhập ng dùng
  Stream<User?> authStateChanges() => _auth.authStateChanges();

  // Func login with email-password
  Future<User> signInWithEmail(String email, String password) async {
    final cred = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return cred.user!;
  }

  // Func register with email-password
  Future<User> signUpWithEmail(
    String email,
    String password, {
    String? displayName,
  }) async {
    final cred = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    final user = cred.user!;
    if (displayName != null && displayName.isNotEmpty) {
      await user.updateDisplayName(displayName);
    }
    // Tạo/merge hồ sơ ở Firestore
    await _db.collection('users').doc(user.uid).set(
      {
        'email': user.email,
        'displayName': displayName ?? user.displayName,
        'photoUrl': user.photoURL,
        'phone': user.phoneNumber,
        'createAt': FieldValue.serverTimestamp(),
      },
      SetOptions(
        merge: true,
      ), // Nếu ng dùng tồn tại thì update thay vì xóa dữ liệu (merge chứ ko create)
    );
    return user;
  }

  // Func login with google
  Future<User> signInWithGoogle() async {
    // Có thể thêm luông google_sign_in ở đây
    throw UnimplementedError('Google Sign_In not implemented yet');
  }

  // Func reset password to email
  Future<void> sendPasswordResetEmail(String email) =>
      _auth.sendPasswordResetEmail(email: email);
  // Func logout
  Future<void> signOut() => _auth.signOut();

  // Func update profile
  Future<void> updateProfile({
    String? displayName,
    String? photoUrl,
    String? phone,
  }) async {
    final u = _auth.currentUser!;
    if (displayName != null) await u.updateDisplayName(displayName);
    if (photoUrl != null) await u.updatePhotoURL(photoUrl);

    // Update trên collection
    await _db.collection('users').doc(u.uid).set({
      if (displayName != null) 'displayName': displayName,
      if (photoUrl != null) 'photoUrl': photoUrl,
      if (phone != null) 'phone': phone,
    }, SetOptions(merge: true));
    await u.reload(); // Reload để đảm bảo current mới nhất
  }

  // Getter truy cập người dùng đang đặng nhập hiện tại
  User? get currentUser => _auth.currentUser;
}
