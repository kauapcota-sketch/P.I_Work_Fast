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
  }
}

class Notificacao extends HiveObject {
  final String titulo;
  final String mensagem;
  final DateTime data;
  final String tipo; // 'solicitacao', 'pagamento', 'concluido', 'avaliacao'
  bool lida;
  final String nomeProfissional;
  final String? fotoProfissional;
  final List<String> especializacoes;
  final String chamadoNome;

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
  });
}

class NotificacaoService {
  static late Box<Notificacao> _box;

  static Future<void> init() async {
    _box = await Hive.openBox<Notificacao>('notificacoesBox');
  }

  static Future<void> adicionarNotificacao(Notificacao notificacao) async {
    await _box.add(notificacao);
  }

  static List<Notificacao> get todas =>
      _box.values.toList().reversed.toList();

  static List<Notificacao> get naoLidas =>
      _box.values.where((n) => !n.lida).toList();

  static int get quantidadeNaoLidas =>
      _box.values.where((n) => !n.lida).length;

  static Future<void> marcarComoLida(Notificacao n) async {
    n.lida = true;
    await n.save();
  }

  static Future<void> marcarTodasComoLidas() async {
    for (var n in _box.values) {
      n.lida = true;
      await n.save();
    }
  }

  // Simula uma notificação de solicitação de profissional
  static Future<void> simularSolicitacao({
    required String nomeProfissional,
    required List<String> especializacoes,
    required String chamadoNome,
  }) async {
    await adicionarNotificacao(Notificacao(
      titulo: 'Nova Solicitação de Serviço',
      mensagem: '$nomeProfissional quer realizar seu chamado "$chamadoNome"',
      data: DateTime.now(),
      tipo: 'solicitacao',
      nomeProfissional: nomeProfissional,
      especializacoes: especializacoes,
      chamadoNome: chamadoNome,
    ));
  }
}