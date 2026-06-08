import 'package:app_habitos/models/confeti_particle.dart';
import 'package:flutter/material.dart';

/// Overlay que muestra la animación de celebración
/// cuando se completan todos los hábitos
class CelebrationOverlay extends StatelessWidget {
  final AnimationController controller;

  const CelebrationOverlay({Key? key, required this.controller})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Fondo semi-transparente
        AnimatedBuilder(
          animation: controller,
          builder: (context, child) {
            return Container(
              color: Colors.black.withOpacity(0.3 * controller.value),
            );
          },
        ),

        // Mensaje de felicitación
        Center(
          child: ScaleTransition(
            scale: CurvedAnimation(
              parent: controller,
              curve: Curves.elasticOut,
            ),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 40),
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF6C63FF), Color(0xFF4ECDC4)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF6C63FF).withOpacity(0.5),
                    blurRadius: 30,
                    offset: const Offset(0, 15),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.celebration, size: 80, color: Colors.white),
                  const SizedBox(height: 16),
                  const Text(
                    '¡Felicidades!',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '¡Has completado todos\ntus hábitos de hoy!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        // Partículas de confeti
        ...List.generate(20, (index) {
          final random = index * 0.1;
          return ConfettiParticle(
            controller: controller,
            delay: random,
            index: index,
          );
        }),
      ],
    );
  }
}
