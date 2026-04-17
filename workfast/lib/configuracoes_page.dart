import 'package:flutter/material.dart';
import 'package:workfast/main.dart'; // Importante para o themeNotifier

class ConfiguracoesPage extends StatelessWidget {
  const ConfiguracoesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Configurações'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // SEÇÃO DE TEMA
          Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: ListTile(
              leading: Icon(isDarkMode ? Icons.dark_mode : Icons.light_mode,
                  color: Colors.amber),
              title: const Text('Modo Escuro'),
              trailing: Switch(
                value: isDarkMode,
                onChanged: (value) {
                  // Alterna o tema globalmente
                  themeNotifier.value =
                      value ? ThemeMode.dark : ThemeMode.light;
                },
              ),
            ),
          ),
          const SizedBox(height: 10),

          // SEÇÃO DE PERFIL
          Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: ListTile(
              leading: const Icon(Icons.person, color: Colors.blue),
              title: const Text('Editar Perfil'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () => Navigator.pushNamed(context, '/perfil'),
            ),
          ),

          const SizedBox(height: 10),

          // BOTÃO SAIR
          Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text('Sair da Conta'),
              onTap: () {
                Navigator.pushNamedAndRemoveUntil(
                    context, '/login', (route) => false);
              },
            ),
          ),
        ],
      ),
    );
  }
}
