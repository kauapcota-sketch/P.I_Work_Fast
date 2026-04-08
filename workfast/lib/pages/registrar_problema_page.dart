import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';

class RegistrarProblemaPage extends StatefulWidget {
  const RegistrarProblemaPage({super.key});

  @override
  State<RegistrarProblemaPage> createState() => _RegistrarProblemaPageState();
}

class _RegistrarProblemaPageState extends State<RegistrarProblemaPage> {
  File? _imagemSelecionada;
  final TextEditingController _descricaoController = TextEditingController();
  final TextEditingController _contatoController = TextEditingController();
  String _categoriaEscolhida = 'Elétrica';
  String _formaContato = 'Whatsapp';

  final ImagePicker _picker = ImagePicker();

  final List<Map<String, dynamic>> _categorias = [
    {'nome': 'Elétrica',    'emoji': '🟡'},
    {'nome': 'Hidráulica',  'emoji': '🔵'},
    {'nome': 'Estrutural',  'emoji': '🟤'},
    {'nome': 'Informática', 'emoji': '🖥️'},
    {'nome': 'Limpeza',     'emoji': '🧹'},
    {'nome': 'Outro',       'emoji': '❓'},
  ];

  Future<void> _selecionarImagem() async {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            Container(
              width: 40, height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            const Text('Adicionar foto',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            ListTile(
              leading: const Icon(Icons.camera_alt_rounded, color: Color(0xFF3A7BD5)),
              title: const Text('Tirar foto'),
              onTap: () async {
                Navigator.pop(context);
                final picked = await _picker.pickImage(
                    source: ImageSource.camera, imageQuality: 80);
                if (picked != null) {
                  setState(() => _imagemSelecionada = File(picked.path));
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_rounded, color: Color(0xFF3A7BD5)),
              title: const Text('Escolher da galeria'),
              onTap: () async {
                Navigator.pop(context);
                final picked = await _picker.pickImage(
                    source: ImageSource.gallery, imageQuality: 80);
                if (picked != null) {
                  setState(() => _imagemSelecionada = File(picked.path));
                }
              },
            ),
            if (_imagemSelecionada != null)
              ListTile(
                leading: const Icon(Icons.delete_rounded, color: Colors.red),
                title: const Text('Remover foto',
                    style: TextStyle(color: Colors.red)),
                onTap: () {
                  Navigator.pop(context);
                  setState(() => _imagemSelecionada = null);
                },
              ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Future<void> _enviar() async {
    final descricao = _descricaoController.text.trim();
    final contato   = _contatoController.text.trim();

    if (descricao.isEmpty) {
      _mostrarSnack('Por favor, descreva o problema.', isErro: true);
      return;
    }
    if (contato.isEmpty) {
      _mostrarSnack('Por favor, informe o contato.', isErro: true);
      return;
    }

    final mensagem =
        'Olá! Estou registrando um problema.\n'
        'Categoria: $_categoriaEscolhida\n'
        'Descrição: $descricao\n'
        'Contato ($_formaContato): $contato';

    if (_formaContato == 'Whatsapp') {
      final numero = contato.replaceAll(RegExp(r'\D'), '');
      final uri = Uri.parse(
          'https://wa.me/$numero?text=${Uri.encodeComponent(mensagem)}');
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        _mostrarSnack('Não foi possível abrir o WhatsApp.', isErro: true);
      }
    } else if (_formaContato == 'Telefone') {
      final numero = contato.replaceAll(RegExp(r'\D'), '');
      final uri = Uri.parse('tel:$numero');
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
        _mostrarSnack('Não foi possível fazer a ligação.', isErro: true);
      }
    } else if (_formaContato == 'Email') {
      final uri = Uri(
        scheme: 'mailto',
        path: contato,
        queryParameters: {
          'subject': 'Problema: $_categoriaEscolhida',
          'body': mensagem,
        },
      );
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
        _mostrarSnack('Não foi possível abrir o e-mail.', isErro: true);
      }
    }
  }

  void _mostrarSnack(String msg, {bool isErro = false}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      backgroundColor: isErro ? Colors.red[700] : Colors.green[700],
      behavior: SnackBarBehavior.floating,
    ));
  }

  String get _hintContato {
    switch (_formaContato) {
      case 'Whatsapp': return '(+55) 11 99999-0000';
      case 'Telefone': return '(+55) 11 3333-4444';
      case 'Email':    return 'exemplo@email.com';
      default:         return '';
    }
  }

  Widget _iconContato() {
    switch (_formaContato) {
      case 'Whatsapp':
        return const Icon(Icons.chat_rounded, color: Colors.green, size: 24);
      case 'Telefone':
        return const Icon(Icons.phone_rounded, color: Colors.blue, size: 24);
      case 'Email':
        return const Icon(Icons.email_rounded, color: Colors.orange, size: 24);
      default:
        return const SizedBox.shrink();
    }
  }

