# STITCH MASTER PROMPT: NeuroTask (100% High-Fidelity UI/UX Reconstruction)

> **Execution Directive for Google Stitch**: Reconstruct the complete NeuroTask mobile application based directly on our finished Flutter/Dart implementation (11 full-screen views and 7 modal/dialog surfaces). Preserve all visual tokens, Spanish (Argentina) copy, navigation paths, and neuro-ergonomic interaction patterns exactly as specified below.  
> **Team (Cátedra DAM — ITU UNCuyo)**: Araujo Jonathan, Batiatto Juan Martín, Belardinelli Agustín, Ortega Mateo.

---

## 1. Product Identity & Core Purpose
* **Application Title**: `NeuroTask: Motor de Foco`
* **Academic Affiliation**: `DAM — ITU UNCuyo` (Desarrollo de Aplicaciones Móviles, Instituto Tecnológico Universitario, Universidad Nacional de Cuyo)
* **Target Audience**: Students and professionals experiencing cognitive overload, executive dysfunction, or ADHD (TDAH).
* **Value Proposition**: *"Transformá el caos de ideas en un camino lógico y sereno."* / *"Menos ruido mental, más foco sereno."*
* **Core Implemented Modules**:
  1. **Splash, 3-Step Onboarding & Persistent Local Auth**: Session persistence (`SplashScreen` -> `WelcomeScreen` if logged in, else `OnboardingScreen` -> `LoginRegisterScreen` with Sign In, Sign Up, and Guest flows).
  2. **Brain Dump Ingestion**: Free-form text area, preset topic pills (`🎓 Entrega DAM`, `📱 Flutter`), accelerated backspace clear animation, and live Web Speech voice dictation (`VoiceDictationSheet`).
  3. **Intelligent DAG Engine & Anti-Overlap Scheduler**: Directed Acyclic Graph (`TopologicalSorter` using Kahn's algorithm) paired with `AnchorScheduleFitter` to fit tasks into free windows around fixed time anchors.
  4. **Strict 1-to-1 Focus Viewport**: `SingleTaskScreen` showing one atomic step at a time with `SwipeToCompleteCard`, `ZenTimerWidget` (`"Tiempo de Flujo: X min" | "Sin apuros"`), optional automatic Brownian noise, optional upcoming anchor alert banner, DAG visualization (`GraphOverviewModal`), schedule overview (`ScheduleOverviewModal`), and guilt-free `CognitiveRescueSheet`.
  5. **Malla Temporal (Time Anchors Manager)**: Full 07:00–23:30 weekly grid displaying real current-week calendar dates (`DateTime.now()`), weekday selectors, staggered teal/lavender cards, and validated Create/Edit/Delete modal forms (`FilterChip` days + range validation).
  6. **Celebration, Achievements Vault, Profile & Settings**: `SummaryCelebrationScreen` with `CognitiveInsightCard` and Markdown export; `AchievementsVaultScreen` (10 badges across 5 categories); `ProfileScreen` with dynamic level progression bar, consecutive-day streak, stats, profile editing (with email migration), and logout; `SettingsScreen` with persisted switches (`Modo Oscuro`, `Alertas de Anclas Horarias`, `Ruido Marrón Automático`, `Vibración Háptica`).

---

## 2. Design Language & Visual Atmosphere
* **Style**: Tactile Soft Neumorphic Double-Elevation with Curved Organic Containers and Beveled Borders (plus Deep Navy Timeline `#0F2E49` exclusively for `AnchorsManagerScreen`).
* **Canvas Modes**:
  * **Light Soft Paper**: Background `#F4F6F9`, pressed surface `#E9EDF4`, top-left white highlights (`#FFFFFF`), soft slate bottom-right shadows (`rgba(166, 178, 196, 0.45)`), 70% white beveled borders.
  * **Dark Soft Slate**: Background `#131822`, card surface `#1C2331`, inset surface `#161C28`, 60% black depth shadows, 8–10% white ridge highlights, cyan `#38BDF8` glowing accents.

---

## 3. Color Tokens (Exact Source Values from `AppColors`)

```text
background          = #F4F6F9 (Light Soft Paper)
cardSurface         = #F4F6F9 (Light Elevated Cards & Buttons)
pressedSurface      = #E9EDF4 (Light Inset Wells & Text Fields)

darkBackground      = #131822 (Dark Soft Slate)
darkCardSurface     = #1C2331 (Dark Elevated Cards & Buttons)
darkPressedSurface  = #161C28 (Dark Inset Wells & Text Fields)

brandDeepBlue       = #2B5B84 (Isotype & Title Primary Blue)
brandSteelBlue      = #4A7D9D (Subtitle & Anchor Accents)
brandGlowCyan       = #38BDF8 (Active DAG Halo & Dark Mode Accent)
brandGlowLight      = #E0F2FE (Soft Cyan Wash)

primaryIndigo       = #4F46E5 (Primary Action CTA End)
primaryIndigoLight  = #6366F1 (Primary Action CTA Start)
indigoGlow          = rgba(99, 102, 241, 0.25)

successEmerald      = #10B981 (Success CTA Start & Progress)
successEmeraldDark  = #059669 (Success CTA End)
emeraldGlow         = rgba(16, 185, 129, 0.25)

amberWarning        = #F59E0B (Cognitive Rescue Accent)
amberLight          = #FEF3C7 (Micro-Step Pill Background)
amberDark           = #D97706 (Micro-Step Text & Warning Hint)

textMain / darkTextMain           = #1E293B / #F8FAFC
textSecondary / darkTextSecondary = #64748B / #94A3B8
textMuted / darkTextMuted         = #94A3B8 / #64748B
borderLight / darkBorderLight     = rgba(255, 255, 255, 0.70) / rgba(255, 255, 255, 0.10)

Anchors Navy Theme:
navyBackground      = #0F2E49
tealCard            = #72B8B0 (Text #132B33)
lavenderCard        = #B48BB6 (Text #28182E)
accentTeal          = #45A59E
```

---

## 4. Typography & Shape Tokens
* **Primary Font**: `Plus Jakarta Sans` (`GoogleFonts.plusJakartaSansTextTheme()`)
* **Monospace Font**: `Courier` / `monospace` (Zen Timer, Report Preview, Timeline Hours)
* **Icons**: `Material Icons Rounded` + expressive semantic emojis (`🧠`, `⚓`, `🏆`, `🎯`, `🌱`, `🌿`, `⚡`, `🎙️`)
* **Border Radii**: 210px circle (Hero Brain), `36px` (Modal BottomSheets), `32px` (Task Hero Card), `24px–28px` (Cards/Dialogs), `20px` (Primary/Success Buttons), `14px–16px` (Chips/Pills).

---

## 5. Complete Screen Inventory to Render (11 Screens + 7 Modals)

1. **`SplashScreen` (`/`)**: Centered circular neumorphic logo (`Icons.psychology_rounded` in Indigo/DeepBlue gradient), title `"NeuroTask"`, subtitle `"Cero carga cognitiva. Foco puro."`, cyan spinner.
2. **`OnboardingScreen` (`/onboarding`)**: Top `"NeuroTask"` + `"Saltar"`, center neumorphic icon card, slide title & description (`"Volcá tus ideas libremente"`, `"El sistema descompone y ordena"`, `"Una sola tarea a la vez"`), animated indicator dots, full-width primary button `"Siguiente"` / `"Comenzar"`.
3. **`LoginRegisterScreen` (`/auth`)**: Elevated icon card (`Icons.psychology_rounded`), header `"¡Hola de nuevo!"` / `"Crear tu cuenta"`, tab bar (`Iniciar Sesión` | `Registrarse`), inset inputs (`Nombre completo` in Register, `Correo Electrónico`, `Contraseña` with eye visibility toggle), success/error alert banners, primary CTA `"Ingresar a NeuroTask"` / `"Crear mi Cuenta"`, divider `"o bien"`, flat guest button `"Continuar como Invitado"`.
4. **`WelcomeScreen` (`/welcome`)**: Top bar with `"NeuroTask"` dot badge + circular icon buttons (`⚓`, `🏆`, `👤`, `⚙️`) + `ThemeToggleButton`; center 210x210 circular breathing hero featuring `brain_logo_transparent.png`, `"NEUROTASK"`, `"MOTOR DE FOCO"`, `"Transformá el caos de ideas en un camino lógico y sereno."`; bottom conditional emerald `"Reanudar paso X: ..."` banner and `"Tocá el cerebro para descomprimir tu mente"` pill.
5. **`BrainDumpScreen` (`/brain-dump`)**: Top bar (`←`, `"Descompresión Cognitiva"`, `⚓`, `ThemeToggleButton`), `"¿Qué ronda por tu cabeza?"`, preset chips (`🎓 Entrega DAM`, `📱 Flutter`), 220px inset text area with floating mic button, word counter + progressive `"Limpiar"` button, primary CTA `"Descomprimir y Secuenciar"`.
6. **`VoiceDictationSheet` (BottomSheet)**: 86px pulsing microphone circle, status `"🎙️ Escuchando tu voz..."` / `"⏸️ Dictado en pausa (Tocá para hablar)"`, 14 animated soundwave bars, inset live transcript box, `"Cancelar"` + `"Usar este Dictado"`.
7. **`SingleTaskScreen` (`/single-task`)**: Top bar (`Paso X de Y`, ambient sound `☁️`, schedule `🕒`, DAG graph `hub`, rescue `spa`, `ThemeToggleButton`), `"ESTÁS ENFOCADO EN ESTO AHORA:"`, optional `"⚓ Próxima ancla: ..."` alert pill, `SwipeToCompleteCard` with category, optional `⏰ HH:mm` & `"Micro-Paso (3m)"` pills, 20pt task title, subtext, divider, `ZenTimerWidget`, swipe hint, emerald `"Paso Completado"` CTA, flat `"Estoy Bloqueado / Dividir más"` button.
8. **Modals from Focus (`CognitiveRescueSheet`, `GraphOverviewModal`, `ScheduleOverviewModal`)**:
   * *Cognitive Rescue*: 3 numbered cards (1: 3-min micro-steps, 2: Low Energy Mode, 3: Postpone task to alternative branch without marking complete).
   * *Graph Overview*: Toggle `"Ver Lista"` / `"Ver Grafo"`, 2D `DagCanvasWidget` tree with cubic Bézier arrows and glowing active capsule, or ordered step cards.
   * *Schedule Overview*: Conditional viability/overload banner (`AnchorScheduleFitter`), chronological list with intermediate anchor bars, `"Reorganizar"` + `"Comenzar"`.
9. **`AnchorsManagerScreen` (`/anchors`)**: Deep navy `#0F2E49` timeline screen (`MALLA TEMPORAL`), top back & `+` buttons, weekday chips (`Lun`–`Dom`), real current-week calendar date block on the top left (`LUNES 23 NOV`, etc.), vertical `07:00–23:00` axis, staggered teal & lavender activity cards; tap opens detail sheet with `"Editar"` and `"Eliminar"`, while `"+"` / `"Editar"` opens `_AddAnchorForm` with weekday `FilterChip`s, time pickers, categories, and validated time range (`end > start`).
10. **`SummaryCelebrationScreen` (`/celebration`) & `AchievementsVaultScreen` (`/achievements`)**:
    * *Celebration*: `"Objetivo Conquistado"` badge, 90x90 emerald-glow 🏆 hero, `"¡Flujo Completado!"`, 3 metric cards (`Nodos Logrados`, `Tiempo Real`, `Calma Mental`), `CognitiveInsightCard`, `"Compartir / Copiar Logro"`, `"Ver Reporte"` dialog, `"Mapa Grafo"`, `"Revisar Baúl de Trofeos"`, `"Iniciar Nuevo Volcado (Brain Dump)"`.
    * *Achievements Vault*: `"BAÚL DE LOGROS"`, progress bar (`X de 10 Conquistados`), category chips, 10 trophy cards opening `AchievementDetailDialog`.
11. **`ProfileScreen` (`/profile`) & `SettingsScreen` (`/settings`)**:
    * *Profile*: Initials avatar circle, dynamic name & email, `"Nivel X — Título"` badge + Next Level progress bar card, 3 stat cards (`Micro-tareas listas`, `Racha actual`, `Tiempo en Foco`), `Bóveda de Logros` shortcut, `"Editar datos personales"` bottom sheet modal, `"Preferencias de notificación"`, red `"Cerrar Sesión"` button.
    * *Settings*: Grouped neumorphic cards with persistent toggles for `"Modo Oscuro"`, `"Alertas de Anclas Horarias"`, `"Ruido Marrón Automático"`, `"Vibración Háptica"`, plus app info (`1.0.0`, `DAG Topological Sort`).

---

## 6. Exact Copy Rules (Spanish - Argentina)
Use natural Rioplatense Spanish (`vos` imperative/conjugation: *"Tocá"*, *"Volcá"*, *"Escribí"*, *"Deslizá"*, *"Ingresá"*, *"Elegí"*, *"Guardá"*). Avoid punitive bright red countdown clocks or crowded multi-task grids inside the Focus screen.
