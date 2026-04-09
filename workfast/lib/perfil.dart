import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';

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

  // Mudamos para nullable para evitar erro de inicialização tardia (late initialization error)
  Box? box;

  @override
  void initState() {
    super.initState();
    _initHive();
  }

  Future<void> _initHive() async {
    // Como abrimos no main, aqui ele apenas recupera a instância já aberta
    box = Hive.box('perfil');
    
    // Usamos setState para que a tela mostre os dados assim que carregarem
    setState(() {
      nomeController.text = box!.get('nome', defaultValue: '');
      descricaoController.text = box!.get('descricao', defaultValue: '');
      telefoneController.text = box!.get('telefone', defaultValue: '');
      emailController.text = box!.get('email', defaultValue: '');

      experiencias = List<String>.from(
        box!.get('experiencias', defaultValue: <String>[]),
      );

      String? caminhoImagem = box!.get('imagem');
      if (caminhoImagem != null && File(caminhoImagem).existsSync()) {
        imagem = File(caminhoImagem);
      }
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

  Future<void> escolherImagem() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        imagem = File(pickedFile.path);
      });
    }
  }

  void salvarDados() {
    if (box == null) return;

    box!.put('nome', nomeController.text.trim());
    box!.put('descricao', descricaoController.text.trim());
    box!.put('telefone', telefoneController.text.trim());
    box!.put('email', emailController.text.trim());
    box!.put('experiencias', experiencias);

    if (imagem != null) {
      box!.put('imagem', imagem!.path);
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('✅ Dados salvos com sucesso!'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );
  }

  void adicionarExperiencia() {
    final expController = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Nova Experiência'),
        content: TextField(
          controller: expController,
          decoration: const InputDecoration(
            hintText: 'Ex: Desenvolvedor Mobile - 2 anos',
            border: OutlineInputBorder(),
          ),
          maxLines: 2,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              final texto = expController.text.trim();
              if (texto.isNotEmpty) {
                setState(() {
                  experiencias.add(texto);
                });
                Navigator.pop(context);
              }
            },
            child: const Text('Adicionar'),
          ),
        ],
      ),
    ).then((_) => expController.dispose());
  }

  void removerExperiencia(String experiencia) {
    setState(() {
      experiencias.remove(experiencia);
    });
  }

  @override
  Widget build(BuildContext context) {
    // Enquanto a box não carrega, mostramos um indicador de progresso
    if (box == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFF2E4A5A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2E4A5A),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Perfil Profissional',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            onPressed: salvarDados,
            icon: const Icon(Icons.save),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 450),
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
                Row(
                  children: [
                    GestureDetector(
                      onTap: escolherImagem,
                      child: CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.blueAccent.withOpacity(0.1),
                        backgroundImage: imagem != null ? FileImage(imagem!) : null,
                        child: imagem == null
                            ? const Icon(Icons.add_a_photo, size: 35, color: Colors.blueAccent)
                            : null,
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            nomeController.text.isEmpty ? 'Seu Nome' : nomeController.text,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2E4A5A),
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextField(
                            controller: nomeController,
                            onChanged: (val) => setState(() {}), // Atualiza o nome no topo em tempo real
                            decoration: InputDecoration(
                              hintText: 'Nome completo',
                              filled: true,
                              fillColor: Colors.grey[50],
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                const Text('Sobre mim', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                TextField(
                  controller: descricaoController,
                  maxLines: 4,
                  decoration: InputDecoration(
                    hintText: 'Habilidades e resumo...',
                    filled: true,
                    fillColor: Colors.grey[50],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Experiências', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    ElevatedButton.icon(
                      onPressed: adicionarExperiencia,
                      icon: const Icon(Icons.add, size: 16),
                      label: const Text('Add'),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                ...experiencias.map((exp) => Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    title: Text(exp),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => removerExperiencia(exp),
                    ),
                  ),
                )),
                const SizedBox(height: 30),
                const Text('Contato', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                TextField(
                  controller: telefoneController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.phone),
                    hintText: 'Telefone',
                    filled: true,
                    fillColor: Colors.grey[50],
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.email),
                    hintText: 'E-mail',
                    filled: true,
                    fillColor: Colors.grey[50],
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                  ),
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: salvarDados,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(16),
                      backgroundColor: Colors.blueAccent,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('SALVAR PERFIL'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}