  @override
  void dispose() {
    _descricaoController.dispose();
    _contatoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF5B9BD5),
      body: SafeArea(
        child: Center(
          child: Container(
            width: double.infinity,
            constraints: const BoxConstraints(maxWidth: 440),
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.18),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Título
                  const Text(
                    'Registrar Problema',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Upload de foto
                  GestureDetector(
                    onTap: _selecionarImagem,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      width: double.infinity,
                      height: 140,
                      decoration: BoxDecoration(
                        color: _imagemSelecionada != null
                            ? Colors.transparent
                            : const Color(0xFFF0F4FF),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: const Color(0xFF3A7BD5),
                          width: 1.8,
                        ),
                      ),
                      child: _imagemSelecionada != null
                          ? Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(11),
                                  child: Image.file(
                                    _imagemSelecionada!,
                                    width: double.infinity,
                                    height: 140,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Positioned(
                                  top: 8, right: 8,
                                  child: GestureDetector(
                                    onTap: () => setState(
                                        () => _imagemSelecionada = null),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.black54,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      padding: const EdgeInsets.all(4),
                                      child: const Icon(Icons.close,
                                          color: Colors.white, size: 18),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Icon(Icons.camera_alt_outlined,
                                    size: 44, color: Color(0xFF3A7BD5)),
                                SizedBox(height: 8),
                                Text('Coloque a foto do problema',
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.black87,
                                        fontWeight: FontWeight.w500)),
                                SizedBox(height: 4),
                                Text('(Toque para adicionar a foto)',
                                    style: TextStyle(
                                        fontSize: 12.5,
                                        color: Colors.black45)),
                              ],
                            ),
                    ),
                  ),
                  const SizedBox(height: 18),

                  // Descrição
                  const Text('Descrição',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87)),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _descricaoController,
                    maxLines: 3,
                    style: const TextStyle(fontSize: 14),
                    decoration: InputDecoration(
                      hintText:
                          'Descreva o problema...\nEx: Buraco na parede, computador ruim',
                      hintStyle: const TextStyle(
                          color: Colors.black38, fontSize: 13.5),
                      filled: true,
                      fillColor: const Color(0xFFF4F4F4),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 12),
                    ),
                  ),
                  const SizedBox(height: 18),

                  // Categoria
                  const Text('Categoria',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87)),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFF4F4F4),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 2),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _categoriaEscolhida,
                        isExpanded: true,
                        icon: const Icon(Icons.keyboard_arrow_down_rounded,
                            color: Colors.black54),
                        style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black87),
                        items: _categorias.map((cat) {
                          return DropdownMenuItem<String>(
                            value: cat['nome'],
                            child: Row(
                              children: [
                                Text(cat['emoji'],
                                    style: const TextStyle(fontSize: 18)),
                                const SizedBox(width: 10),
                                Text(cat['nome']),
                              ],
                            ),
                          );
                        }).toList(),
                        onChanged: (val) {
                          if (val != null) {
                            setState(() => _categoriaEscolhida = val);
                          }
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),

                  // Forma de contato
                  const Text('Forma de contato',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87)),
                  const SizedBox(height: 8),
                  Row(
                    children:
                        ['Whatsapp', 'Telefone', 'Email'].map((opcao) {
                      final selecionado = _formaContato == opcao;
                      return Expanded(
                        child: GestureDetector(
                          onTap: () =>
                              setState(() => _formaContato = opcao),
                          child: Row(
                            children: [
                              Radio<String>(
                                value: opcao,
                                groupValue: _formaContato,
                                activeColor: const Color(0xFF3A7BD5),
                                materialTapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap,
                                onChanged: (v) {
                                  if (v != null) {
                                    setState(() => _formaContato = v);
                                  }
                                },
                              ),
                              Flexible(
                                child: Text(
                                  opcao,
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: selecionado
                                        ? const Color(0xFF3A7BD5)
                                        : Colors.black54,
                                    fontWeight: selecionado
                                        ? FontWeight.w600
                                        : FontWeight.normal,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 14),

                  // Contato
                  const Text('Contato',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87)),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _contatoController,
                    keyboardType: _formaContato == 'Email'
                        ? TextInputType.emailAddress
                        : TextInputType.phone,
                    style: const TextStyle(fontSize: 14),
                    decoration: InputDecoration(
                      hintText: _hintContato,
                      hintStyle: const TextStyle(
                          color: Colors.black38, fontSize: 13.5),
                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(12),
                        child: _iconContato(),
                      ),
                      filled: true,
                      fillColor: const Color(0xFFF4F4F4),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 14),
                    ),
                  ),
                  const SizedBox(height: 28),

                  // Botão Enviar
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton.icon(
                      onPressed: _enviar,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF3A7BD5),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        elevation: 4,
                        shadowColor:
                            const Color(0xFF3A7BD5).withOpacity(0.4),
                      ),
                      icon: const Icon(Icons.send_rounded, size: 22),
                      label: const Text(
                        'Enviar Post Agora!',
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}