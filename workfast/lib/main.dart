import 'package:flutter/material.dart';
import 'pages/registrar_problema_page.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Workfast',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF3A7BD5)),
        useMaterial3: true,
      ),
      home: const RegistrarProblemaPage(),
    );
  }
}