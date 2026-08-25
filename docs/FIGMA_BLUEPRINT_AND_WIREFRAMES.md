# Blueprint de Diseño, Wireframes y Jerarquía de Capas en Figma (Slide 6)

**Proyecto:** NeuroTask — Motor de Foco  
**Cátedra:** Desarrollo de Aplicaciones Móviles (DAM) — ITU, Universidad Nacional de Cuyo  
**Trabajo Práctico:** Ejercitación Tema 1: Diseño Centrado en el Usuario (DCU)  
**Equipo:** Araujo Jonathan, Batiatto Juan Martín, Belardinelli Agustín, Ortega Mateo  

---

## 1. Estructura de Páginas y Organización de Frames en Figma

Para cumplir de forma rigurosa con la **Slide 6 (Prototipo Interactivo y Wireframes)** y generar el **Enlace Público Interactivo**, estructurar el archivo de Figma con la siguiente jerarquía de páginas:

```
[FIGMA FILE: NeuroTask Mobile UI / UX Prototype]
│
├── 🎨 1. Design System & UI Kit
│   ├── Color Tokens (Swatches)
│   │   ├── Base Background: #F4F6F9 (Soft Paper Light)
│   │   ├── Surface Card: #F4F6F9
│   │   ├── Pressed Surface: #E9EDF4
│   │   ├── Primary Indigo: #4F46E5 (Focus / Action)
│   │   ├── Success Emerald: #10B981 (Completion)
│   │   ├── Amber Warning: #F59E0B (Cognitive Rescue)
│   │   └── Text Main / Muted: #1E293B / #64748B
│   ├── Neumorphic Effects Styles (Effect Styles)
│   │   ├── "Soft Card Elevation": Drop Shadow (-6, -6, Blur 14, #FFFFFF) + Drop Shadow (6, 6, Blur 14, #A6B2C4 @ 45%)
│   │   ├── "Pressed Inset": Inner Shadow (4, 4, Blur 8, #A6B2C4 @ 40%) + Inner Shadow (-4, -4, Blur 8, #FFFFFF)
│   │   └── "Indigo Glow": Drop Shadow (0, 4, Blur 16, #6366F1 @ 30%)
│   └── Typography Styles (Text Styles)
│       ├── Heading 1: Plus Jakarta Sans / Bold / 24pt
│       ├── Heading 2: Plus Jakarta Sans / Bold / 20pt
│       ├── Body Regular: Plus Jakarta Sans / Regular / 14pt (Line height 150%)
│       └── Micro Monospace: JetBrains Mono / Medium / 11pt
│
├── 📐 2. Low-Fidelity Wireframes (Baja Fidelidad)
│   ├── Frame 1: Wireframe Ingesta Libre (Estructura de grilla y áreas táctiles)
│   ├── Frame 2: Wireframe Transición de Calma (Loader concéntrico de respiración)
│   ├── Frame 3: Wireframe Foco Activo 1-a-1 (Jerarquía de tarjeta atómica y botones de pulgar)
│   └── Frame 4: Wireframe Rescate Cognitivo (Distribución de opciones de descompresión)
│
└── 🚀 3. High-Fidelity Prototype (Alta Fidelidad - Enlace de Presentación)
    ├── Screen 1: "Brain Dump Ingestion" (Lienzo libre, dictado por voz y selector de presets)
    ├── Screen 2: "DAG Parsing & Sequencing" (Transición animada de calma visual)
    ├── Screen 3: "Single-Task Viewport" (Hero Card neumórfica 1-a-1 con temporizador zen)
    ├── Modal 4: "Cognitive Rescue Sheet" (BottomSheet interactivo con subdivisión en 3 min)
    ├── Modal 5: "DAG Graph Overview" (Mapa topológico completo de tareas para aliviar ansiedad)
    └── Screen 6: "Flow Completion Celebration" (Refuerzo positivo y felicitación dopaminérgica)
```

---

## 2. Mapa de Conexiones e Interacciones de Figma (Prototype Flows)

| Desde (Elemento / Frame) | Evento / Disparador | Acción en Figma | Destino | Animación / Transición |
| :--- | :--- | :--- | :--- | :--- |
| **Screen 1: Ingesta** -> Botón "Descomprimir y Secuenciar" | On Click / Tap | Navigate to | **Screen 2: Transición** | Smart Animate (Ease In/Out 300ms) |
| **Screen 2: Transición** | After Delay (1200ms) | Navigate to | **Screen 3: Single-Task Viewport** | Smart Animate (Ease In/Out 400ms) |
| **Screen 3** -> Botón "Paso Completado" | On Click / Tap | Navigate to | **Screen 3 (Nodo 2)** | Push Left / Smart Animate (250ms) |
| **Screen 3** -> Botón "Estoy Bloqueado / Dividir" | On Click / Tap | Open Overlay | **Modal 4: Cognitive Rescue** | Move In from Bottom (300ms) |
| **Screen 3** -> Ícono "🗺️ Grafo" | On Click / Tap | Open Overlay | **Modal 5: Graph Overview** | Move In from Bottom (300ms) |
| **Modal 4** -> Opción "1. Subdividir en 3 min" | On Click / Tap | Close Overlay + Update | **Screen 3 (Micro-Paso)** | Instant / Smart Animate |
| **Screen 3 (Último Paso)** -> "Paso Completado" | On Click / Tap | Navigate to | **Screen 6: Celebración** | Dissolve (350ms) |

---

## 3. Checklist para la Diapositiva 6 del Slide Deck

1. **Captura Visual del Prototipo:** Incluir el mock-up del smartphone con la pantalla de *Foco Único (1-a-1)* y la de *Ingesta Libre*.
2. **Código QR y Link al Prototipo:**
   - Link al archivo interactivo de Figma (permisos en *"Anyone with the link can view"*).
   - Link al prototipo web interactivo en ejecución.
3. **Puntos Clave a destacar verbalmente en la exposición:**
   - *¿Por qué Neumorphism Soft Paper?* Reduce la fatiga lumínica y la sobrecarga sensorial.
   - *¿Por qué 1 sola tarea a la vez?* Bloquea la parálisis por análisis y la disfunción ejecutiva.
   - *¿Qué es el motor DAG?* Transforma el caos mental en un grafo con ordenamiento topológico automático.
