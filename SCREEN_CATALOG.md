# SCREEN CATALOG: NeuroTask (Complete Screen & Modal Inventory)

> **Document**: `SCREEN_CATALOG.md`  
> **Source-of-Truth**: `Joni23s/NeuroTask_beta00`  
> **Classification**: 100% VERIFIED FROM SOURCE CODE  

---

## 1. Summary Matrix of Surfaces

| Surface Identifier | Formal Name | Route / Access | Type | Key Components / Features |
| :--- | :--- | :--- | :--- | :--- |
| `SCR_01` | **`WelcomeScreen`** | `/` (Home Root) | Full Screen | Hero Breathing Brain Button (210px), Resume Banner, Trophy Vault Shortcut, Theme Toggle |
| `SCR_02` | **`BrainDumpScreen`** | `Navigator.push` from `SCR_01` | Full Screen | Inset Text Area (220px), Example Chips, Live Mic Trigger, Empathetic Empty Validation |
| `MDL_01` | **`VoiceDictationSheet`** | BottomSheet from `SCR_02` | Modal BottomSheet | Pulsing Mic (86px), 14 Live Soundwave Bars, Real-time Transcript Stream Box |
| `MDL_02` | **`ProcessingDialog`** | Dialog from `SCR_02` | Modal Dialog | 1300ms Breathing Spinner, Logic Graph Construction Status |
| `SCR_03` | **`SingleTaskScreen`** | `pushReplacement` from `SCR_02` | Full Screen | 1-to-1 Focus Viewport, `SwipeToCompleteCard`, Zen Timer, Ambient Brown Noise, Rescue Trigger |
| `MDL_03` | **`CognitiveRescueSheet`** | BottomSheet from `SCR_03` | Modal BottomSheet | 3 Rescue Options: Split 3m micro-steps, Low Energy Mode, Skip Branch |
| `MDL_04` | **`GraphOverviewModal`** | BottomSheet from `SCR_03`/`SCR_04` | Modal BottomSheet | Interactive 2D DAG Tree (`DagCanvasWidget`) + Structured List View Toggle |
| `SCR_04` | **`SummaryCelebrationScreen`** | Auto-transition on last task | Full Screen | 🏆 90px Hero Card, Real Measured Metrics, `CognitiveInsightCard`, Markdown Export |
| `MDL_05` | **`ReportPreviewDialog`** | Dialog from `SCR_04` | Modal Dialog | Formatted Text Monospace Preview + Clipboard Copy Action |
| `SCR_05` | **`AchievementsVaultScreen`** | `Navigator.push` from `SCR_01`/`SCR_04`| Full Screen | Progress Indicator, Category Filter Chips, 10 Cognitive Trophy Cards |
| `MDL_06` | **`AchievementDetailDialog`** | Dialog from `SCR_05` | Modal Dialog | 76px Trophy Circle, Unlock Status Pill, Cognitive Impact Insight Callout |

---

## 2. Detailed Screen Specifications

```
WelcomeScreen (SCR_01)
├── TopHeader
│   ├── AcademicBadge ("DAM — ITU UNCuyo")
│   └── TopActionsRow
│       ├── TrophyVaultButton ("🏆") -> Navigates to SCR_05
│       └── ThemeToggleButton (Light/Dark Toggle)
├── HeroCenter
│   ├── BreathingBrainButton (210x210px Circle, Scale 0.96-1.04, Glow 0.20-0.55) -> Navigates to SCR_02
│   │   └── Image ("assets/images/brain_logo_transparent.png")
│   ├── BrandTitle ("NEUROTASK", 30px, w900, Spacing 2.0)
│   ├── BrandSubtitle ("MOTOR DE FOCO", 13px, w700, Spacing 3.5)
│   └── PhilosophyCopy ("Transformá el caos de ideas en un camino lógico y sereno.")
└── BottomActions
    ├── ResumeActiveSessionBanner ("Reanudar paso X: [Task Title]") [Conditional] -> Navigates to SCR_03
    └── TapHintPill ("Tocá el cerebro para descomprimir tu mente", Icons.touch_app_rounded) -> Navigates to SCR_02
```

