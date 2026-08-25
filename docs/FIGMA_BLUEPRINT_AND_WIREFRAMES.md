# Blueprint de Diseño, Wireframes y Jerarquía de Capas en Figma (Slide 6)

**Proyecto:** NeuroTask — Motor de Foco  
**Cátedra:** Desarrollo de Aplicaciones Móviles (DAM) — ITU, Universidad Nacional de Cuyo  
**Trabajo Práctico:** Ejercitación Tema 1: Diseño Centrado en el Usuario (DCU)  
**Equipo:** Araujo Jonathan, Batiatto Juan Martín, Belardinelli Agustín, Ortega Mateo  
**Repositorio GitHub:** [https://github.com/Joni23s/NeuroTask_beta00](https://github.com/Joni23s/NeuroTask_beta00)

---

## 1. Estructura de Páginas y Organización de Frames en Figma

Para cumplir de forma rigurosa con la **Slide 6 (Prototipo Interactivo y Wireframes)** y generar el **Enlace Público Interactivo**, estructurar el archivo de Figma con la siguiente jerarquía de páginas:

```
[FIGMA FILE: NeuroTask Mobile UI / UX Prototype]
│
├── 🎨 1. Design System & UI Kit
│   ├── Color Tokens (Swatches)
│   │   ├── Base Paper Background: #F4F6F9 (Soft Paper Light)
│   │   ├── Brand Deep Blue: #2B5B84 (Isotipo oficial NeuroTask)
│   │   ├── Brand Steel Blue: #4A7D9D (Subtítulos y acentos secundarios)
│   │   ├── Brand Glow Cyan: #38BDF8 (Resplandor de nodo activo)
│   │   ├── Primary Indigo: #4F46E5 (Focus / Action)
│   │   ├── Success Emerald: #10B981 (Tildes de avance / Completado)
│   │   ├── Amber Warning: #F59E0B (Rescate Cognitivo / Micro-Pasos)
│   │   └── Text Main / Muted: #1E293B / #64748B
│   ├── Neumorphic Effects Styles (Effect Styles)
│   │   ├── "Soft Paper Elevation": Drop Shadow (-6, -6, Blur 14, #FFFFFF) + Drop Shadow (6, 6, Blur 14, #A6B2C4 @ 45%)
│   │   ├── "Pressed Inset": Inner Shadow (4, 4, Blur 8, #A6B2C4 @ 40%) + Inner Shadow (-4, -4, Blur 8, #FFFFFF)
│   │   ├── "Cyan Target Glow": Drop Shadow (0, 0, Blur 24, #38BDF8 @ 40%)
│   │   └── "Emerald Success Glow": Drop Shadow (0, 4, Blur 16, #10B981 @ 30%)
│   └── Typography Styles (Text Styles)
│       ├── Heading 1: Plus Jakarta Sans / Bold / 26pt
│       ├── Heading 2: Plus Jakarta Sans / Bold / 20pt
│       ├── Body Regular: Plus Jakarta Sans / Regular / 14pt (Line height 150%)
│       └── Micro Monospace: JetBrains Mono / Medium / 11pt
│
├── 📐 2. Low-Fidelity Wireframes (Baja Fidelidad)
│   ├── Frame 0: Wireframe Splash / Bienvenida (Cerebro central y botón de arranque)
│   ├── Frame 1: Wireframe Ingesta Libre (Estructura de grilla, dictado y presets)
│   ├── Frame 2: Wireframe Transición de Calma (Loader concéntrico de respiración)
│   ├── Frame 3: Wireframe Foco Activo 1-a-1 (Tarjeta atómica, swipe gesture y temporizador zen)
│   ├── Frame 4: Wireframe Rescate Cognitivo (Distribución de opciones de descompresión)
│   ├── Frame 5: Wireframe Mapa DAG Vectorial (Nodos Bézier conectados y orden topológico)
│   └── Frame 6: Wireframe Celebración Dopaminérgica (Métricas de calma mental y nodos logrados)
│
└── 🚀 3. High-Fidelity Prototype (Alta Fidelidad - Enlace de Presentación)
    ├── Screen 0: "Welcome / Zen Splash" (Isotipo interactivo con animación de respiración)
    ├── Screen 1: "Brain Dump Ingestion" (Lienzo libre, dictado por voz y selector de presets)
    ├── Screen 2: "DAG Parsing & Sequencing" (Transición animada de calma visual)
    ├── Screen 3: "Single-Task Viewport" (Hero Card con Swipe-to-Complete, sonido ambiental y timer zen)
    ├── Modal 4: "Cognitive Rescue Sheet" (BottomSheet interactivo con subdivisión en 3 min y Modo Baja Energía)
    ├── Modal 5: "DAG Graph Overview" (Canvas vectorial interactivo con curvas Bézier y estado de nodos)
    └── Screen 6: "Flow Completion Celebration" (Refuerzo dopaminérgico, métricas de foco y calma)
```

---

## 2. Mapa de Conexiones e Interacciones de Figma (Prototype Flows)

| Desde (Elemento / Frame) | Evento / Disparador | Acción en Figma | Destino | Animación / Transición |
| :--- | :--- | :--- | :--- | :--- |
| **Screen 0: Welcome** -> Tap en Isotipo / Botón "Tocar para Descomprimir" | On Click / Tap | Navigate to | **Screen 1: Brain Dump** | Smart Animate (Ease In/Out 350ms) |
| **Screen 1: Ingesta** -> Botón "Descomprimir y Secuenciar" | On Click / Tap | Navigate to | **Screen 2: Transición** | Smart Animate (Ease In/Out 300ms) |
| **Screen 2: Transición** | After Delay (1200ms) | Navigate to | **Screen 3: Single-Task Viewport** | Smart Animate (Ease In/Out 400ms) |
| **Screen 3** -> Gesto "Swipe to Right" / Botón "Paso Completado" | On Drag / Tap | Navigate to | **Screen 3 (Siguiente Nodo)** | Smart Animate (Spring Physics 280ms) |
| **Screen 3** -> Gesto "Pull Down" / Botón "Estoy Bloqueado" | On Drag Down / Tap | Open Overlay | **Modal 4: Cognitive Rescue** | Move In from Bottom (300ms) |
| **Screen 3** -> Ícono "🗺️ Grafo" | On Click / Tap | Open Overlay | **Modal 5: Graph Overview** | Move In from Bottom (300ms) |
| **Modal 4** -> Opción "1. Subdividir en 3 min" | On Click / Tap | Close Overlay + Update | **Screen 3 (Micro-Paso)** | Instant / Smart Animate |
| **Modal 5** -> Botón "Ver Grafo / Ver Lista" | On Click / Tap | Set Variable / Switch Component | **Modal 5 (Vector Canvas)** | Smart Animate (200ms) |
| **Screen 3 (Último Paso)** -> Swipe / "Paso Completado" | On Drag / Tap | Navigate to | **Screen 6: Celebración** | Dissolve (400ms) |
| **Screen 6: Celebración** -> "Iniciar Nuevo Volcado" | On Click / Tap | Navigate to | **Screen 1: Brain Dump** | Push Right (300ms) |

---

## 3. Checklist para la Diapositiva 6 del Slide Deck (Defensa Oral)

1. **Captura Visual del Prototipo:** Incluir el mock-up del smartphone con la pantalla de *Foco Único (1-a-1)*, el *Canvas Vectorial del Grafo* y la *Pantalla de Bienvenida con el Isotipo*.
2. **Código QR y Link al Prototipo:**
   - Link al archivo interactivo de Figma (permisos en *"Anyone with the link can view"*).
   - Link al repositorio de GitHub: `https://github.com/Joni23s/NeuroTask_beta00`.
3. **Puntos Clave a destacar verbalmente en la exposición (Enfoque DCU):**
   - *¿Por qué Neumorphism Soft Paper?* Reduce la fatiga lumínica y la sobrecarga sensorial en personas con fatiga mental o TDAH.
   - *¿Por qué 1 sola tarea a la vez con Swipe?* Bloquea la parálisis por análisis y premia el avance físico con micro-hápticos.
   - *¿Qué es el motor DAG?* Transforma el caos mental del Brain Dump en un grafo acíclico dirigido con ordenamiento topológico automático.
   - *¿Qué rol cumple el Rescate Cognitivo?* Provee una salida ergonómica sin culpas cuando la energía del usuario decae.
