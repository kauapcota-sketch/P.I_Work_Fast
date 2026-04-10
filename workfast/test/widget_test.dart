import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:workfast/buscar_trabalho.dart';


void main() {
  testWidgets('Verifica se a tela principal carrega corretamente',
      (WidgetTester tester) async {
    // Carrega o app
    await tester.pumpWidget(const busctrabalho());

    // Verifica se as categorias aparecem
    expect(find.text('Manutenção'), findsOneWidget);
    expect(find.text('Pedreiro'), findsOneWidget);
    expect(find.text('Eletricista'), findsOneWidget);
    expect(find.text('Programação'), findsOneWidget);

    // Verifica se os nomes dos usuários aparecem
    expect(find.text('Paulo Henrique'), findsOneWidget);
    expect(find.text('Lucas de Oliveira'), findsOneWidget);

    // Verifica se existe o ícone da câmera
    expect(find.byIcon(Icons.camera_alt), findsOneWidget);

    // Verifica se existe o ícone de configurações
    expect(find.byIcon(Icons.settings), findsOneWidget);
  });
}