import "package:equatable/equatable.dart";

class AppUser extends Equatable {
  final String uid;
  final String? email;
  final String? displayName;
  final String? photoUrl;
  final String? phone;

  // Constructor named parameters
  const AppUser({
    required this.uid,
    this.email,
    this.displayName,
    this.photoUrl,
    this.phone,
  });

  // Hằng số tĩnh đại diện cho người dùng rỗng => Ktra trạng thái đăng nhập user
  static const empty = AppUser(uid: '');

  // Getter check empty nếu uid rỗng
  bool get isEmpty => uid.isEmpty;

  @override
  // Ghi đè getter props của Equatable
  // Dùng để so sánh sự bằng nhau giữa 2 đối tượng AppUser
  // 2 AppUser sẽ bằng nhau nếu có dùng các thuộc tính sau
  List<Object?> get props => [uid, email, displayName, photoUrl, phone];
}
