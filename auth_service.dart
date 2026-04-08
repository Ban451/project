import '../models/user_model.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  UserModel? _currentUser;

  bool get isGuest => _currentUser?.isGuest ?? true;
  bool get isAdmin => _currentUser?.isAdmin ?? false;
  bool get isRegularUser => _currentUser?.isRegularUser ?? false;
  
  UserModel? get currentUser => _currentUser;
  
  void loginAsGuest() {
    _currentUser = UserModel.guest();
  }
  
  void loginAsUser({String? name, String? email, String? phone, String? photoUrl}) {
    _currentUser = UserModel.user(
      name: name, 
      email: email, 
      phone: phone,
      photoUrl: photoUrl,
    );
  }
  
  void loginAsAdmin() {
    _currentUser = UserModel.admin();
  }
  
  void logout() {
    _currentUser = UserModel.guest();
  }
  
  void updateProfile({String? name, String? phone, String? photoUrl}) {
    if (_currentUser != null) {
      _currentUser = _currentUser!.copyWith(
        name: name ?? _currentUser!.name,
        phone: phone ?? _currentUser!.phone,
        photoUrl: photoUrl ?? _currentUser!.photoUrl,
      );
    }
  }
  
  // Simulasi registrasi user baru
  void registerUser({required String name, required String email, required String password, String? phone}) {
    _currentUser = UserModel.user(
      name: name,
      email: email,
      phone: phone,
    );
  }
}
