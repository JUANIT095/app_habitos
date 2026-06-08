import 'package:app_habitos/pages/HomePage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Página de inicio de sesión.
/// Muestra el logo, los campos (email y contraseña), el enlace de
/// "olvidaste tu contraseña" y los botones de redes sociales.
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // ========== CONTROLADORES DE LOS CAMPOS ==========
  // Cada controlador "lee" el texto que el usuario escribe en su campo.
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Llave del formulario: nos permite validar todos los campos a la vez.
  final _formKey = GlobalKey<FormState>();

  // Limpia los controladores cuando la pantalla se destruye (evita fugas de memoria).
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  /// Valida el formulario y, si todo está bien, entra a la app.
  void _login() {
    if (_formKey.currentState?.validate() ?? false) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomePage()),
      );
    }
  }

  /// Acción temporal para "¿olvidaste tu contraseña?".
  void _forgotPassword() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Recuperación de contraseña próximamente'),
        backgroundColor: Color(0xFF6C63FF),
      ),
    );
  }

  /// Acción temporal para los botones de redes sociales.
  void _socialLogin(String red) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Inicio de sesión con $red próximamente'),
        backgroundColor: const Color(0xFF6C63FF),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // Fondo con degradado multicolor (oscuro arriba → verde abajo)
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF1A1A2E), // Azul muy oscuro (arriba)
              Color(0xFF2A1B3D), // Morado oscuro
              Color(0xFFFF6584), // Rosa/coral (medio)
              Color(0xFFFFA726), // Naranja
              Color(0xFF52B788), // Verde (abajo)
            ],
            stops: [0.0, 0.2, 0.45, 0.68, 1.0],
          ),
        ),
        child: SafeArea(
          // Permite hacer scroll para que el teclado no "rompa" la pantalla.
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const SizedBox(height: 24),

                  // Frase motivacional superior
                  Text(
                    'De vuelta al camino del progreso.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'MuseoModerno',
                      fontSize: 18,
                      color: Colors.white.withValues(alpha: 0.7),
                      letterSpacing: 0.5,
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Logo de la app (SVG)
                  SvgPicture.asset(
                    'assets/images/LogoConsty.svg',
                    width: 90,
                    height: 90,
                    fit: BoxFit.contain,
                  ),

                  const SizedBox(height: 8),

                  // Título "CONSTY"
                  const Text(
                    'CONSTY',
                    style: TextStyle(
                      fontSize: 45,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 6,
                      fontFamily: 'TanMeringue',
                    ),
                  ),

                  const SizedBox(height: 28),

                  // ========== CAMPOS DEL FORMULARIO ==========
                  _buildTextField(
                    controller: _emailController,
                    hint: 'Email',
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Ingresa tu email';
                      }
                      // Validación simple: que contenga "@" y "."
                      if (!value.contains('@') || !value.contains('.')) {
                        return 'Email no válido';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  _buildTextField(
                    controller: _passwordController,
                    hint: 'Contraseña',
                    obscure: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Ingresa tu contraseña';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 8),

                  // Enlace "¿olvidaste tu contraseña?" alineado a la derecha
                  Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: _forgotPassword,
                      child: Text(
                        '¿olvidaste tu contraseña?',
                        style: TextStyle(
                          fontFamily: 'MuseoModerno',
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Colors.white.withValues(alpha: 0.9),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ========== BOTÓN PRINCIPAL ==========
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _login,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0F172A), // Oscuro
                        foregroundColor: Colors.white,
                        elevation: 6,
                        shadowColor: Colors.black.withValues(alpha: 0.4),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text(
                        'Esto comienza ahora...',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Texto "continua con.."
                  Text(
                    'continua con..',
                    style: TextStyle(
                      fontFamily: 'MuseoModerno',
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.white.withValues(alpha: 0.85),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // ========== BOTONES DE REDES SOCIALES ==========
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildSocialButton(
                        asset: 'assets/images/facebook.svg',
                        red: 'Facebook',
                      ),
                      const SizedBox(width: 20),
                      _buildSocialButton(
                        asset: 'assets/images/google.svg',
                        red: 'Google',
                      ),
                      const SizedBox(width: 20),
                      _buildSocialButton(
                        asset: 'assets/images/apple.svg',
                        red: 'Apple',
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Construye un campo de texto con estilo de "píldora" clara.
  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    bool obscure = false,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      keyboardType: keyboardType,
      style: const TextStyle(color: Color(0xFF1A1A2E), fontSize: 16),
      validator: validator,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(
          color: const Color(0xFF1A1A2E).withValues(alpha: 0.5),
          fontSize: 15,
        ),
        filled: true,
        fillColor: Colors.white.withValues(alpha: 0.92),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 18,
        ),
        // Borde sin línea (solo la forma redondeada)
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: Color(0xFF6C63FF), width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
      ),
    );
  }

  /// Construye un botón blanco con el ícono SVG de una red social.
  Widget _buildSocialButton({required String asset, required String red}) {
    return GestureDetector(
      onTap: () => _socialLogin(red),
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: SvgPicture.asset(asset, fit: BoxFit.contain),
        ),
      ),
    );
  }
}
