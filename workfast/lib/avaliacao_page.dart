import 'package:flutter/material.dart';
import 'package:workfast/avaliacao_service.dart';
import 'package:workfast/notificacao_service.dart';

class AvaliacaoPage extends StatefulWidget {
  final String nomeProfissional;
  final String chamadoNome;

  const AvaliacaoPage({
    super.key,
    required this.nomeProfissional,
    required this.chamadoNome,
  });

  @override
  State<AvaliacaoPage> createState() => _AvaliacaoPageState();
}

class _AvaliacaoPageState extends State<AvaliacaoPage> {
  double _nota = 0;
  final _comentarioController = TextEditingController();
  bool _enviado = false;
  bool _enviando = false;
  bool _confirmouServico = false;

  @override
  void dispose() {
    _comentarioController.dispose();
    super.dispose();
  }

  Future<void> _enviarAvaliacao() async {
    if (_nota == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, selecione uma nota de 1 a 5 estrelas.'),
          backgroundColor: Colors.orange,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    setState(() => _enviando = true);
    await Future.delayed(const Duration(milliseconds: 800));

    await AvaliacaoService.adicionarAvaliacao(Avaliacao(
      nomeAvaliador: 'Você',
      nota: _nota,
      comentario: _comentarioController.text.trim(),
      data: DateTime.now(),
      nomeProfissional: widget.nomeProfissional,
    ));

    await NotificacaoService.adicionarNotificacao(Notificacao(
      titulo: 'Avaliação Enviada ⭐',
      mensagem:
          'Você avaliou ${widget.nomeProfissional} com ${_nota.toStringAsFixed(0)} estrelas.',
      data: DateTime.now(),
      tipo: 'avaliacao',
      nomeProfissional: widget.nomeProfissional,
      especializacoes: [],
      chamadoNome: widget.chamadoNome,
    ));

    if (mounted) {
      setState(() {
        _enviando = false;
        _enviado = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2C3E50),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2C3E50),
        elevation: 0,
        title: const Text('Avaliar Serviço',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: _enviado ? _buildResultado() : _buildFormulario(),
      ),
    );
  }

  Widget _buildFormulario() {
    return Column(
      children: [
        // Confirmação de serviço
        if (!_confirmouServico) ...[
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 15,
                    offset: const Offset(0, 8))
              ],
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.check_circle_outline,
                      size: 60, color: Colors.blue),
                ),
                const SizedBox(height: 20),
                const Text(
                  'O serviço foi concluído?',
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2C3E50)),
                ),
                const SizedBox(height: 8),
                Text(
                  '${widget.nomeProfissional} realizou o serviço "${widget.chamadoNome}"?',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.grey),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14)),
                        ),
                        child: const Text('Ainda não',
                            style: TextStyle(color: Colors.grey)),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () =>
                            setState(() => _confirmouServico = true),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4CAF50),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14)),
                        ),
                        child: const Text('Sim, concluído!',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ] else ...[
          // Formulário de avaliação
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 15,
                    offset: const Offset(0, 8))
              ],
            ),
            child: Column(
              children: [
                // Avatar do profissional
                CircleAvatar(
                  radius: 40,
                  backgroundColor: const Color(0xFF4CAF50),
                  child: Text(
                    widget.nomeProfissional.isNotEmpty
                        ? widget.nomeProfissional[0].toUpperCase()
                        : '?',
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  widget.nomeProfissional,
                  style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2C3E50)),
                ),
                const SizedBox(height: 4),
                Text(
                  'Serviço: ${widget.chamadoNome}',
                  style: const TextStyle(fontSize: 13, color: Colors.grey),
                ),
                const SizedBox(height: 24),

                const Text(
                  'Como foi o serviço?',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2C3E50)),
                ),
                const SizedBox(height: 16),

                // Estrelas de avaliação
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (i) {
                    final estrela = i + 1;
                    return GestureDetector(
                      onTap: () => setState(() => _nota = estrela.toDouble()),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: const EdgeInsets.symmetric(horizontal: 6),
                        child: Icon(
                          _nota >= estrela ? Icons.star : Icons.star_border,
                          size: _nota >= estrela ? 48 : 40,
                          color: _nota >= estrela
                              ? Colors.amber
                              : Colors.grey[300],
                        ),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 8),
                Text(
                  _nota == 0
                      ? 'Toque nas estrelas para avaliar'
                      : _getDescricaoNota(_nota),
                  style: TextStyle(
                    fontSize: 14,
                    color:
                        _nota == 0 ? Colors.grey : _getCorNota(_nota),
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 24),
                const Divider(),
                const SizedBox(height: 16),

                // Comentário
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Deixe um comentário (opcional)',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2C3E50)),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _comentarioController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText:
                        'Ex: Profissional pontual, serviço bem feito...',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14)),
                    filled: true,
                    fillColor: Colors.grey[50],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          SizedBox(
            width: double.infinity,
            height: 58,
            child: ElevatedButton(
              onPressed: _enviando ? null : _enviarAvaliacao,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4CAF50),
                foregroundColor: Colors.white,
                elevation: 8,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
              ),
              child: _enviando
                  ? const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                                color: Colors.white, strokeWidth: 2)),
                        SizedBox(width: 12),
                        Text('Enviando avaliação...',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    )
                  : const Text('ENVIAR AVALIAÇÃO',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildResultado() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(30),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 15,
                  offset: const Offset(0, 8))
            ],
          ),
          child: Column(
            children: [
              // Animação de sucesso
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.amber.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.star, size: 64, color: Colors.amber),
              ),
              const SizedBox(height: 20),
              const Text(
                'Avaliação Enviada!',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2C3E50)),
              ),
              const SizedBox(height: 8),
              Text(
                'Você deu ${_nota.toStringAsFixed(0)} estrelas para ${widget.nomeProfissional}',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 15, color: Colors.grey),
              ),
              const SizedBox(height: 24),

              // Exibe as estrelas dadas
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  5,
                  (i) => Icon(
                    i < _nota ? Icons.star : Icons.star_border,
                    size: 36,
                    color: Colors.amber,
                  ),
                ),
              ),

              if (_comentarioController.text.trim().isNotEmpty) ...[
                const SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Seu comentário:',
                          style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                              fontWeight: FontWeight.bold)),
                      const SizedBox(height: 6),
                      Text(
                        '"${_comentarioController.text.trim()}"',
                        style: const TextStyle(
                            fontSize: 14,
                            fontStyle: FontStyle.italic,
                            color: Color(0xFF2C3E50)),
                      ),
                    ],
                  ),
                ),
              ],

              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFF4CAF50).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.info_outline,
                        color: Color(0xFF4CAF50), size: 18),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Esta avaliação já está visível no perfil do profissional e ajudará outros clientes.',
                        style: TextStyle(fontSize: 12, color: Colors.black87),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        SizedBox(
          width: double.infinity,
          height: 58,
          child: ElevatedButton(
            onPressed: () =>
                Navigator.popUntil(context, ModalRoute.withName('/home')),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2C3E50),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
            ),
            child: const Text('VOLTAR AO INÍCIO',
                style:
                    TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          ),
        ),
      ],
    );
  }

  String _getDescricaoNota(double nota) {
    switch (nota.toInt()) {
      case 1:
        return 'Muito ruim 😞';
      case 2:
        return 'Ruim 😕';
      case 3:
        return 'Regular 😐';
      case 4:
        return 'Bom 😊';
      case 5:
        return 'Excelente! 🌟';
      default:
        return '';
    }
  }

  Color _getCorNota(double nota) {
    if (nota <= 2) return Colors.red;
    if (nota == 3) return Colors.orange;
    return const Color(0xFF4CAF50);
  }
}