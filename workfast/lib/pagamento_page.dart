import 'package:flutter/material.dart';
import 'package:workfast/pagamento_service.dart';
import 'package:workfast/notificacao_service.dart';
import 'package:workfast/chamado_model.dart';

class PagamentoPage extends StatefulWidget {
  final String nomeProfissional;
  final String chamadoNome;
  final double valor;
  final String contatoCliente;
  final String localServico;

  const PagamentoPage({
    super.key,
    required this.nomeProfissional,
    required this.chamadoNome,
    this.valor = 150.00,
    this.contatoCliente = '(31) 99999-0000',
    this.localServico = 'Rua das Flores, 123 - Contagem/MG',
  });

  @override
  State<PagamentoPage> createState() => _PagamentoPageState();
}

class _PagamentoPageState extends State<PagamentoPage> {
  bool _pagamentoConfirmado = false;
  bool _processando = false;
  Pagamento? _pagamento;

  @override
  void initState() {
    super.initState();
    _criarPagamento();
  }

  Future<void> _criarPagamento() async {
    final p = await PagamentoService.criarPagamento(
      chamadoNome: widget.chamadoNome,
      nomeProfissional: widget.nomeProfissional,
      valor: widget.valor,
      contatoCliente: widget.contatoCliente,
      localServico: widget.localServico,
    );
    if (mounted) setState(() => _pagamento = p);
  }

  Future<void> _confirmarPagamento() async {
    if (_pagamento == null) return;
    setState(() => _processando = true);
    await Future.delayed(const Duration(seconds: 2));
    await PagamentoService.confirmarPagamento(_pagamento!);

    // Remover o serviço da tela inicial
    await ChamadoService.removerChamadoPorNomeEDescricao(
        widget.nomeProfissional, widget.chamadoNome);

    // Remover a notificação de proposta
    await NotificacaoService.removerNotificacaoProposta(
        widget.nomeProfissional, widget.chamadoNome);

    // CORREÇÃO: Garantir que a notificação de pagamento use o valor correto e seja do tipo 'pagamento'
    await NotificacaoService.adicionarNotificacao(Notificacao(
      titulo: 'Pagamento Confirmado! ✅',
      mensagem:
          'Pagamento de R\$ ${widget.valor.toStringAsFixed(2)} confirmado. O profissional ${widget.nomeProfissional} recebeu seus dados.',
      data: DateTime.now(),
      tipo: 'pagamento',
      nomeProfissional: widget.nomeProfissional,
      especializacoes: [],
      chamadoNome: widget.chamadoNome,
      valorProposta: widget.valor, // Importante: salvar o valor na notificação
    ));

    if (mounted) {
      setState(() {
        _processando = false;
        _pagamentoConfirmado = true;
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
        title: const Text('Pagamento Seguro',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: _pagamentoConfirmado
            ? _buildPagamentoConfirmado(isDarkMode)
            : _buildQrCode(isDarkMode),
      ),
    );
  }

  Widget _buildQrCode(bool isDarkMode) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(20),
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
              Icon(Icons.qr_code_2,
                  size: 80,
                  color: isDarkMode ? Colors.white : const Color(0xFF2C3E50)),
              const SizedBox(height: 16),
              Text(
                'R\$ ${widget.valor.toStringAsFixed(2)}',
                style: const TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF4CAF50)),
              ),
              const SizedBox(height: 8),
              Text(
                'Serviço: ${widget.chamadoNome}',
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: isDarkMode ? Colors.white : const Color(0xFF2C3E50)),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                'Profissional: ${widget.nomeProfissional}',
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(
                      color:
                          isDarkMode ? Colors.white24 : const Color(0xFF2C3E50),
                      width: 3),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: CustomPaint(
                  size: const Size(180, 180),
                  painter: _QrCodePainter(isDarkMode: isDarkMode),
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isDarkMode
                      ? Colors.white.withOpacity(0.05)
                      : Colors.grey[50],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.grey, size: 18),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Escaneie o QR Code acima com o app do seu banco ou use o botão abaixo para simular o pagamento.',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.green.withOpacity(0.15),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.green.withOpacity(0.3)),
          ),
          child: const Row(
            children: [
              Icon(Icons.lock, color: Color(0xFF4CAF50), size: 20),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Pagamento 100% seguro e criptografado. Seus dados de contato só serão enviados ao profissional após confirmação.',
                  style: TextStyle(fontSize: 12, color: Colors.white70),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          height: 58,
          child: ElevatedButton(
            onPressed: _processando ? null : _confirmarPagamento,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4CAF50),
              foregroundColor: Colors.white,
              elevation: 8,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
            ),
            child: _processando
                ? const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                              color: Colors.white, strokeWidth: 2)),
                      SizedBox(width: 12),
                      Text('Processando pagamento...',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  )
                : const Text('CONFIRMAR PAGAMENTO',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
        ),
      ],
    );
  }

  Widget _buildPagamentoConfirmado(bool isDarkMode) {
    return Column(
      children: [
        Container(
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
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF4CAF50).withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check_circle,
                    size: 64, color: Color(0xFF4CAF50)),
              ),
              const SizedBox(height: 20),
              Text(
                'Pagamento Confirmado!',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.white : const Color(0xFF2C3E50)),
              ),
              const SizedBox(height: 8),
              Text(
                'R\$ ${widget.valor.toStringAsFixed(2)} pagos com sucesso',
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 24),
              const Divider(),
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Dados do Serviço',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color:
                          isDarkMode ? Colors.white : const Color(0xFF2C3E50)),
                ),
              ),
              const SizedBox(height: 12),
              _buildInfoRow(Icons.person, 'Profissional',
                  widget.nomeProfissional, isDarkMode),
              const SizedBox(height: 10),
              _buildInfoRow(
                  Icons.work, 'Serviço', widget.chamadoNome, isDarkMode),
              const SizedBox(height: 10),
              _buildInfoRow(Icons.phone, 'Seu contato (enviado)',
                  widget.contatoCliente, isDarkMode),
              const SizedBox(height: 10),
              _buildInfoRow(Icons.location_on, 'Local do serviço',
                  widget.localServico, isDarkMode),
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
        ),
      ],
    );
  }

  Widget _buildInfoRow(
      IconData icon, String label, String value, bool isDarkMode) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.grey),
        const SizedBox(width: 10),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: TextStyle(
                  fontSize: 14,
                  color: isDarkMode ? Colors.white70 : Colors.black87),
              children: [
                TextSpan(
                    text: '$label: ',
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(text: value),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _QrCodePainter extends CustomPainter {
  final bool isDarkMode;
  _QrCodePainter({required this.isDarkMode});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = isDarkMode ? Colors.white : const Color(0xFF2C3E50)
      ..strokeWidth = 2
      ..style = PaintingStyle.fill;

    // Desenha um QR Code simulado com quadradinhos
    double cellSize = size.width / 10;
    for (int i = 0; i < 10; i++) {
      for (int j = 0; j < 10; j++) {
        if ((i + j) % 2 == 0 || (i == 0 || i == 9 || j == 0 || j == 9)) {
          canvas.drawRect(
            Rect.fromLTWH(
                i * cellSize, j * cellSize, cellSize - 2, cellSize - 2),
            paint,
          );
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
