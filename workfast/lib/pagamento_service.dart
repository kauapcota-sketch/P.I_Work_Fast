import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

enum StatusPagamento { pendente, aguardandoPagamento, pago, concluido }

class PagamentoAdapter extends TypeAdapter<Pagamento> {
  @override
  final int typeId = 6;

  @override
  Pagamento read(BinaryReader reader) {
    return Pagamento(
      id: reader.readString(),
      chamadoNome: reader.readString(),
      nomeProfissional: reader.readString(),
      valor: reader.readDouble(),
      status: StatusPagamento.values[reader.readInt()],
      dataCriacao: DateTime.fromMillisecondsSinceEpoch(reader.readInt()),
      contatoCliente: reader.readString(),
      localServico: reader.readString(),
    );
  }

  @override
  void write(BinaryWriter writer, Pagamento obj) {
    writer.writeString(obj.id);
    writer.writeString(obj.chamadoNome);
    writer.writeString(obj.nomeProfissional);
    writer.writeDouble(obj.valor);
    writer.writeInt(obj.status.index);
    writer.writeInt(obj.dataCriacao.millisecondsSinceEpoch);
    writer.writeString(obj.contatoCliente);
    writer.writeString(obj.localServico);
  }
}

class Pagamento extends HiveObject {
  final String id;
  final String chamadoNome;
  final String nomeProfissional;
  final double valor;
  StatusPagamento status;
  final DateTime dataCriacao;
  final String contatoCliente;
  final String localServico;

  Pagamento({
    required this.id,
    required this.chamadoNome,
    required this.nomeProfissional,
    required this.valor,
    this.status = StatusPagamento.pendente,
    required this.dataCriacao,
    required this.contatoCliente,
    required this.localServico,
  });
}

class PagamentoService {
  static late Box<Pagamento> _box;
  static bool _isInitialized = false;

  static bool get isInitialized => _isInitialized;

  static Future<void> init() async {
    if (_isInitialized) {
      debugPrint("PagamentoService: Já foi inicializado, pulando...");
      return;
    }

    try {
      debugPrint("PagamentoService: Inicializando...");
      _box = await Hive.openBox<Pagamento>('pagamentosBox');
      _isInitialized = true;
      debugPrint("PagamentoService: Box 'pagamentosBox' aberto com sucesso.");
    } catch (e) {
      debugPrint("PagamentoService: Erro na inicialização: $e");
      rethrow;
    }
  }

  static Future<Pagamento> criarPagamento({
    required String chamadoNome,
    required String nomeProfissional,
    required double valor,
    required String contatoCliente,
    required String localServico,
  }) async {
    if (!_isInitialized) {
      debugPrint("PagamentoService: Aviso - Serviço não inicializado");
      throw Exception('PagamentoService não foi inicializado');
    }

    final pagamento = Pagamento(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      chamadoNome: chamadoNome,
      nomeProfissional: nomeProfissional,
      valor: valor,
      status: StatusPagamento.aguardandoPagamento,
      dataCriacao: DateTime.now(),
      contatoCliente: contatoCliente,
      localServico: localServico,
    );
    await _box.add(pagamento);
    return pagamento;
  }

  static Future<void> confirmarPagamento(Pagamento p) async {
    if (!_isInitialized) {
      debugPrint("PagamentoService: Aviso - Serviço não inicializado");
      return;
    }
    p.status = StatusPagamento.pago;
    await p.save();
  }

  static Future<void> marcarComoConcluido(Pagamento p) async {
    if (!_isInitialized) {
      debugPrint("PagamentoService: Aviso - Serviço não inicializado");
      return;
    }
    p.status = StatusPagamento.concluido;
    await p.save();
  }

  static List<Pagamento> get todos {
    if (!_isInitialized) {
      debugPrint("PagamentoService: Aviso - Serviço não inicializado, retornando lista vazia");
      return [];
    }
    return _box.values.toList().reversed.toList();
  }

  static List<Pagamento> getPorStatus(StatusPagamento status) {
    if (!_isInitialized) {
      debugPrint("PagamentoService: Aviso - Serviço não inicializado, retornando lista vazia");
      return [];
    }
    return _box.values.where((p) => p.status == status).toList();
  }
}
