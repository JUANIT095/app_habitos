import 'package:flutter/material.dart';

/// Tarjeta que muestra el progreso diario del usuario
/// Incluye porcentaje, barra de progreso visual y contador de hábitos
class ProgressCard extends StatelessWidget {
  // Controlador de animación para el efecto de deslizamiento
  final AnimationController slideController;

  // Progreso como decimal (0.0 = 0%, 1.0 = 100%)
  final double progress;

  // Número de hábitos completados
  final int completedCount;

  // Número total de hábitos
  final int totalCount;

  // Constructor que requiere todos los parámetros
  const ProgressCard({
    Key? key,
    required this.slideController,
    required this.progress,
    required this.completedCount,
    required this.totalCount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // SlideTransition anima la posición de la tarjeta
    return SlideTransition(
      // Tween define el movimiento: desde 30% abajo hasta posición original
      position: Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero)
          .animate(
            // CurvedAnimation aplica curva de desaceleración suave
            CurvedAnimation(parent: slideController, curve: Curves.easeOut),
          ),
      // Contenedor principal de la tarjeta
      child: Container(
        padding: const EdgeInsets.all(24), // Espacio interno de 24px
        decoration: BoxDecoration(
          // Gradiente diagonal de morado claro a morado oscuro
          gradient: const LinearGradient(
            colors: [
              Color(0xFF6C63FF), // Morado claro (arriba-izquierda)
              Color(0xFF5A52D5), // Morado oscuro (abajo-derecha)
            ],
            begin: Alignment.topLeft, // Comienza arriba-izquierda
            end: Alignment.bottomRight, // Termina abajo-derecha
          ),
          // Bordes muy redondeados
          borderRadius: BorderRadius.circular(24),
          // Sombra pronunciada que hace que la tarjeta "flote"
          boxShadow: [
            BoxShadow(
              color: const Color(
                0xFF6C63FF,
              ).withOpacity(0.4), // Sombra morada translúcida
              blurRadius: 20, // Difuminado suave
              offset: const Offset(0, 10), // Desplazada 10px hacia abajo
            ),
          ],
        ),
        // Contenido organizado verticalmente
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // Alinea a la izquierda
          children: [
            // ========== FILA SUPERIOR: TÍTULO Y PORCENTAJE ==========
            Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceBetween, // Separa máximamente
              children: [
                // Título de la sección
                const Text(
                  'Progreso de Hoy',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                // Badge con el porcentaje
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12, // 12px izquierda/derecha
                    vertical: 6, // 6px arriba/abajo
                  ),
                  decoration: BoxDecoration(
                    // Fondo blanco semi-transparente (efecto glassmorphism)
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20), // Forma de píldora
                  ),
                  child: Text(
                    // Convierte progress (0.0-1.0) a porcentaje entero (0-100)
                    '${(progress * 100).toInt()}%',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

            // Espacio antes de la barra de progreso
            const SizedBox(height: 20),

            // ========== BARRA DE PROGRESO ==========
            // ClipRRect recorta los bordes para que sean redondeados
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              // Barra de progreso lineal
              child: LinearProgressIndicator(
                value: progress, // Valor actual (0.0 a 1.0)
                minHeight: 12, // Altura de la barra
                // Fondo de la barra (parte vacía)
                backgroundColor: Colors.white.withOpacity(0.2),
                // Color de la parte llena (siempre blanco, sin animación de color)
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),

            // Espacio antes del texto informativo
            const SizedBox(height: 16),

            // ========== TEXTO INFORMATIVO ==========
            // Muestra "X de Y hábitos completados"
            Text(
              '$completedCount de $totalCount hábitos completados',
              style: TextStyle(
                fontSize: 14,
                color: Colors.white.withOpacity(0.9), // Casi opaco (90%)
              ),
            ),
          ],
        ),
      ),
    );
  }
}
