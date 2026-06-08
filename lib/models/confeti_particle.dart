import 'package:flutter/material.dart';

/// Partícula individual de confeti para la animación de celebración
/// Crea pequeños círculos y cuadrados de colores que caen desde arriba
class ConfettiParticle extends StatelessWidget {
  // Controlador de animación compartido (viene del padre)
  final AnimationController controller;

  // Retraso antes de que esta partícula empiece a caer
  // Valores típicos: 0.0, 0.05, 0.1, 0.15, etc.
  final double delay;

  // Índice único de la partícula (0, 1, 2, 3...)
  // Determina: posición, color, forma, dirección de movimiento
  final int index;

  // Constructor que requiere todos los parámetros
  const ConfettiParticle({
    Key? key,
    required this.controller,
    required this.delay,
    required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Paleta de 5 colores vibrantes para el confeti
    const colors = [
      Color(0xFF6C63FF), // Morado
      Color(0xFFFF6584), // Rosa
      Color(0xFF4ECDC4), // Turquesa
      Color(0xFF45B7D1), // Azul claro
      Color(0xFFFFA726), // Naranja
    ];

    // Obtiene el ancho de la pantalla
    final screenWidth = MediaQuery.of(context).size.width;

    // Calcula la posición horizontal inicial
    // Distribuye las partículas en 4 columnas equidistantes
    // Ejemplo con 375px:
    // index 0 → 46.875px (columna 1)
    // index 1 → 140.625px (columna 2)
    // index 2 → 234.375px (columna 3)
    // index 3 → 328.125px (columna 4)
    // index 4 → 46.875px (vuelve a columna 1)
    final startX = (index % 4) * (screenWidth / 4) + (screenWidth / 8);

    // AnimatedBuilder se reconstruye en cada frame de la animación
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        // Calcula el progreso individual con delay
        // Si delay = 0.2 y controller = 0.1, entonces progress = 0.0 (aún no empieza)
        // Si delay = 0.2 y controller = 0.5, entonces progress = 0.3 (30% de progreso)
        final progress = (controller.value - delay).clamp(0.0, 1.0);

        // Aplica curva de aceleración (comienza lento, acelera como gravedad)
        final fallProgress = Curves.easeIn.transform(progress);

        // Rotación: gira 4 vueltas completas durante la caída
        final rotationProgress = progress * 4;

        // Posiciona la partícula absolutamente
        return Positioned(
          // Posición horizontal con movimiento lateral
          // Partículas pares: se mueven 50px a la derecha
          // Partículas impares: se mueven 50px a la izquierda
          left: startX + (index.isEven ? 50 : -50) * progress,

          // Posición vertical: cae desde arriba (-50) hasta abajo de la pantalla
          // -50: empieza fuera de vista arriba
          // +100: termina fuera de vista abajo
          top: -50 + (MediaQuery.of(context).size.height + 100) * fallProgress,

          // Aplica rotación durante la caída
          child: Transform.rotate(
            angle:
                rotationProgress * 3.14159, // Rotación en radianes (4 vueltas)
            // Desvanece gradualmente mientras cae
            child: Opacity(
              opacity: 1 - fallProgress, // De 1.0 (visible) a 0.0 (invisible)
              // Contenedor de la partícula
              child: Container(
                width: 12, // Ancho pequeño
                height: 12, // Alto pequeño
                decoration: BoxDecoration(
                  // Color basado en el índice (cicla entre 5 colores)
                  color: colors[index % colors.length],

                  // Forma condicional:
                  // Múltiplos de 3 (0, 3, 6...) → Círculos ⭕
                  // Otros (1, 2, 4, 5...) → Cuadrados ⬜
                  shape: index % 3 == 0 ? BoxShape.circle : BoxShape.rectangle,

                  // Bordes ligeramente redondeados solo para cuadrados
                  borderRadius: index % 3 != 0
                      ? BorderRadius.circular(2)
                      : null, // null para círculos (no lo necesitan)
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
