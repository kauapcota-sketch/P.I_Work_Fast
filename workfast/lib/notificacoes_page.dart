import 'dart:io';
import 'package:flutter/material.dart';
import 'package:workfast/notificacao_service.dart';
import 'package:workfast/pagamento_page.dart';

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
    return Scaffold(
      backgroundColor: const Color(0xFF2C3E50),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2C3E50),
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
                  Icon(Icons.notifications_none, size: 64, color: Colors.white30),
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
                  onTap: () async {
                    await NotificacaoService.marcarComoLida(n);
                    if (n.tipo == 'solicitacao' && mounted) {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => PerfilProfissionalModal(
                            notificacao: n,
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
  final VoidCallback onTap;

  const _NotificacaoCard(
      {required this.notificacao, required this.onTap});

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
            color: notificacao.lida
                ? Colors.transparent
                : cor.withOpacity(0.5),
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
                          decoration: BoxDecoration(
                              color: cor, shape: BoxShape.circle),
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
                    style:
                        const TextStyle(color: Colors.white38, fontSize: 11),
                  ),
                  if (notificacao.tipo == 'solicitacao')
                    Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Text(
                        'Toque para ver o perfil do profissional →',
                        style: TextStyle(
                            color: cor,
                            fontSize: 12,
                            fontWeight: FontWeight.w600),
                      ),
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

// Modal para ver perfil do profissional (apenas nome, foto e especializações)
class PerfilProfissionalModal extends StatefulWidget {
  final Notificacao notificacao;

  const PerfilProfissionalModal({super.key, required this.notificacao});

  @override
  State<PerfilProfissionalModal> createState() =>
      _PerfilProfissionalModalState();
}

class _PerfilProfissionalModalState
    extends State<PerfilProfissionalModal> {
  bool _aceitando = false;
  bool _recusando = false;

  @override
  Widget build(BuildContext context) {
    final n = widget.notificacao;
    return Scaffold(
      backgroundColor: const Color(0xFF2C3E50),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2C3E50),
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
            // Card do Profissional
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
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
                  // Foto e Nome
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
                    style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2C3E50)),
                  ),
                  const SizedBox(height: 8),

                  // Avaliação média
                  _AvaliacaoMedia(nomeProfissional: n.nomeProfissional),

                  const SizedBox(height: 20),
                  const Divider(),
                  const SizedBox(height: 12),

                  // Especializações (sem dados pessoais!)
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Especializações',
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2C3E50))),
                  ),
                  const SizedBox(height: 12),
                  if (n.especializacoes.isEmpty)
                    const Text('Nenhuma especialização informada.',
                        style: TextStyle(color: Colors.grey))
                  else
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: n.especializacoes
                          .map((e) => Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 14, vertical: 8),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF4CAF50)
                                      .withOpacity(0.12),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                      color: const Color(0xFF4CAF50)
                                          .withOpacity(0.3)),
                                ),
                                child: Text(e,
                                    style: const TextStyle(
                                        fontSize: 13,
                                        color: Color(0xFF2C3E50),
                                        fontWeight: FontWeight.w600)),
                              ))
                          .toList(),
                    ),

                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.work_outline,
                            color: Colors.blue, size: 20),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Quer realizar: "${n.chamadoNome}"',
                            style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Aviso de privacidade
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.amber.withOpacity(0.15),
                borderRadius: BorderRadius.circular(14),
                border:
                    Border.all(color: Colors.amber.withOpacity(0.4)),
              ),
              child: const Row(
                children: [
                  Icon(Icons.security, color: Colors.amber, size: 20),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Por privacidade, apenas nome, foto e especializações são exibidos. Dados de contato só são liberados após confirmação do pagamento.',
                      style: TextStyle(fontSize: 12, color: Colors.black87),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Botões de Aceitar/Recusar
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _recusando
                        ? null
                        : () {
                            setState(() => _recusando = true);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Solicitação recusada.'),
                                backgroundColor: Colors.red,
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                            Future.delayed(
                                const Duration(milliseconds: 600),
                                () => Navigator.pop(context));
                          },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.red),
                      foregroundColor: Colors.red,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                    ),
                    child: const Text('RECUSAR',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    onPressed: _aceitando
                        ? null
                        : () async {
                            setState(() => _aceitando = true);
                            if (mounted) {
                              Navigator.pop(context);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => PagamentoPage(
                                    nomeProfissional: n.nomeProfissional,
                                    chamadoNome: n.chamadoNome,
                                  ),
                                ),
                              );
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4CAF50),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      elevation: 6,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                    ),
                    child: const Text('ACEITAR E PAGAR',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _AvaliacaoMedia extends StatelessWidget {
  final String nomeProfissional;
  const _AvaliacaoMedia({required this.nomeProfissional});

  @override
  Widget build(BuildContext context) {
    // Import correto feito no arquivo que usar
    return const SizedBox.shrink();
  }
}