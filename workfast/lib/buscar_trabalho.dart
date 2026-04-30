import 'package:flutter/material.dart';
import 'package:workfast/perfil.dart';
import 'package:workfast/registrar_problema_page.dart';
import 'package:workfast/chamado_model.dart';
import 'package:workfast/detalhes_chamado_page.dart';
import 'package:workfast/configuracoes_page.dart';
import 'package:workfast/notificacoes_page.dart';
import 'package:workfast/notificacao_service.dart';
import 'dart:io';
import 'package:hive_flutter/hive_flutter.dart';

class busctrabalho extends StatelessWidget {
  const busctrabalho({super.key});

  @override
  Widget build(BuildContext context) {
    return const TelaLista();
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
  File? imagem;

  @override
  void initState() {
    super.initState();
    _carregarDadosIniciais();
  }

  void _carregarDadosIniciais() {
    carregarImagem();
    _filtrarChamados();
  }

  Future<void> carregarImagem() async {
    try {
      if (!Hive.isBoxOpen('perfil')) {
        await Hive.openBox('perfil');
      }
      var box = Hive.box('perfil');
      String? caminhoImagem = box.get('imagem');

      if (caminhoImagem != null) {
        final file = File(caminhoImagem);
        if (await file.exists()) {
          if (mounted) {
            setState(() {
              imagem = file;
            });
          }
        }
      }
    } catch (e) {
      debugPrint('Erro ao carregar imagem: $e');
    }
  }

  void _filtrarChamados() {
    try {
      setState(() {
        _chamadosExibidos =
            ChamadoService.getChamadosPorCategoria(_categoriaSelecionada);
      });
    } catch (e) {
      debugPrint('Erro ao filtrar chamados: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final qtdNotificacoes = NotificacaoService.quantidadeNaoLidas;

    return Scaffold(
      backgroundColor: const Color(0xFF2C3E50),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.settings,
                        color: Colors.white, size: 28),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ConfiguracoesPage(),
                        ),
                      );
                    },
                  ),
                  // Sino de notificações com badge
                  Stack(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.notifications,
                            color: Colors.white, size: 28),
                        onPressed: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const NotificacoesPage(),
                            ),
                          );
                          setState(() {}); // Atualiza badge
                        },
                      ),
                      if (qtdNotificacoes > 0)
                        Positioned(
                          right: 8,
                          top: 8,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                            constraints: const BoxConstraints(
                              minWidth: 18,
                              minHeight: 18,
                            ),
                            child: Text(
                              qtdNotificacoes > 9
                                  ? '9+'
                                  : '$qtdNotificacoes',
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PerfilPage(),
                        ),
                      );
                      carregarImagem();
                    },
                    child: CircleAvatar(
                      radius: 24,
                      backgroundColor: Colors.blueAccent,
                      backgroundImage:
                          imagem != null ? FileImage(imagem!) : null,
                      child: imagem == null
                          ? const Icon(Icons.person, color: Colors.white)
                          : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
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
                            child: CardChamado(chamado: chamado),
                          );
                        },
                      ),
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const registraProblema(),
                    ),
                  );

                  if (result == true) {
                    _filtrarChamados();
                  }
                },
                child: Container(
                  height: 70,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF4CAF50), Color(0xFF8BC34A)],
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

class CardChamado extends StatelessWidget {
  final Chamado chamado;

  const CardChamado({super.key, required this.chamado});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetalhesChamadoPage(chamado: chamado),
          ),
        );
      },
      child: Container(
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
                  radius: 18,
                  backgroundColor: const Color(0xFF4CAF50),
                  child: Text(
                    chamado.nome.isNotEmpty
                        ? chamado.nome[0].toUpperCase()
                        : '?',
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
                        chamado.nome,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      Text(
                        'Clique para ver detalhes',
                        style: TextStyle(
                            fontSize: 12, color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.arrow_forward_ios,
                    size: 14, color: Colors.grey),
              ],
            ),
            const SizedBox(height: 14),
            Text(
              chamado.descricao,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  fontSize: 14, height: 1.4, color: Colors.grey.shade700),
            ),
          ],
        ),
      ),
    );
  }
}