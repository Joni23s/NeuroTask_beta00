# STITCH MASTER PROMPT: NeuroTask Beta 0.1 (Interactive Flow & Generation Sequence)

> **Execution Directive for Google Stitch**:  
> Reconstruct the entire NeuroTask Beta 0.1 application with 100% pixel-perfect visual fidelity and **fully wired interactive transitions**.  
> Generate the screens in the exact chronological sequence below so that clicking **"Play / Preview"** immediately starts a seamless, clickable user journey.

---

## 1. PRODUCT IDENTITY & COGNITIVE ARCHITECTURE
* **App Title**: `NeuroTask: Motor de Foco` (Beta 0.1)
* **Core Philosophy**: *"Menos ruido mental, más foco sereno."*
* **Target Users**: Individuals with ADHD/TDAH, executive dysfunction, and time blindness.
* **Core Modules**:
  1. **Daily Anchor Time-Blocking**: Define fixed routine blocks (*Facultad, Gimnasio, Cena*) to defeat time blindness.
  2. **Smart Cognitive Slotting**: Automatically map daily tasks into open windows of lowest mental fatigue.
  3. **Strict 1-to-1 Focus Viewport**: View only one single atomic task at a time.
  4. **Non-Violent Zen Time**: Progressive flow timer (`"Tiempo de Flujo: X min"` | `"| Sin apuros"`).
  5. **Cognitive Rescue & Guardian**: 3-minute micro-steps, low-energy mode, and schedule conflict alerts.
  6. **Empathetic Reinforcement**: 10-badge achievements vault with dual-outcome celebratory insights.

---

## 2. DESIGN TOKENS & VISUAL SYSTEM
* **Aesthetic**: Tactile Soft Neumorphic (Dual ambient shadows, smooth curved containers, 70% white beveled borders).
* **Color Tokens**:
  * Light Background: Soft Paper `#F4F6F9` | Dark Background: Midnight Slate `#131822`
  * Card Surfaces: `#F4F6F9` (Light) / `#1C2331` (Dark)
  * Inset Wells & Tables: `#E5E7EB` / `#E9EDF4` (Light) / `#161C28` (Dark)
  * Brand Deep Blue: `#2B5B84` | Brand Glow Cyan: `#38BDF8`
  * Primary Indigo CTA: `#4F46E5` | Primary Indigo Light: `#6366F1` | Glow: `rgba(99,102,241,0.25)`
  * Success Emerald CTA: `#10B981` | Emerald Glow: `rgba(16,185,129,0.25)`
  * Amber Warning / Rescue: `#F59E0B` | Light Amber: `#FEF3C7` | Dark Amber: `#D97706`
  * Text Colors: Slate-900 `#1E293B` (Main), Slate-500 `#64748B` (Secondary), Slate-400 `#94A3B8` (Muted)
* **Typography**: `Plus Jakarta Sans` (Brand: 30px w900, Headings: 24px w800, Task: 20px w700, Subtext: 13px, Monospace Time: 12-14px).
* **Elevations**:
  * Soft Card: `[Offset(6,6), blur 14, rgba(166,178,196,0.45)] + [Offset(-6,-6), blur 14, #FFFFFF]`
  * Subtle Pill: `[Offset(3,3), blur 8, rgba(166,178,196,0.45)] + [Offset(-3,-3), blur 8, #FFFFFF]`
  * Inset Well: `[Offset(3,3), blur 6, rgba(166,178,196,0.40)] + [Offset(-3,-3), blur 6, #FFFFFF]`

---

## 3. STITCH INTERACTIVE PROTOTYPE FLOW (STEP-BY-STEP PLAY SEQUENCE)

Google Stitch must generate the screens in this **exact chronological order** and automatically link the interactive hotspots as specified:

```mermaid
graph TD
    S01[SCREEN 01: WelcomeScreen (Start Node)] -->|Click 'Planificar mi Día'| S02[SCREEN 02: DailyAnchorsScreen]
    S01 -->|Click Breathing Brain Button| S06[SCREEN 06: BrainDumpScreen]
    S01 -->|Click 🏆 Vault Icon| S08[SCREEN 08: AchievementsVaultScreen]
    
    S02 -->|Click '+' Button| M01[MODAL 01: AddAnchorDialog]
    S02 -->|Click 'Siguiente'| S03[SCREEN 03: CognitiveSlottingScreen]
    
    S03 -->|After Delay 1.2s (Auto)| S04[SCREEN 04: DailyAgendaScreen]
    
    S04 -->|Click 'Reorganizar Tareas'| S04
    S04 -->|Click 'Continuar'| S05[SCREEN 05: SingleTaskScreen (Step 1)]
    
    S05 -->|Swipe Right >140px OR Click 'Paso Completado'| S05B[SCREEN 05B: SingleTaskScreen (Step 2)]
    S05B -->|Swipe Right >140px OR Click 'Paso Completado'| S07[SCREEN 07: SummaryCelebrationScreen]
    
    S05 -->|Click 'Estoy Bloqueado' OR Pull Down| M02[MODAL 02: CognitiveRescueSheet]
    S05 -->|Click 'Mapa Grafo' (Hub Icon)| M03[MODAL 03: GraphOverviewModal]
    
    S07 -->|Click 'Revisar Baúl de Trofeos'| S08
    S07 -->|Click 'Iniciar Nuevo Volcado'| S06
```

