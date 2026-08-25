# NeuroTask: Motor de Foco 🧠✨

> **Aplicación Mobile de Descompresión Cognitiva, Secuenciación DAG y Enfoque Atómico (1 a 1)**  
> **Cátedra:** Desarrollo de Aplicaciones Móviles (DAM) — ITU, Universidad Nacional de Cuyo  
> **Trabajo Práctico:** Ejercitación - Tema 1: Diseño Centrado en el Usuario (DCU)  
> **Equipo:** Araujo Jonathan, Batiatto Juan Martín, Belardinelli Agustín, Ortega Mateo  
> **Repositorio GitHub:** [https://github.com/Joni23s/NeuroTask_beta00](https://github.com/Joni23s/NeuroTask_beta00)

![NeuroTask Logo](NeuroTask_logo.jpg)

---

## 📌 1. Visión General del Proyecto

Las aplicaciones de gestión de tareas tradicionales (Notion, Trello, Jira) trasladan tableros complejos a pantallas reducidas, generando parálisis por análisis, sobrecarga cognitiva y disfunción ejecutiva (común en estudiantes y profesionales con TDAH o fatiga mental).

**NeuroTask** reimagina la experiencia móvil a través de:
1. **Zen Splash / Bienvenida Sensorial:** Isotipo interactivo del cerebro resplandeciente con animación de respiración guiada (*Zen Breathe*).
2. **Ingesta Cruda Asíncrona (Brain Dump):** Vaciado libre de pensamientos en lenguaje natural o dictado por voz.
3. **Motor Algorítmico DAG (Directed Acyclic Graph):** Descomposición y ordenamiento topológico automático según dependencias y nivel de energía.
4. **Single-Task Viewport con Swipe-to-Complete:** Visualización estricta de una única tarea ejecutable a la vez, con gestos de deslizamiento con física de resorte y feedback háptico.
5. **Canvas Vectorial Interactivo del Grafo DAG:** Visualización de nodos conectados con curvas Bézier y resplandor cian del nodo activo (`CustomPainter`).
6. **Módulo de Rescate Cognitivo & Modo Baja Energía:** Subdivisión inmediata en micro-pasos de 3 minutos sin culpa.
7. **Audio Sensorial y Ruido Marrón:** Generador de audio de concentración y campanadas armónicas de gratificación.
8. **Celebración y Métricas de Calma:** Panel de refuerzo dopaminérgico con nodos conquistados y energía preservada.
9. **Estética Light Soft Paper & Soft Neumorphism:** Tonos blanco roto/gris suave (`#F4F6F9`), sombras difusas orgánicas y ausencia de alertas punitivas en rojo.

---

## 📂 2. Estructura del Repositorio

```
NeuroTask_beta00/
├── NeuroTask_logo.jpg                                       # Logotipo original
├── NeuroTask - Documento Maestro de Diseño...md             # Documento teórico completo de las 5 etapas DCU
├── README.md                                                # Documentación general y guía de ejecución
├── LICENSE                                                  # Licencia MIT (4 integrantes)
│
├── web_prototype/                                           # Prototipo Interactivo Web/Mobile de Alta Fidelidad
│   ├── index.html                                           # Simulador de smartphone interactivo
│   ├── css/style.css                                        # Design System Soft Paper & Neumorphism Tokens
│   ├── js/dag_engine.js                                     # Motor algorítmico DAG + Topological Sort
│   ├── js/audio_engine.js                                   # Motor Web Audio API (Campana Zen & Ruido Marrón)
│   └── js/app.js                                            # Lógica reactiva de estados, voz y rescate
│
├── flutter_app/                                             # Proyecto Flutter Completo (Clean Architecture)
│   ├── pubspec.yaml                                         # Dependencias (Riverpod, Google Fonts, etc.)
│   ├── analysis_options.yaml                                # Reglas de linting
│   ├── assets/images/logo.jpg                               # Asset del logotipo
│   └── lib/
│       ├── main.dart                                        # Entrypoint con ProviderScope y WelcomeScreen
│       ├── core/
│       │   ├── theme/ (app_colors.dart, neumorphic_theme.dart)
│       │   ├── widgets/ (neumorphic_card.dart, neumorphic_button.dart, swipe_to_complete_card.dart, zen_timer.dart, flow_indicator.dart)
│       │   ├── services/ (audio_service.dart)
│       │   └── utils/ (haptic_helper.dart)
│       └── features/
│           ├── welcome/ (welcome_screen.dart)
│           ├── brain_dump/ (brain_dump_screen.dart, brain_dump_controller.dart)
│           ├── graph_engine/ (task_node.dart, task_graph.dart, topological_sorter.dart, dag_canvas_widget.dart)
│           ├── focus_viewport/ (single_task_screen.dart, focus_controller.dart, summary_celebration_screen.dart)
│           └── unblock_mode/ (cognitive_rescue_sheet.dart, graph_overview_modal.dart)
│
└── docs/
    └── FIGMA_BLUEPRINT_AND_WIREFRAMES.md                    # Blueprint para Figma y Diapositiva 6
```

---

## 🚀 3. Cómo Ejecutar el Prototipo Interactivo Web

Para abrir y probar el prototipo de forma inmediata en cualquier navegador o smartphone:

### Opción A: Servidor Local Rápido
```bash
# Desde la carpeta raíz del proyecto:
python -m http.server 8080 --directory web_prototype
```
Abrí tu navegador en: **`http://localhost:8080`**

---

## 📱 4. Cómo Compilar y Ejecutar el Proyecto Flutter

El código en `flutter_app/` está listo para ser abierto en **VS Code** o **Android Studio**:

```bash
cd flutter_app

# 1. Obtener dependencias
flutter pub get

# 2. Ejecutar pruebas automatizadas
flutter test

# 3. Ejecutar en Chrome, Emulador o Windows
flutter run -d chrome
```

O simplemente presioná **`F5`** en VS Code.

---

## 🎨 5. Figma Blueprint y Diapositiva 6

Para la confección de las pantallas en Figma y el enlace público interactivo de la **Slide 6**, consultar el archivo [FIGMA_BLUEPRINT_AND_WIREFRAMES.md](docs/FIGMA_BLUEPRINT_AND_WIREFRAMES.md).
