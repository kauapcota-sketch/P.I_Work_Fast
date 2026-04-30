import 'package:flutter/material.dart';
import 'package:workfast/pagamento_service.dart';
import 'package:workfast/notificacao_service.dart';

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

    // Notificação de pagamento confirmado
    await NotificacaoService.adicionarNotificacao(Notificacao(
      titulo: 'Pagamento Confirmado! ✅',
      mensagem:
          'Pagamento de R\$ ${widget.valor.toStringAsFixed(2)} confirmado. O profissional ${widget.nomeProfissional} recebeu seus dados.',
      data: DateTime.now(),
      tipo: 'pagamento',
      nomeProfissional: widget.nomeProfissional,
      especializacoes: [],
      chamadoNome: widget.chamadoNome,
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
    return Scaffold(
      backgroundColor: const Color(0xFF2C3E50),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2C3E50),
        elevation: 0,
        title: const Text('Pagamento Seguro',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: _pagamentoConfirmado
            ? _buildPagamentoConfirmado()
            : _buildQrCode(),
      ),
    );
  }

  Widget _buildQrCode() {
    return Column(
      children: [
        // Info do serviço
        Container(
          padding: const EdgeInsets.all(20),
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
              const Icon(Icons.qr_code_2, size: 80, color: Color(0xFF2C3E50)),
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
                style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2C3E50)),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                'Profissional: ${widget.nomeProfissional}',
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 20),

              // QR Code simulado
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFF2C3E50), width: 3),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: CustomPaint(
                  size: const Size(180, 180),
                  painter: _QrCodePainter(),
                ),
              ),

              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
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

        // Aviso de segurança
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

  Widget _buildPagamentoConfirmado() {
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
              const Text(
                'Pagamento Confirmado!',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2C3E50)),
              ),
              const SizedBox(height: 8),
              Text(
                'R\$ ${widget.valor.toStringAsFixed(2)} pagos com sucesso',
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 24),
              const Divider(),
              const SizedBox(height: 16),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Dados do Serviço',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2C3E50)),
                ),
              ),
              const SizedBox(height: 12),
              _buildInfoRow(
                  Icons.person, 'Profissional', widget.nomeProfissional),
              const SizedBox(height: 10),
              _buildInfoRow(Icons.work, 'Serviço', widget.chamadoNome),
              const SizedBox(height: 10),
              _buildInfoRow(
                  Icons.phone, 'Seu contato (enviado)', widget.contatoCliente),
              const SizedBox(height: 10),
              _buildInfoRow(Icons.location_on, 'Local do serviço',
                  widget.localServico),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.blue, size: 18),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'O profissional recebeu seus dados de contato e endereço. Aguarde o contato dele!',
                        style: TextStyle(fontSize: 12, color: Colors.black87),
                      ),
                    ),
                  ],
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
            onPressed: () =>
                Navigator.popUntil(context, ModalRoute.withName('/home')),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2C3E50),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
            ),
            child: const Text('VOLTAR AO INÍCIO',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String valor) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF4CAF50), size: 20),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: const TextStyle(fontSize: 11, color: Colors.grey)),
              Text(valor,
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w600)),
            ],
          ),
        ],
      ),
    );
  }
}

// Painter para QR Code visual simulado
class _QrCodePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF2C3E50)
      ..style = PaintingStyle.fill;

    final cellSize = size.width / 21;

    // Padrão simulado de QR code
    final pattern = [
      [1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 1, 0, 1, 0, 1, 1, 1, 1, 1, 1, 1],
      [1, 0, 0, 0, 0, 0, 1, 0, 0, 1, 0, 1, 0, 0, 1, 0, 0, 0, 0, 0, 1],
      [1, 0, 1, 1, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 1, 1, 0, 1],
      [1, 0, 1, 1, 1, 0, 1, 0, 0, 1, 0, 1, 0, 0, 1, 0, 1, 1, 1, 0, 1],
      [1, 0, 1, 1, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 1, 1, 0, 1],
      [1, 0, 0, 0, 0, 0, 1, 0, 0, 1, 0, 1, 0, 0, 1, 0, 0, 0, 0, 0, 1],
      [1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 1, 0, 1, 0, 1, 1, 1, 1, 1, 1, 1],
      [0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0],
      [1, 0, 1, 1, 0, 1, 1, 1, 0, 0, 1, 0, 1, 1, 0, 1, 1, 0, 1, 0, 1],
      [0, 1, 0, 0, 1, 0, 0, 1, 1, 0, 0, 1, 0, 0, 1, 0, 0, 1, 0, 1, 0],
      [1, 0, 1, 0, 1, 0, 1, 0, 0, 1, 0, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1],
      [0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0],
      [1, 0, 0, 0, 1, 0, 1, 0, 1, 0, 1, 0, 0, 0, 1, 0, 1, 0, 0, 0, 1],
      [0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 1, 0, 1, 0, 0, 0, 1, 0, 0, 0],
      [1, 1, 1, 1, 1, 1, 1, 0, 0, 1, 0, 0, 1, 0, 0, 1, 1, 0, 1, 0, 1],
      [1, 0, 0, 0, 0, 0, 1, 0, 1, 0, 1, 0, 0, 1, 0, 0, 1, 0, 0, 1, 0],
      [1, 0, 1, 1, 1, 0, 1, 0, 0, 1, 0, 1, 0, 0, 1, 0, 0, 1, 1, 0, 1],
      [1, 0, 1, 1, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 0, 1, 0, 0, 0, 1, 0],
      [1, 0, 1, 1, 1, 0, 1, 0, 0, 1, 0, 0, 0, 1, 0, 0, 1, 0, 1, 0, 1],
      [1, 0, 0, 0, 0, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 0, 1, 0, 1, 0],
      [1, 1, 1, 1, 1, 1, 1, 0, 0, 1, 0, 1, 0, 1, 0, 1, 0, 0, 1, 0, 1],
    ];

    for (int row = 0; row < pattern.length; row++) {
      for (int col = 0; col < pattern[row].length; col++) {
        if (pattern[row][col] == 1) {
          canvas.drawRect(
            Rect.fromLTWH(
              col * cellSize,
              row * cellSize,
              cellSize,
              cellSize,
            ),
            paint,
          );
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}