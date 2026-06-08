// Importaciones necesarias
import 'package:flutter/material.dart';
import '../models/habit_model.dart';
import '../utils/habit_icons.dart'; // Lista de íconos disponibles
import '../utils/habit_colors.dart'; // Paleta de colores disponibles

/// Página para agregar un nuevo hábito
/// Permite al usuario personalizar nombre, ícono y color
class AddHabitPage extends StatefulWidget {
  const AddHabitPage({Key? key}) : super(key: key);

  @override
  State<AddHabitPage> createState() => _AddHabitPageState();
}

// Estado de la página con soporte para animaciones
class _AddHabitPageState extends State<AddHabitPage>
    with SingleTickerProviderStateMixin {
  // ========== CONTROLADORES Y ESTADO ==========

  // Controla el campo de texto del nombre del hábito
  final TextEditingController _nameController = TextEditingController();

  // Llave global para identificar y validar el formulario
  final _formKey = GlobalKey<FormState>();

  // ========== VALORES SELECCIONADOS ==========

  // Ícono seleccionado actualmente (por defecto: estrella)
  IconData _selectedIcon = Icons.star;

  // Color seleccionado actualmente (por defecto: morado)
  Color _selectedColor = const Color(0xFF6C63FF);

  // ========== ESTADO DE VALIDACIÓN ==========

  // Controla si se deben mostrar errores de validación
  bool _showError = false;

  // ========== ANIMACIONES ==========

  // Controlador principal de animaciones
  late AnimationController _animationController;

  // Animación de opacidad (fade in)
  late Animation<double> _fadeAnimation;

  // Animación de posición (slide up)
  late Animation<Offset> _slideAnimation;

  // Se ejecuta una vez al crear el widget
  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  /// Inicializa las animaciones de entrada de la página
  void _initializeAnimations() {
    // Crea el controlador de animación (duración: 600ms)
    _animationController = AnimationController(
      vsync: this, // Sincroniza con el refresh rate de la pantalla
      duration: const Duration(milliseconds: 600),
    );

    // Animación de desvanecimiento: de invisible (0.0) a visible (1.0)
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeIn, // Aceleración suave
      ),
    );

    // Animación de deslizamiento: desde 10% abajo hasta posición original
    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.1), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeOut, // Desaceleración suave
          ),
        );

    // Inicia las animaciones inmediatamente
    _animationController.forward();
  }

  // Limpia recursos cuando el widget se destruye
  @override
  void dispose() {
    _nameController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  /// Valida y guarda el nuevo hábito
  void _saveHabit() {
    // Activa la visualización de errores
    setState(() {
      _showError = true;
    });

    // Valida el formulario completo
    if (_formKey.currentState?.validate() ?? false) {
      // Crea un nuevo hábito con los valores seleccionados
      final newHabit = HabitModel(
        name: _nameController.text.trim(), // Elimina espacios extras
        icon: _selectedIcon,
        completed: false, // Nuevos hábitos no están completados
        streak: 0, // La racha comienza en cero
        color: _selectedColor,
      );

      // Cierra la página y retorna el nuevo hábito a HomePage
      Navigator.pop(context, newHabit);
    }
  }

  // Construye la interfaz de usuario
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        // Evita superposición con notches/barras del sistema
        // Aplica animación de desvanecimiento
        child: FadeTransition(
          opacity: _fadeAnimation,
          // Aplica animación de deslizamiento
          child: SlideTransition(
            position: _slideAnimation,
            child: Column(
              children: [
                // Header con botón de regreso y título
                _buildHeader(),

                // Contenido scrolleable que ocupa el espacio restante
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(), // Efecto rebote
                    padding: const EdgeInsets.all(24.0),
                    // Formulario con validación
                    child: Form(
                      key: _formKey, // Asigna la llave global
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Campo de texto para el nombre
                          _buildNameField(),
                          const SizedBox(height: 32),

                          // Grid de íconos para seleccionar
                          _buildIconSelector(),
                          const SizedBox(height: 32),

                          // Paleta de colores para seleccionar
                          _buildColorSelector(),
                          const SizedBox(height: 32),

                          // Vista previa del hábito
                          _buildPreview(),
                          const SizedBox(height: 40),

                          // Botón para crear el hábito
                          _buildSaveButton(),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Construye el header con botón de regreso y título
  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Row(
        children: [
          // Botón de regreso
          IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () => Navigator.pop(context), // Cierra sin guardar
          ),
          const SizedBox(width: 8),
          // Título de la página
          const Text(
            'Nuevo Hábito',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  /// Construye el campo de texto para el nombre del hábito
  Widget _buildNameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Etiqueta del campo
        const Text(
          'Nombre del Hábito',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 12),
        // Campo de texto con validación
        TextFormField(
          controller: _nameController, // Conecta con el controlador
          style: const TextStyle(color: Colors.white, fontSize: 16),
          decoration: InputDecoration(
            hintText: 'Ej: Meditar 10 minutos', // Texto de ejemplo
            hintStyle: TextStyle(color: Colors.white.withOpacity(0.4)),
            filled: true,
            fillColor: const Color(0xFF1D1E33), // Fondo oscuro
            // Borde por defecto (sin borde visible)
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),

            // Borde cuando NO está enfocado
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(
                color: Colors.white.withOpacity(0.1),
                width: 1,
              ),
            ),

            // Borde cuando ESTÁ enfocado (color del hábito)
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: _selectedColor, width: 2),
            ),

            // Borde cuando hay error
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: Colors.red, width: 2),
            ),

            // Borde cuando está enfocado Y hay error
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: Colors.red, width: 2),
            ),

            contentPadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 18,
            ),
          ),

          // Función de validación
          validator: (value) {
            // Verifica que no esté vacío
            if (value == null || value.trim().isEmpty) {
              return 'Por favor ingresa un nombre';
            }
            // Verifica longitud mínima
            if (value.trim().length < 3) {
              return 'El nombre debe tener al menos 3 caracteres';
            }
            return null; // Validación exitosa
          },

          maxLength: 30, // Máximo 30 caracteres
          textInputAction: TextInputAction.done, // Botón "Listo" en teclado
          // Valida en tiempo real mientras escribe (solo si ya hay errores)
          onChanged: (_) {
            if (_showError) {
              _formKey.currentState?.validate();
            }
          },
        ),
      ],
    );
  }

  /// Construye el selector de íconos en formato grid
  Widget _buildIconSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Etiqueta de la sección
        const Text(
          'Selecciona un Ícono',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 12),
        // Contenedor del grid de íconos
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF1D1E33), // Fondo oscuro
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
          ),
          // Wrap envuelve elementos a la siguiente línea si no caben
          child: Wrap(
            spacing: 12, // Espacio horizontal entre íconos
            runSpacing: 12, // Espacio vertical entre filas
            // Transforma cada ícono disponible en un widget
            children: HabitIcons.availableIcons.map((icon) {
              // Verifica si este ícono es el seleccionado
              final isSelected = icon == _selectedIcon;

              return GestureDetector(
                // Al tocar, actualiza el ícono seleccionado
                onTap: () {
                  setState(() {
                    _selectedIcon = icon;
                  });
                },
                // AnimatedContainer anima los cambios de estilo automáticamente
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    // Fondo: color del hábito si está seleccionado, gris si no
                    color: isSelected
                        ? _selectedColor.withOpacity(0.2)
                        : Colors.white.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(12),
                    // Borde: color del hábito si está seleccionado, transparente si no
                    border: Border.all(
                      color: isSelected ? _selectedColor : Colors.transparent,
                      width: 2,
                    ),
                  ),
                  // Ícono dentro del contenedor
                  child: Icon(
                    icon,
                    color: isSelected ? _selectedColor : Colors.white,
                    size: 28,
                  ),
                ),
              );
            }).toList(), // Convierte el Iterable en List
          ),
        ),
      ],
    );
  }

  /// Construye el selector de colores en formato circular
  Widget _buildColorSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Etiqueta de la sección
        const Text(
          'Selecciona un Color',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 12),
        // Contenedor de la paleta de colores
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF1D1E33),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
          ),
          child: Wrap(
            spacing: 12, // Espacio horizontal entre círculos
            runSpacing: 12, // Espacio vertical entre filas
            // Transforma cada color disponible en un widget
            children: HabitColors.availableColors.map((color) {
              // Verifica si este color es el seleccionado
              final isSelected = color == _selectedColor;

              return GestureDetector(
                // Al tocar, actualiza el color seleccionado
                onTap: () {
                  setState(() {
                    _selectedColor = color;
                  });
                },
                // AnimatedContainer anima los cambios automáticamente
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: color, // El color mismo
                    shape: BoxShape.circle, // Forma circular
                    // Borde blanco si está seleccionado
                    border: Border.all(
                      color: isSelected ? Colors.white : Colors.transparent,
                      width: 3,
                    ),
                    // Sombra con brillo si está seleccionado
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: color.withOpacity(
                                0.5,
                              ), // Sombra del mismo color
                              blurRadius: 12,
                              offset: const Offset(
                                0,
                                4,
                              ), // Desplazada hacia abajo
                            ),
                          ]
                        : [], // Sin sombra si no está seleccionado
                  ),
                  // Muestra check ✓ si está seleccionado
                  child: isSelected
                      ? const Icon(Icons.check, color: Colors.white, size: 24)
                      : null, // null significa "sin hijo"
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  /// Construye la vista previa del hábito con el diseño final
  Widget _buildPreview() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Etiqueta de la sección
        const Text(
          'Vista Previa',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 12),
        // Contenedor que simula cómo se verá la tarjeta del hábito
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFF1D1E33), // Fondo oscuro
            borderRadius: BorderRadius.circular(20),
            // Borde del color seleccionado
            border: Border.all(
              color: _selectedColor.withOpacity(0.5),
              width: 2,
            ),
            // Sombra del color seleccionado
            boxShadow: [
              BoxShadow(
                color: _selectedColor.withOpacity(0.3),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              // ========== ÍCONO DEL HÁBITO ==========
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _selectedColor.withOpacity(0.2), // Fondo translúcido
                  borderRadius: BorderRadius.circular(12),
                ),
                // Muestra el ícono seleccionado con el color seleccionado
                child: Icon(_selectedIcon, color: _selectedColor, size: 28),
              ),

              const SizedBox(width: 16),

              // ========== NOMBRE DEL HÁBITO ==========
              Expanded(
                child: Text(
                  // Si el campo está vacío, muestra placeholder
                  _nameController.text.isEmpty
                      ? 'Tu hábito aparecerá aquí'
                      : _nameController.text, // Sino muestra el texto ingresado
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    // Color gris si está vacío, blanco si tiene texto
                    color: _nameController.text.isEmpty
                        ? Colors.white.withOpacity(0.4)
                        : Colors.white,
                  ),
                ),
              ),

              // ========== CHECKBOX VISUAL ==========
              // Círculo vacío que representa el checkbox
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: Colors.transparent, // Sin relleno
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withOpacity(0.3),
                    width: 2,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Construye el botón para guardar el hábito
  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity, // Ocupa todo el ancho disponible
      child: ElevatedButton(
        onPressed: _saveHabit, // Al presionar, ejecuta la función de guardar
        style: ElevatedButton.styleFrom(
          backgroundColor: _selectedColor, // Color del hábito seleccionado
          foregroundColor: Colors.white, // Texto e íconos en blanco
          padding: const EdgeInsets.symmetric(vertical: 18), // Altura del botón
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16), // Bordes redondeados
          ),
          elevation: 8, // Sombra pronunciada
          shadowColor: _selectedColor.withOpacity(
            0.5,
          ), // Sombra del color seleccionado
        ),
        child: const Text(
          'Crear Hábito',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