```
BrainDumpScreen (SCR_02)
├── TopHeader
│   ├── SectionBadge ("Descompresión Cognitiva")
│   └── HeaderRight
│       ├── BrandLabel ("NEUROTASK")
│       └── ThemeToggleButton
├── Headings
│   ├── Title ("¿Qué ronda por tu cabeza?", 24px, bold)
│   └── Subtitle ("Escribí o dictá libremente. El sistema ordenará el camino lógico.")
├── PresetRow
│   ├── Label ("Ejemplos: ")
│   ├── PresetChip1 ("🎓 Entrega DAM")
│   └── PresetChip2 ("📱 Flutter")
├── InsetTextAreaContainer (Height 220px, pressedElevation, Inset Surface)
│   ├── TextField (maxLines: null, expands: true, Placeholder: "Ej: Tengo que testear los endpoints...")
│   └── FloatingMicButton (44x44px, Icons.mic_rounded) -> Opens MDL_01
├── EmpatheticValidationHint ("Escribí algunas palabras o elegí un ejemplo arriba 👆 para comenzar.") [Conditional]
└── SubmitButton ("Descomprimir y Secuenciar", NeumorphicButtonVariant.primary, 56px) -> Triggers MDL_02 -> SCR_03
```

```
VoiceDictationSheet (MDL_01)
├── DragHandleBar (44x4px, Radius 2)
├── CentralMicPulsingCircle (86x86px, Scale modulated by live dB, Glow Cyan)
├── StatusTitle ("🎙️ Escuchando tu voz..." / "⏸️ Dictado en pausa")
├── StatusDescription ("Hablá con tranquilidad. El sistema convertirá tu voz en texto en vivo.")
├── SoundwaveVisualizer (14 Bars, Animated height 6px to 42px reacting to audio dB)
├── LiveTranscriptionWell (Inset box with real-time text stream)
└── ActionButtonsRow
    ├── CancelButton ("Cancelar", NeumorphicButtonVariant.flat)
    └── ConfirmButton ("Usar este Dictado", NeumorphicButtonVariant.primary)
```

```
SingleTaskScreen (SCR_03) - 1-to-1 Focus Viewport
├── TopNavigationBar
│   ├── FlowIndicator ("Paso X de Y", Green dot indicator)
│   └── SensoryControlsRow
│       ├── AmbientSoundToggle (Icons.cloud_outlined / Icons.cloud_queue_rounded) -> Synthesizes Brown Noise
│       ├── GraphMapButton (Icons.hub_outlined) -> Opens MDL_04
│       ├── RescueButton (Icons.spa_outlined) -> Opens MDL_03
│       └── ThemeToggleButton
├── SectionTag ("ESTÁS ENFOCADO EN ESTO AHORA:", 11px, bold, Slate-400)
├── SwipeToCompleteCard (Hero Task Card with Horizontal Drag >140px & Vertical Drag >70px)
│   ├── DecorativePill (36x4px)
│   ├── CategoryHeaderRow
│   │   ├── CategoryLabel (Uppercase, 11px, bold)
│   │   └── AtomicMicroStepBadge ("Micro-Paso (3m)", Amber Light) [Conditional]
│   ├── TaskTitle (20px, bold, height 1.3)
│   ├── TaskSubtext (13px, secondary slate)
│   ├── DividerLine
│   └── ZenTimerWidget (Pulsing ring 4s, "Tiempo de Flujo: X min", Monospace Time MM:SS, "| Sin apuros")
├── SwipeHint ("👉 Deslizá la tarjeta hacia la derecha para completar")
└── ActionButtons
    ├── StepCompletedButton ("Paso Completado", NeumorphicButtonVariant.success, 56px) -> Advances to next / SCR_04
    └── StuckRescueButton ("Estoy Bloqueado / Dividir más", NeumorphicButtonVariant.flat, Amber icon) -> Opens MDL_03
```

