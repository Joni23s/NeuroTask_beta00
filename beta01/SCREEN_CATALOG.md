# SCREEN CATALOG: NeuroTask Beta 0.1 (Unified Screen & Modal Inventory)

> **Document**: `beta01/SCREEN_CATALOG.md`  
> **Source-of-Truth**: `NeuroTask Beta 0.1 Architecture`  
> **Classification**: 100% UNIFIED SPECIFICATION (Figma Time-Blocking + Existing NeuroTask Engine)  

---

## 1. Unified Surface Matrix

| Identifier | Formal Name | Route / Trigger | Type | Functional Role |
| :--- | :--- | :--- | :--- | :--- |
| `SCR_01` | **`WelcomeScreen`** | `/` (Home Root) | Full Screen | Hero Hub: Botón Cerebro respiratorio (210px), Acceso directo a Planificar Día, Reanudar sesión y Baúl 🏆 |
| `SCR_02A` | **`DailyAnchorsScreen`** [NUEVO] | Tap "Planificar mi Día" en `SCR_01` | Full Screen | Definición de bloques fijos de rutina (*Facultad, Gym, Cena*) con botón `+` |
| `MDL_01A` | **`AddAnchorDialog`** [NUEVO] | Tap `+` en `SCR_02A` | Modal Dialog | Selector rápido de hora de inicio, hora de fin y nombre del compromiso |
| `SCR_02B` | **`CognitiveSlottingScreen`** [NUEVO]| Tap "Siguiente" en `SCR_02A` | Full Screen | Motor de cálculo intermedio: detección de ventanas libres y calce sin fatiga |
| `SCR_02C` | **`DailyAgendaScreen`** [NUEVO] | Transición desde `SCR_02B` | Full Screen | Agenda protegida de tareas (*14:00 Presentación, 15:30 Estudiar*) con "Reorganizar" y "Continuar" |
| `SCR_03` | **`BrainDumpScreen`** | Tap Botón Cerebro en `SCR_01` | Full Screen | Volcado libre de ideas (texto + dictado por voz) y secuenciación DAG |
| `MDL_02` | **`VoiceDictationSheet`** | Tap Micrófono en `SCR_03` | Modal BottomSheet | Dictado por voz en vivo, 14 barras de onda sonoras y transcripción reactiva |
| `MDL_03` | **`ProcessingDialog`** | Tap "Descomprimir" en `SCR_03` | Modal Dialog | Construcción serena del grafo lógico (1300ms) |
| `SCR_04` | **`SingleTaskScreen`** | Entrada desde `SCR_02C` o `MDL_03` | Full Screen | Viewport 1 a 1 de foco extremo, `SwipeToCompleteCard`, Zen Timer, Ruido Marrón y Guardián de Foco |
| `MDL_04` | **`CognitiveRescueSheet`** | Tap Rescate / Swipe Abajo en `SCR_04`| Modal BottomSheet | 3 Opciones de descompresión: Micro-pasos de 3m, Modo Baja Energía, Saltar Rama |
| `MDL_05` | **`GraphOverviewModal`** | Tap Mapa Grafo en `SCR_04`/`SCR_05`| Modal BottomSheet | Lienzo interactivo 2D (`DagCanvasWidget`) con curvas Bézier y alternancia a Lista |
| `MDL_06` | **`TimeGuardianAlertModal`** [NUEVO]| Intento de tarea en horario fijo | Modal Dialog | Alerta empática: *"Ahora estás en tu bloque de Gimnasio. Guardamos tu idea para las 20:00"* |
| `SCR_05` | **`SummaryCelebrationScreen`** | Finalización del último paso | Full Screen | 🏆 Hero de 90px, Métricas reales medidas, `CognitiveInsightCard` y Exportación Markdown |
| `MDL_07` | **`ReportPreviewDialog`** | Tap "Ver Reporte" en `SCR_05` | Modal Dialog | Previsualización en tipografía monospace y copiado directo al portapapeles |
| `SCR_06` | **`AchievementsVaultScreen`** | Tap 🏆 en `SCR_01` o `SCR_05` | Full Screen | Baúl de 10 trofeos con barra de progreso, filtros por categoría y modal de detalle |
| `MDL_08` | **`AchievementDetailDialog`** | Tap en un trofeo de `SCR_06` | Modal Dialog | Detalle del hito, badge de desbloqueo y callout de Impacto Neuro-Cognitivo |

---

## 2. Hierarchical Screen Trees & Specs

```
WelcomeScreen (SCR_01)
├── TopHeader
│   ├── AcademicBadge ("DAM — ITU UNCuyo")
│   └── TopActionsRow
│       ├── TrophyVaultButton ("🏆") -> Navigates to SCR_06
│       └── ThemeToggleButton (Light/Dark Toggle)
├── HeroCenter
│   ├── BreathingBrainButton (210x210px Circle, Scale 0.96-1.04, Glow 0.20-0.55) -> Navigates to SCR_03
│   │   └── Image ("assets/images/brain_logo_transparent.png")
│   ├── BrandTitle ("NEUROTASK", 30px, w900, Spacing 2.0)
│   ├── BrandSubtitle ("MOTOR DE FOCO", 13px, w700, Spacing 3.5)
│   └── PhilosophyCopy ("Transformá el caos de ideas en un camino lógico y sereno.")
└── BottomDualWorkflowActions
    ├── DailyRoutineButton ("🌅 Planificar mi Día (Bloques y Tareas)", NeumorphicButtonVariant.flat, 48px) -> Navigates to SCR_02A
    ├── ResumeActiveSessionBanner ("Reanudar paso X: [Task Title]") [Conditional] -> Navigates to SCR_04
    └── TapHintPill ("Tocá el cerebro para volcado rápido de ideas", Icons.touch_app_rounded) -> Navigates to SCR_03
```

