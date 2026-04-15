import 'package:flutter/material.dart';
import 'package:workfast/chamado_model.dart';

class DetalhesChamadoPage extends StatelessWidget {
  final Chamado chamado;

  const DetalhesChamadoPage({super.key, required this.chamado});

  @override
  Widget build(BuildContext context) {
    // Define a cor baseada na categoria para um visual dinâmico
    Color categoriaColor;
    IconData categoriaIcon;

    switch (chamado.categoria) {
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
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 35,
                          backgroundColor: categoriaColor,
                          child: Text(
                            chamado.nome[0].toUpperCase(),
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
                                chamado.nome,
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF2C3E50),
                                ),
                              ),
                              const SizedBox(height: 5),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: categoriaColor,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(categoriaIcon, size: 14, color: Colors.white),
                                    const SizedBox(width: 5),
                                    Text(
                                      chamado.categoria.name.toUpperCase(),
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
                          chamado.descricao,
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
                        _buildContactItem(Icons.phone, chamado.telefone, Colors.green),
                        const SizedBox(height: 10),
                        _buildContactItem(Icons.email, chamado.email, Colors.indigo),
                        
                        const SizedBox(height: 40),

                        // Botões de Ação
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  // Lógica para aceitar
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Você aceitou este chamado!')),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF4CAF50),
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(vertical: 15),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  elevation: 5,
                                ),
                                child: const Text(
                                  'ACEITAR SERVIÇO',
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),
                        Center(
                          child: TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text(
                              'Voltar para a lista',
                              style: TextStyle(color: Colors.grey.shade600, fontWeight: FontWeight.w600),
                            ),
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
