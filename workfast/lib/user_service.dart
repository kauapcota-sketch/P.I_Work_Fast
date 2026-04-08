class UserService {
  static final Map<String, String> _users = {};
  static final UserService _instance = UserService._internal();
  factory UserService() => _instance;
  UserService._internal();

  bool cadastrarUsuario(String username, String email, String password) {
    if (_users.containsKey(username)) return false;
    _users[username] = password;
    return true;
  }

  bool validarLogin(String username, String password) {
    return _users[username] == password;
  }

  bool isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }
}