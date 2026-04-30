import 'package:hive_flutter/hive_flutter.dart';

// Adapter para Avaliacao
class AvaliacaoAdapter extends TypeAdapter<Avaliacao> {
  @override
  final int typeId = 2;

  @override
  Avaliacao read(BinaryReader reader) {
    return Avaliacao(
      nomeAvaliador: reader.readString(),
      nota: reader.readDouble(),
      comentario: reader.readString(),
      data: DateTime.fromMillisecondsSinceEpoch(reader.readInt()),
      nomeProfissional: reader.readString(),
    );
  }

  @override
  void write(BinaryWriter writer, Avaliacao obj) {
    writer.writeString(obj.nomeAvaliador);
    writer.writeDouble(obj.nota);
    writer.writeString(obj.comentario);
    writer.writeInt(obj.data.millisecondsSinceEpoch);
    writer.writeString(obj.nomeProfissional);
  }
}

class Avaliacao extends HiveObject {
  final String nomeAvaliador;
  final double nota;
  final String comentario;
  final DateTime data;
  final String nomeProfissional;

  Avaliacao({
    required this.nomeAvaliador,
    required this.nota,
    required this.comentario,
    required this.data,
    required this.nomeProfissional,
  });
}

class AvaliacaoService {
  static late Box<Avaliacao> _box;

  static Future<void> init() async {
    _box = await Hive.openBox<Avaliacao>('avaliacoesBox');
  }

  static Future<void> adicionarAvaliacao(Avaliacao avaliacao) async {
    await _box.add(avaliacao);
  }

  static List<Avaliacao> getAvaliacoesDoProfissional(String nomeProfissional) {
    return _box.values
        .where((a) => a.nomeProfissional == nomeProfissional)
        .toList()
        .reversed
        .toList();
  }

  static double getMediaNota(String nomeProfissional) {
    final avaliacoes = getAvaliacoesDoProfissional(nomeProfissional);
    if (avaliacoes.isEmpty) return 0.0;
    final soma = avaliacoes.fold<double>(0, (prev, a) => prev + a.nota);
    return soma / avaliacoes.length;
  }

  static List<Avaliacao> get todasAvaliacoes =>
      _box.values.toList().reversed.toList();
}