---

## 4. DETAILED SCREEN SPECIFICATIONS IN GENERATION ORDER

### [SCREEN 01 / START NODE] — `WelcomeScreen` (Hero Hub)
* **Visual Hierarchy**:
  * **Top Bar**: Academic badge `"DAM — ITU UNCuyo"` (Left) + 🏆 Vault button (Right) + `ThemeToggleButton`.
  * **Center Hero**: 210x210px Neumorphic circular breathing button (scale 0.96-1.04, cyan/indigo glow over 3.2s) with `assets/images/brain_logo_transparent.png`.
  * **Typography**: `"NEUROTASK"` (30px, w900, spacing 2.0) + `"MOTOR DE FOCO"` (13px, w700, spacing 3.5) + `"Transformá el caos de ideas en un camino lógico y sereno."`
  * **Action Buttons**:
    1. Primary Daily CTA: `"🌅 Planificar mi Día (Bloques y Tareas)"` (Flat Neumorphic Card, Height 48px, Radius 18px).
    2. Subtle Secondary Hint: `"Tocá el cerebro para volcado rápido de ideas"`.
* **Stitch Interaction Links**:
  * `[HOTSPOT: "Planificar mi Día"]` -> **Navigates to SCREEN 02 (`DailyAnchorsScreen`)** via Push Transition.
  * `[HOTSPOT: Center Brain Button]` -> **Navigates to SCREEN 06 (`BrainDumpScreen`)** via Fade Transition (400ms).
  * `[HOTSPOT: 🏆 Vault Icon]` -> **Navigates to SCREEN 08 (`AchievementsVaultScreen`)**.

---

### [SCREEN 02] — `DailyAnchorsScreen` (Figma Prototype Screen 1)
* **Visual Hierarchy**:
  * **Top Bar**: `"NEUROTASK"` (Deep Blue `#2B5B84`, 13px, w800) + `ThemeToggleButton`.
  * **Headings**:
    * Label: `"Bienvenido"` (14px, Bold, Slate-700).
    * Main Question: `"¿Cuáles son tus horarios de hoy?"` (24px, w800, Slate-900).
    * Subtitle: `"Saber tus horarios de hoy ayudará a distribuir mejor tus tareas."` (13px, Slate-500).
  * **TimeSlotTableCard**:
    * Neumorphic container (Radius 24px, Background `#E5E7EB`).
    * Structured rows with divider lines:
      * Row 1: `[08:00 - 12:00]` | `Facultad`
      * Row 2: `[17:30 - 19:30]` | `Gimnasio`
      * Row 3: `[22:00 - 00:00]` | `Cena fuera de casa`
    * Bottom `+` Button: 40x40px circle (`#9CA3AF` with white plus).
  * **Bottom CTA**: Full-width button `"Siguiente"` (Height 54px, Radius 20px, Gradient `#4F46E5` -> `#2B5B84`, White Bold Text).
* **Stitch Interaction Links**:
  * `[HOTSPOT: "+" Button]` -> **Opens MODAL 01 (`AddAnchorDialog`)** as Overlay.
  * `[HOTSPOT: "Siguiente"]` -> **Navigates to SCREEN 03 (`CognitiveSlottingScreen`)** via Smart Animate.

---

### [MODAL 01] — `AddAnchorDialog` (Overlay)
* **Visual Hierarchy**: Centered dialog (Radius 24px, card surface), Title `"Añadir Bloque Fijo"`, inputs for Time Range (Start/End) and Event Name (*"Ej: Trabajo"*), `"Cancelar"` and `"Guardar"` buttons.
* **Stitch Interaction Links**:
  * `[HOTSPOT: "Guardar" / "Cancelar"]` -> **Closes overlay and returns to SCREEN 02**.

---

