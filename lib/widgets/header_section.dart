import 'package:flutter/material.dart';

/// Widget del header con saludo personalizado y avatar decorativo
/// Muestra un mensaje de bienvenida y la foto de perfil del usuario
class HeaderSection extends StatelessWidget {
  // Controlador de animación recibido desde el padre (HomePage)
  final AnimationController fadeController;

  // Constructor que requiere obligatoriamente el fadeController
  const HeaderSection({Key? key, required this.fadeController})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    // FadeTransition anima la opacidad del header completo
    return FadeTransition(
      opacity: fadeController, // Usa el controlador para animar
      // Row organiza los elementos horizontalmente
      child: Row(
        // spaceBetween empuja los elementos a los extremos
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // ========== SECCIÓN IZQUIERDA: SALUDO ==========
          Column(
            crossAxisAlignment:
                CrossAxisAlignment.start, // Alinea a la izquierda
            children: [
              // Saludo principal grande y prominente
              const Text(
                '¡Hola, Usuario!',
                style: TextStyle(
                  fontSize: 28, // Texto grande
                  fontWeight: FontWeight.bold, // Negritas
                  color: Colors.white, // Blanco
                ),
              ),

              // Espacio de 4 píxeles entre saludo y subtítulo
              const SizedBox(height: 4),

              // Subtítulo motivacional más discreto
              Text(
                'Construye tu mejor versión',
                style: TextStyle(
                  fontSize: 14, // Texto pequeño
                  // Blanco con 60% opacidad = gris tenue (jerarquía visual)
                  color: Colors.white.withOpacity(0.6),
                ),
              ),
            ],
          ),

          // ========== SECCIÓN DERECHA: AVATAR ==========
          // Container exterior con gradiente circular
          Container(
            decoration: const BoxDecoration(
              // Gradiente de morado a turquesa
              gradient: LinearGradient(
                colors: [
                  Color(0xFF6C63FF), // Morado (inicio)
                  Color(0xFF4ECDC4), // Turquesa (fin)
                ],
                // Por defecto va de izquierda a derecha
              ),
              shape: BoxShape.circle, // Hace el Container circular
            ),
            // Avatar circular con ícono de persona
            child: const CircleAvatar(
              radius: 25, // Radio de 25px = Diámetro de 50px
              backgroundColor:
                  Colors.transparent, // Transparente para ver el gradiente
              child: Icon(
                Icons.person, // Ícono de silueta de persona
                color: Colors.white, // Blanco para contrastar con el gradiente
                size: 28, // Tamaño del ícono
              ),
            ),
          ),
        ],
      ),
    );
  }
}
