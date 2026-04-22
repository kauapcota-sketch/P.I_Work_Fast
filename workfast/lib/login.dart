import 'package:flutter/material.dart';
import 'package:workfast/auth_service.dart';
import 'package:workfast/esqueci_senha_page.dart';

class LoginPage extends StatefulWidget {
  final String? initialUsername;
  final String? initialPassword;

  const LoginPage({
    super.key,
    this.initialUsername,
    this.initialPassword,
  });

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoading = false;
  bool _obscureText = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    if (widget.initialUsername != null)
      _emailController.text = widget.initialUsername!;
    if (widget.initialPassword != null)
      _passwordController.text = widget.initialPassword!;
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    setState(() => _errorMessage = null);

    if (email.isEmpty || password.isEmpty) {
      setState(() => _errorMessage = 'Por favor, preencha todos os campos');
      return;
    }

    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 800));

    final loginValido = AuthService.verificarLogin(email, password);
    setState(() => _isLoading = false);

    if (loginValido) {
      if (mounted) Navigator.pushReplacementNamed(context, '/home');
    } else {
      setState(() => _errorMessage = 'E-mail ou senha incorretos');
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
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo
                  Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          shape: BoxShape.circle,
                          border: Border.all(
                              color: Colors.white.withOpacity(0.2), width: 2),
                        ),
                        child: const Icon(Icons.bolt_rounded,
                            size: 70, color: Color(0xFF4CAF50)),
                      ),
                      const SizedBox(height: 15),
                      const Text('WorkFast',
                          style: TextStyle(
                              fontSize: 42,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                              letterSpacing: 1.5,
                              shadows: [
                                Shadow(
                                    color: Colors.black26,
                                    offset: Offset(0, 4),
                                    blurRadius: 10)
                              ])),
                      Text('Serviços Rápidos e Confiáveis',
                          style: TextStyle(
                              fontSize: 14,
                              color: Colors.white.withOpacity(0.8),
                              letterSpacing: 1.2)),
                    ],
                  ),
                  const SizedBox(height: 50),

                  // Card de login
                  Container(
                    padding: const EdgeInsets.all(28),
                    decoration: BoxDecoration(
                      color:
                          isDarkMode ? const Color(0xFF2C3E50) : Colors.white,
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
                        Text('LOGIN',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: isDarkMode
                                  ? Colors.white
                                  : const Color(0xFF27485F),
                            )),
                        const SizedBox(height: 25),

                        if (_errorMessage != null)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 15),
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.red.shade50,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.red.shade200),
                              ),
                              child: Row(
                                children: [
                                  Icon(Icons.error_outline,
                                      color: Colors.red.shade600, size: 20),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(_errorMessage!,
                                        style: TextStyle(
                                            color: Colors.red.shade700,
                                            fontSize: 14)),
                                  ),
                                ],
                              ),
                            ),
                          ),

                        _buildField(
                          controller: _emailController,
                          label: 'E-mail',
                          icon: Icons.email_outlined,
                          isDarkMode: isDarkMode,
                          tipo: TextInputType.emailAddress,
                        ),
                        const SizedBox(height: 20),
                        _buildField(
                          controller: _passwordController,
                          label: 'Senha',
                          icon: Icons.lock_outline,
                          isDarkMode: isDarkMode,
                          obscure: _obscureText,
                          suffix: IconButton(
                            icon: Icon(
                                _obscureText
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                size: 20),
                            onPressed: () =>
                                setState(() => _obscureText = !_obscureText),
                          ),
                        ),
                        const SizedBox(height: 6),

                        // ── ESQUECI A SENHA ──────────────────────
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const EsqueciSenhaPage(),
                                ),
                              );
                            },
                            child: const Text(
                              'Esqueceu a senha?',
                              style: TextStyle(
                                color: Color(0xFF4CAF50),
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 10),
                        SizedBox(
                          width: double.infinity,
                          height: 60,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _handleLogin,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF4CAF50),
                              foregroundColor: Colors.white,
                              elevation: 8,
                              shadowColor:
                                  const Color(0xFF4CAF50).withOpacity(0.5),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                            ),
                            child: _isLoading
                                ? const CircularProgressIndicator(
                                    color: Colors.white)
                                : const Text('ENTRAR',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 1)),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Não tem uma conta?',
                          style: TextStyle(color: Colors.white70)),
                      TextButton(
                        onPressed: () =>
                            Navigator.pushNamed(context, '/cadastro'),
                        child: const Text('Cadastre-se',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
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
