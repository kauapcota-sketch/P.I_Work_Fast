import 'package:flutter/material.dart';
import 'package:workfast/Eletrica_trabalho.dart';
import 'package:workfast/estrutural_trabalho.dart';
import 'package:workfast/informatica_trabalho.dart';
import 'package:workfast/perfil.dart';
import 'package:workfast/registrar_problema_page.dart'; // ✅ IMPORT ADICIONADO

void main() {
  runApp(const busctrabalho());
}

class busctrabalho extends StatelessWidget {
  const busctrabalho({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TelaLista(),
    );
  }
}

class TelaLista extends StatelessWidget {
  const TelaLista({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2C3E50),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // 🔝 TOPO
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Icon(Icons.settings, color: Colors.white),
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
                      backgroundImage:
                          NetworkImage('https://i.pravatar.cc/100'),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // 🏷️ CATEGORIAS
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _categoriaButton('Geral', Colors.grey, () {}),
                    _categoriaButton('Informática', Colors.blue, () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => InformaticaTrabalho()),
                      );
                    }),
                    _categoriaButton('Elétrica', Colors.orange, () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => EletricaTrabalho()),
                      );
                    }),
                    _categoriaButton('Estrutural', Colors.green, () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => EstruturalTrabalho()),
                      );
                    }),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // 📋 LISTA DE CHAMADOS
              Expanded(
                child: ListView(
                  children: const [
                    CardChamado(
                      nome: 'Paulo Henrique',
                      descricao:
                          'Meu computador desligou de repente e agora nao liga mais.',
                      telefone: '31 5983-1047',
                      email: 'paulo@gmail.com.br',
                    ),
                    SizedBox(height: 15),
                    CardChamado(
                      nome: 'Lucas de Oliveira',
                      descricao: 'Preciso de um analista urgente.',
                      telefone: '31 6589-5632',
                      email: 'lucas@gmail.com.br',
                    ),
                    SizedBox(height: 15),
                    CardChamado(
                      nome: 'Italo Freitas',
                      descricao: 'Preciso trocar a cor da minha casa.',
                      telefone: '31 7690-6743',
                      email: 'Italo@gmail.com.br',
                    ),
                    SizedBox(height: 15),
                    CardChamado(
                      nome: 'Mariana Borges',
                      descricao:
                          'Preciso de um desenvolvedor para montar um site.',
                      telefone: '31 8701-7853',
                      email: 'Mariana@gmail.com.br',
                    ),
                    SizedBox(height: 15),
                    CardChamado(
                      nome: 'Rayanne Silva',
                      descricao: 'Meu micro-ondas quebrou.',
                      telefone: '31 9612-3370',
                      email: 'rayanne@gmail.com.br',
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20), // ✅ MAIS ESPAÇO

              // 📸 BOTÃO INFERIOR - REGISTRA PROBLEMA ✅
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          const registraProblema(), // ✅ LINKADO
                    ),
                  );
                },
                child: Container(
                  height: 70, // ✅ MAIOR E MAIS TOCÁVEL
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Colors.blueAccent, Colors.blue],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blueAccent.withOpacity(0.5),
                        blurRadius: 15,
                        offset: const Offset(0, 8),
                      )
                    ],
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.camera_alt, size: 28, color: Colors.white),
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

  // 🔧 WIDGET REUTILIZÁVEL PARA CATEGORIAS
  Widget _categoriaButton(String texto, Color cor, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: cor.withOpacity(0.2),
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: cor.withOpacity(0.3), width: 1),
        ),
        child: Text(
          texto,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}

// 🧩 CARD MODERNO (mantido igual)
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
                backgroundColor: Colors.blueAccent,
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
                Icon(Icons.call, color: Colors.green, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(telefone,
                          style: const TextStyle(fontWeight: FontWeight.w600)),
                      Text(email,
                          style: TextStyle(fontSize: 12, color: Colors.grey)),
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
