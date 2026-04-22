import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:workfast/auth_service.dart';
import 'package:workfast/cadastro.dart';
import 'package:workfast/buscar_trabalho.dart';
import 'package:workfast/esqueci_senha_page.dart';
import 'package:workfast/login.dart';
import 'package:workfast/perfil.dart';
import 'package:workfast/configuracoes_page.dart';
import 'package:workfast/registrar_problema_page.dart';

// Gerenciador de Tema Global
final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.light);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await AuthService.init();
  runApp(const WorkFastApp());
}

class WorkFastApp extends StatelessWidget {
  const WorkFastApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (_, currentThemeMode, __) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'WorkFast',
          theme: ThemeData(
            primarySwatch: Colors.green,
            brightness: Brightness.light,
            appBarTheme: const AppBarTheme(
              backgroundColor: Color(0xFF2C3E50),
              foregroundColor: Colors.white,
            ),
            scaffoldBackgroundColor: const Color(0xFFECEFF1),
            cardColor: Colors.white,
          ),
          darkTheme: ThemeData(
            primarySwatch: Colors.green,
            brightness: Brightness.dark,
            appBarTheme: const AppBarTheme(
              backgroundColor: Color(0xFF1B2836),
              foregroundColor: Colors.white,
            ),
            scaffoldBackgroundColor: const Color(0xFF1B2836),
            cardColor: const Color(0xFF2C3E50),
          ),
          themeMode: currentThemeMode,
          initialRoute: '/login',
          routes: {
            '/login': (context) => const LoginPage(),
            '/cadastro': (context) => const CadastroPage(),
            '/home': (context) => const busctrabalho(),
            '/perfil': (context) => const PerfilPage(),
            '/configuracoes': (context) => const ConfiguracoesPage(),
            '/registrar_problema': (context) => const registraProblema(),
            '/esqueci_senha': (context) => const EsqueciSenhaPage(),
          },
        );
      },
    );
  }
}
