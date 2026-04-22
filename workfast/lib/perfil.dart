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
    box = await Hive.openBox('perfil');
    await _carregarDados();
  }

  Future<void> _carregarDados() async {
    nomeController.text = box!.get('nome', defaultValue: '');
    descricaoController.text = box!.get('descricao', defaultValue: '');
    telefoneController.text = box!.get('telefone', defaultValue: '');
    emailController.text = box!.get('email', defaultValue: '');
    experiencias =
        List<String>.from(box!.get('experiencias', defaultValue: <String>[]));

    final caminhoImagem = box!.get('imagem') as String?;
    if (caminhoImagem != null) {
      final file = File(caminhoImagem);
      if (await file.exists()) imagem = file;
    }

    if (mounted) setState(() => isLoading = false);
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
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null && mounted) {
      final dir = await getApplicationDocumentsDirectory();
      final newPath =
          '${dir.path}/perfil_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final newFile = await File(picked.path).copy(newPath);
      setState(() => imagem = newFile);
    }
  }

  Future<void> salvarDados() async {
    if (box == null) return;
    await box!.put('nome', nomeController.text.trim());
    await box!.put('descricao', descricaoController.text.trim());
    await box!.put('telefone', telefoneController.text.trim());
    await box!.put('email', emailController.text.trim());
    await box!.put('experiencias', experiencias);
    if (imagem != null) await box!.put('imagem', imagem!.path);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✅ Perfil salvo com sucesso!'),
          backgroundColor: Color(0xFF4CAF50),
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void adicionarExperiencia() {
    final ctrl = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Nova Experiência',
            style: TextStyle(fontWeight: FontWeight.bold)),
        content: TextField(
          controller: ctrl,
          autofocus: true,
          maxLines: 2,
          decoration: InputDecoration(
            hintText: 'Ex: Eletricista Residencial – 3 anos',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancelar')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4CAF50),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12))),
            onPressed: () {
              final t = ctrl.text.trim();
              if (t.isNotEmpty) {
                setState(() => experiencias.add(t));
                Navigator.pop(ctx);
              }
            },
            child: const Text('Adicionar'),
          ),
        ],
      ),
    ).then((_) => ctrl.dispose());
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        backgroundColor: Color(0xFF2C3E50),
        body: Center(child: CircularProgressIndicator(color: Colors.white)),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFF2C3E50),
      body: SafeArea(
        child: Column(
          children: [
            // ── Header ──────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Text('Meu Perfil',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold)),
                  const Spacer(),
                  // Botão salvar no topo (atalho)
                  TextButton.icon(
                    onPressed: salvarDados,
                    icon: const Icon(Icons.save_alt,
                        color: Color(0xFF4CAF50), size: 20),
                    label: const Text('Salvar',
                        style: TextStyle(
                            color: Color(0xFF4CAF50),
                            fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),

            // ── Avatar + banner ──────────────────────────────────
            Stack(
              alignment: Alignment.bottomCenter,
              children: [
                // Banner de fundo
                Container(
                  height: 100,
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF4CAF50), Color(0xFF8BC34A)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                // Avatar sobre o banner
                Positioned(
                  bottom: 0,
                  child: GestureDetector(
                    onTap: escolherImagem,
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 52,
                          backgroundColor: Colors.white,
                          child: CircleAvatar(
                            radius: 48,
                            backgroundColor: const Color(0xFF2C3E50),
                            backgroundImage:
                                imagem != null ? FileImage(imagem!) : null,
                            child: imagem == null
                                ? const Icon(Icons.person,
                                    size: 50, color: Colors.white54)
                                : null,
                          ),
                        ),
                        Positioned(
                          bottom: 4,
                          right: 4,
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: const BoxDecoration(
                              color: Color(0xFF4CAF50),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.camera_alt,
                                size: 16, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 60),

            // ── Conteúdo rolável ─────────────────────────────────
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Color(0xFFF0F2F5),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ── Nome ────────────────────────────────────
                      _secaoTitulo('Informações Pessoais'),
                      const SizedBox(height: 14),
                      _card([
                        _campoTexto(
                          controller: nomeController,
                          label: 'Nome completo',
                          icon: Icons.person_outline,
                        ),
                        const SizedBox(height: 14),
                        _campoTexto(
                          controller: descricaoController,
                          label: 'Sobre você',
                          icon: Icons.info_outline,
                          maxLines: 3,
                        ),
                      ]),

                      const SizedBox(height: 24),

                      // ── Contato ──────────────────────────────────
                      _secaoTitulo('Contato'),
                      const SizedBox(height: 14),
                      _card([
                        _campoTexto(
                          controller: telefoneController,
                          label: 'Telefone',
                          icon: Icons.phone_outlined,
                          tipo: TextInputType.phone,
                        ),
                        const SizedBox(height: 14),
                        _campoTexto(
                          controller: emailController,
                          label: 'Email',
                          icon: Icons.email_outlined,
                          tipo: TextInputType.emailAddress,
                        ),
                      ]),

                      const SizedBox(height: 24),

                      // ── Experiências ─────────────────────────────
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _secaoTitulo('Experiências'),
                          GestureDetector(
                            onTap: adicionarExperiencia,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 8),
                              decoration: BoxDecoration(
                                color: const Color(0xFF4CAF50),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Row(
                                children: [
                                  Icon(Icons.add,
                                      color: Colors.white, size: 18),
                                  SizedBox(width: 4),
                                  Text('Adicionar',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 13)),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),

                      if (experiencias.isEmpty)
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Column(
                            children: [
                              Icon(Icons.work_outline,
                                  size: 36, color: Colors.grey),
                              SizedBox(height: 8),
                              Text('Nenhuma experiência adicionada.',
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 14)),
                            ],
                          ),
                        )
                      else
                        ...experiencias.map(
                          (exp) => Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 14),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(14),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 6,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.work_outline,
                                    color: Color(0xFF4CAF50), size: 20),
                                const SizedBox(width: 12),
                                Expanded(
                                    child: Text(exp,
                                        style: const TextStyle(fontSize: 14))),
                                GestureDetector(
                                  onTap: () =>
                                      setState(() => experiencias.remove(exp)),
                                  child: Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      color: Colors.red.withOpacity(0.1),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(Icons.close,
                                        size: 16, color: Colors.red),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                      const SizedBox(height: 30),

                      // ── Botão salvar ─────────────────────────────
                      SizedBox(
                        width: double.infinity,
                        height: 58,
                        child: ElevatedButton.icon(
                          onPressed: salvarDados,
                          icon: const Icon(Icons.save_alt),
                          label: const Text('SALVAR PERFIL',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF4CAF50),
                            foregroundColor: Colors.white,
                            elevation: 6,
                            shadowColor:
                                const Color(0xFF4CAF50).withOpacity(0.4),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18)),
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

  Widget _secaoTitulo(String texto) => Text(
        texto,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Color(0xFF2C3E50),
        ),
      );

  Widget _card(List<Widget> filhos) => Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: filhos,
        ),
      );

  Widget _campoTexto({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType tipo = TextInputType.text,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      keyboardType: tipo,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: const Color(0xFF4CAF50), size: 22),
        filled: true,
        fillColor: const Color(0xFFF1F4F8),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFF4CAF50), width: 2),
        ),
      ),
    );
  }
}
