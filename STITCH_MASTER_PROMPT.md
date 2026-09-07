# STITCH MASTER PROMPT: NeuroTask (100% High-Fidelity UI/UX Reconstruction)

> **Execution Directive for Google Stitch**: Reconstruct the entire NeuroTask application with 100% pixel-perfect and behavioral fidelity. Do NOT redesign, do NOT simplify, do NOT invent missing UI, copy, or navigation. Adhere strictly to the reverse-engineered specifications below.

---

## 1. Product Identity & Core Purpose
* **Application Title**: `NeuroTask: Motor de Foco`
* **Academic Affiliation**: `DAM — ITU UNCuyo` (Desarrollo de Aplicaciones Móviles, Instituto Tecnológico Universitario, Universidad Nacional de Cuyo)
* **Target Audience**: Neurodivergent students and professionals (ADHD/TDAH, executive dysfunction, cognitive fatigue).
* **Motto / Value Proposition**: *"Transformá el caos de ideas en un camino lógico y sereno."* / *"Menos ruido mental, más foco sereno."*
* **Core Mechanisms**:
  1. **Brain Dump Ingestion**: Free-form text and live voice dictation.
  2. **Intelligent DAG Engine**: Directed Acyclic Graph with Kahn's topological sort for dependency resolution.
  3. **Strict 1-to-1 Focus Viewport**: View only the current atomic step with zero peripheral distraction.
  4. **Non-Violent Zen Time**: Progressive flow timer (`"Tiempo de Flujo" | "Sin apuros"`).
  5. **Cognitive Rescue**: Instant micro-step subdivision (3-minute tasks) and Low Energy reordering.
  6. **Empathetic Neuro-Affirming Reinforcement**: 10-trophy achievements vault with persistent storage and Dual-Outcome completion insights.

---

## 2. Design Language & Visual Atmosphere
* **Style**: Tactile Soft Neumorphic Double-Elevation with Curved Organic Containers and Beveled Borders.
* **Canvas Modes**:
  * **Light Soft Paper**: Background `#F4F6F9`, crisp white top-left highlights (`#FFFFFF`), soft slate bottom-right shadows (`rgba(166, 178, 196, 0.45)`), 70% white beveled borders.
  * **Dark Soft Slate**: Midnight slate background `#131822`, card surface `#1C2331`, inset surface `#161C28`, 60% black depth shadows, 8-10% white top-left ridge highlights, and glowing cyan `#38BDF8` accents.

---

## 3. Global Color Tokens & Roles

```
AppColors.background          = #F4F6F9 (Light Paper Canvas)
AppColors.cardSurface         = #F4F6F9 (Light Elevated Neumorphic Cards & Buttons)
AppColors.pressedSurface      = #E9EDF4 (Light Inset Wells & Text Area)

AppColors.darkBackground      = #131822 (Dark Slate Canvas)
AppColors.darkCardSurface     = #1C2331 (Dark Elevated Cards & Buttons)
AppColors.darkPressedSurface  = #161C28 (Dark Inset Wells & Text Area)

AppColors.brandDeepBlue       = #2B5B84 (Isotype & Title Primary Blue)
AppColors.brandSteelBlue      = #4A7D9D (Subtitle Steel Blue)
AppColors.brandGlowCyan       = #38BDF8 (Active DAG Halo & Dark Mode Accent)
AppColors.brandGlowLight      = #E0F2FE (Soft Cyan Wash)

AppColors.primaryIndigo       = #4F46E5 (Primary Action CTA Gradient End)
AppColors.primaryIndigoLight  = #6366F1 (Primary Action CTA Gradient Start)
AppColors.indigoGlow          = rgba(99, 102, 241, 0.25) (Primary CTA Elevation Glow)

AppColors.successEmerald      = #10B981 (Success Action CTA Gradient Start & Progress)
AppColors.successEmeraldDark  = #059669 (Success Action CTA Gradient End)
AppColors.emeraldGlow         = rgba(16, 185, 129, 0.25) (Success & Trophy Glow)

AppColors.amberWarning        = #F59E0B (Cognitive Rescue Button Accent)
AppColors.amberLight          = #FEF3C7 (Micro-Step Pill Background)
AppColors.amberDark           = #D97706 (Micro-Step Pill Typography & Icon)

AppColors.textMain            = #1E293B (Primary Text Slate-900)
AppColors.textSecondary       = #64748B (Secondary Text Slate-500)
AppColors.textMuted           = #94A3B8 (Hints & Disabled Text Slate-400)

AppColors.darkTextMain        = #F8FAFC (Dark Mode Primary Text Slate-50)
AppColors.darkTextSecondary   = #94A3B8 (Dark Mode Secondary Text Slate-400)
AppColors.darkTextMuted       = #64748B (Dark Mode Muted Text Slate-500)

AppColors.shadowDark          = rgba(166, 178, 196, 0.45) (Light Ambient Depth Shadow)
AppColors.shadowLight         = #FFFFFF (Light Surface Specular Highlight)
AppColors.borderLight         = rgba(255, 255, 255, 0.70) (70% White Bevel Border)
```

