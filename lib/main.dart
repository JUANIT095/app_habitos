// Importa la pantalla principal desde el archivo HomePage.dart
import 'package:app_habitos/pages/onboarding_page.dart';
// Importa el paquete de Flutter con widgets de Material Design
import 'package:flutter/material.dart';

// Función principal - punto de entrada de la aplicación
void main() {
  // Inicializa y ejecuta la aplicación con HabitTrackerApp como widget raíz
  runApp(HabitTrackerApp());
}

// Widget principal de la aplicación (sin estado, inmutable)
class HabitTrackerApp extends StatelessWidget {
  // Constructor constante con key opcional para optimización
  const HabitTrackerApp({super.key});

  // Método que construye la interfaz del widget
  @override
  Widget build(BuildContext context) {
    // Retorna MaterialApp - configura toda la app con Material Design
    return MaterialApp(
      // Oculta el banner "DEBUG" en desarrollo
      debugShowCheckedModeBanner: false,
      // Define el tema visual de toda la aplicación
      theme: ThemeData(
        // Fuente tipográfica predeterminada
        fontFamily: 'MuseoModerno',
        // Activa el modo oscuro
        brightness: Brightness.dark,
        // Color de fondo azul oscuro para todas las pantallas
        scaffoldBackgroundColor: const Color(0xFF0A0E21),
      ),
      // Establece HomePage como la pantalla inicial
      home: OnboardingPage(),
    );
  }
}
