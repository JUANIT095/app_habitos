import 'package:flutter/material.dart';

/// Clase utilitaria que contiene los colores disponibles para los hábitos
/// Paleta de colores vibrantes y profesionales
class HabitColors {
  // Constructor privado para prevenir instanciación
  HabitColors._();

  /// Lista de colores disponibles para personalizar hábitos
  static const List<Color> availableColors = [
    // Morados
    Color(0xFF6C63FF), // Morado principal
    Color(0xFF9D4EDD), // Morado medio
    Color(0xFF7209B7), // Morado oscuro
    // Rosas y Rojos
    Color(0xFFFF6584), // Rosa vibrante
    Color(0xFFE63946), // Rojo coral
    Color(0xFFF72585), // Magenta
    // Azules y Cianos
    Color(0xFF4ECDC4), // Cian
    Color(0xFF45B7D1), // Azul cielo
    Color(0xFF4361EE), // Azul eléctrico
    Color(0xFF0077B6), // Azul océano
    // Verdes
    Color(0xFF06FFA5), // Verde neón
    Color(0xFF4CAF50), // Verde material
    Color(0xFF00B894), // Verde esmeralda
    Color(0xFF2EC4B6), // Verde azulado
    // Naranjas y Amarillos
    Color(0xFFFFA726), // Naranja
    Color(0xFFFF9F1C), // Naranja dorado
    Color(0xFFF77F00), // Naranja quemado
    Color(0xFFFFBE0B), // Amarillo vibrante
    // Tonos especiales
    Color(0xFFE0AAFF), // Lavanda
    Color(0xFFFF99C8), // Rosa pastel
    Color(0xFF90E0EF), // Azul claro
    Color(0xFFA8DADC), // Gris azulado
  ];

  /// Obtiene un color aleatorio de la lista
  static Color getRandomColor() {
    final random = DateTime.now().millisecond % availableColors.length;
    return availableColors[random];
  }

  /// Colores organizados por temperatura (uso futuro para filtros)
  static const List<Color> warmColors = [
    Color(0xFFFF6584),
    Color(0xFFE63946),
    Color(0xFFF72585),
    Color(0xFFFFA726),
    Color(0xFFFF9F1C),
    Color(0xFFF77F00),
    Color(0xFFFFBE0B),
  ];

  static const List<Color> coolColors = [
    Color(0xFF6C63FF),
    Color(0xFF4ECDC4),
    Color(0xFF45B7D1),
    Color(0xFF4361EE),
    Color(0xFF0077B6),
    Color(0xFF06FFA5),
    Color(0xFF4CAF50),
    Color(0xFF00B894),
  ];

  /// Verifica si un color es claro u oscuro
  /// Útil para determinar el color de texto sobre el fondo
  static bool isLightColor(Color color) {
    final luminance = color.computeLuminance();
    return luminance > 0.5;
  }

  /// Obtiene el color de texto apropiado (blanco o negro)
  /// según el color de fondo
  static Color getContrastColor(Color backgroundColor) {
    return isLightColor(backgroundColor) ? Colors.black : Colors.white;
  }
}
