import 'package:firebase_auth/firebase_auth.dart' as fb;
import '../../domain/entities/app_user.dart';

class AppUserModel extends AppUser {
  const AppUserModel({
    required super.uid,
    super.email,
    super.displayName,
    super.photoUrl,
    super.phone,
  });

  factory AppUserModel.fromFirebaseUser(fb.User user) => AppUserModel(
    uid: user.uid,
    email: user.email,
    displayName: user.displayName,
    photoUrl: user.photoURL,
    phone: user.phoneNumber,
  );
}
