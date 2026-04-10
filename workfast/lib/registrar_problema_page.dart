import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const registraProblema());
}

class registraProblema extends StatelessWidget {
  const registraProblema({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: RegistrarProblemaPage(),
    );
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

  final descricaoController = TextEditingController();
  final contatoController = TextEditingController();

  String categoriaEscolhida = 'Elétrica';
  String formaContato = 'Whatsapp';

  final picker = ImagePicker();

  final List<Map<String, String>> categorias = [
    {'nome': 'Elétrica', 'emoji': '🟡'},
    {'nome': 'Estrutural', 'emoji': '🟤'},
    {'nome': 'Informática', 'emoji': '🖥️'},
    {'nome': 'Outro', 'emoji': '❓'},
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
      if (mounted) mostrarSnack('Erro ao selecionar imagem', erro: true);
    }
  }

  Future<void> enviar() async {
    final descricao = descricaoController.text.trim();
    final contato = contatoController.text.trim();

    if (descricao.isEmpty) {
      mostrarSnack('Descreva o problema.', erro: true);
      return;
    }

    if (contato.isEmpty) {
      mostrarSnack('Informe um contato.', erro: true);
      return;
    }

    final mensagem = '''
Olá! Estou registrando um problema.

Categoria: $categoriaEscolhida
Descrição: $descricao
Contato ($formaContato): $contato
${imagemSelecionada != null ? '\n*Foto do problema anexada*' : ''}
''';

    setState(() => isLoading = true);

    try {
      Uri uri;

      switch (formaContato) {
        case 'Whatsapp':
          final numero = contato.replaceAll(RegExp(r'[^0-9]'), '');
          uri = Uri.parse(
              'https://wa.me/$numero?text=${Uri.encodeComponent(mensagem)}');
          break;
        case 'Telefone':
          final numero = contato.replaceAll(RegExp(r'[^0-9]'), '');
          uri = Uri.parse('tel:$numero');
          break;
        case 'Email':
          uri = Uri(
            scheme: 'mailto',
            path: contato,
            queryParameters: {
              'subject': 'Problema: $categoriaEscolhida',
              'body': mensagem,
            },
          );
          break;
        default:
          throw Exception('Forma de contato inválida');
      }

      // Remove canLaunchUrl - o try/catch cuida dos erros
      if (mounted) {
        await launchUrl(
          uri,
          mode: LaunchMode.externalApplication,
        );
        mostrarSnack('Problema enviado com sucesso!');
      }
    } catch (e) {
      if (mounted) {
        mostrarSnack(
            'Não foi possível enviar. Verifique sua conexão ou app instalado.',
            erro: true);
      }
    } finally {
      if (mounted) setState(() => isLoading = false);
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

  String get hintContato {
    return switch (formaContato) {
      'Whatsapp' => '(11) 99999-9999',
      'Telefone' => '(11) 3333-3333',
      'Email' => 'email@exemplo.com',
      _ => '',
    };
  }

  @override
  void dispose() {
    descricaoController.dispose();
    contatoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF5B9BD5),
      appBar: AppBar(
        title: const Text('Registrar Problema'),
        backgroundColor: const Color(0xFF5B9BD5),
        elevation: 0,
        foregroundColor: Colors.white,
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
              // Image picker
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
                          leading:
                              const Icon(Icons.camera_alt, color: Colors.blue),
                          title: const Text('Tirar foto'),
                          onTap: () {
                            Navigator.pop(context);
                            selecionarImagem(ImageSource.camera);
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.photo_library,
                              color: Colors.blue),
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
                          ? Colors.green
                          : Colors.blue.withOpacity(0.5),
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
                              'Toque para adicionar foto',
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
                                  child: const Icon(
                                    Icons.close,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                ),
              ),
              const SizedBox(height: 24),

              // Description
              const Text(
                'Descrição do problema',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: descricaoController,
                maxLines: 4,
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(
                  hintText: 'Descreva detalhadamente o problema...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.grey[50],
                ),
              ),
              const SizedBox(height: 24),

              // Category
              const Text(
                'Categoria',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
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
                    items: categorias.map((categoria) {
                      return DropdownMenuItem<String>(
                        value: categoria['nome'],
                        child: Row(
                          children: [
                            Text(categoria['emoji']!),
                            const SizedBox(width: 8),
                            Text(categoria['nome']!),
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

              // Contact method
              const Text(
                'Forma de contato',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 12),
              ...['Whatsapp', 'Telefone', 'Email'].map((item) {
                return RadioListTile<String>(
                  title: Row(
                    children: [
                      Icon(
                        switch (item) {
                          'Whatsapp' => Icons.message,
                          'Telefone' => Icons.phone,
                          'Email' => Icons.email,
                          _ => Icons.contact_mail,
                        },
                        color:
                            formaContato == item ? Colors.green : Colors.grey,
                      ),
                      const SizedBox(width: 12),
                      Text(item),
                    ],
                  ),
                  value: item,
                  groupValue: formaContato,
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => formaContato = value);
                      // Clear contact field when changing method
                      contatoController.clear();
                    }
                  },
                );
              }),

              const SizedBox(height: 12),
              TextField(
                controller: contatoController,
                keyboardType: formaContato == 'Email'
                    ? TextInputType.emailAddress
                    : TextInputType.phone,
                decoration: InputDecoration(
                  labelText: 'Contato',
                  hintText: hintContato,
                  prefixIcon: Icon(
                    switch (formaContato) {
                      'Whatsapp' => Icons.message,
                      'Telefone' => Icons.phone,
                      'Email' => Icons.email,
                      _ => Icons.contact_mail,
                    },
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.grey[50],
                ),
              ),
              const SizedBox(height: 32),

              // Send button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: isLoading ? null : enviar,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
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
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text(
                          'ENVIAR PROBLEMA',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
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
