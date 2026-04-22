import 'package:hive_flutter/hive_flutter.dart';

class AuthService {
  static const String _boxName = 'userBox';

  static Future<void> init() async {
    await Hive.openBox(_boxName);
  }

  /// Salva um novo usuário. Retorna false se o e-mail já existir.
  static Future<bool> cadastrarUsuario(
      String username, String email, String password) async {
    final box = Hive.box(_boxName);
    if (box.containsKey(email)) return false;
    await box.put(email, {'username': username, 'password': password});
    return true;
  }

  /// Verifica login. Retorna true se email + senha coincidirem.
  static bool verificarLogin(String email, String password) {
    final box = Hive.box(_boxName);
    if (!box.containsKey(email)) return false;
    final userData = box.get(email);
    return userData['password'] == password;
  }

  /// Retorna o nome de usuário associado ao e-mail.
  static String? getLoggedUsername(String email) {
    final box = Hive.box(_boxName);
    final userData = box.get(email);
    return userData?['username'];
  }

  /// Verifica se um e-mail está cadastrado (usado no "esqueci a senha").
  static bool emailExiste(String email) {
    final box = Hive.box(_boxName);
    return box.containsKey(email);
  }

  /// Redefine a senha de um e-mail já existente.
  static Future<void> redefinirSenha(String email, String novaSenha) async {
    final box = Hive.box(_boxName);
    if (!box.containsKey(email)) return;
    final userData = Map<String, dynamic>.from(box.get(email));
    userData['password'] = novaSenha;
    await box.put(email, userData);
  }
}
