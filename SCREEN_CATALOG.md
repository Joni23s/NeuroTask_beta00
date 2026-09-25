# SCREEN CATALOG: NeuroTask (Complete Screen & Modal Inventory)

> **Document**: `SCREEN_CATALOG.md`  
> **Source-of-Truth**: `Joni23s/NeuroTask_beta00`  
> **Classification**: 100% VERIFIED FROM SOURCE CODE  
> **Total Full-Screen Surfaces**: 11 Full Screens  
> **Total Modal Surfaces**: 6 Modals / Bottom Sheets  
> **Total Surfaces**: 17 Surfaces  

---

## 1. Summary Matrix of Surfaces

| Surface Identifier | Formal Name | Route / Access | Type | Key Components / Features |
| :--- | :--- | :--- | :--- | :--- |
| `SCR_00` | **`SplashScreen`** | `/` (App Root) | Full Screen | Logo neumórfico con brillo pulsante, tagline "Cero carga cognitiva" y auto-transición a Onboarding. |
| `SCR_01` | **`OnboardingScreen`** | `/onboarding` | Full Screen | PageView de 3 slides (Volcado, DAG, Foco Atómico), dots indicator y botón comenzar. |
| `SCR_02` | **`LoginRegisterScreen`** | `/auth` | Full Screen | Formulario neumórfico con toggle Iniciar Sesión/Registrarse e ingreso como Invitado. |
| `SCR_03` | **`WelcomeScreen`** | `/welcome` | Full Screen | Hero Breathing Brain Button (210px), Resume Banner, accesos directos a Anclas, Logros, Perfil y Configuración. |
| `SCR_04` | **`BrainDumpScreen`** | `/brain-dump` | Full Screen | Inset Text Area (220px), chips de ejemplo, dictado por voz y validación empática. |
| `MDL_01` | **`VoiceDictationSheet`** | BottomSheet en `SCR_04` | Modal BottomSheet | Micrófono pulsante, barritas de onda de sonido y transcripción en tiempo real. |
| `MDL_02` | **`ProcessingDialog`** | Dialog en `SCR_04` | Modal Dialog | Spinner de respiración (1300ms) y estado de construcción del grafo DAG. |
| `SCR_05` | **`SingleTaskScreen`** | `/single-task` | Full Screen | Viewport 1-a-1 de foco, `SwipeToCompleteCard`, Zen Timer, Ruido Marrón y Rescate Cognitivo. |
| `MDL_03` | **`CognitiveRescueSheet`** | BottomSheet en `SCR_05` | Modal BottomSheet | 3 opciones de rescate: micro-pasos de 3 min, Modo Baja Energía y saltar rama. |
| `MDL_04` | **`GraphOverviewModal`** | BottomSheet en `SCR_05`/`SCR_07` | Modal BottomSheet | Árbol 2D interactivo del grafo (`DagCanvasWidget`) + toggle a vista de lista. |
| `SCR_06` | **`SummaryCelebrationScreen`**| `/celebration` | Full Screen | 🏆 Tarjeta Hero de logro, métricas reales, `CognitiveInsightCard` y exportación de reporte. |
| `MDL_05` | **`ReportPreviewDialog`** | Dialog en `SCR_06` | Modal Dialog | Previsualización de texto en formato monospace y copiado a portapapeles. |
| `SCR_07` | **`AnchorsManagerScreen`** | `/anchors` | Full Screen | Gestión de anclas horarias y compromisos fijos con scheduler fitter. |
| `SCR_08` | **`AchievementsVaultScreen`**| `/achievements` | Full Screen | Barra de progreso, chips de filtro y 10 tarjetas de trofeos cognitivos. |
| `MDL_06` | **`AchievementDetailDialog`** | Dialog en `SCR_08` | Modal Dialog | Círculo de trofeo, pill de estado de desbloqueo e insight de impacto cognitivo. |
| `SCR_09` | **`ProfileScreen`** | `/profile` | Full Screen | Avatar neumórfico, nivel ("Maestro del Foco"), tarjetas de estadísticas y acceso a logros. |
| `SCR_10` | **`SettingsScreen`** | `/settings` | Full Screen | Toggles para Modo Oscuro, Notificaciones de Anclas, Ruido Marrón e Info de versión. |

---

## 2. Detailed Navigation Graph

```
Splash (/) ➔ Onboarding (/onboarding) ➔ Login (/auth) ➔ Welcome (/welcome)
                                                               │
             ┌─────────────────┬─────────────────┬─────────────┴─────────────┐
             ▼                 ▼                 ▼                           ▼
        BrainDump        AnchorsManager   AchievementsVault          Profile & Settings
       (/brain-dump)       (/anchors)      (/achievements)          (/profile, /settings)
             │
             ▼
        SingleTask
      (/single-task)
             │
             ▼
        Celebration
       (/celebration)
```

---

## 3. Directory Layout of Screens

```
flutter_app/lib/features/
├── splash/
│   └── splash_screen.dart (SCR_00)
├── onboarding/
│   ├── onboarding_screen.dart (SCR_01)
│   └── welcome_screen.dart (SCR_03)
├── auth/
│   └── login_register_screen.dart (SCR_02)
├── brain_dump/
│   ├── brain_dump_screen.dart (SCR_04)
│   └── voice_dictation_sheet.dart (MDL_01)
├── focus/
│   ├── single_task_screen.dart (SCR_05)
│   ├── summary_celebration_screen.dart (SCR_06)
│   └── widgets/
│       ├── cognitive_rescue_sheet.dart (MDL_03)
│       └── graph_overview_modal.dart (MDL_04)
├── anchors/
│   └── anchors_manager_screen.dart (SCR_07)
├── achievements/
│   └── achievements_vault_screen.dart (SCR_08)
├── profile/
│   └── profile_screen.dart (SCR_09)
└── settings/
    └── settings_screen.dart (SCR_10)
```
