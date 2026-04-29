import 'package:flutter/material.dart';

// Modelo de notificação
class AppNotificacao {
  final String titulo;
  final String mensagem;
  final IconData icone;
  final Color cor;
  final DateTime horario;
  bool lida;

  AppNotificacao({
    required this.titulo,
    required this.mensagem,
    required this.icone,
    required this.cor,
    required this.horario,
    this.lida = false,
  });
}

// Serviço de notificações (estado global simples)
class NotificacaoService {
  static final List<AppNotificacao> _notificacoes = [
    AppNotificacao(
      titulo: 'Novo chamado disponível!',
      mensagem: 'Um chamado de Informática foi registrado perto de você.',
      icone: Icons.computer,
      cor: Colors.blue,
      horario: DateTime.now().subtract(const Duration(minutes: 5)),
    ),
    AppNotificacao(
      titulo: 'Chamado aceito!',
      mensagem: 'Seu chamado de Elétrica foi aceito por um profissional.',
      icone: Icons.electric_bolt,
      cor: Colors.orange,
      horario: DateTime.now().subtract(const Duration(hours: 1)),
    ),
    AppNotificacao(
      titulo: 'Pontuação atualizada!',
      mensagem: 'Você ganhou 50 pontos por completar um serviço.',
      icone: Icons.star,
      cor: Colors.amber,
      horario: DateTime.now().subtract(const Duration(hours: 3)),
    ),
    AppNotificacao(
      titulo: 'Bem-vindo ao WorkFast!',
      mensagem:
          'Seu cadastro foi realizado com sucesso. Comece a buscar trabalhos!',
      icone: Icons.celebration,
      cor: Colors.green,
      horario: DateTime.now().subtract(const Duration(days: 1)),
    ),
  ];

  static List<AppNotificacao> get todas => List.from(_notificacoes);

  static int get naoLidas => _notificacoes.where((n) => !n.lida).length;

  static void marcarTodasComoLidas() {
    for (var n in _notificacoes) {
      n.lida = true;
    }
  }

  static void adicionarNotificacao(AppNotificacao notificacao) {
    _notificacoes.insert(0, notificacao);
  }
}

class NotificacoesPage extends StatefulWidget {
  const NotificacoesPage({super.key});

  @override
  State<NotificacoesPage> createState() => _NotificacoesPageState();
}

class _NotificacoesPageState extends State<NotificacoesPage> {
  List<AppNotificacao> _notificacoes = [];

  @override
  void initState() {
    super.initState();
    _carregarNotificacoes();
  }

  void _carregarNotificacoes() {
    setState(() {
      _notificacoes = NotificacaoService.todas;
    });
  }

  void _marcarTodasLidas() {
    NotificacaoService.marcarTodasComoLidas();
    setState(() {
      _notificacoes = NotificacaoService.todas;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Todas as notificações foram marcadas como lidas.'),
        backgroundColor: Color(0xFF4CAF50),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  String _formatarHorario(DateTime horario) {
    final agora = DateTime.now();
    final diferenca = agora.difference(horario);

    if (diferenca.inMinutes < 60) {
      return 'Há ${diferenca.inMinutes} min';
    } else if (diferenca.inHours < 24) {
      return 'Há ${diferenca.inHours}h';
    } else {
      return 'Há ${diferenca.inDays} dia(s)';
    }
  }

  @override
  Widget build(BuildContext context) {
    final naoLidas = _notificacoes.where((n) => !n.lida).length;

    return Scaffold(
      backgroundColor: const Color(0xFF2C3E50),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2C3E50),
        elevation: 0,
        centerTitle: true,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Notificações',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            if (naoLidas > 0) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '$naoLidas',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ]
          ],
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          if (naoLidas > 0)
            TextButton(
              onPressed: _marcarTodasLidas,
              child: const Text(
                'Ler todas',
                style: TextStyle(
                  color: Color(0xFF4CAF50),
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ),
        ],
      ),
      body: _notificacoes.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.notifications_none,
                      size: 64, color: Colors.white38),
                  SizedBox(height: 16),
                  Text(
                    'Nenhuma notificação',
                    style: TextStyle(color: Colors.white54, fontSize: 16),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _notificacoes.length,
              itemBuilder: (context, index) {
                final notif = _notificacoes[index];
                return GestureDetector(
                  onTap: () {
                    setState(() => notif.lida = true);
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: notif.lida ? Colors.white : Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      border: notif.lida
                          ? null
                          : Border.all(color: notif.cor, width: 2),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.12),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: notif.cor.withOpacity(0.15),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(notif.icone, color: notif.cor, size: 24),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      notif.titulo,
                                      style: TextStyle(
                                        fontWeight: notif.lida
                                            ? FontWeight.w500
                                            : FontWeight.bold,
                                        fontSize: 15,
                                        color: const Color(0xFF2C3E50),
                                      ),
                                    ),
                                  ),
                                  if (!notif.lida)
                                    Container(
                                      width: 10,
                                      height: 10,
                                      decoration: BoxDecoration(
                                        color: notif.cor,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Text(
                                notif.mensagem,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey.shade600,
                                  height: 1.4,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                _formatarHorario(notif.horario),
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade400,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
