// lib/models/user_model.dart

enum UserRole {
  guest,
  user,
  admin,
}

class UserModel {
  final String? id;
  final String? name;
  final String? email;
  final UserRole role;
  final bool isLoggedIn;

  UserModel({
    this.id,
    this.name,
    this.email,
    required this.role,
    this.isLoggedIn = false,
  });

  // Factory untuk guest (tanpa login)
  factory UserModel.guest() {
    return UserModel(
      id: 'guest_${DateTime.now().millisecondsSinceEpoch}',
      name: 'Guest User',
      email: null,
      role: UserRole.guest,
      isLoggedIn: false,
    );
  }

  // Factory untuk user biasa (after login)
  factory UserModel.user({String? id, String? name, String? email}) {
    return UserModel(
      id: id ?? 'user_${DateTime.now().millisecondsSinceEpoch}',
      name: name ?? 'User',
      email: email,
      role: UserRole.user,
      isLoggedIn: true,
    );
  }

  // Factory untuk admin
  factory UserModel.admin({String? id, String? name, String? email}) {
    return UserModel(
      id: id ?? 'admin_${DateTime.now().millisecondsSinceEpoch}',
      name: name ?? 'Administrator',
      email: email,
      role: UserRole.admin,
      isLoggedIn: true,
    );
  }

  // Cek apakah user adalah guest
  bool get isGuest => role == UserRole.guest;
  
  // Cek apakah user adalah admin
  bool get isAdmin => role == UserRole.admin;
  
  // Cek apakah user adalah user biasa
  bool get isRegularUser => role == UserRole.user;
}