# Guía de Defensa Oral EGI — NeuroTask: Motor de Foco

> **Proyecto:** NeuroTask: Motor de Foco  
> **Cátedra:** Desarrollo de Aplicaciones Móviles (DAM) — ITU, Universidad Nacional de Cuyo  
> **Repositorio:** [https://github.com/Joni23s/NeuroTask_beta00](https://github.com/Joni23s/NeuroTask_beta00)  
> **Documento Principal EGI:** [docs/DOCUMENTO_EGI_NEUROTASK.md](DOCUMENTO_EGI_NEUROTASK.md)  
> **Integrantes (Equipo de 4):** *Araujo Jonathan, Batiatto Juan Martín, Belardinelli Agustín, Ortega Mateo*

---

## 1. Distribución Sugerida para la Defensa Oral Presencial (10–12 Minutos)

La exposición está estructurada en **4 bloques equivalentes** alineados a las 4 secciones del [Documento Único Integrador](DOCUMENTO_EGI_NEUROTASK.md), reservando ~1 minuto de margen para transiciones entre oradores y apertura de preguntas del tribunal.

| Bloque | Orador Sugerido | Eje Temático (Documento EGI) | Duración | Apoyo en Pantalla |
| :--- | :--- | :--- | :---: | :--- |
| **1** | **Integrante 1** | Problema real, DCU y Propuesta de Valor (**Sección I**) | **2 min 30 s** | Lámina de problema, User Persona (*Juan Martín*), POV y pilares de solución. |
| **2** | **Integrante 2** | Diseño, Navegación, Google Stitch y Criterio Visual (**Sección II**) | **2 min 30 s** | Mapa de 11 pantallas + 7 modales, prototipo Stitch, tokens Light/Dark y capturas `docs/egi_assets/`. |
| **3** | **Integrante 3** | Demostración en vivo paso a paso (**Sección III**) | **3 min 45 s** | App Flutter ejecutándose en Chrome o Android (flujo completo end-to-end). |
| **4** | **Integrante 4** | Arquitectura, Teoría Flutter/Riverpod/Persistencia y Análisis Crítico (**Sección IV**) | **2 min 30 s** | Diagrama por capas, snippets reales (`FocusNotifier`, `DbHelper`, `DagCanvasWidget`) y mejoras v2.0. |
| **Total** | **Equipo completo** | **Cobertura integral EGI** | **11 min 15 s** | Fluido, dentro de la ventana **10–12 min**. |

### Guion Resumido por Orador y Pase de Posta

#### Integrante 1 — Problema, DCU y Propuesta de Valor (Sección I)
- **Qué explicar:**
  1. **La paradoja de la productividad móvil:** Apps tradicionales (*Notion, Trello, Jira, Asana*) trasladan tableros complejos, alertas vencidas en rojo y formularios largos a pantallas de 6 pulgadas. En estudiantes universitarios y perfiles con TDAH o sobrecarga cognitiva, esto dispara *ceguera temporal* (*time blindness*), parálisis por análisis y disfunción ejecutiva.
  2. **Investigación DCU real:** Presentar al *User Persona* (**Juan Martín**, 23 años, estudiante de desarrollo y freelance con TDAH inatento), su Mapa de Empatía y el *Problem Statement* del repositorio: el usuario gasta más energía ordenando pendientes que ejecutando.
  3. **Propuesta de valor de NeuroTask:** Invertir la carga cognitiva mediante 4 pilares implementados en código:
     - **Ingesta sin fricción (`BrainDumpScreen`):** volcado libre por texto o dictado por voz.
     - **Motor DAG (`TopologicalSorter`) + `AnchorScheduleFitter`:** descompone en micro-tareas y ordena respetando compromisos horarios fijos (*Anclas*).
     - **Viewport estricto 1-a-1 (`SingleTaskScreen`):** una única tarjeta activa a la vez, con temporizador sereno y *Swipe-to-Complete*.
     - **Rescate Cognitivo sin culpa (`CognitiveRescueSheet`):** micro-pasos de 3 min, Modo Baja Energía o salto a rama independiente.
- **Pase de posta:** *"Para que este enfoque no genere sobrecarga visual, cada pantalla siguió un criterio neuro-ergonómico específico que explica [Integrante 2]."*

#### Integrante 2 — Diseño, Navegación, Google Stitch y Criterio Visual (Sección II)
- **Qué explicar:**
  1. **Arquitectura de navegación:** 11 pantallas full-screen (`SCR_00` a `SCR_10` registradas en `main.dart`) y 7 modales/diálogos (`MDL_01` a `MDL_07`), con bifurcación automática desde `SplashScreen` según sesión activa (`UserRepository.isLoggedIn()`).
  2. **Sistema visual dual y neuro-ergonomía:**
     - **Light Soft Paper (`#F4F6F9`)** y **Dark Soft Slate (`#131822`)** definidos en `AppColors` y `NeumorphicTheme`, con doble sombra neumórfica, tipografía `Plus Jakarta Sans` + `Courier`/monoespaciada, y **cero alertas punitivas en rojo** para vencimientos.
     - Excepción semántica intencional: **Malla Temporal (`#0F2E49`)** en `AnchorsManagerScreen`, con bloques alternados Teal (`#72B8B0`) y Lavanda (`#B48BB6`) para diferenciar la agenda semanal del flujo de ejecución.
  3. **Prototipado y validación:** Evolución desde el prototipo HTML/CSS/JS inicial (`web_prototype/`), reconstrucción de alta fidelidad en **Google Stitch** (`STITCH_MASTER_PROMPT.md` y `.stitch/SCREEN_CATALOG.md`) y pruebas de usabilidad de un solo usuario bajo el criterio de Steve Krug (`docs/PROTOCOLO_PRUEBA_USABILIDAD_1_USUARIO.md`).
- **Pase de posta:** *"Ahora [Integrante 3] va a mostrar todo este recorrido funcionando en vivo en la aplicación Flutter."*

#### Integrante 3 — Demostración en Vivo Paso a Paso (Sección III)
- **Qué explicar:** Narrar en tiempo real los 10 pasos del [Guion de Demo en Vivo](#2-guion-de-demo-en-vivo-sin-fallos-paso-a-paso) (ver sección siguiente), enfatizando el valor para el usuario en cada gesto (ej. por qué no se muestran las otras tareas en `SingleTaskScreen`, cómo el ancla no se pisa con el horario calculado y cómo el rescate desbloquea sin penalizar).
- **Pase de posta:** *"Con el flujo completo demostrado, [Integrante 4] cierra explicando cómo se sostiene esto por debajo en arquitectura, estado y persistencia."*

#### Integrante 4 — Arquitectura, Teoría Flutter/Riverpod/Persistencia y Análisis Crítico (Sección IV)
- **Qué explicar:**
  1. **Principio declarativo $\text{UI} = f(\text{Estado})$ y enfoque Bottom-to-Top:** Capas limpias (`UI/Features -> Riverpod Notifiers -> Repositories -> Domain/Services -> DbHelper/SharedPreferences`).
  2. **Motor algorítmico y `CustomPainter`:** Ordenamiento topológico de Kahn (`TopologicalSorter.sort`), ajuste anti-solapamiento (`AnchorScheduleFitter.fitTasks`) y renderizado vectorial en `DagCanvasWidget` (`_TreeDagPainter`).
  3. **Persistencia y Calidad:** Por qué `DbHelper` Singleton usa `SharedPreferences` (compatibilidad única Android + Chrome Web), serialización `toMap()`/`fromObject()` + `.withId`, y cobertura con los tests en `flutter_app/test/` (25 casos `flutter test` + 2 scripts Dart).
  4. **Autocrítica honesta y hoja de ruta v2.0:** Auth local sin hash/backend, `SharedPreferences` vs Drift/SQLite, parser `RegExp` vs NLP/LLM y alertas in-app vs notificaciones push nativas.

---

## 2. Guion de Demo en Vivo sin Fallos (Paso a Paso)

### Checklist Pre-Demo (1 minuto antes de exponer)
1. **Target recomendado:** Ejecutar en **Chrome** (`flutter run -d chrome`) si se desea demostrar el micrófono real vía `Web Speech API`, o en **Android** (`speech_to_text` nativo + vibración háptica real). *(En Windows Desktop nativo, el dictado muestra simulación asistida).*
2. **Estado inicial limpio para mostrar Splash -> Onboarding -> Auth:** Si ya había una sesión iniciada, entrar antes a **Perfil -> Cerrar Sesión** (pone `neurotask_is_logged_in_v1 = false`) o abrir una ventana limpia/incógnito en Chrome.
3. **Credenciales académicas pre-sembradas en `UserRepository`:**
   - Correo: `estudiante.dam@itu.uncuyo.edu.ar`
   - Contraseña: `password123`
   *(También se puede registrar una cuenta nueva en vivo o usar "Continuar como Invitado").*

### Secuencia Exacta en Vivo (10 Pasos)

| Paso | Pantalla / Modal | Acción Exacta del Presentador | Qué Verificar en Pantalla y Qué Explicar |
| :---: | :--- | :--- | :--- |
| **1** | **Splash** (`SplashScreen`, `/`) | Abrir la app y esperar ~2.8 segundos sin tocar nada. | Se ve el isotipo animado (`Icons.psychology_rounded`), *"NeuroTask — Cero carga cognitiva. Foco puro."* Explicar que el `Timer` consulta `UserRepository().isLoggedIn()`: si es `false`, va a Onboarding; si ya hay sesión, salta directo a `WelcomeScreen`. |
| **2** | **Onboarding** (`OnboardingScreen`, `/onboarding`) | Deslizar o pulsar **"Siguiente"** en las 3 tarjetas y terminar en **"Comenzar"**. | Mostrar la progresión de 3 pasos: *1) Volcá tus ideas libremente, 2) El sistema descompone y ordena, 3) Una sola tarea a la vez*. Explicar la regla *"No me hagas pensar"*. |
| **3** | **Registro / Login** (`LoginRegisterScreen`, `/auth`) | Mostrar brevemente el tab **"Registrarse"** (o crear cuenta nueva) y luego ingresar en **"Iniciar Sesión"** con `estudiante.dam@itu.uncuyo.edu.ar` / `password123` (o **"Continuar como Invitado"**). | Destacar las validaciones activas (nombre, regex de email, mínimo 6 caracteres, toggle de contraseña) y los banners visuales de éxito/error sin diálogos bloqueantes. |
| **4** | **Welcome** (`WelcomeScreen`, `/welcome`) | Detenerse 3 segundos en la pantalla principal. | Mostrar el isotipo cerebral con animación *Zen Breathe* (210x210px), los 4 accesos superiores (`⚓`, `🏆`, `👤`, `⚙️` + tema) y mencionar que si existe una sesión previa sin terminar aparece el banner verde `"Reanudar paso X: ..."`. |
| **5** | **Malla Temporal `07:00–23:30`** (`AnchorsManagerScreen`, `/anchors`) | Tocar el ícono **`⚓`** arriba a la derecha. Cambiar entre días `Lun..Dom`, tocar una tarjeta existente para **Editar** y pulsar **`+`** para **Agregar** un ancla nueva (ej. *"Repaso EGI"* de `16:00` a `16:45`, eligiendo días con `FilterChip`). | Mostrar el calendario semanal `07:00–23:00` (con bloques que cubren hasta `23:30`, como *Cena y Desconexión*), las **fechas reales de la semana actual** calculadas con `DateTime.now()`, la validación horaria (`end > start`) y al menos un día seleccionado. Volver atrás a Welcome. |
| **6** | **Configuración** (`SettingsScreen`, `/settings`) | Tocar **`⚙️`** en Welcome. Probar el switch **"Modo Oscuro"** (Soft Slate `#131822`), verificar **"Alertas de Anclas Horarias"**, activar **"Ruido Marrón Automático"** y mostrar **"Vibración Háptica"**. | Explicar que cada switch persiste de forma asíncrona con `SettingsNotifier` (`ThemeNotifier` para el tema) y modifica el comportamiento real del foco (`HapticHelper.enabled`, audio automático y banner de ancla). Volver a Welcome. |
| **7** | **Brain Dump** (`BrainDumpScreen`, `/brain-dump`) | Tocar el cerebro central (o `"Tocá el cerebro para descomprimir tu mente"`). Pulsar el chip **`🎓 Entrega DAM`** (opcional: mostrar `"Limpiar"` con su borrado regresivo progresivo y volver a cargar el preset). Tocar el **botón de micrófono** (`VoiceDictationSheet`) y dictar una frase o usar `"Usar este Dictado"`. Pulsar **"Descomprimir y Secuenciar"**. | Mostrar que no hay campos de fecha ni prioridad manuales. *(Plan B en Windows nativo sin micrófono: usar el botón `"Probar Simulación de Dictado en Windows"` dentro de `VoiceDictationSheet`).* Se abre el modal `"Construyendo Grafo Lógico..."`. |
| **8** | **Single-Task Viewport 1-a-1** (`SingleTaskScreen`, `/single-task`) | **a)** Señalar la tarjeta única + `ZenTimerWidget` + banner **`"⚓ Próxima ancla: ..."`** y confirmar que el Ruido Marrón arrancó automáticamente.<br>**b)** Tocar el ícono de grafo (`hub_outlined`) para abrir `GraphOverviewModal` (`DagCanvasWidget` + toggle `"Ver Lista"` / `"Ver Grafo"`).<br>**c)** Tocar el ícono de reloj (`schedule_rounded`) para abrir `ScheduleOverviewModal`.<br>**d)** Abrir **Rescate Cognitivo** (`spa_outlined` o `"Estoy Bloqueado / Dividir más"`): probar primero **"Saltar a rama independiente"** y luego volver a abrirlo para probar **"Subdividir en micro-pasos de 3 min"**.<br>**e)** Completar las tareas deslizando **`SwipeToCompleteCard`** hacia la derecha (`>= 140px`) hasta terminar la cola. | Explicar en **(b)** el algoritmo de Kahn y las curvas Bézier en `CustomPainter`; en **(c)** cómo `AnchorScheduleFitter` salta las anclas sin solapamientos; en **(d)** que *"Saltar a rama independiente"* pospone la tarea al final con `isCompleted: false` (no la da por hecha) y que *"Micro-pasos de 3 min"* divide el nodo actual en 2 pasos livianos (3m y 5m) con badge `"Micro-Paso (3m)"`; en **(e)** destacar la recompensa sonora (`zen_chime`) y háptica al completar. |
| **9** | **Celebración** (`SummaryCelebrationScreen`, `/celebration`) | Revisar la tarjeta de resumen, señalar **`CognitiveInsightCard`**, tocar **"Ver Reporte"** (`ReportPreviewDialog`) y **"Copiar al Portapapeles"** (o **"Compartir / Copiar Logro"**). | Mostrar que las métricas son reales (`Nodos Logrados`, `Tiempo Real`, `Calma Mental: 100%`), el mensaje de insight cambia dinámicamente según tiempo real vs estimado (Hiperfoco ⚡ / Persistencia 🌱 / Ritmo 🎯) y el reporte se exporta en formato Markdown. |
| **10** | **Perfil y Bóveda de Logros** (`ProfileScreen`, `/profile` y `AchievementsVaultScreen`, `/achievements`) | Desde Celebración tocar **"Revisar Baúl de Trofeos"** (mostrar progreso, filtros por categoría y detalle `"Impacto Neuro-Cognitivo"`). Luego volver a Welcome y entrar a **`👤` Perfil**. | Mostrar la barra **"Próximo Nivel"** (`X / Y tareas`), la **racha diaria** consecutiva, el tiempo total en foco y abrir **"Editar datos personales"** para demostrar la actualización en vivo con migración de cuenta en `UserRepository`. |

