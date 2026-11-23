# SCREEN CATALOG: NeuroTask (Complete Screen & Modal Inventory)

> **Document**: `.stitch/SCREEN_CATALOG.md`  
> **Source-of-Truth**: `Joni23s/NeuroTask_beta00`  
> **Team**: Araujo Jonathan, Batiatto Juan Martín, Belardinelli Agustín, Ortega Mateo (DAM — ITU UNCuyo)  
> **Classification**: 100% VERIFIED FROM FINAL SOURCE CODE (11 Full Screens + 7 Modal Surfaces)  

---

## 1. Summary Matrix of Surfaces

| Surface ID | Formal Name | Route / Access | Type | Key Components / Features |
| :--- | :--- | :--- | :--- | :--- |
| `SCR_00` | **`SplashScreen`** | `/` (Root) | Full Screen | Breathing circular neumorphic logo (`Icons.psychology_rounded`), tagline `"Cero carga cognitiva. Foco puro."`, auto-checks `UserRepository.isLoggedIn()` to route to `/welcome` or `/onboarding`. |
| `SCR_01` | **`OnboardingScreen`** | `/onboarding` | Full Screen | 3-slide `PageView` (`Volcá tus ideas libremente`, `El sistema descompone y ordena`, `Una sola tarea a la vez`), `Saltar` CTA, animated dots, `Siguiente` / `Comenzar`. |
| `SCR_02` | **`LoginRegisterScreen`** | `/auth` | Full Screen | Tab toggle `Iniciar Sesión` / `Registrarse`, validated inputs (`Nombre`, `Correo Electrónico`, `Contraseña` con ojo toggle), CTA `Ingresar a NeuroTask` / `Crear mi Cuenta`, guest CTA `Continuar como Invitado`, success/error banners. |
| `SCR_03` | **`WelcomeScreen`** | `/welcome` | Full Screen | Top bar (`NeuroTask` dot badge + 4 circular actions: `⚓`, `🏆`, `👤`, `⚙️` + `ThemeToggleButton`), Breathing Brain Hero (210x210 circle with `brain_logo_transparent.png`), conditional Resume Session Banner, Tap Hint Pill. |
| `SCR_04` | **`BrainDumpScreen`** | `/brain-dump` | Full Screen | Back button, `"Descompresión Cognitiva"` badge, `⚓` shortcut, `ThemeToggleButton`, preset chips (`🎓 Entrega DAM`, `📱 Flutter`), 220px `NeuroInsetContainer` text area, floating mic button, word count + progressive accelerated `"Limpiar"`, CTA `"Descomprimir y Secuenciar"`. |
| `MDL_01` | **`VoiceDictationSheet`** | BottomSheet from `SCR_04` | Modal BottomSheet | `HitTestBehavior.opaque` pulsing mic circle (86px), live transcript inset well, 14 animated soundwave bars, permission error banner, `"Cancelar"` + `"Usar este Dictado"`. |
| `MDL_02` | **`ProcessingDialog`** | Dialog from `SCR_04` | Modal Dialog | Breathing `CircularProgressIndicator`, `"Construyendo Grafo Lógico..."`, `"Eliminando ruido cognitivo y aislando tu primer paso..."`. |
| `SCR_05` | **`SingleTaskScreen`** | `/single-task` | Full Screen | `FlowIndicator` (`Paso X de Y`), ambient sound toggle (auto-starts Brownian noise if `autoBrownNoise` enabled), schedule modal, DAG graph modal, cognitive rescue trigger, theme toggle, conditional `"⚓ Próxima ancla: ..."` alert banner, `SwipeToCompleteCard` with `ZenTimerWidget`, `"Paso Completado"` + `"Estoy Bloqueado / Dividir más"`. |
| `MDL_03` | **`CognitiveRescueSheet`** | BottomSheet from `SCR_05` | Modal BottomSheet | 3 guilt-free options: (1) Subdivide into 3m micro-steps, (2) Low Energy Mode, (3) Skip/postpone task to end of queue without completing it. |
| `MDL_04` | **`GraphOverviewModal`** | BottomSheet from `SCR_05`/`SCR_06` | Modal BottomSheet | View toggle (`Ver Lista` / `Ver Grafo`), `DagCanvasWidget` (`InteractiveViewer` + `_TreeDagPainter` with Bezier curves and pulsing node glow) or step list. |
| `MDL_05` | **`ScheduleOverviewModal`** | BottomSheet from `SCR_05` | Modal BottomSheet | Conditional overload/viability banner from `AnchorScheduleFitter`, chronological inset list with intermediate anchor bars, `"Reorganizar"` (`/anchors`) + `"Comenzar"`. |
| `SCR_06` | **`SummaryCelebrationScreen`** | `/celebration` | Full Screen | `"Objetivo Conquistado"` badge, 🏆 vault shortcut + theme toggle, 90x90 trophy card, `"¡Flujo Completado!"`, 3 metric cards (`Nodos Logrados`, `Tiempo Real`, `Calma Mental`), `CognitiveInsightCard`, `"Compartir / Copiar Logro"`, `"Ver Reporte"`, `"Mapa Grafo"`, `"Revisar Baúl de Trofeos"`, `"Iniciar Nuevo Volcado (Brain Dump)"`. |
| `MDL_06` | **`ReportPreviewDialog`** | Dialog from `SCR_06` | Modal Dialog | Monospace report preview + `"Copiar al Portapapeles"`. |
| `SCR_07` | **`AnchorsManagerScreen`** | `/anchors` | Full Screen | Deep navy canvas (`#0F2E49`), centered brain logo + `"MALLA TEMPORAL"`, back & `+` add buttons, horizontal `Lun..Dom` pills, real current-week date header (`dayName`, `dayNumber`, `monthName`), hourly timeline (`07:00–23:00`), staggered teal & lavender activity cards with tap-to-inspect details (`Editar` + `Eliminar`) and validated CRUD form (`FilterChip` days, time range validation `end > start`). |
| `SCR_08` | **`AchievementsVaultScreen`** | `/achievements` | Full Screen | `"BAÚL DE LOGROS"` bar, progress overview card (`LinearProgressIndicator`), 6 category filter pills, 10 achievement cards (`unlocked`/`locked` states). |
| `MDL_07` | **`AchievementDetailDialog`** | Dialog from `SCR_08` | Modal Dialog | 76px trophy circle, status pill (`✨ DESBLOQUEADO` / `🔒 BLOQUEADO`), `"Impacto Neuro-Cognitivo"` callout, `"Entendido"`. |
| `SCR_09` | **`ProfileScreen`** | `/profile` | Full Screen | Avatar initials circle, name, email, dynamic level badge (`Nivel X — Título`), Level Progress Card (`Próximo Nivel`, `X / Y tareas`, `LinearProgressIndicator`), 3 metric cards (`Micro-tareas listas`, real consecutive-day `Racha actual`, `Tiempo en Foco`), `Bóveda de Logros`, `ListTile` `"Editar datos personales"` (live modal editing name & email with migration), `"Preferencias de notificación"` -> `/settings`, `"Cerrar Sesión"` -> `/auth`. |
| `SCR_10` | **`SettingsScreen`** | `/settings` | Full Screen | Persistent `settingsProvider` + `themeProvider` switches: `"Modo Oscuro"`, `"Alertas de Anclas Horarias"`, `"Ruido Marrón Automático"`, `"Vibración Háptica"`; app info (`Versión de la app: 1.0.0`, `Motor de ordenamiento: DAG Topological Sort`). |

