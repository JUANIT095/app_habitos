# 🌱 CONSTY — App de Hábitos

> **CONSTY** (de "Constancia") es una aplicación móvil hecha en **Flutter** para crear y seguir hábitos diarios. Marca tus hábitos como completados, mira tu progreso del día y recibe una animación de celebración 🎉 cuando los completas todos.

Este README está pensado para **principiantes**: explica no solo *qué* hace cada parte, sino *por qué* está organizada así y qué conceptos de Flutter usa.

---

## 📑 Tabla de contenido

1. [¿Qué es Flutter? (lo mínimo que debes saber)](#-qué-es-flutter-lo-mínimo-que-debes-saber)
2. [Capturas del flujo de la app](#-flujo-de-la-app)
3. [Estructura de carpetas](#-estructura-de-carpetas)
4. [Arquitectura: cómo se conecta todo](#-arquitectura-cómo-se-conecta-todo)
5. [Explicación archivo por archivo](#-explicación-archivo-por-archivo)
6. [Conceptos clave de Flutter usados](#-conceptos-clave-de-flutter-usados)
7. [Cómo ejecutar el proyecto](#-cómo-ejecutar-el-proyecto)
8. [Ideas para seguir mejorando](#-ideas-para-seguir-mejorando)

---

## 🧩 ¿Qué es Flutter? (lo mínimo que debes saber)

- **Flutter** es un kit de Google para crear apps (Android, iOS, web, escritorio) con **un solo código**.
- El lenguaje que usa se llama **Dart**.
- En Flutter **TODO es un "widget"**: un botón, un texto, un espacio, una pantalla entera... todos son widgets. Los widgets se anidan unos dentro de otros como piezas de Lego para formar la interfaz.

Hay dos tipos de widgets que verás mucho en este proyecto:

| Tipo | ¿Qué es? | ¿Cuándo se usa? |
|------|----------|-----------------|
| `StatelessWidget` | Widget **sin estado**: se dibuja una vez y no cambia solo. | Cosas fijas (una tarjeta, un encabezado). |
| `StatefulWidget` | Widget **con estado**: puede cambiar mientras la app corre (cuando el usuario toca algo). | Pantallas interactivas (la lista de hábitos). |

> 💡 **Idea central:** cuando algo debe cambiar en pantalla (ej: marcar un hábito), se llama a `setState()`, y Flutter **vuelve a dibujar** esa parte automáticamente.

---

## 🎬 Flujo de la app

```
┌────────────────┐     "Saltar      ┌──────────────┐    botón "+"     ┌─────────────────┐
│ OnboardingPage │   por ahora →"   │   HomePage   │  ───────────────▶│  AddHabitPage   │
│  (Bienvenida)  │ ───────────────▶ │  (Principal) │                  │ (Crear hábito)  │
│                │                  │              │ ◀─────────────── │                 │
│  Logo CONSTY   │                  │ Lista de     │  devuelve el     │ nombre, ícono,  │
│  Registrarse   │                  │ hábitos +    │  nuevo hábito    │ color + preview │
│  Iniciar sesión│                  │ progreso     │                  │                 │
└────────────────┘                  └──────────────┘                  └─────────────────┘
                                            │
                                            │ si completas TODOS
                                            ▼
                                   🎉 CelebrationOverlay
                                   (confeti + "¡Felicidades!")
```

1. **Onboarding (bienvenida):** muestra el logo y los botones *Registrarse* / *Iniciar sesión* (aún sin función real) y un enlace *"Saltar por ahora"* que lleva a la pantalla principal.
2. **Home (principal):** muestra el saludo, una tarjeta con el % de progreso del día y la lista de hábitos. Tocas un hábito para marcarlo como hecho.
3. **Agregar hábito:** un formulario para elegir nombre, ícono y color, con una vista previa en vivo.
4. **Celebración:** cuando *todos* los hábitos quedan marcados, aparece una animación de confeti.

---

## 📁 Estructura de carpetas

```
app_habitos/
├── lib/                        ← Aquí vive TODO el código Dart de la app
│   ├── main.dart               ← 🚪 Punto de entrada (arranca la app)
│   │
│   ├── pages/                  ← 📄 Pantallas completas
│   │   ├── onboarding_page.dart   (pantalla de bienvenida)
│   │   ├── HomePage.dart          (pantalla principal)
│   │   └── add_habit_page.dart    (formulario para crear hábito)
│   │
│   ├── models/                 ← 📦 Datos + algunos componentes visuales
│   │   ├── habit_model.dart       (el "molde" de datos de un hábito)
│   │   ├── habit_card.dart        (tarjeta visual de un hábito)
│   │   ├── progress_card.dart     (tarjeta de progreso del día)
│   │   ├── celebration_overlay.dart (animación de felicitación)
│   │   └── confeti_particle.dart  (cada partícula de confeti)
│   │
│   ├── widgets/                ← 🧱 Componentes reutilizables
│   │   └── header_section.dart    (encabezado con saludo y avatar)
│   │
│   └── utils/                  ← 🛠️ Herramientas y constantes
│       ├── habit_colors.dart      (paleta de colores disponibles)
│       └── habit_icons.dart       (lista de íconos disponibles)
│
├── assets/                     ← 🎨 Recursos: imágenes y fuentes
│   ├── images/LogoConsty.svg
│   └── fonts/  (MuseoModerno, TanMeringue)
│
└── pubspec.yaml                ← ⚙️ "Carnet de identidad" del proyecto
                                   (nombre, dependencias, assets, fuentes)
```

> 📝 **Nota de aprendizaje:** Idealmente, los archivos como `habit_card.dart` o `progress_card.dart` van en `widgets/` (porque son *componentes visuales*), y en `models/` solo deberían ir los "moldes de datos" como `habit_model.dart`. En este proyecto están mezclados — funciona igual, pero tenlo en cuenta cuando crezca. Ver [Ideas para mejorar](#-ideas-para-seguir-mejorando).

---

## 🏗️ Arquitectura: cómo se conecta todo

La app sigue una idea sencilla de **separación por responsabilidades**:

```
                          ┌─────────────────────────┐
                          │       main.dart         │
                          │  (configura tema +      │
                          │   pantalla inicial)     │
                          └───────────┬─────────────┘
                                      │ usa
                          ┌───────────▼─────────────┐
              PANTALLAS   │        pages/           │   ← Cada pantalla que ve el usuario
                          └───────────┬─────────────┘
                                      │ construyen su UI con...
            ┌─────────────────────────┼──────────────────────────┐
            ▼                         ▼                           ▼
  ┌──────────────────┐    ┌────────────────────┐      ┌──────────────────┐
  │   widgets/       │    │   models/ (UI)     │      │   models/ (datos)│
  │  header_section  │    │  habit_card        │      │  habit_model     │
  │                  │    │  progress_card     │      │  (el "molde")    │
  │ (piezas visuales │    │  celebration_...   │      │                  │
  │  reutilizables)  │    │  confeti_particle  │      └──────────────────┘
  └──────────────────┘    └────────────────────┘
            ▲                         ▲
            └─────────────┬───────────┘
                          │ leen constantes de...
                  ┌───────▼────────┐
                  │     utils/     │   ← colores e íconos disponibles
                  │ habit_colors   │
                  │ habit_icons    │
                  └────────────────┘
```

### ¿Dónde se guardan los datos?

⚠️ **Importante:** Actualmente los hábitos viven **solo en memoria** (en una lista dentro de `HomePage`). Esto significa:

- Hay 2 hábitos de ejemplo "quemados" en el código (Meditación y Ejercicio).
- Si agregas hábitos y **cierras la app, se pierden** (no hay base de datos ni guardado en disco todavía).

Esto es perfecto para aprender, y más adelante se le puede agregar persistencia (ver [Ideas para mejorar](#-ideas-para-seguir-mejorando)).

### ¿Cómo "viaja" un hábito nuevo de una pantalla a otra?

Este es el patrón más importante de la app. Cuando creas un hábito:

```
HomePage                          AddHabitPage
   │                                   │
   │  Navigator.push(AddHabitPage) ───▶│  (se abre el formulario)
   │                                   │
   │                                   │  usuario llena nombre/ícono/color
   │                                   │  y pulsa "Crear Hábito"
   │                                   │
   │  ◀─── Navigator.pop(nuevoHabito) ─┤  (devuelve el hábito creado)
   │                                   │
   │  setState() → agrega a la lista   │
   │  y la pantalla se redibuja        │
   ▼                                   ▼
```

En código:
- `HomePage` **espera** el resultado con `await Navigator.push(...)`.
- `AddHabitPage` **devuelve** el hábito con `Navigator.pop(context, nuevoHabito)`.
- `HomePage` lo recibe y hace `setState(() => habits.add(nuevoHabito))`.

---

## 📜 Explicación archivo por archivo

### 🚪 `main.dart` — El arranque
Es lo primero que se ejecuta. Su función `main()` llama a `runApp()`. Aquí se configura:
- El **tema** global (modo oscuro, color de fondo azul oscuro `#0A0E21`, fuente `MuseoModerno`).
- La **pantalla inicial**: `OnboardingPage`.

### 📄 `pages/onboarding_page.dart` — Bienvenida
Pantalla de presentación con animaciones de entrada (fade + slide). Muestra el logo SVG de CONSTY sobre un fondo con degradado. Tiene 3 botones:
- *Registrarse* e *Iniciar sesión* → por ahora solo muestran un mensaje "próximamente" (placeholders).
- *Saltar por ahora →* → lleva a `HomePage` con `Navigator.pushReplacement` (reemplaza la pantalla para que no se pueda "volver atrás" al onboarding).

### 📄 `pages/HomePage.dart` — El corazón de la app
Es un `StatefulWidget` porque su contenido cambia. Se encarga de:
- Guardar la **lista de hábitos** (`habits`).
- Calcular el **progreso** (`completados / total`).
- `_toggleHabit()`: marca/desmarca un hábito al tocarlo.
- `_checkCompletion()`: si todos están completos, dispara la **celebración**.
- Abrir `AddHabitPage` y recibir el hábito nuevo.
- Orquestar 3 **animaciones**: aparición (fade), deslizamiento (slide) y celebración.

### 📄 `pages/add_habit_page.dart` — Crear hábito
Un formulario (`Form`) con validación. El usuario:
1. Escribe un **nombre** (mínimo 3 caracteres — se valida).
2. Elige un **ícono** de una cuadrícula (lista de `utils/habit_icons.dart`).
3. Elige un **color** de una paleta (lista de `utils/habit_colors.dart`).
4. Ve una **vista previa en vivo** de cómo quedará la tarjeta.
5. Pulsa *Crear Hábito* → se valida y se devuelve a `HomePage`.

### 📦 `models/habit_model.dart` — El "molde" de un hábito
Es la pieza más simple pero fundamental. Define **qué información tiene un hábito**:
```dart
class HabitModel {
  String name;       // nombre, ej: "Meditación"
  IconData icon;     // ícono que lo representa
  bool completed;    // ¿está hecho hoy?
  int streak;        // racha de días seguidos 🔥
  Color color;       // color personalizado
}
```
Piensa en esto como un **formulario en blanco**: cada hábito que creas es una "copia llena" de este molde.

### 📦 `models/habit_card.dart` — Tarjeta de un hábito
Widget visual que dibuja **una** tarjeta de hábito: el ícono, el nombre, la racha y el checkbox redondo. Cuando está completado, se tacha el nombre, se ilumina el borde y se llena el check ✓. Recibe un `onTap` (qué hacer al tocarlo).

### 📦 `models/progress_card.dart` — Tarjeta de progreso
La tarjeta morada de arriba que muestra *"Progreso de Hoy"*, el **porcentaje**, una **barra de progreso** y el texto *"X de Y hábitos completados"*.

### 📦 `models/celebration_overlay.dart` — Celebración 🎉
Capa que aparece **encima** de todo cuando completas todos los hábitos: un fondo oscurecido, un cartel de *"¡Felicidades!"* que crece con efecto elástico, y 20 partículas de confeti.

### 📦 `models/confeti_particle.dart` — Confeti
Define **cada** partícula de confeti: su color, forma (círculo o cuadrado), posición, rotación y caída. `celebration_overlay` crea 20 de estas con retrasos distintos para el efecto de lluvia.

### 🧱 `widgets/header_section.dart` — Encabezado
El saludo *"¡Hola, Usuario!"* con el subtítulo motivacional y el avatar circular con degradado en la esquina.

### 🛠️ `utils/habit_colors.dart` — Paleta de colores
Una lista de ~22 colores predefinidos (`availableColors`) que se usan en el selector de color. También tiene utilidades extra (color aleatorio, detectar si un color es claro/oscuro) para uso futuro.

### 🛠️ `utils/habit_icons.dart` — Catálogo de íconos
Una lista de ~37 íconos (`availableIcons`) organizados por categoría (salud, comida, estudio, etc.) que se muestran en el selector de íconos.

### ⚙️ `pubspec.yaml` — Configuración del proyecto
El archivo de configuración. Aquí se declaran:
- Las **dependencias** (ej: `flutter_svg` para mostrar el logo `.svg`).
- Los **assets** (imágenes) y las **fuentes** (`MuseoModerno`, `TanMeringue`).

---

## 🧠 Conceptos clave de Flutter usados

| Concepto | ¿Qué es? | ¿Dónde verlo? |
|----------|----------|----------------|
| **Widgets** | Piezas que forman la interfaz. | En todos lados |
| **StatefulWidget + setState** | Redibujar la UI cuando algo cambia. | `HomePage`, `AddHabitPage` |
| **Navigator (push/pop)** | Moverse entre pantallas y devolver datos. | `HomePage` ↔ `AddHabitPage` |
| **Animaciones (AnimationController, Tween)** | Movimiento suave (fade, slide, escala). | `HomePage`, `onboarding`, confeti |
| **Modelo de datos** | Una clase que representa información. | `habit_model.dart` |
| **Validación de formularios** | Revisar que el usuario escriba bien. | `add_habit_page.dart` |
| **Reutilización de widgets** | Crear componentes y usarlos muchas veces. | `HabitCard`, `HeaderSection` |
| **Assets y fuentes** | Imágenes y tipografías personalizadas. | `pubspec.yaml`, `onboarding` |

---

## ▶️ Cómo ejecutar el proyecto

```bash
# 1. Instala las dependencias
flutter pub get

# 2. Conecta un dispositivo o abre un emulador, y ejecuta:
flutter run

# (Opcional) Revisar el estado del código:
flutter analyze
```

> Requisitos: tener el **SDK de Flutter** instalado (este proyecto usa Dart `^3.9.0`).

---

## 🚀 Ideas para seguir mejorando

Pensadas para aprender, de la más fácil a la más avanzada:

1. **Conectar los botones del onboarding** (Registrarse / Iniciar sesión) a pantallas reales.
2. **Guardar los hábitos** para que no se borren al cerrar la app (con `shared_preferences` o una base de datos como `hive`/`sqflite`).
3. **Poder borrar o editar** un hábito existente.
4. **Calcular la racha (streak) automáticamente** según los días completados.
5. **Reorganizar las carpetas**: mover `habit_card`, `progress_card`, `celebration_overlay` y `confeti_particle` de `models/` a `widgets/`, dejando en `models/` solo los datos.
6. **Renombrar `HomePage.dart` → `home_page.dart`** para seguir la convención de Dart (minúsculas con guion bajo).
7. **Cambiar `withOpacity()` por `withValues()`** (la versión moderna que recomienda Flutter).

---

*Hecho con 💜 y Flutter.*