---

## 3. Banco de Preguntas y Respuestas Técnicas del Docente

### Pregunta 1: ¿Cómo aplican el paradigma de interfaz declarativa ($\text{UI} = f(\text{Estado})$)?

- **Respuesta directa para defensa:**  
  En Flutter no manipulamos widgets de forma imperativa (no llamamos `label.setText(...)` ni ocultamos vistas manualmente). Cada pantalla es una función pura del estado expuesto por Riverpod mediante `ref.watch(...)`: cuando cambia el estado en un `Notifier` o se invalida un `FutureProvider`, Flutter reconstruye automáticamente solo la porción de árbol afectada.
- **Evidencia real verificada en código:**
  - **`NeuroTaskApp`** ([`flutter_app/lib/main.dart`](../flutter_app/lib/main.dart)): es un `ConsumerWidget` cuyo `build()` observa `final themeState = ref.watch(themeProvider);` y retorna `MaterialApp(themeMode: themeState.themeMode, ...)`. Al cambiar el tema en cualquier pantalla, toda la aplicación cambia entre `NeumorphicTheme.lightTheme` y `NeumorphicTheme.darkTheme`.
  - **`SingleTaskScreen`** ([`flutter_app/lib/features/focus/single_task_screen.dart`](../flutter_app/lib/features/focus/single_task_screen.dart)): observa `focusProvider`, `audioServiceProvider`, `settingsProvider` y `anchorsProvider`. Su `build()` proyecta 3 estados excluyentes: si `executionQueue.isEmpty && !isCompletedAll` renderiza `CircularProgressIndicator`; si `isCompletedAll || currentTask == null` retorna `SummaryCelebrationScreen()`; y si hay tarea activa, renderiza esa única `task` dentro de `SwipeToCompleteCard` y muestra condicionalmente el banner de ancla solo cuando `settingsState.anchorNotifications && nextAnchor != null`.
  - **`ProfileScreen`** ([`flutter_app/lib/features/profile/profile_screen.dart`](../flutter_app/lib/features/profile/profile_screen.dart)): es un `ConsumerWidget` que observa `currentUserProfileProvider` y `userAchievementsListProvider`. Mediante `profileAsync.when(loading:, error:, data:)` declara la UI para carga, error y datos reales; al completar tareas (`FocusNotifier.completeCurrentTask()`) o editar perfil se invoca `ref.invalidate(currentUserProfileProvider)` y la pantalla se actualiza automáticamente.

