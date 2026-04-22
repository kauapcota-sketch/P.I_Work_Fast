import 'package:flutter/material.dart';
import 'package:workfast/auth_service.dart';

class EsqueciSenhaPage extends StatefulWidget {
  const EsqueciSenhaPage({super.key});

  @override
  State<EsqueciSenhaPage> createState() => _EsqueciSenhaPageState();
}

class _EsqueciSenhaPageState extends State<EsqueciSenhaPage> {
  final _emailController = TextEditingController();
  final _novaSenhaController = TextEditingController();
  final _confirmarSenhaController = TextEditingController();

  bool _obscureNova = true;
  bool _obscureConfirmar = true;
  bool _isLoading = false;
  bool _emailVerificado = false; // controla qual "passo" mostrar
  String? _errorMessage;
  String? _emailEncontrado;

  @override
  void dispose() {
    _emailController.dispose();
    _novaSenhaController.dispose();
    _confirmarSenhaController.dispose();
    super.dispose();
  }

  /// Passo 1: verifica se o e-mail existe no cadastro
  Future<void> _verificarEmail() async {
    final email = _emailController.text.trim();

    setState(() => _errorMessage = null);

    if (email.isEmpty) {
      setState(() => _errorMessage = 'Informe seu e-mail');
      return;
    }

    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 600));

    final existe = AuthService.emailExiste(email);
    setState(() => _isLoading = false);

    if (existe) {
      setState(() {
        _emailVerificado = true;
        _emailEncontrado = email;
      });
    } else {
      setState(
          () => _errorMessage = 'Nenhuma conta encontrada com este e-mail.');
    }
  }

  /// Passo 2: redefine a senha
  Future<void> _redefinirSenha() async {
    final nova = _novaSenhaController.text.trim();
    final confirmar = _confirmarSenhaController.text.trim();

    setState(() => _errorMessage = null);

    if (nova.isEmpty || confirmar.isEmpty) {
      setState(() => _errorMessage = 'Preencha os dois campos.');
      return;
    }

    if (nova.length < 6) {
      setState(
          () => _errorMessage = 'A senha deve ter pelo menos 6 caracteres.');
      return;
    }

    if (nova != confirmar) {
      setState(() => _errorMessage = 'As senhas não coincidem.');
      return;
    }

    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 600));

    await AuthService.redefinirSenha(_emailEncontrado!, nova);

    setState(() => _isLoading = false);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Senha redefinida com sucesso!'),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );
      Navigator.pop(context); // volta para o login
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDarkMode
                ? [const Color(0xFF1B2836), const Color(0xFF0D141A)]
                : [const Color(0xFF27485F), const Color(0xFF4A7A99)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // AppBar manual para manter visual do app
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Row(
                  children: [
                    IconButton(
                      icon:
                          const Icon(Icons.arrow_back_ios, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const Text(
                      'Recuperar Senha',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Column(
                      children: [
                        // Ícone
                        Container(
                          padding: const EdgeInsets.all(22),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            shape: BoxShape.circle,
                            border: Border.all(
                                color: Colors.white.withOpacity(0.2), width: 2),
                          ),
                          child: Icon(
                            _emailVerificado
                                ? Icons.lock_reset
                                : Icons.email_outlined,
                            size: 60,
                            color: const Color(0xFF4CAF50),
                          ),
                        ),
                        const SizedBox(height: 20),

                        Text(
                          _emailVerificado ? 'Nova Senha' : 'Esqueceu a senha?',
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _emailVerificado
                              ? 'Digite a nova senha para sua conta'
                              : 'Informe o e-mail cadastrado para redefinir',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.8),
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 40),

                        // Card principal
                        Container(
                          padding: const EdgeInsets.all(28),
                          decoration: BoxDecoration(
                            color: isDarkMode
                                ? const Color(0xFF2C3E50)
                                : Colors.white,
                            borderRadius: BorderRadius.circular(35),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                blurRadius: 25,
                                offset: const Offset(0, 15),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              if (_errorMessage != null)
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 16),
                                  child: Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: Colors.red.shade50,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                          color: Colors.red.shade200),
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(Icons.error_outline,
                                            color: Colors.red.shade600,
                                            size: 20),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            _errorMessage!,
                                            style: TextStyle(
                                                color: Colors.red.shade700,
                                                fontSize: 14),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                              // PASSO 1: campo de e-mail
                              if (!_emailVerificado) ...[
                                _buildField(
                                  controller: _emailController,
                                  label: 'E-mail cadastrado',
                                  icon: Icons.email_outlined,
                                  isDarkMode: isDarkMode,
                                  tipo: TextInputType.emailAddress,
                                ),
                                const SizedBox(height: 28),
                                SizedBox(
                                  width: double.infinity,
                                  height: 58,
                                  child: ElevatedButton(
                                    onPressed:
                                        _isLoading ? null : _verificarEmail,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF4CAF50),
                                      foregroundColor: Colors.white,
                                      elevation: 8,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                    ),
                                    child: _isLoading
                                        ? const CircularProgressIndicator(
                                            color: Colors.white)
                                        : const Text('VERIFICAR E-MAIL',
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold)),
                                  ),
                                ),
                              ],

                              // PASSO 2: campos de nova senha
                              if (_emailVerificado) ...[
                                // E-mail bloqueado (só leitura)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 14),
                                  decoration: BoxDecoration(
                                    color: Colors.green.shade50,
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                        color: Colors.green.shade200),
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.check_circle,
                                          color: Color(0xFF4CAF50), size: 20),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Text(
                                          _emailEncontrado!,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 14),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 20),
                                _buildField(
                                  controller: _novaSenhaController,
                                  label: 'Nova senha',
                                  icon: Icons.lock_outline,
                                  isDarkMode: isDarkMode,
                                  obscure: _obscureNova,
                                  suffix: IconButton(
                                    icon: Icon(
                                        _obscureNova
                                            ? Icons.visibility_off
                                            : Icons.visibility,
                                        size: 20),
                                    onPressed: () => setState(
                                        () => _obscureNova = !_obscureNova),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                _buildField(
                                  controller: _confirmarSenhaController,
                                  label: 'Confirmar nova senha',
                                  icon: Icons.lock_reset_outlined,
                                  isDarkMode: isDarkMode,
                                  obscure: _obscureConfirmar,
                                  suffix: IconButton(
                                    icon: Icon(
                                        _obscureConfirmar
                                            ? Icons.visibility_off
                                            : Icons.visibility,
                                        size: 20),
                                    onPressed: () => setState(() =>
                                        _obscureConfirmar = !_obscureConfirmar),
                                  ),
                                ),
                                const SizedBox(height: 28),
                                SizedBox(
                                  width: double.infinity,
                                  height: 58,
                                  child: ElevatedButton(
                                    onPressed:
                                        _isLoading ? null : _redefinirSenha,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF4CAF50),
                                      foregroundColor: Colors.white,
                                      elevation: 8,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                    ),
                                    child: _isLoading
                                        ? const CircularProgressIndicator(
                                            color: Colors.white)
                                        : const Text('REDEFINIR SENHA',
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold)),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],
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

  Widget _buildField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required bool isDarkMode,
    bool obscure = false,
    Widget? suffix,
    TextInputType tipo = TextInputType.text,
  }) {
    final textColor = isDarkMode ? Colors.white : Colors.black87;
    return TextField(
      controller: controller,
      obscureText: obscure,
      keyboardType: tipo,
      style: TextStyle(color: textColor),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: textColor.withOpacity(0.6), fontSize: 14),
        prefixIcon: Icon(icon, color: const Color(0xFF4CAF50), size: 22),
        suffixIcon: suffix,
        filled: true,
        fillColor: isDarkMode
            ? Colors.white.withOpacity(0.05)
            : const Color(0xFFF1F4F8),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: Color(0xFF4CAF50), width: 2),
        ),
      ),
    );
  }
}
