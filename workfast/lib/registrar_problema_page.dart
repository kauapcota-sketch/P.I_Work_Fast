import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:hive_flutter/hive_flutter.dart';
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
        setState(() => imagemSelecionada = File(imagem.path));
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

  void enviar() async {
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
      mostrarSnack("Informe um email.", erro: true);
      return;
    }
    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+$').hasMatch(email)) {
      mostrarSnack("Por favor, insira um e-mail válido.", erro: true);
      return;
    }

    final categoriaSelecionada =
        categorias.firstWhere((c) => c['nome'] == categoriaEscolhida)['valor']
            as CategoriaChamado;

    await ChamadoService.adicionarChamado(Chamado(
      nome: nome,
      descricao: descricao,
      telefone: telefone,
      email: email,
      categoria: categoriaSelecionada,
      imagemPath: imagemSelecionada?.path,
    ));

    mostrarSnack('Problema registrado com sucesso!');

    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) Navigator.pop(context, true);
    });
  }

  @override
  void initState() {
    super.initState();
    _carregarDadosPerfil();
  }

  Future<void> _carregarDadosPerfil() async {
    try {
      final box = await Hive.openBox('perfil');
      final nome = box.get('nome', defaultValue: '');
      final telefone = box.get('telefone', defaultValue: '');
      final email = box.get('email', defaultValue: '');
      
      if (mounted) {
        setState(() {
          if (nome.isNotEmpty) nomeController.text = nome;
          if (telefone.isNotEmpty) telefoneController.text = telefone;
          if (email.isNotEmpty) emailController.text = email;
        });
      }
    } catch (e) {
      // Silenciosamente ignora erros
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

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    // Cores adaptadas
    final scaffoldBg =
        isDarkMode ? const Color(0xFF1B2836) : const Color(0xFFECEFF1);
    final cardBg = isDarkMode ? const Color(0xFF2C3E50) : Colors.white;
    final textoPrimario = isDarkMode ? Colors.white : const Color(0xFF2C3E50);
    final textoInput = isDarkMode ? Colors.white : Colors.black87;
    final fillColor =
        isDarkMode ? Colors.white.withOpacity(0.07) : Colors.grey.shade50;
    final borderColor = isDarkMode ? Colors.white24 : Colors.grey.shade300;

    return Scaffold(
      backgroundColor: scaffoldBg,
      appBar: AppBar(
        title: const Text('Registrar Problema',
            style: TextStyle(fontWeight: FontWeight.bold)),
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
            color: cardBg,
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
              // Foto do problema
              GestureDetector(
                onTap: () => showModalBottomSheet(
                  context: context,
                  backgroundColor:
                      isDarkMode ? const Color(0xFF2C3E50) : Colors.grey[100],
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
                          title: Text('Tirar foto',
                              style: TextStyle(color: textoPrimario)),
                          onTap: () {
                            Navigator.pop(context);
                            selecionarImagem(ImageSource.camera);
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.photo_library,
                              color: Color(0xFF4CAF50)),
                          title: Text('Escolher da galeria',
                              style: TextStyle(color: textoPrimario)),
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
                    color: fillColor,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: imagemSelecionada != null
                          ? const Color(0xFF4CAF50)
                          : borderColor,
                      width: 2,
                    ),
                  ),
                  child: imagemSelecionada == null
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.add_a_photo,
                                size: 48,
                                color:
                                    isDarkMode ? Colors.white38 : Colors.grey),
                            const SizedBox(height: 8),
                            Text('Toque para adicionar foto (opcional)',
                                style: TextStyle(
                                    color: isDarkMode
                                        ? Colors.white54
                                        : Colors.grey)),
                          ],
                        )
                      : Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(14),
                              child: Image.file(imagemSelecionada!,
                                  width: double.infinity,
                                  height: 160,
                                  fit: BoxFit.cover),
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
                                      shape: BoxShape.circle),
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

              _label('Seu nome', textoPrimario),
              const SizedBox(height: 10),
              _campo(nomeController, 'Ex: João Silva', Icons.person_outline,
                  tipo: TextInputType.name,
                  textoInput: textoInput,
                  fillColor: fillColor,
                  borderColor: borderColor),
              const SizedBox(height: 20),

              _label('Descrição do problema', textoPrimario),
              const SizedBox(height: 10),
              TextField(
                controller: descricaoController,
                maxLines: 4,
                textCapitalization: TextCapitalization.sentences,
                style: TextStyle(color: textoInput),
                decoration: InputDecoration(
                  hintText: 'Descreva detalhadamente o problema...',
                  hintStyle: TextStyle(
                      color: isDarkMode ? Colors.white38 : Colors.grey),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: borderColor)),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: borderColor)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide:
                          const BorderSide(color: Color(0xFF4CAF50), width: 2)),
                  filled: true,
                  fillColor: fillColor,
                ),
              ),
              const SizedBox(height: 20),

              _label('Categoria', textoPrimario),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: fillColor,
                  border: Border.all(color: borderColor),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: categoriaEscolhida,
                    dropdownColor: cardBg,
                    style: TextStyle(color: textoInput, fontSize: 14),
                    items: categorias.map((cat) {
                      return DropdownMenuItem<String>(
                        value: cat['nome'] as String,
                        child: Row(children: [
                          Text(cat['emoji'] as String),
                          const SizedBox(width: 8),
                          Text(cat['nome'] as String,
                              style: TextStyle(color: textoInput)),
                        ]),
                      );
                    }).toList(),
                    onChanged: (v) {
                      if (v != null) setState(() => categoriaEscolhida = v);
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20),

              _label('Telefone de contato', textoPrimario),
              const SizedBox(height: 10),
              _campo(
                  telefoneController, '(11) 99999-9999', Icons.phone_outlined,
                  tipo: TextInputType.phone,
                  textoInput: textoInput,
                  fillColor: fillColor,
                  borderColor: borderColor),
              const SizedBox(height: 20),

              _label('E-mail de contato', textoPrimario),
              const SizedBox(height: 10),
              _campo(emailController, 'seu@email.com', Icons.email_outlined,
                  tipo: TextInputType.emailAddress,
                  textoInput: textoInput,
                  fillColor: fillColor,
                  borderColor: borderColor),
              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: enviar,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4CAF50),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    elevation: 2,
                  ),
                  child: const Text('REGISTRAR PROBLEMA',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _label(String texto, Color cor) {
    return Text(
      texto,
      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: cor),
    );
  }

  Widget _campo(
    TextEditingController controller,
    String hint,
    IconData icon, {
    TextInputType tipo = TextInputType.text,
    required Color textoInput,
    required Color fillColor,
    required Color borderColor,
  }) {
    return TextField(
      controller: controller,
      keyboardType: tipo,
      style: TextStyle(color: textoInput),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: textoInput.withOpacity(0.4)),
        prefixIcon: Icon(icon, color: const Color(0xFF4CAF50)),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: borderColor)),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: borderColor)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF4CAF50), width: 2)),
        filled: true,
        fillColor: fillColor,
      ),
    );
  }
}