---

### Pregunta 2: ¿Qué widgets reutilizables crearon y dónde utilizan `CustomPainter`?

- **Respuesta directa para defensa:**  
  Centralizamos un Design System neumórfico propio en `lib/core/widgets/` para no duplicar estilos ni lógica gestual entre pantallas, y usamos `CustomPainter` específicamente para dibujar el grafo dirigido acíclico (DAG) interactivo con curvas Bézier y halo animado.
- **Widgets reutilizables verificados (`flutter_app/lib/core/widgets/`):**
  1. **`NeumorphicCard`** (`neumorphic_card.dart`): contenedor base con doble sombra (`context.softElevation`), borde sutil y soporte opcional de `onTap`.
  2. **`NeumorphicButton`** (`neumorphic_button.dart`): botón táctil con 4 variantes (`NeumorphicButtonVariant.primary`, `success`, `flat`, `pressed`), gradientes, respuesta háptica (`HapticHelper.lightTap()`) y feedback visual de hundimiento (`AnimatedContainer`).
  3. **`NeuroInsetContainer`** (`neuro_inset_container.dart`): contenedor con relieve hundido (`context.pressedSurface`, `context.pressedElevation`) usado en campos de texto de Auth, textarea de Brain Dump, listas de horarios y preview de reporte.
  4. **`NeuroBadge`** (`neuro_badge.dart`): píldora reutilizable con 3 constructores nombrados semánticos (`NeuroBadge.status`, `NeuroBadge.chip`, `NeuroBadge.highlight`).
  5. **`NeuroModalSheet`** y `showNeuroModalSheet` (`neuro_modal_sheet.dart`): bottom sheet unificado con esquinas superiores de `36px`, *drag handle* y encabezado opcional con `trailing`.
  6. **`SwipeToCompleteCard`** (`swipe_to_complete_card.dart`): tarjeta con `GestureDetector` bidireccional — deslizamiento horizontal (`_triggerThreshold = 140.0`) con barra revelada progresiva para completar, y arrastre vertical descendente (`_verticalTriggerThreshold = 70.0`) para invocar Rescate Cognitivo.
  7. **`ZenTimerWidget`** (`zen_timer_widget.dart`): cronómetro de sesión no punitivo (`Timer.periodic` cada 1s) con punto respiratorio aislado en `RepaintBoundary`.
  8. **`FlowIndicator`** (`flow_indicator.dart`): píldora superior `"Paso X de Y"` del progreso de foco.
  *(Además de `ThemeToggleButton` en `theme_toggle_button.dart` y widgets específicos de foco como `CognitiveInsightCard` en `features/focus/widgets/`).*