```
CognitiveRescueSheet (MDL_03)
├── DragHandleBar (48x4px)
├── Title ("Descompresión y Rescate Cognitivo", 18px, bold)
├── Subtitle ("Elegí cómo querés continuar sin culpas ni presiones.")
├── RescueOption1 (Badge '1' Indigo, "Subdividir en micro-pasos de 3 min", "Desarma la tarea en un paso mínimo para arrancar ya.")
├── RescueOption2 (Badge '2' Amber, "Activar Modo Baja Energía", "Reordena el grafo para hacer únicamente lo menos demandante.")
├── RescueOption3 (Badge '3' Emerald, "Saltar a rama independiente", "Avanzá por otra tarea desbloqueada sin bloquear el flujo.")
└── BackToTaskButton ("Volver a la tarea")
```

```
GraphOverviewModal (MDL_04)
├── DragHandleBar (48x4px)
├── HeaderRow
│   ├── Titles ("Mapa del Grafo (Tus ideas)", "Secuencia topológica calculada")
│   └── ViewToggleButton ("Ver Lista" / "Ver Grafo")
├── ViewportContainer (Max Height 360px)
│   ├── DagCanvasWidget (2D Interactive Viewer 0.75x-2.2x, Node Capsules 150x62px, Bézier Curves, Active Glow Halo)
│   └── ListView (Structured step cards with status numbers/checks, categories, minutes, titles)
└── CloseButton ("Cerrar Mapa")
```

```
SummaryCelebrationScreen (SCR_04)
├── TopHeader
│   ├── Badge ("Objetivo Conquistado")
│   └── Actions (Trophy Vault 🏆 + ThemeToggle)
├── HeroCenter
│   ├── TrophyContainer (90x90px Neumorphic Card with Emerald Glow, 🏆 emoji 44px)
│   ├── Title ("¡Flujo Completado!", 24px, bold)
│   └── Subtitle ("Completaste todos los pasos del camino lógico sin sobrecarga sensorial ni parálisis ejecutiva.")
├── MetricsRow (3 Measured Real Cards)
│   ├── Card1 ("🎯", "$totalNodes / $totalNodes", "Nodos Logrados")
│   ├── Card2 ("⏳", "$formattedRealTime", "Tiempo Real")
│   └── Card3 ("🌿", "100%", "Calma Mental")
├── CognitiveInsightCard (Dual Reward: Hyperfocus ⚡ vs Resilience 🌱 vs Harmony 🎯)
└── ActionsColumn
    ├── ShareReportButton ("Compartir / Copiar Logro", NeumorphicButtonVariant.success) -> Copies Markdown
    ├── SubActionsRow
    │   ├── ViewReportButton ("Ver Reporte", Icons.description_outlined) -> Opens MDL_05
    │   └── GraphMapButton ("Mapa Grafo", Icons.hub_outlined) -> Opens MDL_04
    ├── VaultShortcutButton ("Revisar Baúl de Trofeos", 🏆) -> Navigates to SCR_05
    └── ResetCTA ("Iniciar Nuevo Volcado (Brain Dump)", NeumorphicButtonVariant.primary) -> Navigates to SCR_02
```

```
AchievementsVaultScreen (SCR_05)
├── TopBar
│   ├── BackButton (Icons.arrow_back_ios_new_rounded)
│   ├── Title ("BAÚL DE LOGROS", 14px, w800, Spacing 1.2)
│   └── ThemeToggleButton
├── ProgressOverviewCard
│   ├── Header ("$unlockedCount de $totalCount Conquistados", "Progreso cognitivo: X%")
│   └── ProgressBar (LinearProgressIndicator, Emerald)
├── CategoryFilterPills (Scrollable Horizontal: "Todos", "🎯 Foco", "🌱 Resiliencia", "🌿 Calma", "🧠 Exploración", "👑 Maestría")
└── AchievementsListView (10 Trophy Items with Unlocked/Locked State, Emojis, Titles, Descriptions) -> Tap opens MDL_06
```
