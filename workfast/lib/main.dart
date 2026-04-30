import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:workfast/auth_service.dart';
import 'package:workfast/cadastro.dart';
import 'package:workfast/buscar_trabalho.dart';
import 'package:workfast/login.dart';
import 'package:workfast/perfil.dart';
import 'package:workfast/configuracoes_page.dart';
import 'package:workfast/registrar_problema_page.dart';
import 'package:workfast/chamado_model.dart';
import 'package:workfast/avaliacao_service.dart';
import 'package:workfast/notificacao_service.dart';
import 'package:workfast/pagamento_service.dart';
import 'package:workfast/politicas_page.dart';
import 'package:workfast/avaliacao_page.dart';
import 'package:workfast/notificacoes_page.dart';
import 'package:workfast/pagamento_page.dart';

// Gerenciador de Tema Global
final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.light);

void main() async {
  // Garante que os bindings do Flutter estejam prontos
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // 1. Inicializa o Hive
    await Hive.initFlutter();

    // 2. Registra os Adapters Manuais
    Hive.registerAdapter(CategoriaChamadoAdapter());
    Hive.registerAdapter(ChamadoAdapter());
    Hive.registerAdapter(AvaliacaoAdapter());
    Hive.registerAdapter(NotificacaoAdapter());
    Hive.registerAdapter(PagamentoAdapter());

    // 3. Abre os boxes necessários
    await AuthService.init();
    await ChamadoService.init();
    await AvaliacaoService.init();
    await NotificacaoService.init();
    await PagamentoService.init();

    // Abre box de configurações e perfil
    if (!Hive.isBoxOpen('perfil')) {
      await Hive.openBox('perfil');
    }
    if (!Hive.isBoxOpen('configuracoes')) {
      await Hive.openBox('configuracoes');
    }

    // Simula notificações de demonstração se não houver nenhuma
    if (NotificacaoService.todas.isEmpty) {
      await NotificacaoService.simularSolicitacao(
        nomeProfissional: 'Carlos Eletricista',
        especializacoes: ['Elétrica Residencial', 'Instalações', '5 anos exp.'],
        chamadoNome: 'Reparo elétrico urgente',
      );
      await NotificacaoService.simularSolicitacao(
        nomeProfissional: 'João Informática',
        especializacoes: ['Manutenção PC', 'Redes', 'Formatação'],
        chamadoNome: 'Computador não liga',
      );
    }
  } catch (e) {
    debugPrint('Erro na inicialização: $e');
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
          initialRoute: '/login',
          routes: {
            '/login': (context) => const PoliticasWrapper(
                  child: LoginPage(),
                ),
            '/cadastro': (context) => const CadastroPage(),
            '/home': (context) => const busctrabalho(),
            '/perfil': (context) => const PerfilPage(),
            '/configuracoes': (context) => const ConfiguracoesPage(),
            '/registrar_problema': (context) => const registraProblema(),
            '/notificacoes': (context) => const NotificacoesPage(),
          },
        );
      },
    );
  }
}