### [SCREEN 03] — `CognitiveSlottingScreen` (Intermediate Calculation Engine)
* **Visual Hierarchy**:
  * **Top Bar**: `"NEUROTASK"` + `ThemeToggleButton`.
  * **Headings**: `"Calculando Ventanas Libres..."` (22px, Bold) + `"Buscando momentos de menor fatiga mental para tus tareas."` (13px).
  * **Center Engine**: 160x160px Neumorphic pulsing circle with Cyan Halo `#38BDF8` and spinning clock icon.
  * **Live Badges**:
    * `"✓ 3 Bloques fijos protegidos"` (Emerald badge).
    * `"⏳ 4 Ventanas libres detectadas (6h 30m disponibles)"` (Slate badge).
    * `"⚡ Asignando orden lógico según demanda cognitiva..."` (Indigo badge).
* **Stitch Interaction Links**:
  * `[TRIGGER: After Delay 1200ms (Auto)]` -> **Automatically transitions to SCREEN 04 (`DailyAgendaScreen`)**.

---

### [SCREEN 04] — `DailyAgendaScreen` (Figma Prototype Screen 2)
* **Visual Hierarchy**:
  * **Top Bar**: `"NEUROTASK"` + `ThemeToggleButton`.
  * **Headings**: `"Tus tareas de hoy"` (24px, w800) + `"Verificá si tus horarios se adaptan a las tareas."` (13px).
  * **ScheduledTasksCard**:
    * Neumorphic container (Radius 24px, Background `#E5E7EB`).
    * Structured rows with divider lines:
      * Row 1: `[14:00]` | `Hacer la presentación`
      * Row 2: `[15:30]` | `Estudiar`
      * Row 3: `[20:00]` | `Lavar la ropa`
      * Row 4: `[21:00]` | `Tender la ropa`
  * **Bottom Stacked Buttons**:
    1. Secondary: `"Reorganizar Tareas"` (Height 50px, Deep Blue `#0284C7`, White Text).
    2. Primary CTA: `"Continuar"` (Height 54px, Gradient `#006699` -> `#0284C7`, White Bold Text).
* **Stitch Interaction Links**:
  * `[HOTSPOT: "Reorganizar Tareas"]` -> **Triggers instant shuffle animation on SCREEN 04**.
  * `[HOTSPOT: "Continuar"]` -> **Navigates to SCREEN 05 (`SingleTaskScreen`)**.

---

### [SCREEN 05] — `SingleTaskScreen` (1-to-1 Focus Viewport — Step 1)
* **Visual Hierarchy**:
  * **Top Navigation Bar**: `FlowIndicator` (`"Paso 1 de 4"`) + Ruido Marrón audio toggle (🌧️) + Graph Map icon (`Icons.hub_outlined`) + Rescue icon (`Icons.spa_outlined`) + `ThemeToggleButton`.
  * **Section Tag**: `"ESTÁS ENFOCADO EN ESTO AHORA:"` (11px, bold, Slate-400).
  * **Hero Card (`SwipeToCompleteCard`)**:
    * Category: `"PRESENTACIÓN & DISEÑO"`.
    * Task Title: `"Hacer la presentación de DAM ITU"` (20px, bold).
    * Subtext: `"Diseñar las diapositivas clave en Figma según el informe."` (13px).
    * Divider + `ZenTimerWidget` (`"Tiempo de Flujo: 25 min"` | MM:SS | `"| Sin apuros"`).
  * **Time Guardian Status Pill**: `"🛡️ Horario asignado: 14:00 - 15:15 | Siguiente bloque fijo: Gym a las 17:30"`.
  * **Swipe Hint**: `"👉 Deslizá la tarjeta hacia la derecha para completar"`.
  * **Buttons**: `"Paso Completado"` (Success Emerald, 56px) + `"Estoy Bloqueado / Dividir más"` (Flat Amber, 48px).
* **Stitch Interaction Links**:
  * `[HOTSPOT: Swipe Right >140px OR Click "Paso Completado"]` -> **Advances to SCREEN 05B (Step 2: "Estudiar")**.
  * `[HOTSPOT: "Estoy Bloqueado" / Pull Down]` -> **Opens MODAL 02 (`CognitiveRescueSheet`)**.
  * `[HOTSPOT: Graph Map Icon]` -> **Opens MODAL 03 (`GraphOverviewModal`)**.

---

### [SCREEN 05B] — `SingleTaskScreen` (Step 2: "Estudiar")
* Same layout as Screen 05 with updated content: `FlowIndicator ("Paso 2 de 4")`, Title `"Estudiar temas teóricos de la unidad 1"`.
* **Stitch Interaction Links**:
  * `[HOTSPOT: Swipe Right / Click "Paso Completado"]` -> **Navigates to SCREEN 07 (`SummaryCelebrationScreen`)**.

---

