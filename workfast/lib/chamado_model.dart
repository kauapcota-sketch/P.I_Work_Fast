enum CategoriaChamado {
  geral,
  informatica,
  eletrica,
  estrutural,
}

class Chamado {
  final String nome;
  final String descricao;
  final String telefone;
  final String email;
  final CategoriaChamado categoria;

  Chamado({
    required this.nome,
    required this.descricao,
    required this.telefone,
    required this.email,
    this.categoria = CategoriaChamado.geral,
  });
}

class ChamadoService {
  static final List<Chamado> _todosChamados = [
    Chamado(
      nome: 'Paulo Henrique',
      descricao: 'Meu computador desligou de repente e agora nao liga mais.',
      telefone: '31 5983-1047',
      email: 'paulo@gmail.com.br',
      categoria: CategoriaChamado.informatica,
    ),
    // ... adicione os outros aqui se desejar
  ];

  static List<Chamado> getChamadosPorCategoria(CategoriaChamado categoria) {
    if (categoria == CategoriaChamado.geral) {
      return _todosChamados;
    } else {
      return _todosChamados
          .where((chamado) => chamado.categoria == categoria)
          .toList();
    }
  }

  static void adicionarChamado(Chamado novoChamado) {}
}
