import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:workfast/chamado_model.dart';

class registraProblema extends StatelessWidget {
  const registraProblema({super.key});

  @override
  Widget build(BuildContext context) {
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
      mostrarSnack('Erro ao selecionar imagem', erro: true);
    }
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
      mostrarSnack('Informe um telefone.', erro: true);
      return;
    }
    if (email.isEmpty) {
      mostrarSnack('Informe um email.', erro: true);
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
      // Se seu model aceitar imagem, adiciona aqui:
      // imagemPath: imagemSelecionada?.path,
    );

    ChamadoService.adicionarChamado(novoChamado);

    mostrarSnack('Problema registrado com sucesso!');

    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) Navigator.pop(context, true);
    });
  }

  void mostrarSnack(String texto, {bool erro = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(texto),
        backgroundColor: erro ? Colors.red[400] : Colors.green[400],
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
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
              // IMAGEM
              GestureDetector(
                onTap: () => showModalBottomSheet(
                  context: context,
                  builder: (_) => Wrap(
                    children: [
                      ListTile(
                        leading: const Icon(Icons.camera_alt),
                        title: const Text('Tirar foto'),
                        onTap: () {
                          Navigator.pop(context);
                          selecionarImagem(ImageSource.camera);
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.photo),
                        title: const Text('Galeria'),
                        onTap: () {
                          Navigator.pop(context);
                          selecionarImagem(ImageSource.gallery);
                        },
                      ),
                    ],
                  ),
                ),
                child: Container(
                  height: 160,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.blue),
                  ),
                  child: imagemSelecionada == null
                      ? const Center(child: Text('Adicionar foto'))
                      : Image.file(imagemSelecionada!, fit: BoxFit.cover),
                ),
              ),

              const SizedBox(height: 24),

              // NOME
              const Text('Seu nome'),
              TextField(controller: nomeController),

              const SizedBox(height: 16),

              // DESCRIÇÃO
              const Text('Descrição'),
              TextField(
                controller: descricaoController,
                maxLines: 4,
              ),

              const SizedBox(height: 16),

              // CATEGORIA
              DropdownButton<String>(
                value: categoriaEscolhida,
                isExpanded: true,
                items: categorias.map((c) {
                  return DropdownMenuItem(
                    value: c['nome'] as String,
                    child: Text('${c['emoji']} ${c['nome']}'),
                  );
                }).toList(),
                onChanged: (v) {
                  if (v != null) setState(() => categoriaEscolhida = v);
                },
              ),

              const SizedBox(height: 16),

              // TELEFONE
              const Text('Telefone'),
              TextField(controller: telefoneController),

              const SizedBox(height: 16),

              // EMAIL
              const Text('Email'),
              TextField(controller: emailController),

              const SizedBox(height: 24),

              // BOTÃO
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: isLoading ? null : enviar,
                  child: const Text('REGISTRAR PROBLEMA'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