### [MODAL 02] — `CognitiveRescueSheet` (BottomSheet Overlay)
* **Visual Hierarchy**: BottomSheet (Radius 36px), Title `"Descompresión y Rescate Cognitivo"`, 3 Option Cards:
  1. `"Subdividir en micro-pasos de 3 min"` (Badge 1 Indigo).
  2. `"Activar Modo Baja Energía"` (Badge 2 Amber).
  3. `"Saltar a rama independiente"` (Badge 3 Emerald).
* **Stitch Interaction Links**:
  * `[HOTSPOT: Any Option]` -> **Closes sheet and applies change in SCREEN 05**.

---

### [MODAL 03] — `GraphOverviewModal` (BottomSheet Overlay)
* **Visual Hierarchy**: BottomSheet with Title `"Mapa del Grafo (Tus ideas)"`, Toggle Button `"Ver Lista" / "Ver Grafo"`, 2D interactive DAG canvas with animated Bézier curves and cyan active halo.
* **Stitch Interaction Links**:
  * `[HOTSPOT: "Cerrar Mapa"]` -> **Closes modal and returns to SCREEN 05**.

---

### [SCREEN 06] — `BrainDumpScreen` (Free-Form Ingestion Flow)
* **Visual Hierarchy**: Header `"Descompresión Cognitiva"`, Title `"¿Qué ronda por tu cabeza?"`, Example Pills (`"🎓 Entrega DAM"`, `"📱 Flutter"`), 220px Inset Text Area with Floating Mic Button, Primary CTA `"Descomprimir y Secuenciar"`.
* **Stitch Interaction Links**:
  * `[HOTSPOT: Mic Button]` -> **Opens Voice Dictation BottomSheet**.
  * `[HOTSPOT: "Descomprimir y Secuenciar"]` -> **Navigates to SCREEN 05 via 1300ms Processing Dialog**.

---

### [SCREEN 07] — `SummaryCelebrationScreen` (Victory & Reward)
* **Visual Hierarchy**:
  * Top Badge `"Objetivo Conquistado"` + 🏆 Vault button.
  * 90x90px Neumorphic Card with Emerald Glow and 🏆 emoji (44px).
  * Title `"¡Flujo Completado!"` (24px, bold).
  * 3 Metric Cards: `🎯 4 / 4 Nodos Logrados` | `⏳ 1h 25m Tiempo Real` | `🌿 100% Calma Mental`.
  * `CognitiveInsightCard`: Dual reward callout (`"⚡ ¡Modo Hiperfoco Conquistado! Ganaste ~35 min de libertad mental"`).
  * Buttons: `"Compartir / Copiar Logro"` (Success) + `"Revisar Baúl de Trofeos"` (🏆) + `"Iniciar Nuevo Volcado (Brain Dump)"`.
* **Stitch Interaction Links**:
  * `[HOTSPOT: "Revisar Baúl de Trofeos"]` -> **Navigates to SCREEN 08 (`AchievementsVaultScreen`)**.
  * `[HOTSPOT: "Iniciar Nuevo Volcado"]` -> **Navigates to SCREEN 06 (`BrainDumpScreen`)**.

---

### [SCREEN 08] — `AchievementsVaultScreen` (10 Trophy Vault)
* **Visual Hierarchy**: Top Bar with Back Button and Title `"BAÚL DE LOGROS"`, Progress Card (`"4 de 10 Conquistados"` + Emerald Progress Bar), Category Filter Chips (`"Todos"`, `"🎯 Foco"`, `"🌱 Resiliencia"`, `"🌿 Calma"`, `"🧠 Exploración"`, `"👑 Maestría"`), 10 Neumorphic Trophy Cards.
* **Stitch Interaction Links**:
  * `[HOTSPOT: Back Button]` -> **Returns to previous screen**.
  * `[HOTSPOT: Trophy Card]` -> **Opens Trophy Detail Dialog Overlay**.

---

## 5. SUMMARY OF STITCH PLAY MODE EXECUTION
When the user presses **Play / Present**:
1. Starts at **SCREEN 01 (`WelcomeScreen`)**.
2. Click `"Planificar mi Día"` -> Smoothly slides to **SCREEN 02 (`DailyAnchorsScreen`)**.
3. Click `"Siguiente"` -> Shows **SCREEN 03 (`CognitiveSlottingScreen`)** calculating for 1.2s.
4. Auto-opens **SCREEN 04 (`DailyAgendaScreen`)** showing mapped tasks.
5. Click `"Continuar"` -> Enters **SCREEN 05 (`SingleTaskScreen`)** in 1-to-1 focus mode.
6. Swipe or Click `"Paso Completado"` -> Advances tasks and lands on **SCREEN 07 (`SummaryCelebrationScreen`)**.
7. Click `"Revisar Baúl de Trofeos"` -> Explores **SCREEN 08 (`AchievementsVaultScreen`)**.
