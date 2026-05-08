import 'package:flutter/material.dart';
import 'package:workfast/auth_service.dart';
import 'package:workfast/chamado_model.dart';
import 'package:workfast/avaliacao_service.dart';
import 'package:workfast/notificacao_service.dart';
import 'package:workfast/pagamento_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    try {
      debugPrint("SplashScreen: Iniciando aplicação...");
      
      // Aguarda a inicialização de todos os serviços
      await Future.wait([
        AuthService.init(),
        ChamadoService.init(),
        AvaliacaoService.init(),
        NotificacaoService.init(),
        PagamentoService.init(),
      ]);

      debugPrint("SplashScreen: Todos os serviços inicializados com sucesso!");

      // Aguarda um pequeno delay para garantir que tudo está pronto
      await Future.delayed(const Duration(milliseconds: 500));

      if (mounted) {
        // Navega para a tela de login
        Navigator.pushReplacementNamed(context, '/login');
      }
    } catch (e) {
      debugPrint("SplashScreen: Erro na inicialização: $e");
      
      if (mounted) {
        // Mostra um diálogo de erro
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            title: const Text('Erro de Inicialização'),
            content: Text('Ocorreu um erro ao inicializar o aplicativo:\n\n$e'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _initializeApp(); // Tenta novamente
                },
                child: const Text('Tentar Novamente'),
              ),
            ],
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2C3E50),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white.withOpacity(0.2),
                  width: 2,
                ),
              ),
              child: const Icon(
                Icons.bolt_rounded,
                size: 70,
                color: Color(0xFF4CAF50),
              ),
            ),
            const SizedBox(height: 30),
            
            // Nome da empresa
            const Text(
              'WorkFast',
              style: TextStyle(
                fontSize: 42,
                fontWeight: FontWeight.w900,
                color: Colors.white,
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(height: 10),
            
            // Subtítulo
            Text(
              'Serviços Rápidos e Confiáveis',
              style: TextStyle(
                fontSize: 14,
                color: Colors.white.withOpacity(0.8),
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 60),
            
            // Loading indicator
            const CircularProgressIndicator(
              color: Color(0xFF4CAF50),
              strokeWidth: 3,
            ),
            const SizedBox(height: 20),
            
            // Texto de carregamento
            Text(
              'Carregando...',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white.withOpacity(0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