- **Uso de `CustomPainter` (`flutter_app/lib/features/focus/widgets/dag_canvas_widget.dart`):**
  - **`DagCanvasWidget` + `_TreeDagPainter extends CustomPainter`:** envuelto en `InteractiveViewer` (zoom `0.75` a `2.2`) y `AnimatedBuilder` ligado a `_pulseController`. En `paint(Canvas canvas, Size size)` calcula las posiciones 2D de los nodos, traza **curvas Bézier cúbicas** (`path.cubicTo`) con flechas direccionales coloreadas según estado (esmeralda completado, gradiente activo, gris pendiente), dibuja cada tarjeta redondeada (`drawRRect`), un halo pulsante alrededor del nodo actual y renderiza etiquetas con `TextPainter`. Implementa `shouldRepaint` comparando `pulseValue`, `currentIndex`, `nodes` e `isDarkMode`.

---

### Pregunta 3: ¿Cómo manejan el estado y la inyección de dependencias?

- **Respuesta directa para defensa:**  
  Usamos **Riverpod (`flutter_riverpod`)** como contenedor único de estado e inyección de dependencias, separando los **proveedores de repositorios** (infraestructura de datos) de los **`NotifierProvider`** (estado de negocio/UI) y los **`FutureProvider`** (lecturas asíncronas reactivas).
