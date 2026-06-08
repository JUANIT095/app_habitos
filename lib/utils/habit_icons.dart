import 'package:flutter/material.dart';

/// Clase utilitaria que contiene los íconos disponibles para los hábitos
/// Organizada por categorías para facilitar la selección
class HabitIcons {
  // Constructor privado para prevenir instanciación
  HabitIcons._();

  /// Lista completa de íconos disponibles para los hábitos
  static const List<IconData> availableIcons = [
    // Salud y Bienestar
    Icons.self_improvement, // Meditación
    Icons.fitness_center, // Ejercicio
    Icons.directions_run, // Correr
    Icons.pool, // Natación
    Icons.sports_martial_arts, // Artes marciales
    Icons.sports_baseball, // Yoga
    Icons.bedtime, // Dormir
    // Alimentación
    Icons.restaurant, // Comer saludable
    Icons.water_drop, // Beber agua
    Icons.local_cafe, // Café/té
    Icons.eco, // Vegetales
    // Aprendizaje
    Icons.menu_book, // Leer
    Icons.school, // Estudiar
    Icons.language, // Idiomas
    Icons.science, // Ciencia
    // Creatividad
    Icons.palette, // Arte
    Icons.music_note, // Música
    Icons.brush, // Pintar
    Icons.camera_alt, // Fotografía
    Icons.edit, // Escribir
    // Productividad
    Icons.work, // Trabajo
    Icons.checklist, // Tareas
    Icons.timer, // Pomodoro
    Icons.laptop, // Programar
    // Social
    Icons.people, // Socializar
    Icons.family_restroom, // Familia
    Icons.favorite, // Amor
    Icons.phone, // Llamar
    // Finanzas
    Icons.savings, // Ahorrar
    Icons.attach_money, // Dinero
    Icons.trending_up, // Inversión
    // Hogar
    Icons.cleaning_services, // Limpieza
    Icons.kitchen, // Cocinar
    Icons.grass, // Jardinería
    // Otros
    Icons.pets, // Mascotas
    Icons.star, // Favorito
    Icons.wb_sunny, // Despertar temprano
    Icons.nightlight, // Rutina nocturna
  ];

  /// Obtiene un ícono aleatorio de la lista
  static IconData getRandomIcon() {
    final random = DateTime.now().millisecond % availableIcons.length;
    return availableIcons[random];
  }

  /// Categorías de íconos para organización avanzada (uso futuro)
  static const Map<String, List<IconData>> categories = {
    'Salud': [
      Icons.self_improvement,
      Icons.fitness_center,
      Icons.directions_run,
      Icons.pool,
      Icons.sports_martial_arts,
      Icons.sports_bar,
      Icons.bedtime,
    ],
    'Alimentación': [
      Icons.restaurant,
      Icons.water_drop,
      Icons.local_cafe,
      Icons.eco,
    ],
    'Aprendizaje': [
      Icons.menu_book,
      Icons.school,
      Icons.language,
      Icons.science,
    ],
    'Creatividad': [
      Icons.palette,
      Icons.music_note,
      Icons.brush,
      Icons.camera_alt,
      Icons.edit,
    ],
    'Productividad': [Icons.work, Icons.checklist, Icons.timer, Icons.laptop],
  };
}
