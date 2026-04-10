import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class PerfilPage extends StatefulWidget {
  const PerfilPage({super.key});

  @override
  State<PerfilPage> createState() => _PerfilPageState();
}

class _PerfilPageState extends State<PerfilPage> {
  final nomeController = TextEditingController();
  final descricaoController = TextEditingController();
  final telefoneController = TextEditingController();
  final emailController = TextEditingController();

  List<String> experiencias = [];
  File? imagem;
  Box? box;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _initHive();
  }

  Future<void> _initHive() async {
    await Hive.initFlutter();
    box = await Hive.openBox('perfil');
    await _carregarDados();
  }

  Future<void> _carregarDados() async {
    nomeController.text = box!.get('nome', defaultValue: '');
    descricaoController.text = box!.get('descricao', defaultValue: '');
    telefoneController.text = box!.get('telefone', defaultValue: '');
    emailController.text = box!.get('email', defaultValue: '');

    experiencias = List<String>.from(
      box!.get('experiencias', defaultValue: <String>[]),
    );

    String? caminhoImagem = box!.get('imagem');
    if (caminhoImagem != null) {
      final file = File(caminhoImagem);
      if (await file.exists()) {
        imagem = file;
      }
    }

    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    nomeController.dispose();
    descricaoController.dispose();
    telefoneController.dispose();
    emailController.dispose();
    super.dispose();
  }

  Future<void> escolherImagem() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null && mounted) {
      final directory = await getApplicationDocumentsDirectory();
      final newPath =
          '${directory.path}/perfil_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final newFile = await File(pickedFile.path).copy(newPath);

      if (mounted) {
        setState(() {
          imagem = newFile;
        });
      }
    }
  }

  Future<void> salvarDados() async {
    if (box == null) return;

    await box!.put('nome', nomeController.text.trim());
    await box!.put('descricao', descricaoController.text.trim());
    await box!.put('telefone', telefoneController.text.trim());
    await box!.put('email', emailController.text.trim());
    await box!.put('experiencias', experiencias);

    if (imagem != null) {
      await box!.put('imagem', imagem!.path);
    }

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✅ Dados salvos com sucesso!'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void adicionarExperiencia() {
    final expController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Nova Experiência'),
        content: TextField(
          controller: expController,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Ex: Desenvolvedor Mobile - 2 anos',
            border: OutlineInputBorder(),
          ),
          maxLines: 2,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              final texto = expController.text.trim();
              if (texto.isNotEmpty) {
                setState(() {
                  experiencias.add(texto);
                });
                Navigator.of(context).pop();
              }
            },
            child: const Text('Adicionar'),
          ),
        ],
      ),
    ).then((_) {
      expController.dispose();
    });
  }

  void removerExperiencia(String experiencia) {
    setState(() {
      experiencias.remove(experiencia);
    });
  }

  Widget _campoContato({
    required IconData icon,
    required TextEditingController controller,
    required String hint,
    required Color cor,
  }) {
    return TextField(
      controller: controller,
      keyboardType:
          hint == 'Email' ? TextInputType.emailAddress : TextInputType.phone,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: cor),
        filled: true,
        fillColor: Colors.grey[200],
        hintText: hint,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading || box == null) {
      return const Scaffold(
        backgroundColor: Color(0xFF1E2A38),
        body: Center(
          child: CircularProgressIndicator(color: Colors.white),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFF1E2A38),
      body: SafeArea(
        child: Column(
          children: [
            // 🔙 APP BAR COM BOTÃO VOLTAR
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFF1E2A38),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back_ios,
                        color: Colors.white, size: 22),
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.white.withOpacity(0.2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Perfil',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),

            // CONTEÚDO PRINCIPAL
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(24)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),

                      // 👤 FOTO + NOME
                      Row(
                        children: [
                          GestureDetector(
                            onTap: escolherImagem,
                            child: CircleAvatar(
                              radius: 38,
                              backgroundColor: Colors.blue.withOpacity(0.1),
                              backgroundImage:
                                  imagem != null ? FileImage(imagem!) : null,
                              child: imagem == null
                                  ? const Icon(Icons.person,
                                      size: 38, color: Colors.blue)
                                  : null,
                            ),
                          ),
                          const SizedBox(width: 15),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Nome do usuário',
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.grey),
                                ),
                                const SizedBox(height: 5),
                                TextField(
                                  controller: nomeController,
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.green[100],
                                    hintText: 'Seu nome',
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 10),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide.none,
                                    ),
                                    suffixIcon:
                                        const Icon(Icons.edit, size: 18),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),

                      const SizedBox(height: 25),

                      // 📝 DESCRIÇÃO
                      const Text(
                        'Descrição',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: descricaoController,
                        maxLines: 3,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.grey[200],
                          hintText: 'Fale sobre você...',
                          contentPadding: const EdgeInsets.all(12),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),

                      const SizedBox(height: 25),

                      // 💼 EXPERIÊNCIAS
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Experiências',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          InkWell(
                            onTap: adicionarExperiencia,
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.blue[100],
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(Icons.add),
                            ),
                          )
                        ],
                      ),

                      const SizedBox(height: 10),

                      ...experiencias.map(
                        (exp) => Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 10),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Expanded(child: Text(exp)),
                              InkWell(
                                onTap: () => removerExperiencia(exp),
                                borderRadius: BorderRadius.circular(20),
                                child: Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    color: Colors.red.withOpacity(0.1),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.close,
                                    size: 16,
                                    color: Colors.red,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 25),

                      // 📞 CONTATO
                      const Text(
                        'Contato',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),

                      const SizedBox(height: 10),

                      _campoContato(
                        icon: Icons.phone,
                        controller: telefoneController,
                        hint: 'Telefone',
                        cor: Colors.green,
                      ),

                      const SizedBox(height: 10),

                      _campoContato(
                        icon: Icons.email,
                        controller: emailController,
                        hint: 'Email',
                        cor: Colors.indigo,
                      ),

                      const SizedBox(height: 30),

                      // 💾 BOTÃO SALVAR
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: salvarDados,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueAccent,
                            padding: const EdgeInsets.all(16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 3,
                          ),
                          child: const Text(
                            'SALVAR',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