- **Evidencia real verificada en código:**
  - **`ProviderScope`** ([`flutter_app/lib/main.dart`](../flutter_app/lib/main.dart)): envuelve `NeuroTaskApp` en `runApp(...)`, habilitando la resolución del grafo de providers en toda la app y permitiendo aislar cada test mediante `ProviderContainer()` en `flutter_app/test/`.
  - **`providers.dart`** ([`flutter_app/lib/data/repositories/providers.dart`](../flutter_app/lib/data/repositories/providers.dart)):
    - Inyección de repositorios vía `Provider`: `taskRepositoryProvider`, `anchorRepositoryProvider`, `userRepositoryProvider`, `achievementRepositoryProvider`.
    - Consultas reactivas vía `FutureProvider`: `currentUserProfileProvider` y `userAchievementsListProvider`.
  - **Controladores `NotifierProvider`:**
    - `FocusNotifier` (`focusProvider` en [`focus_controller.dart`](../flutter_app/lib/features/focus/focus_controller.dart)): administra `FocusState` (grafo DAG, cola de ejecución, índice actual, modo baja energía, tiempo transcurrido), consumiendo `taskRepositoryProvider`, `anchorRepositoryProvider` y `userRepositoryProvider` mediante `ref.read(...)`.
    - `SettingsNotifier` (`settingsProvider` en [`settings_controller.dart`](../flutter_app/lib/features/settings/settings_controller.dart)): gestiona `SettingsState` (`anchorNotifications`, `autoBrownNoise`, `hapticFeedback`) y sincroniza `HapticHelper.enabled`.
    - Otros notifiers del mismo patrón: `AnchorsNotifier`, `BrainDumpNotifier`, `AchievementsNotifier`, `ThemeNotifier`, `AudioServiceNotifier`, `SpeechNotifier`.
  - **Uso correcto de `ref`:**
    - `ref.watch(...)` dentro de `build()` para reconstrucción reactiva.
    - `ref.read(...)` dentro de callbacks/eventos (`onPressed`, `onSwipeCompleted`, métodos internos de Notifiers).
    - `ref.invalidate(...)` al mutar datos persistidos (`LoginRegisterScreen`, `ProfileScreen`, `FocusNotifier.completeCurrentTask()`, `AchievementsNotifier`) para refrescar `currentUserProfileProvider` y `userAchievementsListProvider`.

