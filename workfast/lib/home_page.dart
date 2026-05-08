import 'package:flutter/material.dart';
import 'package:workfast/chamado_model.dart';
import 'package:workfast/detalhes_chamado_page.dart';

// ignore: depend_on_referenced_packages

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedCategoryIndex = 0;

  final List<CategoryItem> categories = [
    CategoryItem(
      name: 'Geral',
      icon: Icons.category,
      color: Colors.blue,
      category: CategoriaChamado.geral,
    ),
    CategoryItem(
      name: 'Informática',
      icon: Icons.computer,
      color: Colors.purple,
      category: CategoriaChamado.informatica,
    ),
    CategoryItem(
      name: 'Elétrica',
      icon: Icons.flash_on,
      color: Colors.orange,
      category: CategoriaChamado.eletrica,
    ),
    CategoryItem(
      name: 'Estrutural',
      icon: Icons.home_repair_service,
      color: Colors.teal,
      category: CategoriaChamado.estrutural,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final selectedCategory = categories[_selectedCategoryIndex];

    // Verifica se o serviço foi inicializado
    if (!ChamadoService.isInitialized) {
      return Scaffold(
        backgroundColor:
            isDarkMode ? const Color(0xFF1B2836) : const Color(0xFFECEFF1),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(color: Color(0xFF4CAF50)),
              const SizedBox(height: 16),
              Text(
                'Carregando dados...',
                style: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
            ],
          ),
        ),
      );
    }

    final chamados =
        ChamadoService.getChamadosPorCategoria(selectedCategory.category);

    return Scaffold(
      backgroundColor:
          isDarkMode ? const Color(0xFF1B2836) : const Color(0xFFECEFF1),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2C3E50),
        elevation: 0,
        title: const Text(
          'WorkFast',
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 24),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.white),
            onPressed: () => Navigator.pushNamed(context, '/notificacoes'),
          ),
          IconButton(
            icon: const Icon(Icons.person, color: Colors.white),
            onPressed: () => Navigator.pushNamed(context, '/perfil'),
          ),
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white),
            onPressed: () => Navigator.pushNamed(context, '/configuracoes'),
          ),
        ],
      ),
      // CORREÇÃO 3: Melhorar responsividade com LayoutBuilder
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Banner com saudação - Responsivo
                Container(
                  margin: EdgeInsets.all(constraints.maxWidth * 0.04),
                  padding: EdgeInsets.all(constraints.maxWidth * 0.05),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF4CAF50), Color(0xFF8BC34A)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Bem-vindo ao WorkFast!',
                        style: TextStyle(
                          fontSize: _getResponsiveFontSize(constraints, 22),
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Encontre serviços profissionais de qualidade',
                        style: TextStyle(
                          fontSize: _getResponsiveFontSize(constraints, 14),
                          color: Colors.white.withOpacity(0.9),
                        ),
                      ),
                    ],
                  ),
                ),

                // Título da seção - Responsivo
                Padding(
                  padding: EdgeInsets.fromLTRB(
                    constraints.maxWidth * 0.04,
                    constraints.maxWidth * 0.02,
                    constraints.maxWidth * 0.04,
                    constraints.maxWidth * 0.03,
                  ),
                  child: Text(
                    'Categorias de Serviços',
                    style: TextStyle(
                      fontSize: _getResponsiveFontSize(constraints, 18),
                      fontWeight: FontWeight.bold,
                      color:
                          isDarkMode ? Colors.white : const Color(0xFF2C3E50),
                    ),
                  ),
                ),

                // Carrossel de categorias - Responsivo
                SizedBox(
                  height: _getResponsiveCategoryHeight(constraints),
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.symmetric(
                      horizontal: constraints.maxWidth * 0.04,
                    ),
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      final category = categories[index];
                      final isSelected = index == _selectedCategoryIndex;

                      return GestureDetector(
                        onTap: () =>
                            setState(() => _selectedCategoryIndex = index),
                        child: Container(
                          margin: EdgeInsets.only(
                            right: constraints.maxWidth * 0.03,
                          ),
                          padding: EdgeInsets.all(
                            constraints.maxWidth * 0.03,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? category.color.withOpacity(0.9)
                                : (isDarkMode
                                    ? Colors.white.withOpacity(0.1)
                                    : Colors.white),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: isSelected
                                  ? category.color
                                  : Colors.transparent,
                              width: 2,
                            ),
                            boxShadow: isSelected
                                ? [
                                    BoxShadow(
                                      color: category.color.withOpacity(0.3),
                                      blurRadius: 8,
                                      offset: const Offset(0, 4),
                                    ),
                                  ]
                                : [],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                category.icon,
                                color:
                                    isSelected ? Colors.white : category.color,
                                size: _getResponsiveIconSize(constraints),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                category.name,
                                style: TextStyle(
                                  fontSize:
                                      _getResponsiveFontSize(constraints, 12),
                                  fontWeight: FontWeight.bold,
                                  color: isSelected
                                      ? Colors.white
                                      : (isDarkMode
                                          ? Colors.white
                                          : Colors.black87),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 24),

                // Título dos chamados - Responsivo
                Padding(
                  padding: EdgeInsets.fromLTRB(
                    constraints.maxWidth * 0.04,
                    0,
                    constraints.maxWidth * 0.04,
                    constraints.maxWidth * 0.03,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          'Chamados ${selectedCategory.name}',
                          style: TextStyle(
                            fontSize: _getResponsiveFontSize(constraints, 18),
                            fontWeight: FontWeight.bold,
                            color: isDarkMode
                                ? Colors.white
                                : const Color(0xFF2C3E50),
                          ),
                        ),
                      ),
                      if (chamados.isNotEmpty)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: selectedCategory.color.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '${chamados.length}',
                            style: TextStyle(
                              fontSize: _getResponsiveFontSize(constraints, 14),
                              fontWeight: FontWeight.bold,
                              color: selectedCategory.color,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),

                // Lista de chamados - Responsivo
                if (chamados.isEmpty)
                  Padding(
                    padding: const EdgeInsets.all(32),
                    child: Center(
                      child: Column(
                        children: [
                          Icon(
                            Icons.inbox,
                            size: 64,
                            color: Colors.grey.withOpacity(0.5),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Nenhum chamado encontrado',
                            style: TextStyle(
                              fontSize: _getResponsiveFontSize(constraints, 16),
                              color: isDarkMode
                                  ? Colors.white70
                                  : Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: constraints.maxWidth * 0.04,
                    ),
                    child: Column(
                      children: List.generate(
                        chamados.length,
                        (index) {
                          final chamado = chamados[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: _buildChamadoCard(
                              context,
                              chamado,
                              selectedCategory.color,
                              isDarkMode,
                              constraints,
                            ),
                          );
                        },
                      ),
                    ),
                  ),

                const SizedBox(height: 24),

                // Botão para registrar problema - Responsivo
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: constraints.maxWidth * 0.04,
                    vertical: constraints.maxWidth * 0.04,
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    height: _getResponsiveButtonHeight(constraints),
                    child: ElevatedButton.icon(
                      onPressed: () =>
                          Navigator.pushNamed(context, '/registrar_problema'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4CAF50),
                        foregroundColor: Colors.white,
                        elevation: 8,
                        shadowColor: const Color(0xFF4CAF50).withOpacity(0.5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      icon: const Icon(Icons.add_circle_outline),
                      label: Text(
                        'Registrar Novo Problema',
                        style: TextStyle(
                          fontSize: _getResponsiveFontSize(constraints, 16),
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // Funções auxiliares para responsividade
  double _getResponsiveFontSize(BoxConstraints constraints, double baseSize) {
    if (constraints.maxWidth < 400) {
      return baseSize * 0.85;
    } else if (constraints.maxWidth < 600) {
      return baseSize * 0.95;
    }
    return baseSize;
  }

  double _getResponsiveIconSize(BoxConstraints constraints) {
    if (constraints.maxWidth < 400) {
      return 28;
    } else if (constraints.maxWidth < 600) {
      return 30;
    }
    return 32;
  }

  double _getResponsiveCategoryHeight(BoxConstraints constraints) {
    if (constraints.maxWidth < 400) {
      return 90;
    } else if (constraints.maxWidth < 600) {
      return 95;
    }
    return 100;
  }

  double _getResponsiveButtonHeight(BoxConstraints constraints) {
    if (constraints.maxWidth < 400) {
      return 48;
    } else if (constraints.maxWidth < 600) {
      return 52;
    }
    return 56;
  }

  Widget _buildChamadoCard(
    BuildContext context,
    Chamado chamado,
    Color categoryColor,
    bool isDarkMode,
    BoxConstraints constraints,
  ) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetalhesChamadoPage(chamado: chamado),
          ),
        );
      },
      child: Container(
        padding: EdgeInsets.all(constraints.maxWidth * 0.04),
        decoration: BoxDecoration(
          color: isDarkMode ? Colors.white.withOpacity(0.05) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDarkMode
                ? Colors.white.withOpacity(0.1)
                : Colors.grey.withOpacity(0.2),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Avatar com cor da categoria
            Container(
              width: _getResponsiveAvatarSize(constraints),
              height: _getResponsiveAvatarSize(constraints),
              decoration: BoxDecoration(
                color: categoryColor.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  chamado.nome.isNotEmpty ? chamado.nome[0].toUpperCase() : '?',
                  style: TextStyle(
                    color: categoryColor,
                    fontSize: _getResponsiveFontSize(constraints, 24),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(width: constraints.maxWidth * 0.04),

            // Informações do chamado
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    chamado.nome,
                    style: TextStyle(
                      fontSize: _getResponsiveFontSize(constraints, 16),
                      fontWeight: FontWeight.bold,
                      color:
                          isDarkMode ? Colors.white : const Color(0xFF2C3E50),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    chamado.descricao,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: _getResponsiveFontSize(constraints, 13),
                      color: isDarkMode ? Colors.white70 : Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(
                        Icons.phone_outlined,
                        size: _getResponsiveFontSize(constraints, 12),
                        color:
                            isDarkMode ? Colors.white54 : Colors.grey.shade500,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          chamado.telefone,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: _getResponsiveFontSize(constraints, 12),
                            color: isDarkMode
                                ? Colors.white54
                                : Colors.grey.shade500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Ícone de seta
            Icon(
              Icons.arrow_forward_ios,
              color: isDarkMode ? Colors.white30 : Colors.grey.shade400,
              size: _getResponsiveFontSize(constraints, 16),
            ),
          ],
        ),
      ),
    );
  }

  double _getResponsiveAvatarSize(BoxConstraints constraints) {
    if (constraints.maxWidth < 400) {
      return 48;
    } else if (constraints.maxWidth < 600) {
      return 52;
    }
    return 56;
  }
}

class CategoryItem {
  final String name;
  final IconData icon;
  final Color color;
  final CategoriaChamado category;

  CategoryItem({
    required this.name,
    required this.icon,
    required this.color,
    required this.category,
  });
}
