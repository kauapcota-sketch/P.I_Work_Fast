import 'package:flutter/material.dart';
import 'package:workfast/Eletrica_trabalho.dart';
import 'package:workfast/buscar_trabalho.dart';
import 'package:workfast/informatica_trabalho.dart';
import 'package:workfast/perfil.dart';

void main() {
  runApp(const EstruturalTrabalho());
}

class EstruturalTrabalho extends StatelessWidget {
  const EstruturalTrabalho({super.key});

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

              //  CATEGORIAS
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    TextButton(
                     onPressed: () {
                       Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => busctrabalho()),
                      ); 
                     },
                     style: TextButton.styleFrom(
                       padding: EdgeInsets.zero,
                     ),
                     child: Container(
                       margin: const EdgeInsets.only(right: 10),
                       padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                       decoration: BoxDecoration(
                         color: Colors.white10,
                         borderRadius: BorderRadius.circular(20),
                       ),
                       child: Text(
                         "Geral",
                         style: const TextStyle(color: Colors.white),
                       ),
                     ),
                    ),

                    TextButton(
                     onPressed: () {
                        Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => InformaticaTrabalho()),
                      );
                     },
                     style: TextButton.styleFrom(
                       padding: EdgeInsets.zero, 
                     ),
                     child: Container(
                       margin: const EdgeInsets.only(right: 10),
                       padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                       decoration: BoxDecoration(
                         color: Colors.white10,
                         borderRadius: BorderRadius.circular(20),
                       ),
                       child: Text(
                         "Informatica",
                         style: const TextStyle(color: Colors.white),
                       ),
                     ),
                    ),

                    TextButton(
                     onPressed: () {
                        Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => EletricaTrabalho()),
                      );
                     },
                     style: TextButton.styleFrom(
                       padding: EdgeInsets.zero, 
                     ),
                     child: Container(
                       margin: const EdgeInsets.only(right: 10),
                       padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                       decoration: BoxDecoration(
                         color: Colors.white10,
                         borderRadius: BorderRadius.circular(20),
                       ),
                       child: Text(
                         "Elétrica",
                         style: const TextStyle(color: Colors.white),
                       ),
                     ),
                    ),
                    TextButton(
                     onPressed: () {
                       
                     },
                     style: TextButton.styleFrom(
                       padding: EdgeInsets.zero, 
                     ),
                     child: Container(
                       margin: const EdgeInsets.only(right: 10),
                       padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                       decoration: BoxDecoration(
                         color: const Color.fromARGB(0, 255, 255, 255),
                         borderRadius: BorderRadius.circular(20),
                       ),
                       child: Text(
                         "Estrutural",
                         style: const TextStyle(color: Colors.white),
                       ),
                     ),
                    ),
                  ],
                ),
              ),

              

              const SizedBox(height: 20),

              //  LISTA
              Expanded(
                child: ListView(
                  children: const [
                    CardChamado(
                      nome: 'João Pereira',
                      descricao:
                          'Preciso reformar meu banheiro por causa de infiltração nas paredes.',
                      telefone: '31 5176-2094',
                      email: 'Joao@gmail.com.br',
                    ),
                    SizedBox(height: 15),
                    CardChamado(
                      nome: 'Ana Costa',
                      descricao: 'Quero construir um muro no terreno e preciso de um pedreiro..',
                      telefone: '31 7643-3824',
                      email: 'AnaCosta@gmail.com.br',
                    ),
                    SizedBox(height: 15),
                    CardChamado(
                      nome: 'Roberto Almeida',
                      descricao: 'Minha casa está com rachaduras e preciso de avaliação estrutural.',
                      telefone: '31 5432-1234',
                      email: 'Roberto@gmail.com.br',
                    ),
                    SizedBox(height: 15),
                    CardChamado(
                      nome: 'Juliana Martins',
                      descricao: 'Preciso trocar o telhado que está com goteiras.',
                      telefone: '31 7843-75467',
                      email: 'Juliana@gmail.com.br',
                    ),
                    SizedBox(height: 15),
                    CardChamado(
                      nome: 'Fernando Ribeiro',
                      descricao: 'Quero fazer uma ampliação na minha casa e preciso de orçamento.',
                      telefone: '31 4267-6742',
                      email: 'Fernando@gmail.com.br',
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

  
}

// NOVA TELA DE PERFIL
class PerfilScreen extends StatelessWidget {
  const PerfilScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2C3E50),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              //  BOTÃO VOLTAR
              Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    'Meu Perfil',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 40),

              //  FOTO DE PERFIL GRANDE
              const CircleAvatar(
                radius: 60,
                backgroundImage: NetworkImage('https://i.pravatar.cc/100'),
              ),

              const SizedBox(height: 20),

              //  NOME E PROFISSÃO
              const Text(
                'João Silva',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Desenvolvedor Flutter',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                ),
              ),

              const SizedBox(height: 40),

              // 📋 INFORMAÇÕES DO PERFIL
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Informações',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2C3E50),
                        ),
                      ),
                      const SizedBox(height: 20),
                      
                      _infoRow(Icons.phone, '31 99999-9999'),
                      _infoRow(Icons.email, 'joao.silva@email.com'),
                      _infoRow(Icons.location_on, 'Belo Horizonte, MG'),
                      _infoRow(Icons.work, 'Desenvolvedor Sênior'),

                      const Spacer(),

                      //  BOTÕES DE AÇÃO
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () {},
                              icon: const Icon(Icons.edit),
                              label: const Text('Editar'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blueAccent,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () {},
                              icon: const Icon(Icons.logout),
                              label: const Text('Sair'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.redAccent,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey.shade600, size: 24),
          const SizedBox(width: 12),
          Text(
            text,
            style: const TextStyle(
              fontSize: 16,
              color: Color(0xFF2C3E50),
            ),
          ),
        ],
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