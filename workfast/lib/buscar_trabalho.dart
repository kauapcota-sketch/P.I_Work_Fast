import 'package:flutter/material.dart';

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
                  const CircleAvatar(
                    backgroundImage:
                        NetworkImage('https://i.pravatar.cc/100'),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // 📂 CATEGORIAS
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _chip('manutenção'),
                    _chip('pedreiro'),
                    _chip('eletricista'),
                    _chip('programação'),
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
                      nome: 'Lucas de Oliveira',
                      descricao: 'Preciso de um analista urgente.',
                      telefone: '31 6589-5632',
                      email: 'lucas@gmail.com.br',
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10),

              // 📸 BOTÃO INFERIOR
              Container(
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
                  child: Icon(Icons.camera_alt, size: 28, color: Colors.white),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _chip(String text) {
    return Container(
      margin: const EdgeInsets.only(right: 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: const TextStyle(color: Colors.white),
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
                backgroundColor: Colors.blueAccent,
                child: Text(
                  nome[0],
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                nome,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              )
            ],
          ),

          const SizedBox(height: 12),

          // 📞 CONTATO
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(telefone),
                Text(
                  email,
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          // 📝 DESCRIÇÃO
          Text(
            descricao,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),

          const SizedBox(height: 6),

          const Align(
            alignment: Alignment.centerRight,
            child: Text(
              'Ler mais...',
              style: TextStyle(
                fontSize: 12,
                color: Colors.blueAccent,
              ),
            ),
          )
        ],
      ),
    );
  }
}