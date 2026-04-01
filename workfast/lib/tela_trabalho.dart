import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TelaChamado(),
    );
  }
}

class TelaChamado extends StatelessWidget {
  const TelaChamado({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2C3E50),
      body: Center(
        child: Container(
          width: 300,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFB0BEC5),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Nome
              Row(
                children: [
                  const CircleAvatar(
                    radius: 10,
                    backgroundColor: Colors.grey,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.lightBlue[100],
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Center(
                        child: Text(
                          'Paulo Henrique',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              // Imagem
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: Image.network(
                  'https://photos.enjoei.com.br/public/300x300/czM6Ly9waG90b3MuZW5qb2VpLmNvbS5ici9wcm9kdWN0cy84NTgzOTY0L2I4NTEyZTRmZDZiOWFkM2YwNDE2YTM3YzhiNmY3MDNiLmpwZw',
                  height: 120,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),

              const SizedBox(height: 10),

              // Texto
              const Text(
                'Meu computador desligou de repente e agora não liga mais. Quando tento ligar, as vezes as luzes acendem por um instante, mas não aparece nada na tela e ele desliga logo em seguida. Já testei a tomada e o cabo de energia, mas o problema continua.',
                style: TextStyle(fontSize: 12),
                textAlign: TextAlign.justify,
              ),

              const SizedBox(height: 12),

              // Botão Aceitar
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                  ),
                  child: const Text('Aceitar'),
                ),
              ),

              const SizedBox(height: 8),

              // Botão Voltar
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[700],
                    padding: const EdgeInsets.symmetric(vertical: 10),
                  ),
                  child: const Text('Voltar'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}