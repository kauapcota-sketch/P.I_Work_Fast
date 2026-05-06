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
  File? imagem;

  @override
  void initState() {
    super.initState();
    _carregarDadosIniciais();
  }

  void _carregarDadosIniciais() {
    carregarImagem();
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

  void _atualizarCategoria(CategoriaChamado novaCategoria) {
    setState(() {
      _categoriaSelecionada = novaCategoria;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    // Modo escuro: azul bem escuro. Modo claro: cinza claro neutro
    final bgColor =
        isDarkMode ? const Color(0xFF1B2836) : const Color(0xFFECEFF1);
    final tituloColor = isDarkMode ? Colors.white : const Color(0xFF2C3E50);
    final iconeHeaderColor =
        isDarkMode ? Colors.white : const Color(0xFF2C3E50);

    return ValueListenableBuilder<Box<Notificacao>>(
      valueListenable: NotificacaoService.notificacoesBox.listenable(),
      builder: (context, notificacoesBox, _) {
        final qtdNotificacoes = NotificacaoService.quantidadeNaoLidas;

        return Scaffold(
          backgroundColor: bgColor,
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: Icon(Icons.settings,
                            color: iconeHeaderColor, size: 28),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const ConfiguracoesPage()),
                          );
                        },
                      ),
                      Stack(
                        children: [
                          IconButton(
                            icon: Icon(Icons.notifications,
                                color: iconeHeaderColor, size: 28),
                            onPressed: () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const NotificacoesPage()),
                              );
                            },
                          ),
                          if (qtdNotificacoes > 0)
                            Positioned(
                              right: 8,
                              top: 8,
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: const BoxDecoration(
                                    color: Colors.red, shape: BoxShape.circle),
                                constraints: const BoxConstraints(
                                    minWidth: 18, minHeight: 18),
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
                                builder: (context) => const PerfilPage()),
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
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Chamados Recentes',
                      style: TextStyle(
                          color: tituloColor,
                          fontSize: 28,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Filtros de categoria
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _categoriaButton(
                            'Geral', CategoriaChamado.geral, isDarkMode),
                        _categoriaButton('Informática',
                            CategoriaChamado.informatica, isDarkMode),
                        _categoriaButton(
                            'Elétrica', CategoriaChamado.eletrica, isDarkMode),
                        _categoriaButton('Estrutural',
                            CategoriaChamado.estrutural, isDarkMode),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: ValueListenableBuilder<Box<Chamado>>(
                      valueListenable: ChamadoService.chamadosBox.listenable(),
                      builder: (context, box, _) {
                        final chamadosExibidos =
                            ChamadoService.getChamadosPorCategoria(
                                _categoriaSelecionada);
                        if (chamadosExibidos.isEmpty) {
                          return Center(
                            child: Text(
                              'Nenhum chamado nesta categoria.',
                              style: TextStyle(
                                  color: isDarkMode
                                      ? Colors.white70
                                      : Colors.black54,
                                  fontSize: 16),
                            ),
                          );
                        } else {
                          return ListView.builder(
                            itemCount: chamadosExibidos.length,
                            itemBuilder: (context, index) {
                              final chamado = chamadosExibidos[index];
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 15),
                                child: CardChamado(chamado: chamado),
                              );
                            },
                          );
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const registraProblema()),
                      );
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
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
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
      },
    );
  }

  Widget _categoriaButton(
      String label, CategoriaChamado categoria, bool isDarkMode) {
    final bool isSelected = _categoriaSelecionada == categoria;

    // Modo claro: fundo cinza visível, texto escuro. Modo escuro: fundo branco translúcido, texto branco
    final Color bgNaoSelecionado = isDarkMode
        ? Colors.white.withOpacity(0.12)
        : const Color(0xFF2C3E50).withOpacity(0.12);
    final Color labelNaoSelecionado =
        isDarkMode ? Colors.white70 : const Color(0xFF2C3E50);

    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: ChoiceChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (selected) {
          if (selected) _atualizarCategoria(categoria);
        },
        selectedColor: const Color(0xFF4CAF50),
        backgroundColor: bgNaoSelecionado,
        side: BorderSide(
          color: isSelected
              ? const Color(0xFF4CAF50)
              : (isDarkMode
                  ? Colors.white24
                  : const Color(0xFF2C3E50).withOpacity(0.3)),
          width: 1,
        ),
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : labelNaoSelecionado,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
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
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    // Modo escuro: card translúcido branco sobre fundo escuro
    // Modo claro: card branco sólido sobre fundo cinza claro
    final cardBg = isDarkMode ? Colors.white.withOpacity(0.08) : Colors.white;
    final cardBorder = isDarkMode
        ? Colors.white.withOpacity(0.1)
        : Colors.grey.withOpacity(0.2);
    final nomeColor = isDarkMode ? Colors.white : const Color(0xFF1B2836);
    final descColor = isDarkMode ? Colors.white70 : Colors.grey.shade600;
    final arrowColor = isDarkMode ? Colors.white30 : Colors.grey.shade400;
    final avatarLetraColor = isDarkMode ? Colors.white : Colors.white;

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
          color: cardBg,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: cardBorder),
          boxShadow: isDarkMode
              ? []
              : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: Colors.blueAccent.withOpacity(0.8),
              child: Text(
                chamado.nome.isNotEmpty ? chamado.nome[0].toUpperCase() : '?',
                style: TextStyle(
                    color: avatarLetraColor,
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
                    style: TextStyle(
                        color: nomeColor,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    chamado.descricao,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: descColor, fontSize: 14),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, color: arrowColor, size: 16),
          ],
        ),
      ),
    );
  }
}
