import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class NotificacaoAdapter extends TypeAdapter<Notificacao> {
  @override
  final int typeId = 3;

  @override
  Notificacao read(BinaryReader reader) {
    return Notificacao(
      titulo: reader.readString(),
      mensagem: reader.readString(),
      data: DateTime.fromMillisecondsSinceEpoch(reader.readInt()),
      tipo: reader.readString(),
      lida: reader.readBool(),
      nomeProfissional: reader.readString(),
      fotoProfissional: reader.readString(),
      especializacoes: List<String>.from(reader.readStringList()),
      chamadoNome: reader.readString(),
      valorProposta: reader.readDouble(),
    );
  }

  @override
  void write(BinaryWriter writer, Notificacao obj) {
    writer.writeString(obj.titulo);
    writer.writeString(obj.mensagem);
    writer.writeInt(obj.data.millisecondsSinceEpoch);
    writer.writeString(obj.tipo);
    writer.writeBool(obj.lida);
    writer.writeString(obj.nomeProfissional);
    writer.writeString(obj.fotoProfissional ?? '');
    writer.writeStringList(obj.especializacoes);
    writer.writeString(obj.chamadoNome);
    writer.writeDouble(obj.valorProposta);
  }
}

class Notificacao extends HiveObject {
  final String titulo;
  final String mensagem;
  final DateTime data;
  final String tipo;
  bool lida;
  final String nomeProfissional;
  final String? fotoProfissional;
  final List<String> especializacoes;
  final String chamadoNome;
  final double valorProposta;

  Notificacao({
    required this.titulo,
    required this.mensagem,
    required this.data,
    required this.tipo,
    this.lida = false,
    required this.nomeProfissional,
    this.fotoProfissional,
    required this.especializacoes,
    required this.chamadoNome,
    this.valorProposta = 0.0,
  });
}

class NotificacaoService {
  static late Box<Notificacao> _box;
  static bool _isInitialized = false;

  static bool get isInitialized => _isInitialized;

  static Future<void> init() async {
    if (_isInitialized) {
      debugPrint("NotificacaoService: Já foi inicializado, pulando...");
      return;
    }

    try {
      debugPrint("NotificacaoService: Inicializando...");
      _box = await Hive.openBox<Notificacao>('notificacoesBox');
      _isInitialized = true;
      debugPrint("NotificacaoService: Box 'notificacoesBox' aberto com sucesso.");
    } catch (e) {
      debugPrint("NotificacaoService: Erro na inicialização: $e");
      rethrow;
    }
  }

  static Box<Notificacao> get notificacoesBox {
    if (!_isInitialized) {
      throw Exception('NotificacaoService não foi inicializado. Chame NotificacaoService.init() antes de usar.');
    }
    return _box;
  }

  static Future<void> adicionarNotificacao(Notificacao notificacao) async {
    if (!_isInitialized) {
      debugPrint("NotificacaoService: Aviso - Serviço não inicializado");
      return;
    }
    await _box.add(notificacao);
  }

  static Future<void> removerNotificacao(Notificacao notificacao) async {
    if (!_isInitialized) {
      debugPrint("NotificacaoService: Aviso - Serviço não inicializado");
      return;
    }
    await notificacao.delete();
  }

  static Future<void> removerNotificacaoProposta(String nomeProfissional, String chamadoNome) async {
    if (!_isInitialized) return;
    
    final keysToDelete = _box.keys.where((key) {
      final n = _box.get(key);
      return n != null && 
             n.tipo == 'solicitacao' && 
             n.nomeProfissional == nomeProfissional && 
             n.chamadoNome == chamadoNome;
    }).toList();

    for (var key in keysToDelete) {
      await _box.delete(key);
    }
    debugPrint("NotificacaoService: Notificações de proposta removidas para $nomeProfissional");
  }

  static List<Notificacao> get todas {
    if (!_isInitialized) {
      debugPrint("NotificacaoService: Aviso - Serviço não inicializado, retornando lista vazia");
      return [];
    }
    return _box.values.toList().reversed.toList();
  }

  static List<Notificacao> get naoLidas {
    if (!_isInitialized) {
      debugPrint("NotificacaoService: Aviso - Serviço não inicializado, retornando lista vazia");
      return [];
    }
    return _box.values.where((n) => !n.lida).toList();
  }

  static int get quantidadeNaoLidas {
    if (!_isInitialized) {
      debugPrint("NotificacaoService: Aviso - Serviço não inicializado");
      return 0;
    }
    return _box.values.where((n) => !n.lida).length;
  }

  static Future<void> marcarComoLida(Notificacao n) async {
    if (!_isInitialized) {
      debugPrint("NotificacaoService: Aviso - Serviço não inicializado");
      return;
    }
    n.lida = true;
    await n.save();
  }

  static Future<void> marcarTodasComoLidas() async {
    if (!_isInitialized) {
      debugPrint("NotificacaoService: Aviso - Serviço não inicializado");
      return;
    }
    for (var n in _box.values) {
      n.lida = true;
      await n.save();
    }
  }

  static Future<void> simularSolicitacao({
    required String nomeProfissional,
    required List<String> especializacoes,
    required String chamadoNome,
    double valorProposta = 0.0,
  }) async {
    if (!_isInitialized) {
      debugPrint("NotificacaoService: Aviso - Serviço não inicializado");
      return;
    }
    await adicionarNotificacao(Notificacao(
      titulo: 'Nova Solicitação de Serviço',
      mensagem: '$nomeProfissional quer realizar seu chamado "$chamadoNome"',
      data: DateTime.now(),
      tipo: 'solicitacao',
      nomeProfissional: nomeProfissional,
      especializacoes: especializacoes,
      chamadoNome: chamadoNome,
      valorProposta: valorProposta,
    ));
  }
}
