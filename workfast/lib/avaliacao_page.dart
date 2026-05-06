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
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final bgColor =
        isDarkMode ? const Color(0xFF1B2836) : const Color(0xFF2C3E50);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Avaliar Serviço',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: _enviado
            ? _buildResultado(isDarkMode)
            : _buildFormulario(isDarkMode),
      ),
    );
  }

  Widget _buildFormulario(bool isDarkMode) {
    return Column(
      children: [
        if (!_confirmouServico) ...[
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: isDarkMode ? const Color(0xFF2C3E50) : Colors.white,
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
                Text(
                  'O serviço foi concluído?',
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color:
                          isDarkMode ? Colors.white : const Color(0xFF2C3E50)),
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
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: isDarkMode ? const Color(0xFF2C3E50) : Colors.white,
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
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color:
                          isDarkMode ? Colors.white : const Color(0xFF2C3E50)),
                ),
                const SizedBox(height: 4),
                Text(
                  'Serviço: ${widget.chamadoNome}',
                  style: const TextStyle(fontSize: 13, color: Colors.grey),
                ),
                const SizedBox(height: 24),
                Text(
                  'Como foi o serviço?',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color:
                          isDarkMode ? Colors.white : const Color(0xFF2C3E50)),
                ),
                const SizedBox(height: 16),
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
                    color: _nota == 0 ? Colors.grey : _getCorNota(_nota),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 24),
                const Divider(),
                const SizedBox(height: 16),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Deixe um comentário (opcional)',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: isDarkMode
                            ? Colors.white
                            : const Color(0xFF2C3E50)),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _comentarioController,
                  maxLines: 3,
                  style: TextStyle(
                      color: isDarkMode ? Colors.white : Colors.black),
                  decoration: InputDecoration(
                    hintText: 'Ex: Profissional pontual, serviço bem feito...',
                    hintStyle: TextStyle(
                        color: isDarkMode ? Colors.white38 : Colors.grey),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14)),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(
                          color: isDarkMode
                              ? Colors.white24
                              : Colors.grey.shade300),
                    ),
                    filled: true,
                    fillColor: isDarkMode
                        ? Colors.white.withOpacity(0.05)
                        : Colors.grey[50],
                  ),
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: _enviando ? null : _enviarAvaliacao,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4CAF50),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                      elevation: 4,
                    ),
                    child: _enviando
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text('ENVIAR AVALIAÇÃO',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildResultado(bool isDarkMode) {
    return Container(
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF2C3E50) : Colors.white,
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
          const Icon(Icons.check_circle, size: 80, color: Color(0xFF4CAF50)),
          const SizedBox(height: 20),
          Text(
            'Obrigado!',
            style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.white : const Color(0xFF2C3E50)),
          ),
          const SizedBox(height: 12),
          const Text(
            'Sua avaliação ajuda a manter a qualidade dos serviços no WorkFast.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
          const SizedBox(height: 30),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2C3E50),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
              ),
              child: const Text('VOLTAR AO INÍCIO',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  String _getDescricaoNota(double nota) {
    if (nota == 1) return 'Péssimo';
    if (nota == 2) return 'Ruim';
    if (nota == 3) return 'Regular';
    if (nota == 4) return 'Bom';
    return 'Excelente!';
  }

  Color _getCorNota(double nota) {
    if (nota <= 2) return Colors.red;
    if (nota == 3) return Colors.orange;
    return Colors.green;
  }
}
