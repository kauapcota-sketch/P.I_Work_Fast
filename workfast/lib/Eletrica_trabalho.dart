import 'package:flutter/material.dart';
import 'package:workfast/buscar_trabalho.dart';
import 'package:workfast/chamado_model.dart';

class EletricaTrabalho extends StatelessWidget {
  const EletricaTrabalho({super.key});

  @override
  Widget build(BuildContext context) {
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
                  padding: EdgeInsets.only(bottom: 15),
                  child: CardChamado(chamado: chamado),
                );
              },
            ),
    );
  }
}
