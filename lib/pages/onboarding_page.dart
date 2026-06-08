import 'package:app_habitos/pages/HomePage.dart';
import 'package:app_habitos/pages/login_page.dart';
import 'package:app_habitos/pages/register_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Página de bienvenida que se muestra al abrir la app por primera vez
class OnboardingPage extends StatefulWidget {
  const OnboardingPage({Key? key}) : super(key: key);

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage>
    with SingleTickerProviderStateMixin {
  // Controlador de animación para efectos de entrada
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  /// Inicializa las animaciones de entrada
  void _initializeAnimations() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    // Animación de desvanecimiento
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
      ),
    );

    // Animación de deslizamiento de botones
    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: const Interval(0.4, 1.0, curve: Curves.easeOut),
          ),
        );

    // Inicia las animaciones
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  /// Navega a la página de registro
  void _navigateToRegister() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const RegisterPage()),
    );
  }

  /// Navega a la página de inicio de sesión
  void _navigateToLogin() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
    );
  }

  /// Navega directamente al HomePage (para desarrollo/pruebas)
  void _skipToHome() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const HomePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Gradiente de fondo similar a la imagen
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF1A1A2E),
              Color(0xFF16213E),
              Color(0xFF52B788),
              Color.fromARGB(255, 255, 255, 28),
              Color.fromARGB(255, 255, 101, 132),
            ],
            stops: [0.0, 0.38, 0.57, 0.66, 0.88],
          ),
        ),
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Column(
              children: [
                // Header con frase motivacional
                _buildHeader(),

                // Espacio flexible
                const Spacer(flex: 2),

                // Logo/Ícono de la app
                _buildLogo(),

                const SizedBox(height: 40),

                // Título "Bienvenido a CONSTY"
                _buildTitle(),

                // Espacio flexible
                const Spacer(flex: 3),

                // Botones de acción
                SlideTransition(
                  position: _slideAnimation,
                  child: _buildActionButtons(),
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Construye el header con la frase motivacional
  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.only(top: 40),
      child: Text(
        'Pequeños pasos, grandes cambios',
        style: TextStyle(
          fontFamily: 'MuseoModerno',
          fontSize: 20,
          color: Colors.white.withOpacity(0.7),
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  /// Construye el logo/ícono de la app
  Widget _buildLogo() {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: 1),
      duration: const Duration(milliseconds: 2000),
      curve: Curves.elasticOut,
      builder: (context, double value, child) {
        return Transform.scale(scale: value, child: child);
      },
      child: Container(
        width: 120,
        height: 120,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Center(
          child: SvgPicture.asset(
            'assets/images/LogoConsty.svg',
            width: 100,
            height: 100,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }

  /// Construye una barra individual del logo

  /// Construye el título principal
  Widget _buildTitle() {
    return Column(
      children: [
        Text(
          'Bienvenido a..',
          style: TextStyle(
            fontSize: 20,
            color: Colors.white.withOpacity(0.8),
            fontWeight: FontWeight.w300,
            letterSpacing: 1.5,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'CONSTY',
          style: TextStyle(
            fontSize: 60,
            color: Colors.white,
            fontWeight: FontWeight.bold,
            letterSpacing: 8,
            fontFamily: 'TanMeringue',
          ),
        ),
      ],
    );
  }

  /// Construye los botones de acción
  Widget _buildActionButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        children: [
          // Botón "Registrarse"
          _buildButton(
            text: 'Registrarse',
            icon: Icons.person_add,
            onPressed: _navigateToRegister,
            isPrimary: true,
          ),
          const SizedBox(height: 36),

          // Botón "Iniciar sesión"
          _buildButton(
            text: 'Iniciar sesión',
            icon: Icons.login,
            onPressed: _navigateToLogin,
            isPrimary: false,
          ),
          const SizedBox(height: 34),

          // Texto "Saltar" (para desarrollo)
          TextButton(
            onPressed: _skipToHome,
            child: Text(
              'Saltar por ahora →',
              style: TextStyle(
                color: Colors.white.withOpacity(0.6),
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Construye un botón con estilo personalizado
  Widget _buildButton({
    required String text,
    required IconData icon,
    required VoidCallback onPressed,
    required bool isPrimary,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 22),
        label: Text(
          text,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: isPrimary
              ? const Color(0xFF0F172A) // Botón oscuro
              : Colors.white.withOpacity(0.9), // Botón claro
          foregroundColor: isPrimary ? Colors.white : const Color(0xFF0F172A),
          elevation: isPrimary ? 0 : 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
          shadowColor: Colors.black.withOpacity(0.3),
        ),
      ),
    );
  }
}
