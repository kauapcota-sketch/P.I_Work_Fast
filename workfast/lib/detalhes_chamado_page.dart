import 'package:flutter/material.dart';
import 'package:workfast/chamado_model.dart';
import 'package:workfast/avaliacao_service.dart';
import 'package:workfast/avaliacao_page.dart';
import 'package:workfast/pagamento_page.dart';

class DetalhesChamadoPage extends StatefulWidget {
  final Chamado chamado;

  const DetalhesChamadoPage({super.key, required this.chamado});

  @override
  State<DetalhesChamadoPage> createState() => _DetalhesChamadoPageState();
}

class _DetalhesChamadoPageState extends State<DetalhesChamadoPage> {
  List<Avaliacao> _avaliacoes = [];
  double _media = 0.0;
  final _propostaController = TextEditingController();
  late StatusNegociacao _status;
  late double? _valorFinal;

  @override
  void initState() {
    super.initState();
    _status = widget.chamado.status;
    _valorFinal = widget.chamado.valorFinal;
    _carregarAvaliacoes();
  }

  void _carregarAvaliacoes() {
    setState(() {
      _avaliacoes =
          AvaliacaoService.getAvaliacoesDoProfissional(widget.chamado.nome);
      _media = AvaliacaoService.getMediaNota(widget.chamado.nome);
    });
  }

  void _enviarProposta() {
    final valor = double.tryParse(_propostaController.text);
    if (valor == null || valor <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Insira um valor válido para a proposta.')),
      );
      return;
    }

    widget.chamado.status = StatusNegociacao.propostaEnviada;
    widget.chamado.valorFinal = valor;
    widget.chamado.save();

    setState(() {
      _status = StatusNegociacao.propostaEnviada;
      _valorFinal = valor;
    });

    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content:
              Text('Proposta de R\$ ${valor.toStringAsFixed(2)} enviada!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    Color categoriaColor;
    IconData categoriaIcon;

    switch (widget.chamado.categoria) {
      case CategoriaChamado.informatica:
        categoriaColor = Colors.blue;
        categoriaIcon = Icons.computer;
        break;
      case CategoriaChamado.eletrica:
        categoriaColor = Colors.orange;
        categoriaIcon = Icons.electric_bolt;
        break;
      case CategoriaChamado.estrutural:
        categoriaColor = Colors.green;
        categoriaIcon = Icons.build;
        break;
      default:
        categoriaColor = Colors.grey;
        categoriaIcon = Icons.work;
    }

    return Scaffold(
      backgroundColor:
          isDarkMode ? const Color(0xFF1B2836) : const Color(0xFF2C3E50),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Detalhes do Serviço',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: isDarkMode ? const Color(0xFF2C3E50) : Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: categoriaColor.withOpacity(0.1),
                      borderRadius:
                          const BorderRadius.vertical(top: Radius.circular(30)),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 35,
                          backgroundColor: categoriaColor,
                          child: Text(
                            widget.chamado.nome.isNotEmpty
                                ? widget.chamado.nome[0].toUpperCase()
                                : '?',
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 30,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.chamado.nome,
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: isDarkMode
                                      ? Colors.white
                                      : const Color(0xFF2C3E50),
                                ),
                              ),
                              const SizedBox(height: 5),
                              if (_media > 0)
                                Row(
                                  children: [
                                    ...List.generate(
                                        5,
                                        (i) => Icon(
                                              i < _media.round()
                                                  ? Icons.star
                                                  : Icons.star_border,
                                              color: Colors.amber,
                                              size: 16,
                                            )),
                                    const SizedBox(width: 4),
                                    Text(
                                      '${_media.toStringAsFixed(1)} (${_avaliacoes.length})',
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: isDarkMode
                                              ? Colors.white70
                                              : Colors.grey[700]),
                                    ),
                                  ],
                                ),
                              const SizedBox(height: 5),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                    color: categoriaColor,
                                    borderRadius: BorderRadius.circular(20)),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(categoriaIcon,
                                        size: 14, color: Colors.white),
                                    const SizedBox(width: 5),
                                    Text(
                                      widget.chamado.categoria.name
                                          .toUpperCase(),
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (widget.chamado.imagem != null) ...[
                          ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Image.file(
                              widget.chamado.imagem!,
                              width: double.infinity,
                              height: 200,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],
                        Text(
                          'Descrição do Problema',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: isDarkMode
                                  ? Colors.white
                                  : const Color(0xFF2C3E50)),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          widget.chamado.descricao,
                          style: TextStyle(
                              fontSize: 15,
                              color: isDarkMode
                                  ? Colors.white70
                                  : Colors.grey.shade700,
                              height: 1.6),
                        ),
                        const SizedBox(height: 30),
                        Text(
                          'Informações de Contato',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: isDarkMode
                                  ? Colors.white
                                  : const Color(0xFF2C3E50)),
                        ),
                        const SizedBox(height: 15),
                        _buildContactItem(Icons.phone, widget.chamado.telefone,
                            Colors.green, isDarkMode),
                        const SizedBox(height: 10),
                        _buildContactItem(Icons.email, widget.chamado.email,
                            Colors.indigo, isDarkMode),
                        const SizedBox(height: 30),

                        // --- SEÇÃO DE NEGOCIAÇÃO ---
                        if (_status == StatusNegociacao.aberto) ...[
                          const Divider(),
                          const SizedBox(height: 10),
                          Text(
                            'Negociar Valor',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: isDarkMode
                                    ? Colors.white
                                    : const Color(0xFF2C3E50)),
                          ),
                          const SizedBox(height: 15),
                          TextField(
                            controller: _propostaController,
                            keyboardType: TextInputType.number,
                            style: TextStyle(
                                color:
                                    isDarkMode ? Colors.white : Colors.black),
                            decoration: InputDecoration(
                              labelText: 'Sua Proposta (R\$)',
                              labelStyle: TextStyle(
                                  color: isDarkMode
                                      ? Colors.white70
                                      : Colors.grey),
                              prefixIcon: const Icon(Icons.attach_money,
                                  color: Colors.green),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15)),
                            ),
                          ),
                          const SizedBox(height: 15),
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: _enviarProposta,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15)),
                              ),
                              child: const Text('ENVIAR PROPOSTA',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold)),
                            ),
                          ),
                        ] else if (_status ==
                            StatusNegociacao.propostaEnviada) ...[
                          Container(
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              color: Colors.amber.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(color: Colors.amber),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.hourglass_empty,
                                    color: Colors.amber),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    'Proposta de R\$ ${_valorFinal?.toStringAsFixed(2)} enviada. Aguardando cliente.',
                                    style: TextStyle(
                                        color: isDarkMode
                                            ? Colors.white
                                            : Colors.black87,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
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

  Widget _buildContactItem(
      IconData icon, String text, Color color, bool isDarkMode) {
    return Row(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 10),
        Text(
          text,
          style: TextStyle(
              fontSize: 16, color: isDarkMode ? Colors.white : Colors.black87),
        ),
      ],
    );
  }
}
