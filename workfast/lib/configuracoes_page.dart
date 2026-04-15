import 'package:flutter/material.dart';
import 'package:workfast/main.dart';
import 'package:workfast/perfil.dart';

class ConfiguracoesPage extends StatefulWidget {
  const ConfiguracoesPage({super.key});

  @override
  State<ConfiguracoesPage> createState() => _ConfiguracoesPageState();
}

class _ConfiguracoesPageState extends State<ConfiguracoesPage> {
  bool notificacoes = true;
  bool temaEscuro = false;
  bool mostrarTelefone = true;
  bool mostrarEmail = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          const Color(0xFF2C3E50), // Padronizado com o resto do app
      appBar: AppBar(
        title: const Text('Configurações',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF2C3E50),
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _sectionTitle('Conta'),
          _card([
            _item(
              icon: Icons.person,
              title: 'Editar Perfil',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const PerfilPage()),
                );
              },
            ),
            _item(
              icon: Icons.lock,
              title: 'Alterar Senha',
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('Funcionalidade em desenvolvimento')),
                );
              },
            ),
          ]),
          _sectionTitle('Notificações'),
          _card([
            SwitchListTile(
              activeColor: const Color(0xFF4CAF50),
              value: notificacoes,
              onChanged: (value) {
                setState(() => notificacoes = value);
              },
              title: const Text('Receber notificações',
                  style: TextStyle(fontWeight: FontWeight.w500)),
            ),
          ]),
          _sectionTitle('Aparência'),
          _card([
            SwitchListTile(
              activeColor: const Color(0xFF4CAF50),
              value: temaEscuro,
              onChanged: (value) {
                setState(() => temaEscuro = value);
              },
              title: const Text('Tema escuro',
                  style: TextStyle(fontWeight: FontWeight.w500)),
            ),
          ]),
          _sectionTitle('Privacidade'),
          _card([
            SwitchListTile(
              activeColor: const Color(0xFF4CAF50),
              value: mostrarTelefone,
              onChanged: (value) {
                setState(() => mostrarTelefone = value);
              },
              title: const Text('Mostrar telefone',
                  style: TextStyle(fontWeight: FontWeight.w500)),
            ),
            SwitchListTile(
              activeColor: const Color(0xFF4CAF50),
              value: mostrarEmail,
              onChanged: (value) {
                setState(() => mostrarEmail = value);
              },
              title: const Text('Mostrar email',
                  style: TextStyle(fontWeight: FontWeight.w500)),
            ),
          ]),
          _sectionTitle('Outros'),
          _card([
            _item(
              icon: Icons.info,
              title: 'Sobre o app',
              onTap: () {},
            ),
            _item(
              icon: Icons.logout,
              title: 'Sair',
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MyApp(),
                    ));
              },
              color: Colors.red,
            ),
          ]),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, top: 20, bottom: 10),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          color: Colors.white70,
          fontSize: 13,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _card(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Column(children: children),
      ),
    );
  }

  Widget _item({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? color,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: (color ?? const Color(0xFF4CAF50)).withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: color ?? const Color(0xFF4CAF50), size: 20),
      ),
      title: Text(title,
          style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 15)),
      trailing:
          const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
      onTap: onTap,
    );
  }
}
