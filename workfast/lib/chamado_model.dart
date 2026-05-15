import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:hive_flutter/hive_flutter.dart';

// --- ENUM CATEGORIA ---
enum CategoriaChamado {
  geral,
  informatica,
  eletrica,
  estrutural,
}

// --- ENUM STATUS NEGOCIACAO ---
enum StatusNegociacao {
  aberto,
  propostaEnviada,
  aceito,
  recusado,
}

// --- CLASSE CHAMADO ---
class Chamado extends HiveObject {
  final String nome;
  final String descricao;
  final String telefone;
  final String email;
  final CategoriaChamado categoria;
  final String? imagemPath;
  StatusNegociacao status;
  double? valorFinal;

  Chamado({
    required this.nome,
    required this.descricao,
    required this.telefone,
    required this.email,
    this.categoria = CategoriaChamado.geral,
    this.imagemPath,
    this.status = StatusNegociacao.aberto,
    this.valorFinal,
  });

  File? get imagem => imagemPath != null ? File(imagemPath!) : null;
}

// --- ADAPTER MANUAL PARA CATEGORIA ---
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

// --- ADAPTER MANUAL PARA STATUS NEGOCIACAO ---
class StatusNegociacaoAdapter extends TypeAdapter<StatusNegociacao> {
  @override
  final int typeId = 2;

  @override
  StatusNegociacao read(BinaryReader reader) {
    return StatusNegociacao.values[reader.readInt()];
  }

  @override
  void write(BinaryWriter writer, StatusNegociacao obj) {
    writer.writeInt(obj.index);
  }
}

// --- ADAPTER MANUAL PARA CHAMADO ---
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
      status: StatusNegociacao.values[reader.readInt()],
      valorFinal: reader.readDouble(),
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
    writer.writeInt(obj.status.index);
    writer.writeDouble(obj.valorFinal ?? 0.0);
  }
}

// --- SERVIÇO DE CHAMADOS ---
class ChamadoService {
  static late Box<Chamado> _chamadosBox;
  static bool _isInitialized = false;
  
  static Box<Chamado> get chamadosBox {
    if (!_isInitialized) {
      throw Exception('ChamadoService não foi inicializado. Chame ChamadoService.init() antes de usar.');
    }
    return _chamadosBox;
  }
  
  static bool get isInitialized => _isInitialized;

  static Future<void> init() async {
    if (_isInitialized) {
      debugPrint("ChamadoService: Já foi inicializado, pulando...");
      return;
    }
    
    try {
      debugPrint("ChamadoService: Inicializando...");
      _chamadosBox = await Hive.openBox<Chamado>("chamadosBox");
      _isInitialized = true;
      debugPrint(
          "ChamadoService: Box 'chamadosBox' aberto. Contém ${_chamadosBox.length} chamados.");

      if (_chamadosBox.isEmpty) {
        debugPrint("ChamadoService: Box vazio, adicionando dados mockados.");
        _addMockData();
      }
    } catch (e) {
      debugPrint("ChamadoService: Erro na inicialização: $e");
      rethrow;
    }
  }

  static void _addMockData() {
    debugPrint("ChamadoService: Adicionando dados mockados...");
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
    debugPrint("ChamadoService: Chamado adicionado: ${chamado.nome}");
  }

  static Future<void> removerChamadoPorNomeEDescricao(String nome, String descricao) async {
    if (!_isInitialized) return;
    
    final keysToDelete = _chamadosBox.keys.where((key) {
      final c = _chamadosBox.get(key);
      return c != null && c.nome == nome && c.descricao == descricao;
    }).toList();

    for (var key in keysToDelete) {
      await _chamadosBox.delete(key);
    }
    debugPrint("ChamadoService: Chamados removidos para $nome");
  }

  static List<Chamado> getChamadosPorCategoria(CategoriaChamado categoria) {
    if (!_isInitialized) {
      debugPrint("ChamadoService: Aviso - Serviço não inicializado, retornando lista vazia");
      return [];
    }
    
    debugPrint("ChamadoService: Filtrando chamados por categoria: $categoria");
    List<Chamado> resultados;
    if (categoria == CategoriaChamado.geral) {
      resultados = _chamadosBox.values.toList().reversed.toList();
    } else {
      resultados = _chamadosBox.values
          .where((c) => c.categoria == categoria)
          .toList()
          .reversed
          .toList();
    }
    debugPrint(
        "ChamadoService: Encontrados ${resultados.length} chamados para $categoria.");
    return resultados;
  }

  static List<Chamado> get todosChamados {
    if (!_isInitialized) {
      debugPrint("ChamadoService: Aviso - Serviço não inicializado, retornando lista vazia");
      return [];
    }
    debugPrint("ChamadoService: Acessando todos os chamados.");
    return _chamadosBox.values.toList().reversed.toList();
  }

  static Future<void> clearAllChamados() async {
    debugPrint("ChamadoService: Limpando todos os chamados.");
    await _chamadosBox.clear();
    _addMockData();
    debugPrint("ChamadoService: Chamados limpos e mock data adicionada.");
  }
}
