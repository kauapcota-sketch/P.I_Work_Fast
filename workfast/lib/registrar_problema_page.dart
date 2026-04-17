import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:workfast/chamado_model.dart';

class registraProblema extends StatelessWidget {
  const registraProblema({super.key});

  @override
  Widget build(BuildContext context) {
    // Sem MaterialApp aqui — evita tela preta ao voltar
    return const RegistrarProblemaPage();
  }
}

class RegistrarProblemaPage extends StatefulWidget {
  const RegistrarProblemaPage({super.key});

  @override
  State<RegistrarProblemaPage> createState() => _RegistrarProblemaPageState();
}

class _RegistrarProblemaPageState extends State<RegistrarProblemaPage> {
  File? imagemSelecionada;
  bool isLoading = false;

  final nomeController = TextEditingController();
  final descricaoController = TextEditingController();
  final telefoneController = TextEditingController();
  final emailController = TextEditingController();

  String categoriaEscolhida = 'Elétrica';

  final picker = ImagePicker();

  final List<Map<String, dynamic>> categorias = [
    {'nome': 'Elétrica', 'emoji': '🟡', 'valor': CategoriaChamado.eletrica},
    {'nome': 'Estrutural', 'emoji': '🟤', 'valor': CategoriaChamado.estrutural},
    {
      'nome': 'Informática',
      'emoji': '🖥️',
      'valor': CategoriaChamado.informatica
    },
    {'nome': 'Geral', 'emoji': '❓', 'valor': CategoriaChamado.geral},
  ];

  Future<void> selecionarImagem(ImageSource source) async {
    try {
      final XFile? imagem = await picker.pickImage(
        source: source,
        imageQuality: 80,
      );
      if (imagem != null && mounted) {
        setState(() {
          imagemSelecionada = File(imagem.path);
        });
      }
    } catch (e) {
      if (mounted) mostrarSnack('Erro ao selecionar imagem.', erro: true);
    }
  }

