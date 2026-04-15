import 'package:flutter/material.dart';
import 'package:workfast/chamado_model.dart';

class EletricaTrabalho extends StatelessWidget {
  const EletricaTrabalho({super.key});

  @override
  Widget build(BuildContext context) {
    // Tenta buscar da ChamadoService (ajustado para o que criamos antes)
    final eletricaChamados =
        ChamadoService.getChamadosPorCategoria(CategoriaChamado.eletrica);

    return Scaffold(
      backgroundColor: const Color(0xFF2C3E50),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2C3E50),
        elevation: 0,
        title: const Text(
          'Chamados de Elétrica',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: eletricaChamados.isEmpty
          ? const Center(
              child: Text(
                'Nenhum chamado de Elétrica encontrado.',
                style: TextStyle(color: Colors.white70, fontSize: 16),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: eletricaChamados.length,
              itemBuilder: (context, index) {
                final chamado = eletricaChamados[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: LocalCardChamado(
                    // Usando o card definido abaixo
                    nome: chamado.nome,
                    descricao: chamado.descricao,
                    telefone: chamado.telefone,
                    email: chamado.email,
                  ),
                );
              },
            ),
    );
  }
}

// Widget de Card definido aqui dentro para não depender de outros arquivos
class LocalCardChamado extends StatelessWidget {
  final String nome;
  final String descricao;
  final String telefone;
  final String email;

  const LocalCardChamado({
    super.key,
    required this.nome,
    required this.descricao,
    required this.telefone,
    required this.email,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 10,
            offset: const Offset(0, 6),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: const Color(0xFF4CAF50),
                child: Text(
                  nome[0].toUpperCase(),
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                nome,
                style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            descricao,
            style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
          ),
        ],
      ),
    );
  }
}
