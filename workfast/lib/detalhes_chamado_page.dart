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

  @override
  void initState() {
    super.initState();
    _carregarAvaliacoes();
  }

  void _carregarAvaliacoes() {
    setState(() {
      _avaliacoes =
          AvaliacaoService.getAvaliacoesDoProfissional(widget.chamado.nome);
      _media = AvaliacaoService.getMediaNota(widget.chamado.nome);
    });
  }

  @override
  Widget build(BuildContext context) {
    // Define a cor baseada na categoria para um visual dinâmico
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
      backgroundColor: const Color(0xFF2C3E50),
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
            // Card Principal
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
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
                  // Cabeçalho do Card com Foto e Nome
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
                            widget.chamado.nome[0].toUpperCase(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.chamado.nome,
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF2C3E50),
                                ),
                              ),
                              const SizedBox(height: 5),
                              // Avaliação média
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
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      '${_media.toStringAsFixed(1)} (${_avaliacoes.length})',
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey[700]),
                                    ),
                                  ],
                                ),
                              const SizedBox(height: 5),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: categoriaColor,
                                  borderRadius: BorderRadius.circular(20),
                                ),
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
                                        fontWeight: FontWeight.bold,
                                      ),
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

                  // Conteúdo do Card
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
                        const Text(
                          'Descrição do Problema',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2C3E50),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          widget.chamado.descricao,
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.grey.shade700,
                            height: 1.6,
                          ),
                        ),
                        const SizedBox(height: 30),

                        // Seção de Contato
                        const Text(
                          'Informações de Contato',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2C3E50),
                          ),
                        ),
                        const SizedBox(height: 15),
                        _buildContactItem(Icons.phone, widget.chamado.telefone,
                            Colors.green),
                        const SizedBox(height: 10),
                        _buildContactItem(
                            Icons.email, widget.chamado.email, Colors.indigo),

                        const SizedBox(height: 30),

                        // Botões de Ação
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  // Solicitar serviço - vai para pagamento
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => PagamentoPage(
                                        nomeProfissional: widget.chamado.nome,
                                        chamadoNome: widget.chamado.descricao
                                            .substring(
                                          0,
                                          widget.chamado.descricao.length > 30
                                              ? 30
                                              : widget.chamado.descricao.length,
                                        ),
                                        contatoCliente: widget.chamado.telefone,
                                        localServico:
                                            'Endereço confirmado no app',
                                      ),
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF4CAF50),
                                  foregroundColor: Colors.white,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 15),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  elevation: 5,
                                ),
                                child: const Text(
                                  'ACEITAR SERVIÇO',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 12),

                        // Botão Avaliar (se já tiver histórico)
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            onPressed: () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => AvaliacaoPage(
                                    nomeProfissional: widget.chamado.nome,
                                    chamadoNome: widget.chamado.descricao
                                        .substring(
                                      0,
                                      widget.chamado.descricao.length > 30
                                          ? 30
                                          : widget.chamado.descricao.length,
                                    ),
                                  ),
                                ),
                              );
                              _carregarAvaliacoes();
                            },
                            icon: const Icon(Icons.star_outline,
                                color: Colors.amber),
                            label: const Text(
                              'AVALIAR SERVIÇO',
                              style: TextStyle(
                                  color: Colors.amber,
                                  fontWeight: FontWeight.bold),
                            ),
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: Colors.amber),
                              padding:
                                  const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15)),
                            ),
                          ),
                        ),

                        const SizedBox(height: 15),
                        Center(
                          child: TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text(
                              'Voltar para a lista',
                              style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Seção de Avaliações
            if (_avaliacoes.isNotEmpty) ...[
              const SizedBox(height: 24),
              _buildAvaliacoesSection(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildAvaliacoesSection() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 15,
              offset: const Offset(0, 6))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: Color(0xFF2C3E50),
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Row(
              children: [
                const Icon(Icons.star, color: Colors.amber, size: 22),
                const SizedBox(width: 10),
                const Text(
                  'Avaliações',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.amber.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 14),
                      const SizedBox(width: 4),
                      Text(
                        _media.toStringAsFixed(1),
                        style: const TextStyle(
                            color: Colors.amber,
                            fontWeight: FontWeight.bold,
                            fontSize: 13),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: _avaliacoes
                  .take(3)
                  .map((a) => _buildAvaliacaoItem(a))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvaliacaoItem(Avaliacao avaliacao) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 14,
                backgroundColor: const Color(0xFF4CAF50),
                child: Text(
                  avaliacao.nomeAvaliador.isNotEmpty
                      ? avaliacao.nomeAvaliador[0].toUpperCase()
                      : '?',
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(width: 8),
              Text(avaliacao.nomeAvaliador,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 13)),
              const Spacer(),
              Row(
                children: List.generate(
                  5,
                  (i) => Icon(
                    i < avaliacao.nota ? Icons.star : Icons.star_border,
                    color: Colors.amber,
                    size: 14,
                  ),
                ),
              ),
            ],
          ),
          if (avaliacao.comentario.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              avaliacao.comentario,
              style: TextStyle(fontSize: 13, color: Colors.grey[700]),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildContactItem(IconData icon, String text, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(width: 15),
          Text(
            text,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}