---

### Pregunta 4: ¿Cómo trabajan la asincronía sin trabar la UI?

- **Respuesta directa para defensa:**  
  Dart ejecuta la UI en un único hilo (*Main Isolate* / *Event Loop*). Por eso todas las lecturas/escrituras de disco, parseos y temporizadores se resuelven de forma no bloqueante con `Future`, `async`/`await`, `Timer` y `Future.microtask`, manteniendo el renderizado fluido a 60/120 FPS.
- **Evidencia real verificada en código:**
  - **`Future` y `async`/`await`:** Todos los repositorios (`TaskRepository`, `AnchorRepository`, `UserRepository`, `AchievementRepository`), `DbHelper`, `SessionStorageService` y `AchievementsStorageService` exponen métodos `Future<T>` sobre `SharedPreferences.getInstance()`. La UI reacciona mediante `FutureProvider` (`.when(loading:, data:)`) o estados `isLoading` sin congelar animaciones.
  - **`Future.microtask(...)` en Riverpod:** En `FocusNotifier.build()`, `SettingsNotifier.build()`, `AnchorsNotifier.build()`, `AchievementsNotifier.build()`, `ThemeNotifier.build()` y `SpeechNotifier.build()`, el `build()` retorna de inmediato un estado inicial seguro sincrónico y agenda la carga asíncrona en la siguiente microtanda (`Future.microtask(() => ...)`), evitando modificar `state` mientras Riverpod aún está construyendo el provider.
  - **`Timer` y control de ciclo de vida (`mounted` / `dispose`):**
    - `SplashScreen`: usa `Timer(const Duration(milliseconds: 2800), () async { ... })`, verifica `if (!mounted) return;` tras el `await UserRepository().isLoggedIn()` y cancela `_navigationTimer?.cancel()` en `dispose()`.
    - `ZenTimerWidget`: usa `Timer.periodic(const Duration(seconds: 1), ...)` y lo cancela en `dispose()`, aislando el pulso en `RepaintBoundary` para no repintar toda la pantalla cada segundo.
    - `BrainDumpScreen` y `VoiceDictationSheet`: animan paso a paso (borrado regresivo progresivo y simulación de dictado) cediendo el frame entre iteraciones con `await Future.delayed(...)` y chequeando `if (!mounted) return;`.

