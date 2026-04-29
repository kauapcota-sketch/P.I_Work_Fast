import 'dart:io';
import 'package:hive_flutter/hive_flutter.dart';

// --- ENUM CATEGORIA ---
enum CategoriaChamado {
  geral,
  informatica,
  eletrica,
  estrutural,
}

// --- CLASSE CHAMADO ---
class Chamado extends HiveObject {
  final String nome;
  final String descricao;
  final String telefone;
  final String email;
  final CategoriaChamado categoria;
  final String? imagemPath;

  Chamado({
    required this.nome,
    required this.descricao,
    required this.telefone,
    required this.email,
    this.categoria = CategoriaChamado.geral,
    this.imagemPath,
  });

  File? get imagem => imagemPath != null ? File(imagemPath!) : null;
}

// --- ADAPTER MANUAL PARA CATEGORIA (Resolve o erro no main.dart) ---
class CategoriaChamadoAdapter extends TypeAdapter<CategoriaChamado> {
  @override
  final int typeId = 0;

  @override
  CategoriaChamado read(BinaryReader reader) {
    return CategoriaChamado.values[reader.readInt()];
  }

  @override
  void write(BinaryWriter writer, CategoriaChamado obj) {
    writer.writeInt(obj.index);
  }
}

// --- ADAPTER MANUAL PARA CHAMADO (Resolve o erro no main.dart) ---
class ChamadoAdapter extends TypeAdapter<Chamado> {
  @override
  final int typeId = 1;

  @override
  Chamado read(BinaryReader reader) {
    return Chamado(
      nome: reader.readString(),
      descricao: reader.readString(),
      telefone: reader.readString(),
      email: reader.readString(),
      categoria: CategoriaChamado.values[reader.readInt()],
      imagemPath: reader.readString(),
    );
  }

  @override
  void write(BinaryWriter writer, Chamado obj) {
    writer.writeString(obj.nome);
    writer.writeString(obj.descricao);
    writer.writeString(obj.telefone);
    writer.writeString(obj.email);
    writer.writeInt(obj.categoria.index);
    writer.writeString(obj.imagemPath ?? '');
  }
}

// --- SERVIÇO DE CHAMADOS ---
class ChamadoService {
  static late Box<Chamado> _chamadosBox;

  static Future<void> init() async {
    // Abre o box usando o Adapter manual
    _chamadosBox = await Hive.openBox<Chamado>('chamadosBox');

    if (_chamadosBox.isEmpty) {
      _addMockData();
    }
  }

  static void _addMockData() {
    final mockData = [
      Chamado(
        nome: 'Paulo Henrique',
        descricao: 'Meu computador desligou de repente e agora nao liga mais.',
        telefone: '31 5983-1047',
        email: 'paulo@gmail.com.br',
        categoria: CategoriaChamado.informatica,
      ),
      Chamado(
        nome: 'Rayanne Silva',
        descricao: 'Meu micro-ondas quebrou.',
        telefone: '31 9612-3370',
        email: 'rayanne@gmail.com.br',
        categoria: CategoriaChamado.eletrica,
      ),
      Chamado(
        nome: 'Ana Paula',
        descricao: 'Reparo de telhado e infiltrações.',
        telefone: '31 1234-5678',
        email: 'ana@gmail.com.br',
        categoria: CategoriaChamado.estrutural,
      ),
    ];
    _chamadosBox.addAll(mockData);
  }

  static Future<void> adicionarChamado(Chamado chamado) async {
    await _chamadosBox.add(chamado);
  }

  static List<Chamado> getChamadosPorCategoria(CategoriaChamado categoria) {
    if (categoria == CategoriaChamado.geral) {
      return _chamadosBox.values.toList().reversed.toList();
    } else {
      return _chamadosBox.values
          .where((c) => c.categoria == categoria)
          .toList()
          .reversed
          .toList();
    }
  }

  static List<Chamado> get todosChamados =>
      _chamadosBox.values.toList().reversed.toList();
}