  void mostrarSnack(String texto, {bool erro = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(texto),
        backgroundColor: erro ? Colors.red[400] : Colors.green[400],
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  void enviar() {
    final nome = nomeController.text.trim();
    final descricao = descricaoController.text.trim();
    final telefone = telefoneController.text.trim();
    final email = emailController.text.trim();

    if (nome.isEmpty) {
      mostrarSnack('Informe seu nome.', erro: true);
      return;
    }
    if (descricao.isEmpty) {
      mostrarSnack('Descreva o problema.', erro: true);
      return;
    }
    if (telefone.isEmpty) {
      mostrarSnack('Informe um telefone de contato.', erro: true);
      return;
    }
    if (email.isEmpty) {
      mostrarSnack('Informe um email de contato.', erro: true);
      return;
    }

    final categoriaSelecionada = categorias.firstWhere(
      (c) => c['nome'] == categoriaEscolhida,
    )['valor'] as CategoriaChamado;

    final novoChamado = Chamado(
      nome: nome,
      descricao: descricao,
      telefone: telefone,
      email: email,
      categoria: categoriaSelecionada,
      imagem: imagemSelecionada, // foto anexada (pode ser null)
    );

    ChamadoService.adicionarChamado(novoChamado);

    mostrarSnack('Problema registrado com sucesso!');

    // Aguarda o snackbar aparecer e volta para a lista
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) Navigator.pop(context, true);
    });
  }

  @override
  void dispose() {
    nomeController.dispose();
    descricaoController.dispose();
    telefoneController.dispose();
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2C3E50),
      appBar: AppBar(
        title: const Text('Registrar Problema'),
        backgroundColor: const Color(0xFF2C3E50),
        elevation: 0,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Seletor de imagem ──────────────────────────────
              GestureDetector(
                onTap: () => showModalBottomSheet(
                  context: context,
                  backgroundColor: Colors.grey[100],
                  shape: const RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                  builder: (_) => SafeArea(
                    child: Wrap(
                      children: [
                        ListTile(
                          leading: const Icon(Icons.camera_alt,
                              color: Color(0xFF4CAF50)),
                          title: const Text('Tirar foto'),
                          onTap: () {
                            Navigator.pop(context);
                            selecionarImagem(ImageSource.camera);
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.photo_library,
                              color: Color(0xFF4CAF50)),
                          title: const Text('Escolher da galeria'),
                          onTap: () {
                            Navigator.pop(context);
                            selecionarImagem(ImageSource.gallery);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                child: Container(
                  width: double.infinity,
                  height: 160,
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: imagemSelecionada != null
                          ? const Color(0xFF4CAF50)
                          : Colors.grey.withOpacity(0.4),
                      width: 2,
                    ),
                  ),
                  child: imagemSelecionada == null
                      ? const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.add_a_photo,
                                size: 48, color: Colors.grey),
                            SizedBox(height: 8),
                            Text(
                              'Toque para adicionar foto (opcional)',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        )
                      : Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(14),
                              child: Image.file(
                                imagemSelecionada!,
                                width: double.infinity,
                                height: 160,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Positioned(
                              top: 8,
                              right: 8,
                              child: GestureDetector(
                                onTap: () =>
                                    setState(() => imagemSelecionada = null),
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: const BoxDecoration(
                                    color: Colors.black54,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(Icons.close,
                                      color: Colors.white, size: 20),
                                ),
                              ),
                            ),
                          ],
                        ),
                ),
              ),
              const SizedBox(height: 24),

              // ── Nome ───────────────────────────────────────────
              const Text('Seu nome',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              const SizedBox(height: 12),
              TextField(
                controller: nomeController,
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(
                  hintText: 'Ex: João Silva',
                  prefixIcon: const Icon(Icons.person_outline),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                  filled: true,
                  fillColor: Colors.grey[50],
                ),
              ),
              const SizedBox(height: 24),

              // ── Descrição ──────────────────────────────────────
              const Text('Descrição do problema',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              const SizedBox(height: 12),
              TextField(
                controller: descricaoController,
                maxLines: 4,
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(
                  hintText: 'Descreva detalhadamente o problema...',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                  filled: true,
                  fillColor: Colors.grey[50],
                ),
              ),
              const SizedBox(height: 24),

              // ── Categoria ──────────────────────────────────────
              const Text('Categoria',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: categoriaEscolhida,
                    items: categorias.map((cat) {
                      return DropdownMenuItem<String>(
                        value: cat['nome'] as String,
                        child: Row(
                          children: [
                            Text(cat['emoji'] as String),
                            const SizedBox(width: 8),
                            Text(cat['nome'] as String),
                          ],
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() => categoriaEscolhida = value);
                      }
                    },
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // ── Telefone ───────────────────────────────────────
              const Text('Telefone de contato',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              const SizedBox(height: 12),
              TextField(
                controller: telefoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  hintText: '(11) 99999-9999',
                  prefixIcon: const Icon(Icons.phone_outlined),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                  filled: true,
                  fillColor: Colors.grey[50],
                ),
              ),
              const SizedBox(height: 24),

              // ── Email ──────────────────────────────────────────
              const Text('Email de contato',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              const SizedBox(height: 12),
              TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: 'email@exemplo.com',
                  prefixIcon: const Icon(Icons.email_outlined),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                  filled: true,
                  fillColor: Colors.grey[50],
                ),
              ),
              const SizedBox(height: 32),

              // ── Botão enviar ───────────────────────────────────
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: isLoading ? null : enviar,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4CAF50),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                  ),
                  child: isLoading
                      ? const SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(
                              color: Colors.white, strokeWidth: 2),
                        )
                      : const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.check_circle_outline),
                            SizedBox(width: 10),
                            Text(
                              'REGISTRAR PROBLEMA',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
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
}
