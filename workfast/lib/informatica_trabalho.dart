import 'package:flutter/material.dart';
import 'package:workfast/buscar_trabalho.dart';
import 'package:workfast/chamado_model.dart';

class InformaticaTrabalho extends StatelessWidget {
  const InformaticaTrabalho({super.key});

  @override
  Widget build(BuildContext context) {
    final informaticaChamados =
        ChamadoService.getChamadosPorCategoria(CategoriaChamado.informatica);

    return Scaffold(
      backgroundColor: const Color(0xFF2C3E50),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2C3E50),
        elevation: 0,
        title: const Text(
          'Chamados de Informática',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: informaticaChamados.isEmpty
          ? const Center(
              child: Text(
                'Nenhum chamado de Informática encontrado.',
                style: TextStyle(color: Colors.white70, fontSize: 16),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: informaticaChamados.length,
              itemBuilder: (context, index) {
                final chamado = informaticaChamados[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: CardChamado(chamado: chamado),
                );
              },
            ),
    );
  }
}
