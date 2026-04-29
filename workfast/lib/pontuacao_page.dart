import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

// Serviço de pontuação (gamificação)
class PontuacaoService {
  static const String _boxName = 'pontuacao';

  static Future<void> init() async {
    await Hive.openBox(_boxName);
  }

  static Box get _box => Hive.box(_boxName);

  // Pega a pontuação total
  static int getPontos() {
    return _box.get('pontos', defaultValue: 0) as int;
  }

  // Adiciona pontos e registra a conquista
  static Future<void> adicionarPontos(int quantidade, String motivo) async {
    final atual = getPontos();
    await _box.put('pontos', atual + quantidade);

    // Registra histórico
    final historico = List<Map>.from(_box.get('historico', defaultValue: []));
    historico.insert(0, {
      'pontos': quantidade,
      'motivo': motivo,
      'data': DateTime.now().toIso8601String(),
    });
    await _box.put('historico', historico);
  }

  // Retorna histórico de pontos
  static List<Map> getHistorico() {
    return List<Map>.from(_box.get('historico', defaultValue: []));
  }

  // Retorna o nível baseado nos pontos
  static Map<String, dynamic> getNivel(int pontos) {
    if (pontos < 100) {
      return {
        'nome': 'Iniciante',
        'icone': '🌱',
        'cor': Colors.grey,
        'proximo': 100
      };
    } else if (pontos < 300) {
      return {
        'nome': 'Aprendiz',
        'icone': '⚡',
        'cor': Colors.blue,
        'proximo': 300
      };
    } else if (pontos < 600) {
      return {
        'nome': 'Profissional',
        'icone': '🔧',
        'cor': Colors.green,
        'proximo': 600
      };
    } else if (pontos < 1000) {
      return {
        'nome': 'Especialista',
        'icone': '🏆',
        'cor': Colors.orange,
        'proximo': 1000
      };
    } else {
      return {
        'nome': 'Mestre',
        'icone': '👑',
        'cor': Colors.purple,
        'proximo': 9999
      };
    }
  }

  // Lista de conquistas disponíveis
  static List<Map<String, dynamic>> getConquistas(int pontos) {
    return [
      {
        'titulo': 'Primeiro Passo',
        'descricao': 'Faça seu primeiro cadastro',
        'icone': Icons.login,
        'cor': Colors.green,
        'pontos': 10,
        'desbloqueada': pontos >= 10,
      },
      {
        'titulo': 'Prestativo',
        'descricao': 'Registre seu primeiro chamado',
        'icone': Icons.add_circle,
        'cor': Colors.blue,
        'pontos': 50,
        'desbloqueada': pontos >= 50,
      },
      {
        'titulo': 'Confiável',
        'descricao': 'Aceite 5 chamados',
        'icone': Icons.handshake,
        'cor': Colors.orange,
        'pontos': 150,
        'desbloqueada': pontos >= 150,
      },
      {
        'titulo': 'Experiente',
        'descricao': 'Alcance 300 pontos',
        'icone': Icons.workspace_premium,
        'cor': Colors.purple,
        'pontos': 300,
        'desbloqueada': pontos >= 300,
      },
      {
        'titulo': 'Mestre WorkFast',
        'descricao': 'Alcance 1000 pontos',
        'icone': Icons.emoji_events,
        'cor': Colors.amber,
        'pontos': 1000,
        'desbloqueada': pontos >= 1000,
      },
    ];
  }
}

class PontuacaoPage extends StatefulWidget {
  const PontuacaoPage({super.key});

  @override
  State<PontuacaoPage> createState() => _PontuacaoPageState();
}

class _PontuacaoPageState extends State<PontuacaoPage> {
  int _pontos = 0;
  List<Map> _historico = [];

  @override
  void initState() {
    super.initState();
    _carregarDados();
  }

  Future<void> _carregarDados() async {
    await PontuacaoService.init();
    setState(() {
      _pontos = PontuacaoService.getPontos();
      _historico = PontuacaoService.getHistorico();
    });
  }

