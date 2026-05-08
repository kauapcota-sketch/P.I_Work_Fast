import 'package:flutter/material.dart';
import 'package:workfast/chamado_model.dart';
import 'package:workfast/detalhes_chamado_page.dart';

class InformaticaTrabalho extends StatelessWidget {
  const InformaticaTrabalho({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final informaticaChamados =
        ChamadoService.getChamadosPorCategoria(CategoriaChamado.informatica);

    return Scaffold(
      backgroundColor:
          isDarkMode ? const Color(0xFF1B2836) : const Color(0xFF2C3E50),
      appBar: AppBar(
        backgroundColor:
            isDarkMode ? const Color(0xFF1B2836) : const Color(0xFF2C3E50),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Chamados de Informática',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
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
                  child: _CardChamadoLocal(chamado: chamado),
                );
              },
            ),
    );
  }
}

class _CardChamadoLocal extends StatelessWidget {
  final Chamado chamado;

  const _CardChamadoLocal({required this.chamado});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => DetalhesChamadoPage(chamado: chamado)),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDarkMode
              ? Colors.white.withOpacity(0.05)
              : Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withOpacity(0.1)),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: Colors.blueAccent.withOpacity(0.2),
              child: Text(
                chamado.nome.isNotEmpty ? chamado.nome[0].toUpperCase() : '?',
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    chamado.nome,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    chamado.descricao,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios,
                color: Colors.white30, size: 16),
          ],
        ),
      ),
    );
  }
}