---

### Pregunta 5: ¿Cómo persisten datos y por qué `DbHelper` Singleton usa `SharedPreferences` en lugar de `sqflite`?

- **Respuesta directa para defensa:**  
  Implementamos la capa de persistencia siguiendo el patrón **Singleton** en `DbHelper` y contratos de serialización relacional plana (`toMap()`, `fromObject()`, constructores `.withId`), eligiendo `SharedPreferences` como motor físico para lograr compatibilidad real multiplataforma (**Android + Chrome Web**) sin duplicar código ni requerir dependencias nativas incompatibles con navegador.
- **Evidencia real verificada en código (`flutter_app/lib/model/dbhelper.dart` y modelos):**
  - **Singleton estricto:**
    ```dart
    static final DbHelper _dbHelper = DbHelper._internal();
    DbHelper._internal();
    factory DbHelper() => _dbHelper;
    ```
    Garantiza que toda la app comparta una única instancia coordinadora, evitando condiciones de carrera o lecturas inconsistentes sobre la tabla `neurotask_anchors_table_v1`.
  - **Modelado compatible con SQLite:** `TimeAnchor`, `TaskNode` y `UserProfile` implementan constructores nombrados `.withId` (para reconstrucción con integridad referencial), `toMap()` y `fromObject(dynamic o)`. `DbHelper` expone operaciones CRUD tipadas (`insertAnchor`, `getAnchors`, `getAnchorObjects`, `updateAnchor`, `deleteAnchor`, `deleteRows`, `resetToDefaults`).
  - **¿Por qué `SharedPreferences` y no `sqflite`?**
    1. `sqflite` está pensado para SQLite nativo en Android/iOS/Desktop y **no funciona directamente en Flutter Web (Chrome)** sin configuraciones adicionales de `sqlite3.wasm`/IndexedDB.
    2. NeuroTask se ejecuta, prueba y despliega tanto en **Android** como en **Chrome Web** (`flutter run -d chrome` y pruebas web con `Web Speech API` / `Web Audio API`). `SharedPreferences` unifica Android (`SharedPreferences` XML) y Chrome (`localStorage`) bajo una única API `Future`.
    3. En pruebas unitarias (`anchors_test.dart`, `egi_features_test.dart`, `widget_test.dart`), permite inyectar estado determinista en milisegundos con `SharedPreferences.setMockInitialValues({})` sin levantar un emulador.
  - **¿Qué cambiaríamos en v2.0?**  
    Reemplazar el motor interno de `DbHelper` por **Drift** (SQLite tipado con soporte nativo y Web/WASM) o un cliente de sincronización cloud (**Supabase / PostgreSQL**), sin tocar una sola pantalla ni controlador gracias a la abstracción de `AnchorRepository`, `TaskRepository`, `UserRepository` y `AchievementRepository`.