---

## 4. Typography System
* **Primary Family**: `Plus Jakarta Sans`
* **Monospace Family**: `Courier` / `monospace` (Timer & Export Report)
* **Scale**:
  * **Brand Title**: 30px, w900, letter-spacing: 2.0px.
  * **Brand Subtitle**: 13px, w700, letter-spacing: 3.5px.
  * **Screen Title**: 24px, w700, line-height: 1.2.
  * **Task Title**: 20px, w700, line-height: 1.3.
  * **Modal Title**: 18px, w700.
  * **Primary CTA Label**: 15px, w700, white text.
  * **Body Main**: 14px, w400, line-height: 1.5.
  * **Body Subtext**: 13px, w400, line-height: 1.4.
  * **Category Badges**: 11px, w700, uppercase, letter-spacing: 0.8-1.1px.
  * **Timer Monospace**: 12px, w700, monospace.
  * **Meta / Subtitle**: 11px, w500.

---

## 5. Shape, Elevation & Shadows
* **Border Radii**:
  * Welcome Hero Brain: Circle (`BoxShape.circle`, Diameter 210px).
  * Main Task Hero Card & Bottom Sheets: `32px` / `36px`.
  * Neumorphic Cards & Dialogs: `24px` / `28px`.
  * CTA Buttons: `20px` (Primary/Success), `18px` (Rescue), `14px` (Pills).
  * Small Status Badges: `16px` / `14px` / `10px`.
* **Elevation Shadow Matrices**:
  * `softElevation`: `[Offset(6,6), blur 14, #A6B2C4 (0.45)] + [Offset(-6,-6), blur 14, #FFFFFF]`
  * `subtleElevation`: `[Offset(3,3), blur 8, #A6B2C4 (0.45)] + [Offset(-3,-3), blur 8, #FFFFFF]`
  * `pressedElevation`: `[Offset(3,3), blur 6, #A6B2C4 (0.40)] + [Offset(-3,-3), blur 6, #FFFFFF]`
  * `darkSoftElevation`: `[Offset(6,6), blur 16, #000000 (0.60)] + [Offset(-4,-4), blur 12, #FFFFFF (0.08)]`
  * `darkSubtleElevation`: `[Offset(3,3), blur 8, #000000 (0.60)] + [Offset(-2,-2), blur 6, #FFFFFF (0.08)]`
  * `darkPressedElevation`: `[Offset(3,3), blur 6, #000000 (0.80)] + [Offset(-2,-2), blur 4, #FFFFFF (0.05)]`

---

## 6. Core Component Matrix

### 6.1 `NeumorphicButton`
* **Variants**:
  * `primary`: LinearGradient `[#6366F1 -> #4F46E5]`, radius 20, glow `indigoGlow`, white bold text.
  * `success`: LinearGradient `[#10B981 -> #059669]`, radius 20, glow `emeraldGlow`, white bold text.
  * `flat`: Surface color, subtle elevation, bevel border, dark text.
  * `pressed`: Inset surface, pressed elevation, bevel border.
* **Interaction**: `onTapDown` transforms state into `_isPressed = true` with `HapticFeedback.lightImpact()`, swapping shadows to `pressedElevation` over 140ms.

### 6.2 `SwipeToCompleteCard`
* **Stack Anatomy**:
  * **Background Reveal Surface**: Appears when `dragOffset > 10px`. Background `#10B981` (alpha 0.15 to 0.75), 44px circle check icon with emerald glow, copy toggles from `"Deslizá para completar..."` to `"¡Soltá para completar!"` at 95% threshold (threshold: 140px).
  * **Foreground Card**: Neumorphic card with Matrix4 translation `(dragOffset, verticalDragOffset * 0.4, 0.0)`.
  * **Horizontal Gesture**: Triggers `onSwipeCompleted()` at 140px drag with `HapticFeedback.mediumImpact()`.
  * **Vertical Downward Gesture**: Triggers `onPullRescue()` at 70px vertical drag with `HapticFeedback.heavyImpact()`.