---

## 2. Navigation Graph

```
Splash (/) ──[isLoggedIn == true]───────────────────────────────┐
    │                                                           ▼
    └──[isLoggedIn == false]──► Onboarding (/onboarding) ──► Auth (/auth) ──► Welcome (/welcome)
                                                                                  │
                 ┌────────────────────────┬───────────────────┬───────────────────┴───────────────────┐
                 ▼                        ▼                   ▼                   ▼                   ▼
            BrainDump (/brain-dump)  Anchors (/anchors)  Achievements       Profile (/profile)   Settings (/settings)
                 │                                       (/achievements)          │
                 ▼                                                                └──► EditProfileModal / Settings
            SingleTask (/single-task) ──[Complete All]──► Celebration (/celebration)
                 │                                              │
                 └── Modals: Rescue, GraphOverview, Schedule    └── Modals: ReportPreview, GraphOverview
```

---

## 3. Detailed Core Screen Flows

```
WelcomeScreen (SCR_03)
├── TopHeader
│   ├── StatusBadge ("NeuroTask", Indigo/Cyan Dot)
│   └── TopActionsRow
│       ├── AnchorsButton ("⚓") -> SCR_07
│       ├── TrophyVaultButton ("🏆") -> SCR_08
│       ├── ProfileButton (Icons.person_outline_rounded) -> SCR_09
│       ├── SettingsButton (Icons.settings_outlined) -> SCR_10
│       └── ThemeToggleButton (Light/Dark)
├── HeroCenter
│   ├── BreathingBrainButton (210x210 Circle, Brain Logo) -> SCR_04
│   ├── BrandTitle ("NEUROTASK", 30px, w900)
│   ├── BrandSubtitle ("MOTOR DE FOCO", 13px, w700)
│   └── PhilosophyCopy ("Transformá el caos de ideas en un camino lógico y sereno.")
└── BottomActions
    ├── ResumeActiveSessionBanner [Conditional] -> SCR_05
    └── TapHintPill ("Tocá el cerebro para descomprimir tu mente") -> SCR_04
```