```
DailyAnchorsScreen (SCR_02A) - Figma Prototype Screen 1
├── TopHeader
│   ├── BrandTitle ("NEUROTASK", 13px, w800, Deep Blue)
│   └── ThemeToggleButton
├── Headings
│   ├── SmallLabel ("Bienvenido", 14px, bold, Slate-700)
│   ├── MainQuestion ("¿Cuáles son tus horarios de hoy?", 24px, w800, Slate-900)
│   └── Subtitle ("Saber tus horarios de hoy ayudará a distribuir mejor tus tareas.", 13px, Slate-500)
├── TimeSlotTableCard (Neumorphic Elevated Container, Radius 24px, BG #E5E7EB)
│   ├── Row1 (`[08:00 - 12:00]` | `Facultad`)
│   ├── DividerLine
│   ├── Row2 (`[17:30 - 19:30]` | `Gimnasio`)
│   ├── DividerLine
│   ├── Row3 (`[22:00 - 00:00]` | `Cena fuera de casa`)
│   └── BottomAddArea
│       └── AddSlotButton (Circular 40x40px, #9CA3AF, Plus Icon) -> Opens MDL_01A
└── BottomCTA
    └── NextButton ("Siguiente", NeumorphicButtonVariant.primary, 54px) -> Navigates to SCR_02B
```

```
CognitiveSlottingScreen (SCR_02B) - Intermediate Engine Screen
├── TopHeader ("NEUROTASK" + ThemeToggle)
├── Headings
│   ├── Title ("Calculando Ventanas Libres...", 22px, bold)
│   └── Subtitle ("Buscando momentos de menor fatiga mental para tus tareas.", 13px, Slate-500)
├── CentralEngineVisualizer
│   ├── PulsingNeumorphicCircle (160x160px, Glowing Cyan Halo #38BDF8)
│   │   └── AnimatedClockGearIcon
│   └── LiveSlottingMetrics
│       ├── Badge1 ("✓ 3 Bloques fijos protegidos", Emerald Badge)
│       ├── Badge2 ("⏳ 4 Ventanas libres detectadas (6h 30m disponibles)", Slate Badge)
│       └── Badge3 ("⚡ Asignando orden lógico según demanda cognitiva...", Indigo Badge)
└── AutoTransition (Fade 1200ms) -> Navigates to SCR_02C
```

```
DailyAgendaScreen (SCR_02C) - Figma Prototype Screen 2
├── TopHeader ("NEUROTASK" + ThemeToggle)
├── Headings
│   ├── Title ("Tus tareas de hoy", 24px, w800, Slate-900)
│   └── Subtitle ("Verificá si tus horarios se adaptan a las tareas.", 13px, Slate-500)
├── ScheduledTasksCard (Neumorphic Elevated Container, Radius 24px, BG #E5E7EB)
│   ├── Row1 (`[14:00]` | `Hacer la presentación`)
│   ├── DividerLine
│   ├── Row2 (`[15:30]` | `Estudiar`)
│   ├── DividerLine
│   ├── Row3 (`[20:00]` | `Lavar la ropa`)
│   ├── DividerLine
│   └── Row4 (`[21:00]` | `Tender la ropa`)
└── BottomStackedActions
    ├── ReorganizeButton ("Reorganizar Tareas", Deep Blue #0284C7, 50px) -> Re-shuffles with haptics
    └── ContinueToFocusCTA ("Continuar", Gradient Indigo/DeepBlue, 54px) -> Enters SCR_04
```

```
SingleTaskScreen (SCR_04) - 1-to-1 Focus Viewport
├── TopNavigationBar
│   ├── FlowIndicator ("Paso X de Y", Green dot indicator)
│   └── SensoryControlsRow
│       ├── AmbientSoundToggle (Icons.cloud_outlined / Icons.cloud_queue_rounded) -> Synthesizes Brown Noise
│       ├── GraphMapButton (Icons.hub_outlined) -> Opens MDL_05
│       ├── RescueButton (Icons.spa_outlined) -> Opens MDL_04
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
├── TimeGuardianStatusPill ("🛡️ Horario asignado: 14:00 - 15:15 | Siguiente bloque fijo: Gym a las 17:30")
├── SwipeHint ("👉 Deslizá la tarjeta hacia la derecha para completar")
└── ActionButtons
    ├── StepCompletedButton ("Paso Completado", NeumorphicButtonVariant.success, 56px) -> Advances to next / SCR_05
    └── StuckRescueButton ("Estoy Bloqueado / Dividir más", NeumorphicButtonVariant.flat, Amber icon) -> Opens MDL_04
```