### 6.3 `FlowIndicator`
* **Anatomy**: Pill container with `subtleElevation`, 8px emerald circle, text: `"Paso X de Y"` (size 12, bold).

### 6.4 `ZenTimerWidget`
* **Anatomy**: Row with pulsating purple ring (14px to 18px over 4s), label `"Tiempo de Flujo: X min"`, live elapsed time in monospace font (MM:SS), and reassuring tag `"| Sin apuros"`.

### 6.5 `ThemeToggleButton`
* **Anatomy**: 38x38px rounded square (radius 14), subtle elevation, AnimatedSwitcher with ScaleTransition toggling between `Icons.dark_mode_rounded` (Blue) and `Icons.light_mode_rounded` (Amber `#FBBF24`).

### 6.6 `DagCanvasWidget` / `_TreeDagPainter`
* **Anatomy**: 2D Interactive DAG tree inside `InteractiveViewer` (0.75x to 2.2x zoom). Nodes rendered as 150x62px capsules with left status badge (`✓`, `▶`, or index number), category, minutes, and title. Edges rendered as smooth cubic Bézier curves with directional arrowheads (completed = emerald, active = gradient emerald to indigo/cyan, inactive = muted slate). Active node features a breathing glow halo (radius 4 to 7px, 1800ms period).

---

## 7. Complete Screen Specifications

### Screen 1: `WelcomeScreen`
* **Top Bar**:
  * Left: Badge `'DAM — ITU UNCuyo'` with dot indicator.
  * Right: 🏆 Trophy Vault button (38x38 circle) + `ThemeToggleButton`.
* **Center Hero**:
  * 210x210px Neumorphic circular breathing button (scale 0.96 to 1.04, glow 0.20 to 0.55 over 3200ms).
  * Asset: `assets/images/brain_logo_transparent.png` (Fallback: `Icons.psychology_rounded`).
  * Title: `'NEUROTASK'` (30px, w900, spacing 2.0).
  * Subtitle: `'MOTOR DE FOCO'` (13px, w700, spacing 3.5).
  * Copy: `'Transformá el caos de ideas en un camino lógico y sereno.'`
* **Bottom Actions**:
  * If active session exists: Resume banner `'Reanudar paso X: [Task Title]'` (Emerald wash pill with play icon).
  * Interactive Hint Pill: `'Tocá el cerebro para descomprimir tu mente'` with `Icons.touch_app_rounded`.

### Screen 2: `BrainDumpScreen`
* **Header**:
  * Badge: `'Descompresión Cognitiva'`.
  * Brand: `'NEUROTASK'` + `ThemeToggleButton`.
* **Headings**:
  * Title: `'¿Qué ronda por tu cabeza?'` (24px, bold).
  * Subtitle: `'Escribí o dictá libremente. El sistema ordenará el camino lógico.'`
* **Preset Buttons**:
  * Row of pills: `'Ejemplos: '` -> `'🎓 Entrega DAM'`, `'📱 Flutter'`.
* **Inset Text Well**:
  * 220px height, inset surface with `pressedElevation`, border amber if empty validation triggered.
  * Placeholder: `'Ej: Tengo que testear los endpoints en Postman, redactar el resumen ejecutivo del informe y armar las 7 diapositivas en Figma...'`
  * Floating Bottom-Right Mic Button: 44x44px rounded square (radius 14) with `Icons.mic_rounded`.
* **Empathetic Validation**:
  * Row with `Icons.info_outline_rounded` + text `'Escribí algunas palabras o elegí un ejemplo arriba 👆 para comenzar.'`
* **CTA Button**:
  * `NeumorphicButtonVariant.primary`, height 56px: `'Descomprimir y Secuenciar'` + `Icons.arrow_forward_rounded`.
* **Processing Dialog**:
  * Triggered on submission for 1300ms. CircularProgressIndicator in primary indigo, title `'Construyendo Grafo Lógico...'`, subtitle `'Eliminando ruido cognitivo y aislando tu primer paso...'`.

### Modal Sheet 1: `VoiceDictationSheet`
* **Anatomy**: Modal BottomSheet (top radius 36px).
* **Center Mic**: 86x86px circle pulsing with live mic volume level + cyan glow halo.
* **Status**: `'🎙️ Escuchando tu voz...'` or `'⏸️ Dictado en pausa (Tocá para hablar)'`.
* **Live Visualizer**: 14 animated soundwave bars (height 6px to 42px) dynamically responding to audio dB input.
* **Live Transcript Box**: Inset well showing real-time transcribed words.
* **Actions**: `'Cancelar'` (Flat) + `'Usar este Dictado'` (Primary Indigo with checkmark).

