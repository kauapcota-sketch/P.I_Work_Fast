import 'package:flutter/material.dart';
import 'package:workfast/Eletrica_trabalho.dart';
import 'package:workfast/buscar_trabalho.dart';
import 'package:workfast/estrutural_trabalho.dart';
import 'package:workfast/perfil.dart';

import 'package:workfast/registrar_problema_page.dart'; // 👈 IMPORTANTE

void main() {
  runApp(const InformaticaTrabalho());
}

class InformaticaTrabalho extends StatelessWidget {
  const InformaticaTrabalho({super.key});

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

              // 🔹 CATEGORIAS
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _botao(context, "Geral", busctrabalho()),
                    _chipAtivo("Informática"),
                    _botao(context, "Elétrica", EletricaTrabalho()),
                    _botao(context, "Estrutural", EstruturalTrabalho()),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // 📋 LISTA
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
                      nome: 'Marcos Oliveira',
                      descricao: 'Preciso de um criador de software.',
                      telefone: '31 7690-4521',
                      email: 'Marcos@gmail.com.br',
                    ),
                    SizedBox(height: 15),
                    CardChamado(
                      nome: 'João Pedro',
                      descricao: 'Minha internet está muito lenta.',
                      telefone: '31 7842-5632',
                      email: 'João@gmail.com.br',
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10),

              // 📸 BOTÃO INFERIOR FUNCIONANDO
              InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const registraProblema(),
                    ),
                  );
                },
                child: Ink(
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.blueAccent,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blueAccent.withOpacity(0.4),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      )
                    ],
                  ),
                  child: const Center(
                    child:
                        Icon(Icons.camera_alt, size: 28, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 🔹 BOTÃO NORMAL
  Widget _botao(BuildContext context, String texto, Widget pagina) {
    return TextButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => pagina),
        );
      },
      style: TextButton.styleFrom(padding: EdgeInsets.zero),
      child: Container(
        margin: const EdgeInsets.only(right: 10),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white10,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          texto,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  // 🔹 CHIP ATIVO
  Widget _chipAtivo(String texto) {
    return Container(
      margin: const EdgeInsets.only(right: 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.blueAccent,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        texto,
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}

// 🧩 CARD
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
          Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.blueAccent,
                child:
                    Text(nome[0], style: const TextStyle(color: Colors.white)),
              ),
              const SizedBox(width: 10),
              Text(
                nome,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              )
            ],
          ),
          const SizedBox(height: 10),
          Text(descricao),
          const SizedBox(height: 10),
          Text(telefone),
          Text(email, style: const TextStyle(fontSize: 12)),
          const SizedBox(height: 5),
          const Align(
            alignment: Alignment.centerRight,
            child: Text(
              'Ler mais...',
              style: TextStyle(color: Colors.blueAccent, fontSize: 12),
            ),
          )
        ],
      ),
    );
  }
}
