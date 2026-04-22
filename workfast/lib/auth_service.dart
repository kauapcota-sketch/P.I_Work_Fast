import 'package:hive_flutter/hive_flutter.dart';

class AuthService {
  // AJUSTADO: Nome agora é exatamente igual ao do seu main.dart
  static const String _boxName = 'usuarios';

  static Future<void> init() async {
    await Hive.openBox(_boxName);
  }

  static Future<bool> cadastrarUsuario(
      String username, String email, String password) async {
    final box = Hive.box(_boxName);

    if (box.containsKey(email)) {
      print('ERRO: E-mail $email já existe no banco.');
      return false;
    }

    await box.put(email, {
      'username': username,
      'password': password,
    });

    await box.flush();
    print('SUCESSO: Usuário $username cadastrado com e-mail $email');
    return true;
  }

  static bool verificarLogin(String loginInformado, String password) {
    final box = Hive.box(_boxName);

    // 1. Tenta buscar diretamente pelo E-mail (mais rápido)
    if (box.containsKey(loginInformado)) {
      final dados = box.get(loginInformado);
      if (dados['password'] == password) {
        print('SUCESSO LOGIN: Entrou via E-mail');
        return true;
      }
    }

    // 2. Se não achou pelo e-mail, percorre o banco para buscar pelo Nome de Usuário
    for (var key in box.keys) {
      final dados = box.get(key);
      if (dados['username'] == loginInformado &&
          dados['password'] == password) {
        print('SUCESSO LOGIN: Entrou via Nome de Usuário');
        return true;
      }
    }

    print(
        'ERRO LOGIN: Usuário ou E-mail "$loginInformado" não encontrado ou senha incorreta.');
    return false;
  }
}
