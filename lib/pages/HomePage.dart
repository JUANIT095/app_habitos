// Importa los widgets y modelos personalizados necesarios
import 'package:app_habitos/models/celebration_overlay.dart';
import 'package:app_habitos/models/habit_card.dart';
import 'package:app_habitos/models/progress_card.dart';
import 'package:flutter/material.dart';
import '../widgets/header_section.dart';
import '../models/habit_model.dart';
import 'add_habit_page.dart';

// HomePage es un StatefulWidget porque su contenido cambia dinámicamente
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

// Estado privado de HomePage con soporte para múltiples animaciones
class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  // Controladores para diferentes animaciones en la pantalla
  late AnimationController
  _fadeController; // Controla el efecto de desvanecimiento
  late AnimationController
  _slideController; // Controla el deslizamiento de elementos
  late AnimationController
  _celebrationController; // Controla la animación de celebración

  // Bandera para mostrar/ocultar la animación de celebración
  bool _showCelebration = false;

  // Lista de hábitos con datos iniciales (hardcodeados)
  final List<HabitModel> habits = [
    HabitModel(
      name: 'Meditación',
      icon: Icons.self_improvement,
      completed: true, // Está completado hoy
      streak: 5, // 5 días consecutivos
      color: const Color(0xFF6C63FF), // Color morado
    ),
    HabitModel(
      name: 'Ejercicio',
      icon: Icons.fitness_center,
      completed: true,
      streak: 12, // 12 días consecutivos
      color: const Color(0xFFFF6584), // Color rosa
    ),
  ];

  // Se ejecuta una sola vez cuando el widget se crea
  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  // Configura los controladores de animación
  void _initializeAnimations() {
    // Animación de desvanecimiento (800ms)
    _fadeController = AnimationController(
      vsync: this, // Sincroniza con el refresh rate de la pantalla
      duration: const Duration(milliseconds: 800),
    );
    // Animación de deslizamiento (600ms)
    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    // Animación de celebración (1000ms)
    _celebrationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    // Inicia las animaciones de fade y slide inmediatamente
    _fadeController.forward();
    _slideController.forward();
  }

  // Verifica si todos los hábitos están completados para mostrar celebración
  void _checkCompletion() {
    // Cuenta cuántos hábitos están completados
    final completedCount = habits.where((h) => h.completed).length;

    // Si todos están completos y no se está mostrando la celebración
    if (completedCount == habits.length && !_showCelebration) {
      setState(() {
        _showCelebration = true; // Activa la celebración
      });

      // Ejecuta la animación hacia adelante
      _celebrationController.forward().then((_) {
        // Sin delay, ejecuta la animación en reversa
        Future.delayed(const Duration(milliseconds: 0), () {
          _celebrationController.reverse().then((_) {
            // Verifica que el widget siga montado en el árbol
            if (mounted) {
              setState(() {
                _showCelebration = false; // Oculta la celebración
              });
              _celebrationController.reset(); // Resetea el controlador
            }
          });
        });
      });
    }
  }

  // Alterna el estado de completado de un hábito específico
  void _toggleHabit(int index) {
    setState(() {
      // Invierte el valor booleano (true -> false, false -> true)
      habits[index].completed = !habits[index].completed;
    });
    // Verifica si se debe mostrar la celebración
    _checkCompletion();
  }

  // Limpia los controladores cuando el widget se destruye (previene memory leaks)
  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _celebrationController.dispose();
    super.dispose();
  }

  // Construye la interfaz de usuario
  @override
  Widget build(BuildContext context) {
    // Calcula cuántos hábitos están completados
    final completedCount = habits.where((h) => h.completed).length;

    // Calcula el progreso (de 0.0 a 1.0)
    final double progress = habits.isEmpty
        ? 0.0 // Si no hay hábitos, progreso = 0
        : completedCount / habits.length; // Divide completados / total

    // Scaffold proporciona la estructura básica de la pantalla
    return Scaffold(
      body: Stack(
        // Stack apila widgets uno sobre otro
        children: [
          // Capa principal con contenido scrolleable
          SafeArea(
            // Evita superposición con notches/barras del sistema
            child: SingleChildScrollView(
              // Permite hacer scroll
              physics:
                  const BouncingScrollPhysics(), // Efecto rebote al scrollear
              child: Padding(
                padding: const EdgeInsets.all(
                  20.0,
                ), // Margen de 20px en todos los lados
                child: Column(
                  // Organiza elementos verticalmente
                  crossAxisAlignment:
                      CrossAxisAlignment.start, // Alinea a la izquierda
                  children: [
                    // Encabezado con saludo y fecha (con animación fade)
                    HeaderSection(fadeController: _fadeController),
                    const SizedBox(height: 30), // Espacio vertical
                    // Tarjeta de progreso general (con animación slide)
                    ProgressCard(
                      slideController: _slideController,
                      progress: progress,
                      completedCount: completedCount,
                      totalCount: habits.length,
                    ),
                    const SizedBox(height: 30),

                    // Título de la sección
                    const Text(
                      'Tus Hábitos',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Lista de tarjetas de hábitos
                    _buildHabitsList(),
                    const SizedBox(height: 20),

                    // Botón para agregar nuevos hábitos
                    _buildAddButton(),
                  ],
                ),
              ),
            ),
          ),

          // Capa de celebración superpuesta (solo visible cuando se completan todos)
          if (_showCelebration)
            IgnorePointer(
              // No captura eventos touch (transparente a toques)
              child: CelebrationOverlay(controller: _celebrationController),
            ),
        ],
      ),
    );
  }

  // Construye la lista de hábitos con animaciones
  Widget _buildHabitsList() {
    return ListView.builder(
      shrinkWrap: true, // Ajusta altura al contenido
      physics: const NeverScrollableScrollPhysics(), // Desactiva scroll interno
      itemCount: habits.length, // Número de elementos
      itemBuilder: (context, index) {
        // Anima cada tarjeta individualmente
        return TweenAnimationBuilder(
          tween: Tween<double>(begin: 0, end: 1), // De invisible a visible
          duration: Duration(
            milliseconds: 400 + (index * 100),
          ), // Efecto cascada
          builder: (context, double value, child) {
            return Opacity(
              opacity: value, // Controla transparencia
              child: Transform.translate(
                offset: Offset(0, 30 * (1 - value)), // Desliza desde abajo
                child: child,
              ),
            );
          },
          child: HabitCard(
            habit: habits[index],
            onTap: () => _toggleHabit(index), // Al tocar, marca/desmarca
          ),
        );
      },
    );
  }

  // Construye el botón para agregar nuevos hábitos
  Widget _buildAddButton() {
    return Center(
      child: ElevatedButton.icon(
        onPressed: () async {
          // Navega a la página de agregar hábito y espera el resultado
          final newHabit = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddHabitPage()),
          );

          // Si se retornó un hábito válido, lo agrega a la lista
          if (newHabit != null && newHabit is HabitModel) {
            setState(() {
              habits.add(newHabit);
            });
          }
        },
        icon: const Icon(Icons.add, size: 24), // Icono de "+"
        label: const Text(
          "Agregar Hábito",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF6C63FF), // Color morado
          foregroundColor: Colors.white, // Texto e icono blanco
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30), // Bordes muy redondeados
          ),
          elevation: 8, // Sombra pronunciada
          shadowColor: const Color(
            0xFF6C63FF,
          ).withOpacity(0.5), // Sombra morada translúcida
        ),
      ),
    );
  }
}
