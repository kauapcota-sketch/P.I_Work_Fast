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

// ESTA CLASSE ESTAVA FALTANDO NO SEU ARQUIVO:
class ChamadoService {
  static final List<Chamado> _todosChamados = [
    Chamado(
      nome: 'Paulo Henrique',
      descricao: 'Meu computador desligou de repente e agora nao liga mais.',
      telefone: '31 5983-1047',
      email: 'paulo@gmail.com.br',
      categoria: CategoriaChamado.informatica,
    ),
    Chamado(
      nome: 'Lucas de Oliveira',
      descricao: 'Preciso de um analista urgente.',
      telefone: '31 6589-5632',
      email: 'lucas@gmail.com.br',
      categoria: CategoriaChamado.informatica,
    ),
    Chamado(
      nome: 'Italo Freitas',
      descricao: 'Preciso trocar a cor da minha casa.',
      telefone: '31 7690-6743',
      email: 'italo@gmail.com.br',
      categoria: CategoriaChamado.estrutural,
    ),
    Chamado(
      nome: 'Mariana Borges',
      descricao: 'Preciso de um desenvolvedor para montar um site.',
      telefone: '31 8701-7853',
      email: 'mariana@gmail.com.br',
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
      nome: 'Carlos Eduardo',
      descricao: 'Instalação de nova fiação elétrica para um cômodo.',
      telefone: '31 9876-5432',
      email: 'carlos@gmail.com.br',
      categoria: CategoriaChamado.eletrica,
    ),
    Chamado(
      nome: 'Ana Paula',
      descricao: 'Reparo de telhado e infiltrações.',
      telefone: '31 1234-5678',
      email: 'ana@gmail.com.br',
      categoria: CategoriaChamado.estrutural,
    ),
    Chamado(
      nome: 'Pedro Rocha',
      descricao: 'Formatação de computador e instalação de software.',
      telefone: '31 2345-6789',
      email: 'pedro@gmail.com.br',
      categoria: CategoriaChamado.informatica,
    ),
    Chamado(
      nome: 'Julia Lima',
      descricao: 'Revisão geral da parte elétrica da casa.',
      telefone: '31 3456-7890',
      email: 'julia@gmail.com.br',
      categoria: CategoriaChamado.eletrica,
    ),
    Chamado(
      nome: 'Rafaela Costa',
      descricao: 'Construção de uma pequena parede divisória.',
      telefone: '31 4567-8901',
      email: 'rafaela@gmail.com.br',
      categoria: CategoriaChamado.estrutural,
    ),
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

  static List<Chamado> get todosChamados => _todosChamados;
}
