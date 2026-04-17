import 'package:hive_flutter/hive_flutter.dart';

class AuthService {
  static const String _boxName = 'userBox';

  // Inicializa o Hive para o Auth
  static Future<void> init() async {
    await Hive.openBox(_boxName);
  }

  // Salva um novo usuário
  static Future<bool> cadastrarUsuario(
      String username, String email, String password) async {
    final box = Hive.box(_boxName);

    // Verifica se o e-mail já existe
    if (box.containsKey(email)) {
      return false;
    }

    // Salva os dados (Email como chave)
    await box.put(email, {
      'username': username,
      'password': password,
    });

    return true;
  }

  // Verifica o login
  static bool verificarLogin(String email, String password) {
    final box = Hive.box(_boxName);

    if (!box.containsKey(email)) {
      return false;
    }

    final userData = box.get(email);
    return userData['password'] == password;
  }

  // Pega o nome do usuário logado
  static String? getLoggedUsername(String email) {
    final box = Hive.box(_boxName);
    final userData = box.get(email);
    return userData?['username'];
  }
}