  Future<void> _simularGanho() async {
    // Botão de demonstração — simula ganho de pontos
    const opcoes = [
      {'pts': 10, 'msg': 'Login realizado'},
      {'pts': 50, 'msg': 'Chamado registrado'},
      {'pts': 100, 'msg': 'Serviço aceito'},
    ];
    final opcao = opcoes[_historico.length % opcoes.length];
    await PontuacaoService.adicionarPontos(
      opcao['pts'] as int,
      opcao['msg'] as String,
    );
    await _carregarDados();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('+${opcao['pts']} pontos: ${opcao['msg']}'),
          backgroundColor: const Color(0xFF4CAF50),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final nivel = PontuacaoService.getNivel(_pontos);
    final conquistas = PontuacaoService.getConquistas(_pontos);
    final Color nivelCor = nivel['cor'] as Color;
    final int proximoNivel = nivel['proximo'] as int;
    final double progresso =
        proximoNivel >= 9999 ? 1.0 : _pontos / proximoNivel;

    return Scaffold(
      backgroundColor: const Color(0xFF2C3E50),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2C3E50),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Minha Pontuação',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Card de pontuação principal ──────────────────────
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [nivelCor, nivelCor.withOpacity(0.7)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: nivelCor.withOpacity(0.4),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Text(
                    nivel['icone'] as String,
                    style: const TextStyle(fontSize: 52),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    nivel['nome'] as String,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '$_pontos',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 56,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const Text(
                    'PONTOS',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Barra de progresso para o próximo nível
                  if (proximoNivel < 9999) ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Próximo nível',
                          style: TextStyle(color: Colors.white70, fontSize: 12),
                        ),
                        Text(
                          '$_pontos / $proximoNivel pts',
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        value: progresso.clamp(0.0, 1.0),
                        backgroundColor: Colors.white24,
                        valueColor:
                            const AlwaysStoppedAnimation<Color>(Colors.white),
                        minHeight: 10,
                      ),
                    ),
                  ] else
                    const Text(
                      '🏆 Nível máximo atingido!',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            // ── Botão de demonstração ────────────────────────────
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                onPressed: _simularGanho,
                icon: const Icon(Icons.add_circle_outline),
                label: const Text(
                  'SIMULAR GANHO DE PONTOS',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4CAF50),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  elevation: 4,
                ),
              ),
            ),

            const SizedBox(height: 28),

            // ── Conquistas ───────────────────────────────────────
            const Text(
              'Conquistas',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 14),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.2,
              ),
              itemCount: conquistas.length,
              itemBuilder: (context, index) {
                final c = conquistas[index];
                final bool desbloqueada = c['desbloqueada'] as bool;
                final Color cor = c['cor'] as Color;
                return Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: desbloqueada ? Colors.white : Colors.white24,
                    borderRadius: BorderRadius.circular(16),
                    border:
                        desbloqueada ? Border.all(color: cor, width: 2) : null,
                    boxShadow: desbloqueada
                        ? [
                            BoxShadow(
                              color: cor.withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            )
                          ]
                        : null,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        c['icone'] as IconData,
                        size: 32,
                        color: desbloqueada ? cor : Colors.white38,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        c['titulo'] as String,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          color: desbloqueada
                              ? const Color(0xFF2C3E50)
                              : Colors.white54,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${c['pontos']} pts',
                        style: TextStyle(
                          fontSize: 11,
                          color: desbloqueada ? cor : Colors.white38,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),

            const SizedBox(height: 28),

            // ── Histórico ────────────────────────────────────────
            const Text(
              'Histórico de Pontos',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 14),
            if (_historico.isEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Column(
                  children: [
                    Icon(Icons.history, size: 36, color: Colors.grey),
                    SizedBox(height: 8),
                    Text(
                      'Nenhum ponto registrado ainda.',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              )
            else
              ..._historico.take(10).map((h) {
                final data = DateTime.tryParse(h['data'] as String? ?? '');
                final String dataStr = data != null
                    ? '${data.day}/${data.month}/${data.year} ${data.hour}:${data.minute.toString().padLeft(2, '0')}'
                    : '';
                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.06),
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFF4CAF50).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          '+${h['pontos']}',
                          style: const TextStyle(
                            color: Color(0xFF4CAF50),
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              h['motivo'] as String? ?? '',
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                                color: Color(0xFF2C3E50),
                              ),
                            ),
                            if (dataStr.isNotEmpty)
                              Text(
                                dataStr,
                                style: TextStyle(
                                    fontSize: 11, color: Colors.grey.shade500),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
