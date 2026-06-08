import 'package:flutter/material.dart';

/// Modelo que representa un hábito
class HabitModel {
  String name;
  IconData icon;
  bool completed;
  int streak;
  Color color;

  HabitModel({
    required this.name,
    required this.icon,
    required this.completed,
    required this.streak,
    required this.color,
  });
}
