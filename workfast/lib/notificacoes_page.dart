import 'dart:io';
import 'package:flutter/material.dart';
import 'package:workfast/notificacao_service.dart';
import 'package:workfast/pagamento_page.dart';
import 'package:workfast/chamado_model.dart';

class NotificacoesPage extends StatefulWidget {
  const NotificacoesPage({super.key});

  @override
  State<NotificacoesPage> createState() => _NotificacoesPageState();
}

class _NotificacoesPageState extends State<NotificacoesPage> {
  List<Notificacao> _notificacoes = [];

  @override
  void initState() {
    super.initState();
    _carregar();
  }

  void _carregar() {
    setState(() => _notificacoes = NotificacaoService.todas);
  }

  Future<void> _marcarTodasLidas() async {
    await NotificacaoService.marcarTodasComoLidas();
    _carregar();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final bgColor =
        isDarkMode ? const Color(0xFF1B2836) : const Color(0xFF2C3E50);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Notificações',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          if (_notificacoes.any((n) => !n.lida))
            TextButton(
              onPressed: _marcarTodasLidas,
              child: const Text('Ler todas',
                  style: TextStyle(color: Color(0xFF4CAF50), fontSize: 13)),
            ),
        ],
      ),
      body: _notificacoes.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.notifications_none,
                      size: 64, color: Colors.white30),
                  SizedBox(height: 12),
                  Text('Nenhuma notificação',
                      style: TextStyle(color: Colors.white54, fontSize: 16)),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _notificacoes.length,
              itemBuilder: (context, index) {
                final n = _notificacoes[index];
                return _NotificacaoCard(
                  notificacao: n,
                  isDarkMode: isDarkMode,
                  onTap: () async {
                    await NotificacaoService.marcarComoLida(n);
                    if (n.tipo == 'solicitacao' && mounted) {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => PerfilProfissionalModal(
                            notificacao: n,
                            onNotificacaoRemovida: _carregar,
                          ),
                        ),
                      );
                    }
                    _carregar();
                  },
                );
              },
            ),
    );
  }
}

class _NotificacaoCard extends StatelessWidget {
  final Notificacao notificacao;
  final bool isDarkMode;
  final VoidCallback onTap;

  const _NotificacaoCard(
      {required this.notificacao,
      required this.isDarkMode,
      required this.onTap});

  IconData _getIcon() {
    switch (notificacao.tipo) {
      case 'solicitacao':
        return Icons.person_add;
      case 'pagamento':
        return Icons.payment;
      case 'concluido':
        return Icons.check_circle;
      case 'avaliacao':
        return Icons.star;
      default:
        return Icons.notifications;
    }
  }

  Color _getColor() {
    switch (notificacao.tipo) {
      case 'solicitacao':
        return Colors.blue;
      case 'pagamento':
        return Colors.orange;
      case 'concluido':
        return const Color(0xFF4CAF50);
      case 'avaliacao':
        return Colors.amber;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final cor = _getColor();
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: notificacao.lida
              ? Colors.white.withOpacity(0.08)
              : Colors.white.withOpacity(0.15),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: notificacao.lida ? Colors.transparent : cor.withOpacity(0.5),
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: cor.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(_getIcon(), color: cor, size: 24),
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
                          notificacao.titulo,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: notificacao.lida
                                ? FontWeight.normal
                                : FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      if (!notificacao.lida)
                        Container(
                          width: 8,
                          height: 8,
                          decoration:
                              BoxDecoration(color: cor, shape: BoxShape.circle),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    notificacao.mensagem,
                    style: const TextStyle(color: Colors.white60, fontSize: 13),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    _formatarData(notificacao.data),
                    style: const TextStyle(color: Colors.white38, fontSize: 11),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatarData(DateTime data) {
    final agora = DateTime.now();
    final diff = agora.difference(data);
    if (diff.inMinutes < 1) return 'Agora';
    if (diff.inMinutes < 60) return 'Há ${diff.inMinutes} min';
    if (diff.inHours < 24) return 'Há ${diff.inHours}h';
    return 'Há ${diff.inDays} dias';
  }
}

class PerfilProfissionalModal extends StatefulWidget {
  final Notificacao notificacao;
  final VoidCallback? onNotificacaoRemovida;

  const PerfilProfissionalModal({
    super.key,
    required this.notificacao,
    this.onNotificacaoRemovida,
  });

  @override
  State<PerfilProfissionalModal> createState() =>
      _PerfilProfissionalModalState();
}

class _PerfilProfissionalModalState extends State<PerfilProfissionalModal> {
  Future<void> _recusarProposta() async {
    // Remove a notificação
    await NotificacaoService.removerNotificacao(widget.notificacao);
    
    // Chama callback para atualizar a lista
    widget.onNotificacaoRemovida?.call();
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Proposta recusada e removida das notificações.'),
          duration: Duration(seconds: 2),
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final n = widget.notificacao;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
          isDarkMode ? const Color(0xFF1B2836) : const Color(0xFF2C3E50),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Perfil do Profissional',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: isDarkMode ? const Color(0xFF2C3E50) : Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  )
                ],
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.blue,
                    backgroundImage: n.fotoProfissional != null &&
                            n.fotoProfissional!.isNotEmpty
                        ? FileImage(File(n.fotoProfissional!))
                        : null,
                    child: (n.fotoProfissional == null ||
                            n.fotoProfissional!.isEmpty)
                        ? Text(
                            n.nomeProfissional.isNotEmpty
                                ? n.nomeProfissional[0].toUpperCase()
                                : '?',
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 36,
                                fontWeight: FontWeight.bold),
                          )
                        : null,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    n.nomeProfissional,
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: isDarkMode
                            ? Colors.white
                            : const Color(0xFF2C3E50)),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: n.especializacoes.map((e) {
                      return Chip(
                        label: Text(e, style: const TextStyle(fontSize: 12)),
                        backgroundColor: Colors.blue.withOpacity(0.1),
                      );
                    }).toList(),
                  ),
                  const Divider(height: 40),
                  const Text(
                    'Este profissional se ofereceu para realizar o seu serviço. Você deseja aceitar a proposta?',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 20),
                  // Exibição do valor proposto
                  if (n.valorProposta > 0) ...[
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.green.withOpacity(0.5),
                          width: 1.5,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Valor Proposto:',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: isDarkMode
                                  ? Colors.white70
                                  : Colors.grey[700],
                            ),
                          ),
                          Text(
                            'R\$ ${n.valorProposta.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: _recusarProposta,
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            side: const BorderSide(color: Colors.red),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15)),
                          ),
                          child: const Text('RECUSAR',
                              style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => PagamentoPage(
                                  nomeProfissional: n.nomeProfissional,
                                  chamadoNome: n.chamadoNome,
                                ),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            backgroundColor: const Color(0xFF4CAF50),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15)),
                          ),
                          child: const Text('ACEITAR',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