---

### Pregunta 6: ¿Qué limitaciones técnicas tiene hoy la app y qué mejorarían en una v2.0?

- **Respuesta directa para defensa:**  
  NeuroTask es un MVP funcional sólido orientado a validar el flujo neuro-ergonómico y la arquitectura por capas, pero reconocemos 5 limitaciones técnicas claras que ya están acotadas para una versión productiva 2.0:

| Limitación Actual (Verificada en Código) | Impacto Técnico / Funcional | Qué Mejoraríamos en v2.0 |
| :--- | :--- | :--- |
| **1. Autenticación local sin hashing ni backend** (`UserRepository` guarda cuentas en `SharedPreferences` bajo `_keyAccounts` con contraseña en texto plano) | No hay sincronización entre dispositivos ni seguridad criptográfica real de credenciales. | Backend con **Supabase Auth / Firebase Auth** o API REST con JWT + hashing (`Argon2`/`bcrypt`) y almacenamiento seguro (`flutter_secure_storage`). |
| **2. Persistencia JSON en `SharedPreferences` en vez de SQL relacional** (`DbHelper`, `SessionStorageService`, `AchievementsStorageService`) | No escala para miles de registros históricos, consultas complejas ni analítica longitudinal. | Migrar a **Drift (SQLite + WASM Web)** con tablas relacionales indexadas, claves foráneas reales y migraciones versionadas. |
| **3. Parser de Brain Dump por `RegExp` y palabras clave fijas** (`TopologicalSorter.parseRawText`) | Limita a un máximo de 6 nodos y depende de conectores textuales en español (`y luego`, `después`, comas) para inferir ramas. | Integrar un **LLM / NLP** (ej. Gemini API con esquema JSON estricto) manteniendo `TopologicalSorter.sort()` (Kahn) como validador acíclico determinista en el cliente. |
| **4. Alertas de anclas solo dentro de la app** (`SettingsState.anchorNotifications` + banner en `SingleTaskScreen`) | Si el usuario minimiza la app, no recibe un recordatorio suave previo a su clase o reunión. | Integrar **`flutter_local_notifications` + `timezone`** para programar avisos no punitivos antes de cada ancla activa. |
| **5. Dictado por voz dependiente de plataforma** (`Web Speech API` en Chrome, `speech_to_text` en Android, simulación en Windows nativo) | En Windows Desktop nativo no hay captura real de micrófono con el plugin actual. | Unificar captura multiplataforma (ej. plugin nativo desktop o envío de audio a Whisper/Speech-to-Text cuando no haya soporte local). |