### Screen 3: `SingleTaskScreen` (1-to-1 Focus Viewport)
* **Top Navigation Bar**:
  * Left: `FlowIndicator` (`'Paso X de Y'`).
  * Right: Ambient Sound Button (`Icons.cloud_outlined` / `Icons.cloud_queue_rounded` toggles Brownian noise), Graph Map Button (`Icons.hub_outlined`), Cognitive Rescue Button (`Icons.spa_outlined`), and `ThemeToggleButton`.
* **Section Tag**: `'ESTÁS ENFOCADO EN ESTO AHORA:'` (11px, bold, uppercase, slate-400).
* **Hero Interactive Task Card** (`SwipeToCompleteCard`):
  * Top decorative pill bar (36x4px).
  * Category label in uppercase + Optional `'Micro-Paso (3m)'` amber badge if atomic substep.
  * Main Task Title (20px, bold, line-height 1.3).
  * Subtext / Context Description (13px, secondary text).
  * Divider line.
  * `ZenTimerWidget` (`'Tiempo de Flujo: X min'` | MM:SS | `'| Sin apuros'`).
* **Swipe Hint**: `'👉 Deslizá la tarjeta hacia la derecha para completar'`.
* **Action Buttons**:
  1. Success CTA (Height 56px): `'Paso Completado'` + `Icons.check_circle_outline`.
  2. Rescue Flat Button (Height 48px): `'Estoy Bloqueado / Dividir más'` + `Icons.help_outline_rounded` (Amber).

### Modal Sheet 2: `CognitiveRescueSheet`
* **Header**: Drag handle + Title `'Descompresión y Rescate Cognitivo'`, Subtitle `'Elegí cómo querés continuar sin culpas ni presiones.'`.
* **3 Structured Option Cards**:
  1. Badge `'1'` (Indigo): `'Subdividir en micro-pasos de 3 min'` — `'Desarma la tarea en un paso mínimo para arrancar ya.'`
  2. Badge `'2'` (Amber): `'Activar Modo Baja Energía'` — `'Reordena el grafo para hacer únicamente lo menos demandante.'`
  3. Badge `'3'` (Emerald): `'Saltar a rama independiente'` — `'Avanzá por otra tarea desbloqueada sin bloquear el flujo.'`
* **Footer**: TextButton `'Volver a la tarea'`.

### Modal Sheet 3: `GraphOverviewModal`
* **Header**: Title `'Mapa del Grafo (Tus ideas)'`, Subtitle `'Secuencia topológica calculada'`, Right View Toggle button (`'Ver Lista'` vs `'Ver Grafo'`).
* **Graph View**: Renders `DagCanvasWidget` 2D interactive topological tree.
* **List View**: Structured `ListView` of `NeumorphicCard` items with step badges, categories, estimated minutes, and titles.
* **Footer**: TextButton `'Cerrar Mapa'`.

### Screen 4: `SummaryCelebrationScreen`
* **Header**: Badge `'Objetivo Conquistado'` + 🏆 Vault button + `ThemeToggleButton`.
* **Hero Celebration Container**: 90x90px Neumorphic card with emerald glow and 🏆 trophy emoji (44px).
* **Headings**: Title `'¡Flujo Completado!'` (24px, bold), Subtitle `'Completaste todos los pasos del camino lógico sin sobrecarga sensorial ni parálisis ejecutiva.'`.
* **3 Measured Metric Cards**:
  1. `'🎯'` | `'$totalNodes / $totalNodes'` | `'Nodos Logrados'`.
  2. `'⏳'` | `'$formattedRealTime'` | `'Tiempo Real'`.
  3. `'🌿'` | `'100%'` | `'Calma Mental'`.
* **Cognitive Insight Card**: Dual-outcome reward card:
  * **Hyperfocus Speed**: `'⚡ ¡Modo Hiperfoco Conquistado!'` — Highlights saved minutes of mental freedom.
  * **Persistence Resilience**: `'🌱 Victoria de Persistencia y Calma'` — Celebrates starting and finishing without abandoning.
  * **Harmonic Balance**: `'🎯 Ritmo y Precisión Armónica'` — Celebrates synchronized estimation and execution.
