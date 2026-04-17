import 'package:flutter/material.dart';
import 'package:workfast/buscar_trabalho.dart';
import 'package:workfast/chamado_model.dart';
import 'package:workfast/main.dart'; // Importa o CardChamado

class EstruturalTrabalho extends StatelessWidget {
  const EstruturalTrabalho({super.key});

  @override
  Widget build(BuildContext context) {
    final estruturalChamados = ChamadoService.getChamadosPorCategoria(CategoriaChamado.estrutural);

    return Scaffold(
      backgroundColor: const Color(0xFF2C3E50),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2C3E50),
        elevation: 0,
        title: const Text(
          'Chamados Estruturais',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: estruturalChamados.isEmpty
          ? const Center(
              child: Text(
                'Nenhum chamado Estrutural encontrado.',
                style: TextStyle(color: Colors.white70, fontSize: 16),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: estruturalChamados.length,
              itemBuilder: (context, index) {
                final chamado = estruturalChamados[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: CardChamado(chamado: chamado),
                );
              },
            ),
    );
  }
}
