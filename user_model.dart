enum UserRole {
  guest,
  user,
  admin,
}

class UserModel {
  final String? id;
  final String? name;
  final String? email;
  final String? phone;
  final String? photoUrl;
  final UserRole role;
  final bool isLoggedIn;

  UserModel({
    this.id,
    this.name,
    this.email,
    this.phone,
    this.photoUrl,
    required this.role,
    this.isLoggedIn = false,
  });

  factory UserModel.guest() {
    return UserModel(
      id: 'guest_${DateTime.now().millisecondsSinceEpoch}',
      name: 'Pengunjung',
      email: null,
      phone: null,
      photoUrl: null,
      role: UserRole.guest,
      isLoggedIn: false,
    );
  }

  factory UserModel.user({String? id, String? name, String? email, String? phone, String? photoUrl}) {
    return UserModel(
      id: id ?? 'user_${DateTime.now().millisecondsSinceEpoch}',
      name: name ?? 'Pengguna',
      email: email,
      phone: phone,
      photoUrl: photoUrl,
      role: UserRole.user,
      isLoggedIn: true,
    );
  }

  factory UserModel.admin({String? id, String? name, String? email, String? photoUrl}) {
    return UserModel(
      id: id ?? 'admin_${DateTime.now().millisecondsSinceEpoch}',
      name: name ?? 'Administrator',
      email: email ?? 'admin@stayvue.com',
      phone: null,
      photoUrl: photoUrl,
      role: UserRole.admin,
      isLoggedIn: true,
    );
  }

  bool get isGuest => role == UserRole.guest;
  bool get isAdmin => role == UserRole.admin;
  bool get isRegularUser => role == UserRole.user;
  
  // Copy dengan data baru
  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? photoUrl,
    UserRole? role,
    bool? isLoggedIn,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      photoUrl: photoUrl ?? this.photoUrl,
      role: role ?? this.role,
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
    );
  }
}
