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

    await box.flush(); // Garante a gravação no disco
    return true;
  }

  // Verifica o login (Aceita tanto E-mail quanto Nome de Usuário)
  static bool verificarLogin(String loginInput, String password) {
    final box = Hive.box(_boxName);

    // 1. Tenta verificar se o loginInput é um E-MAIL cadastrado
    if (box.containsKey(loginInput)) {
      final userData = box.get(loginInput);
      if (userData['password'] == password) {
        return true;
      }
    }

    // 2. Se não achou pelo e-mail, busca pelo NOME DE USUÁRIO (username)
    for (var key in box.keys) {
      final userData = box.get(key);
      if (userData['username'] == loginInput &&
          userData['password'] == password) {
        return true;
      }
    }

    return false;
  }

  // Pega o nome do usuário logado (Aceita e-mail ou username como entrada)
  static String? getLoggedUsername(String loginInput) {
    final box = Hive.box(_boxName);

    // Se for e-mail
    if (box.containsKey(loginInput)) {
      final userData = box.get(loginInput);
      return userData?['username'];
    }

    // Se for username
    for (var key in box.keys) {
      final userData = box.get(key);
      if (userData['username'] == loginInput) {
        return userData['username'];
      }
    }

    return null;
  }

  // Salva o nome do usuário logado na box de perfil
  static Future<void> salvarNomeNoPerfil(String username) async {
    try {
      final perfilBox = await Hive.openBox('perfil');
      await perfilBox.put('nome', username);
      await perfilBox.flush();
    } catch (e) {
      // Silenciosamente ignora erros
    }
  }

  // Verifica se um e-mail está cadastrado
  static bool emailExiste(String email) {
    final box = Hive.box(_boxName);
    return box.containsKey(email);
  }

  // Redefine a senha de um e-mail já existente
  static Future<void> redefinirSenha(String email, String novaSenha) async {
    final box = Hive.box(_boxName);
    if (!box.containsKey(email)) return;

    final userData = Map<String, dynamic>.from(box.get(email));
    userData['password'] = novaSenha;

    await box.put(email, userData);
    await box.flush();
  }
}
