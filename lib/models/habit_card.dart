import 'package:flutter/material.dart';
import '../models/habit_model.dart';

/// Tarjeta individual que representa un hábito
/// Muestra ícono, nombre, racha y checkbox interactivo
class HabitCard extends StatelessWidget {
  // Objeto con toda la información del hábito
  final HabitModel habit;

  // Función callback que se ejecuta al tocar la tarjeta
  final VoidCallback onTap;

  // Constructor que requiere el hábito y la función
  const HabitCard({Key? key, required this.habit, required this.onTap})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Contenedor principal de la tarjeta
    return Container(
      // Margen solo en la parte inferior (separa tarjetas)
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        // Fondo azul oscuro
        color: const Color(0xFF1D1E33),

        // Bordes muy redondeados
        borderRadius: BorderRadius.circular(20),

        // Borde condicional: visible solo si está completado
        border: Border.all(
          color: habit.completed
              ? habit.color.withOpacity(0.5) // Borde del color del hábito
              : Colors.transparent, // Sin borde
          width: 2,
        ),

        // Sombra condicional: solo si está completado
        boxShadow: habit.completed
            ? [
                BoxShadow(
                  color: habit.color.withOpacity(
                    0.3,
                  ), // Sombra del color del hábito
                  blurRadius: 12, // Difuminado suave
                  offset: const Offset(0, 4), // Desplazada 4px abajo
                ),
              ]
            : [], // Sin sombra si no está completado
      ),
      // Material para el efecto ripple
      child: Material(
        color: Colors.transparent, // Transparente para ver el Container
        // InkWell proporciona el efecto de onda al tocar
        child: InkWell(
          onTap: onTap, // Ejecuta la función al tocar
          borderRadius: BorderRadius.circular(20), // Ripple respeta bordes
          // Padding interno
          child: Padding(
            padding: const EdgeInsets.all(20),
            // Row organiza elementos horizontalmente
            child: Row(
              children: [
                // ========== ÍCONO DEL HÁBITO ==========
                Container(
                  padding: const EdgeInsets.all(
                    12,
                  ), // Espacio alrededor del ícono
                  decoration: BoxDecoration(
                    // Fondo translúcido del color del hábito
                    color: habit.color.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  // Ícono con color sólido del hábito
                  child: Icon(habit.icon, color: habit.color, size: 28),
                ),

                // Espacio entre ícono y texto
                const SizedBox(width: 16),

                // ========== INFORMACIÓN DEL HÁBITO ==========
                // Expanded ocupa todo el espacio disponible
                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start, // Alinea a la izquierda
                    children: [
                      // Nombre del hábito
                      Text(
                        habit.name,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600, // Semi-negrita
                          color: Colors.white,
                          // Tachado condicional: solo si está completado
                          decoration: habit.completed
                              ? TextDecoration
                                    .lineThrough // ~~tachado~~
                              : null, // Sin decoración
                          decorationColor: habit.color, // Color del tachado
                          decorationThickness: 2, // Línea gruesa
                        ),
                      ),

                      // Pequeño espacio
                      const SizedBox(height: 4),

                      // Racha de días con ícono de fuego
                      Row(
                        children: [
                          // Ícono de fuego 🔥
                          const Icon(
                            Icons.local_fire_department,
                            color: Color(0xFFFF6584), // Rosa/rojo
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          // Texto con número de días
                          Text(
                            '${habit.streak} días',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.white.withOpacity(
                                0.6,
                              ), // Gris tenue
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // ========== CHECKBOX ANIMADO ==========
                // AnimatedContainer anima automáticamente los cambios
                AnimatedContainer(
                  duration: const Duration(
                    milliseconds: 300,
                  ), // 300ms de transición
                  curve: Curves
                      .easeInOut, // Curva suave de aceleración/desaceleración
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    // Color de fondo condicional
                    color: habit.completed
                        ? habit
                              .color // Relleno con color si está completado
                        : Colors.transparent, // Vacío si no está completado
                    shape: BoxShape.circle, // Forma circular
                    // Borde condicional
                    border: Border.all(
                      color: habit.completed
                          ? habit
                                .color // Borde del color si completado
                          : Colors.white.withOpacity(
                              0.3,
                            ), // Borde gris si no completado
                      width: 2,
                    ),
                  ),
                  // Ícono check condicional
                  child: habit.completed
                      ? const Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 18,
                        ) // ✓
                      : null, // Sin ícono si no está completado
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