* **Action Buttons**:
  1. Success Button: `'Compartir / Copiar Logro'` + `Icons.share_rounded` (Copies Markdown report to clipboard with floating SnackBar).
  2. Sub-Row: `'Ver Reporte'` (`Icons.description_outlined`) + `'Mapa Grafo'` (`Icons.hub_outlined`).
  3. Vault Shortcut: `'Revisar Baúl de Trofeos'` (🏆).
  4. Primary Reset CTA: `'Iniciar Nuevo Volcado (Brain Dump)'`.

### Screen 5: `AchievementsVaultScreen`
* **Top Bar**: Back icon (`Icons.arrow_back_ios_new_rounded`), Title `'BAÚL DE LOGROS'`, and `ThemeToggleButton`.
* **Progress Overview Card**: 🏆 icon, `'$unlockedCount de $totalCount Conquistados'`, `'Progreso cognitivo: X%'`, and emerald `LinearProgressIndicator`.
* **Horizontal Filter Chips**: `'Todos'`, `'🎯 Foco'`, `'🌱 Resiliencia'`, `'🌿 Calma'`, `'🧠 Exploración'`, `'👑 Maestría'`.
* **Trophy Catalog (10 Badges)**:
  1. 🧠 `'Descompresión Inicial'` (Exploración): First brain dump.
  2. 🏆 `'Paso a Paso'` (Foco): Complete 1 whole flow.
  3. ⚡ `'Rayo de Hiperfoco'` (Foco): Finish faster than estimated.
  4. 🌱 `'Campeón de Resiliencia'` (Resiliencia): Complete longer than estimated.
  5. 🛡️ `'Rescate Inteligente'` (Resiliencia): Use micro-step split or low energy mode.
  6. 🌙 `'Guardián Nocturno'` (Calma): Complete session in Dark Mode.
  7. 🌧️ `'Burbuja Sensorial'` (Calma): Use Brownian noise ambient audio.
  8. 🎙️ `'Voz y Pensamiento'` (Exploración): Use speech-to-text dictation.
  9. 💎 `'Trilogía Serena'` (Maestría): Complete 3 full flow sessions.
  10. 👑 `'Cerebro NeuroTask'` (Maestría): Unlock 5 or more badges.
* **Trophy Detail Dialog**: Unlocked modal displaying 76px trophy circle, status pill (`'✨ DESBLOQUEADO'` vs `'🔒 BLOQUEADO'`), title, description, and `'Impacto Neuro-Cognitivo:'` insight callout.

---

## 8. Exact Copy & Content Dictionary (Spanish - Argentina)
* All UI strings must match literal source code verbatim:
  * `"Transformá el caos de ideas en un camino lógico y sereno."`
  * `"Tocá el cerebro para descomprimir tu mente"`
  * `"¿Qué ronda por tu cabeza?"`
  * `"Escribí o dictá libremente. El sistema ordenará el camino lógico."`
  * `"Descomprimir y Secuenciar"`
  * `"ESTÁS ENFOCADO EN ESTO AHORA:"`
  * `"👉 Deslizá la tarjeta hacia la derecha para completar"`
  * `"¡Soltá para completar!"` / `"Deslizá para completar..."`
  * `"Paso Completado"`
  * `"Estoy Bloqueado / Dividir más"`
  * `"Subdividir en micro-pasos de 3 min"`
  * `"Activar Modo Baja Energía"`
  * `"Saltar a rama independiente"`
  * `"¡Flujo Completado!"`
  * `"Completaste todos los pasos del camino lógico sin sobrecarga sensorial ni parálisis ejecutiva."`
  * `"Compartir / Copiar Logro"`
  * `"Iniciar Nuevo Volcado (Brain Dump)"`
  * `"BAÚL DE LOGROS"`
  * `"DAM — ITU UNCuyo"`

---

## 9. Explicit Prohibitions & Constraints
1. **DO NOT REDESIGN** the visual hierarchy or change the soft neumorphic double-shadow elevation into flat standard Material cards.
2. **DO NOT INVENT** countdown timer panic elements (no red countdown rings, no alarm sounds).
3. **DO NOT DISPLAY** multiple concurrent tasks on the focus screen. The 1-to-1 focus viewport is a core architectural requirement.
4. **DO NOT SUBSTITUTE** Spanish (Argentina) copy with generic English or paraphrased text.
5. **DO NOT OMIT** the Web Audio Brownian noise acoustic synthesizer or the 10-badge achievements vault.
