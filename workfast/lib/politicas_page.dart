import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class PoliticasPage extends StatefulWidget {
  final VoidCallback onAceitar;

  const PoliticasPage({super.key, required this.onAceitar});

  @override
  State<PoliticasPage> createState() => _PoliticasPageState();
}

class _PoliticasPageState extends State<PoliticasPage> {
  bool _leuTudo = false;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 50) {
        if (!_leuTudo) setState(() => _leuTudo = true);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF27485F), Color(0xFF4A7A99)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.bolt_rounded,
                          color: Color(0xFF4CAF50), size: 28),
                    ),
                    const SizedBox(width: 12),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('WorkFast',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 1)),
                        Text('Termos e Políticas',
                            style: TextStyle(
                                color: Colors.white70, fontSize: 12)),
                      ],
                    ),
                  ],
                ),
              ),

              // Card de Políticas
              Expanded(
                child: Container(
                  margin: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 20,
                          offset: const Offset(0, 10)),
                    ],
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: const BoxDecoration(
                          color: Color(0xFF2C3E50),
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(30)),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.policy, color: Color(0xFF4CAF50)),
                            const SizedBox(width: 10),
                            const Text(
                              'Políticas e Termos de Uso',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                            const Spacer(),
                            if (!_leuTudo)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.orange.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: Colors.orange),
                                ),
                                child: const Text('Role para baixo',
                                    style: TextStyle(
                                        color: Colors.orange, fontSize: 11)),
                              ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          controller: _scrollController,
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildSecao(
                                '⚡ Bem-vindo ao WorkFast',
                                'O WorkFast é uma plataforma que conecta clientes que precisam de serviços profissionais com trabalhadores qualificados nas áreas de Informática, Elétrica, Estrutural e serviços em Geral. Ao utilizar nosso aplicativo, você concorda com os termos descritos neste documento.',
                              ),
                              _buildDivider(),
                              _buildSecao(
                                '💳 Como Funciona o Pagamento',
                                '''O sistema de pagamento do WorkFast funciona da seguinte maneira:

1. O CLIENTE anuncia o serviço com um valor proposto.
2. O TRABALHADOR solicita aceitar o chamado.
3. O CLIENTE analisa o perfil, avaliações e especializações do trabalhador antes de aprovar.
4. Após aprovação do cliente, o pagamento é realizado via QR Code seguro diretamente pelo aplicativo.
5. Somente após a confirmação do pagamento, o trabalhador recebe os dados de contato e localização do cliente.
6. Após a conclusão do serviço, o cliente confirma e avalia o trabalho realizado.

⚠️ O WorkFast não armazena dados de cartão de crédito. Os pagamentos são processados por gateway seguro e criptografado.''',
                              ),
                              _buildDivider(),
                              _buildSecao(
                                '🔒 Privacidade do Usuário',
                                '''Levamos sua privacidade muito a sério:

• Seus dados pessoais (nome, telefone, endereço) são compartilhados SOMENTE com o profissional aprovado para o serviço, após confirmação do pagamento.
• Não vendemos, alugamos ou compartilhamos seus dados com terceiros para fins publicitários.
• As avaliações são públicas e vinculadas ao seu perfil profissional.
• Você pode solicitar a exclusão da sua conta e de todos os seus dados a qualquer momento pelo e-mail: privacidade@workfast.com.br
• Suas senhas são armazenadas de forma criptografada e nunca são acessadas por nossa equipe.''',
                              ),
                              _buildDivider(),
                              _buildSecao(
                                '⭐ Sistema de Avaliações',
                                '''As avaliações garantem a qualidade dos serviços:

• Após a conclusão de cada serviço, o cliente poderá avaliar o profissional com uma nota de 1 a 5 estrelas e uma descrição.
• As avaliações ficam visíveis no perfil do profissional e são usadas pelo cliente para decidir se aceita a solicitação de um trabalhador.
• Avaliações falsas ou abusivas serão removidas e podem resultar em banimento da plataforma.
• A média de avaliações é calculada automaticamente e atualizada em tempo real.''',
                              ),
                              _buildDivider(),
                              _buildSecao(
                                '🔔 Notificações',
                                'Você receberá notificações quando: um profissional solicitar seu chamado, o pagamento for confirmado, o serviço for marcado como concluído ou quando houver mensagens importantes sobre sua conta. Você pode gerenciar suas preferências de notificação nas Configurações.',
                              ),
                              _buildDivider(),
                              _buildSecao(
                                '📋 Responsabilidades',
                                '''Ao usar o WorkFast:

• O cliente é responsável por fornecer informações corretas sobre o serviço solicitado.
• O profissional é responsável por realizar o serviço conforme acordado.
• O WorkFast atua apenas como intermediário e não se responsabiliza por danos causados durante a prestação do serviço.
• Condutas inadequadas devem ser reportadas pelo sistema de denúncias do aplicativo.''',
                              ),
                              _buildDivider(),
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF4CAF50).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                      color: const Color(0xFF4CAF50)
                                          .withOpacity(0.3)),
                                ),
                                child: const Row(
                                  children: [
                                    Icon(Icons.verified,
                                        color: Color(0xFF4CAF50)),
                                    SizedBox(width: 10),
                                    Expanded(
                                      child: Text(
                                        'Ao continuar, você declara que leu e concorda com todos os termos e políticas do WorkFast.',
                                        style: TextStyle(
                                            fontSize: 13,
                                            color: Color(0xFF2C3E50),
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 10),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Botão Aceitar
              Padding(
                padding: const EdgeInsets.all(16),
                child: SizedBox(
                  width: double.infinity,
                  height: 58,
                  child: ElevatedButton(
                    onPressed: _leuTudo ? widget.onAceitar : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4CAF50),
                      disabledBackgroundColor: Colors.grey.withOpacity(0.4),
                      foregroundColor: Colors.white,
                      elevation: 8,
                      shadowColor: const Color(0xFF4CAF50).withOpacity(0.5),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                    ),
                    child: Text(
                      _leuTudo
                          ? 'LI E ACEITO OS TERMOS'
                          : 'ROLE PARA LER TUDO',
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSecao(String titulo, String conteudo) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(titulo,
              style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2C3E50))),
          const SizedBox(height: 8),
          Text(conteudo,
              style: TextStyle(
                  fontSize: 13, color: Colors.grey[700], height: 1.6)),
        ],
      ),
    );
  }

  Widget _buildDivider() => Container(
        margin: const EdgeInsets.symmetric(vertical: 12),
        height: 1,
        color: Colors.grey.withOpacity(0.2),
      );
}

