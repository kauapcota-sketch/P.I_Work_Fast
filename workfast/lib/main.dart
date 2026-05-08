import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:workfast/auth_service.dart';
import 'package:workfast/cadastro.dart';
import 'package:workfast/home_page.dart';
import 'package:workfast/login.dart';
import 'package:workfast/perfil.dart';
import 'package:workfast/configuracoes_page.dart';
import 'package:workfast/registrar_problema_page.dart';
import 'package:workfast/chamado_model.dart';
import 'package:workfast/avaliacao_service.dart';
import 'package:workfast/notificacao_service.dart';
import 'package:workfast/pagamento_service.dart';
import 'package:workfast/politicas_page.dart';
import 'package:workfast/notificacoes_page.dart';
import 'package:workfast/splash_screen.dart';

final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.light);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Hive.initFlutter();

    // Registro de Adapters - IMPORTANTE: Isso deve ser feito ANTES de qualquer uso
    if (!Hive.isAdapterRegistered(0))
      Hive.registerAdapter(CategoriaChamadoAdapter());
    if (!Hive.isAdapterRegistered(1)) Hive.registerAdapter(ChamadoAdapter());
    if (!Hive.isAdapterRegistered(2))
      Hive.registerAdapter(StatusNegociacaoAdapter());
    if (!Hive.isAdapterRegistered(5)) Hive.registerAdapter(AvaliacaoAdapter());
    if (!Hive.isAdapterRegistered(3))
      Hive.registerAdapter(NotificacaoAdapter());
    if (!Hive.isAdapterRegistered(6)) Hive.registerAdapter(PagamentoAdapter());

    // Abre as boxes de configuração
    if (!Hive.isBoxOpen('perfil')) await Hive.openBox('perfil');
    if (!Hive.isBoxOpen('configuracoes')) await Hive.openBox('configuracoes');
    
    debugPrint('main: Hive inicializado e adapters registrados');
  } catch (e) {
    debugPrint('Erro na inicialização do Hive: $e');
  }

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
          initialRoute: '/splash',
          routes: {
            '/splash': (context) => const SplashScreen(),
            '/login': (context) => const PoliticasWrapper(
                  child: LoginPage(),
                ),
            '/cadastro': (context) => const CadastroPage(),
            '/home': (context) => const HomePage(),
            '/perfil': (context) => PerfilPage(),
            '/configuracoes': (context) => ConfiguracoesPage(),
            '/registrar_problema': (context) => RegistrarProblemaPage(),
            '/notificacoes': (context) => NotificacoesPage(),
          },
        );
      },
    );
  }
}
