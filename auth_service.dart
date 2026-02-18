
class UserModel {
  final String? name;
  final String? email;
  
  UserModel({this.name, this.email});
  
  factory UserModel.guest() {
    return UserModel(name: 'Guest');
  }
  
  factory UserModel.user({String? name, String? email}) {
    return UserModel(name: name ?? 'User', email: email);
  }
  
  factory UserModel.admin() {
    return UserModel(name: 'Admin');
  }
}

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  bool _isGuest = true; // Default guest
  bool _isAdmin = false;
  UserModel? _currentUser;
  
  bool get isGuest => _isGuest;
  bool get isAdmin => _isAdmin;
  bool get isRegularUser => !_isGuest && !_isAdmin;
  
  UserModel? get currentUser => _currentUser;
  
  void loginAsGuest() {
    _isGuest = true;
    _isAdmin = false;
    _currentUser = UserModel.guest();
    print('Logged in as Guest');
  }
  
  void loginAsUser({String? name, String? email}) {
    _isGuest = false;
    _isAdmin = false;
    _currentUser = UserModel.user(name: name, email: email);
    print('Logged in as User: $name');
  }
  
  void loginAsAdmin() {
    _isGuest = false;
    _isAdmin = true;
    _currentUser = UserModel.admin();
    print('Logged in as Admin');
  }
  
  void logout() {
    _isGuest = true;
    _isAdmin = false;
    _currentUser = UserModel.guest();
    print('Logged out');
  }
}