// Wrapper que verifica se o usuário já aceitou os termos
class PoliticasWrapper extends StatefulWidget {
  final Widget child;

  const PoliticasWrapper({super.key, required this.child});

  @override
  State<PoliticasWrapper> createState() => _PoliticasWrapperState();
}

class _PoliticasWrapperState extends State<PoliticasWrapper> {
  bool? _aceitou;

  @override
  void initState() {
    super.initState();
    _verificarAceite();
  }

  Future<void> _verificarAceite() async {
    final box = await Hive.openBox('configuracoes');
    final aceitou = box.get('politicas_aceitas', defaultValue: false) as bool;
    if (mounted) setState(() => _aceitou = aceitou);
  }

  Future<void> _aceitarPoliticas() async {
    final box = Hive.box('configuracoes');
    await box.put('politicas_aceitas', true);
    if (mounted) setState(() => _aceitou = true);
  }

  @override
  Widget build(BuildContext context) {
    if (_aceitou == null) {
      return const Scaffold(
        backgroundColor: Color(0xFF2C3E50),
        body: Center(child: CircularProgressIndicator(color: Colors.white)),
      );
    }
    if (_aceitou == false) {
      return PoliticasPage(onAceitar: _aceitarPoliticas);
    }
    return widget.child;
  }
}