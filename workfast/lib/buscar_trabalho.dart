import 'package:flutter/material.dart';
import 'package:workfast/perfil.dart';
import 'package:workfast/registrar_problema_page.dart';
import 'package:workfast/chamado_model.dart'; // Mudei de "chamado_model.dart" (com espaço) para "chamado_model.dart" (com underline)

void main() {
  runApp(const busctrabalho());
}

class busctrabalho extends StatelessWidget {
  const busctrabalho({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const TelaLista(),
    );
  }
}

class TelaLista extends StatefulWidget {
  const TelaLista({super.key});

  @override
  State<TelaLista> createState() => _TelaListaState();
}

class _TelaListaState extends State<TelaLista> {
  CategoriaChamado _categoriaSelecionada = CategoriaChamado.geral;
  List<Chamado> _chamadosExibidos = [];

  @override
  void initState() {
    super.initState();
    _filtrarChamados();
  }

  void _filtrarChamados() {
    setState(() {
      _chamadosExibidos =
          ChamadoService.getChamadosPorCategoria(_categoriaSelecionada);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2C3E50), // Fundo escuro para contraste
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // 🔝 TOPO - Configurações e Avatar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.settings,
                        color: Colors.white, size: 28),
                    onPressed: () {
                      // Ação para configurações
                    },
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PerfilPage(),
                        ),
                      );
                    },
                    child: const CircleAvatar(
                      radius: 24,
                      backgroundImage: NetworkImage(
                          'https://i.pravatar.cc/100?img=3'), // Imagem de avatar dinâmica
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Título da Página
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Chamados Recentes',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // 🏷️ CATEGORIAS - Botões clicáveis
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _categoriaButton('Geral', CategoriaChamado.geral),
                    _categoriaButton(
                        'Informática', CategoriaChamado.informatica),
                    _categoriaButton('Elétrica', CategoriaChamado.eletrica),
                    _categoriaButton('Estrutural', CategoriaChamado.estrutural),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // 📋 LISTA DE CHAMADOS
              Expanded(
                child: _chamadosExibidos.isEmpty
                    ? const Center(
                        child: Text(
                          'Nenhum chamado nesta categoria.',
                          style: TextStyle(color: Colors.white70, fontSize: 16),
                        ),
                      )
                    : ListView.builder(
                        itemCount: _chamadosExibidos.length,
                        itemBuilder: (context, index) {
                          final chamado = _chamadosExibidos[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 15),
                            child: CardChamado(
                              nome: chamado.nome,
                              descricao: chamado.descricao,
                              telefone: chamado.telefone,
                              email: chamado.email,
                            ),
                          );
                        },
                      ),
              ),

              const SizedBox(height: 20),

              // 📸 BOTÃO INFERIOR - REGISTRAR PROBLEMA
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const registraProblema(),
                    ),
                  );
                },
                child: Container(
                  height: 70,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFF4CAF50),
                        Color(0xFF8BC34A)
                      ], // Gradiente de verde
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF4CAF50).withOpacity(0.5),
                        blurRadius: 15,
                        offset: const Offset(0, 8),
                      )
                    ],
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add_circle_outline,
                          size: 28, color: Colors.white),
                      SizedBox(width: 12),
                      Text(
                        'REGISTRAR PROBLEMA',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _categoriaButton(String texto, CategoriaChamado categoria) {
    final isSelected = _categoriaSelecionada == categoria;
    return GestureDetector(
      onTap: () {
        setState(() {
          _categoriaSelecionada = categoria;
          _filtrarChamados();
        });
      },
      child: Container(
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF4CAF50)
              : Colors.grey.withOpacity(0.2),
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF4CAF50)
                : Colors.grey.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Text(
          texto,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.white70,
            fontWeight: FontWeight.w600,
            fontSize: 15,
          ),
        ),
      ),
    );
  }
}

// 🧩 CARD MODERNO
class CardChamado extends StatelessWidget {
  final String nome;
  final String descricao;
  final String telefone;
  final String email;

  const CardChamado({
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
          // 👤 NOME
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
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      nome,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    Text(
                      'Chamado #${DateTime.now().millisecondsSinceEpoch.toString().substring(8, 11)}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),

          const SizedBox(height: 14),

          // 📞 CONTATO
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Row(
              children: [
                const Icon(Icons.call, color: Color(0xFF4CAF50), size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(telefone,
                          style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.black87)),
                      Text(email,
                          style: TextStyle(
                              fontSize: 12, color: Colors.grey.shade600)),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // 📝 DESCRIÇÃO
          Text(
            descricao,
            style: TextStyle(
              fontSize: 14,
              height: 1.4,
              color: Colors.grey.shade700,
            ),
          ),
        ],
      ),
    );
  }
}
