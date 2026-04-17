enum CategoriaChamado {
  eletrica,
  estrutural,
  informatica,
  geral,
}

class Chamado {
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
    required this.categoria,
    this.imagemPath,
  });
}

class ChamadoService {
  static final List<Chamado> _chamados = [];

  static void adicionarChamado(Chamado chamado) {
    _chamados.add(chamado);
  }

  static List<Chamado> listarChamados() {
    return _chamados;
  }
}
