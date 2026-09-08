# NT-SPEC-ARCH-003: Sistema de Anclas Temporales (Time Anchors), Prevención de Solapamiento y Capa de Persistencia Robusta

- **Estado:** Propuesta Técnica y Arquitectural (SDD)
- **Fecha:** 2026-09-08
- **Cátedra:** DAM — ITU UNCuyo
- **Equipo:** Araujo Jonathan, Batiatto Juan Martín, Belardinelli Agustín, Ortega Mateo
- **Diseño Base:** Análisis de Wireframes de Compañero + Adaptación al Sistema Neumórfico DCU de NeuroTask

---

## 1. Diagnóstico y Visión del Problema

### 1.1. Análisis de los Wireframes del Compañero
El compañero de equipo propone tres pantallas funcionales clave:
1. **Hub Inicial (Wireframe 1):** Acceso explícito a "Crea tus anclas", "Tus actividades" y "Crea nuevas actividades".
2. **Configuración de Horarios / Anclas de Hoy (Wireframe 2):** Vista de bloques horarios no negociables (ej. *08:00 - 12:00 Facultad*, *17:30 - 19:30 Gimnasio*, *22:00 - 00:00 Cena*) con opción de agregar nuevas anclas (`+`) y botón "Siguiente".
3. **Verificación Horaria de Tareas (Wireframe 3):** Lista de tareas del día proyectadas en horarios específicos (ej. *14:00 Presentación*, *15:30 Estudiar*, *20:00 Lavar ropa*, *21:00 Tender ropa*) con botones "Reorganizar Tareas" y "Comenzar".

> **Hallazgo Clave de Relación Temporal entre Wireframe 2 y Wireframe 3:**
> En el Wireframe 2 el usuario tiene ocupado de *17:30 a 19:30* (Gimnasio). En el Wireframe 3, las tareas se ubican en la ventana previa (*14:00 - 17:00*) y en la ventana posterior (*20:00 - 21:30*), sin solaparse jamás con el Gimnasio. Este es el principio de **"Time-Blocking Adaptativo"**.

### 1.2. La Problemática en TDAH / Disfunción Ejecutiva
- **Ceguera Temporal (*Time Blindness*):** Las personas con TDAH perciben el tiempo como dos estados: *"Ahora"* o *"No Ahora"*. Una lista abstracta de tareas provoca la ilusión de que "todo se puede hacer hoy", llevando a la frustración cuando chocan con la cursada universitaria o el trabajo.
- **Parálisis por Planificación Rígida:** Un calendario convencional (Google Calendar / Outlook) exige microgestionar cada minuto. Cuando un horario se rompe, el usuario abandona toda la app.
- **La Solución NeuroTask:** No imponemos un calendario estricto. Ofrecemos **"Anclas" (Islas fijas recurrentes)** y el motor calcula automáticamente los **"Huecos Cognitivos" (Ventanas Libres)** donde encajan las tareas del Grafo DAG generado en el Brain Dump.

---

## 2. Arquitectura de Dominio y Algoritmos

### 2.1. Modelo de Dominio: `TimeAnchor`
Ubicación: `lib/core/domain/models/time_anchor.dart`
```dart
class TimeAnchor {
  final String id;
  final String title;
  final String startTime; // "HH:mm" (ej. "08:00")
  final String endTime;   // "HH:mm" (ej. "12:00")
  final List<int> daysOfWeek; // 1 = Lunes, ..., 7 = Domingo (vacío = solo hoy)
  final String category;  // "Estudio", "Salud", "Trabajo", "Descanso"
  final bool isRecurring; // Si se repite semanalmente
  final bool isActive;

  const TimeAnchor({
    required this.id,
    required this.title,
    required this.startTime,
    required this.endTime,
    this.daysOfWeek = const [],
    this.category = 'General',
    this.isRecurring = true,
    this.isActive = true,
  });

  int get startMinutes => _toMinutes(startTime);
  int get endMinutes => _toMinutes(endTime);
  int get durationMinutes => endMinutes - startMinutes;

  static int _toMinutes(String time) {
    final parts = time.split(':');
    return int.parse(parts[0]) * 60 + int.parse(parts[1]);
  }
}
```

### 2.2. Algoritmo de Agendamiento Anti-Solapamiento (`AnchorScheduleFitter`)
Ubicación: `lib/core/domain/services/anchor_schedule_fitter.dart`
- **Entrada:**
  1. `List<TaskNode> tasks`: Nodos secuenciados en orden topológico por Kahn DAG.
  2. `List<TimeAnchor> anchors`: Anclas activas del día, ordenadas cronológicamente.
  3. `DateTime startTime`: Hora de inicio deseada (por defecto la hora actual o la mañana).
- **Proceso:**
  1. **Cálculo de Ventanas Libres (*Free Slots*):** Identifica intervalos disponibles entre el final de un ancla y el inicio de la siguiente.
  2. **Colocación Secuencial:** Para cada tarea en la cola del DAG:
     - Si la duración de la tarea cabe en la ventana libre actual, se le asigna la hora de inicio y fin.
     - Si colisiona con un ancla (ej. supera las 17:30 y hay gimnasio), **salta automáticamente** al término del ancla (19:30) y continúa en la siguiente ventana libre.
  3. **Diagnóstico de Viabilidad Cognitiva:**
     - Si la suma total de minutos de tareas supera las ventanas libres disponibles antes de la noche (ej. 23:00), el algoritmo genera una alerta serena:
       *"Atención: Tenés 4h 30m de tareas pero solo 2h 15m de ventanas libres. Te sugerimos posponer 2 tareas no críticas para mañana."*

---

## 3. Capa de Persistencia Robusta (Evaluación de Motores)

### 3.1. Restricciones Técnicas
- El proyecto se ejecuta tanto en **Web (`flutter run -d chrome`)** como en **Android / iOS**.
- El uso de `sqflite` crudo **no funciona en Web** sin configuraciones complejas de `sqlite3.wasm` en la carpeta `web/` y headers COOP/COEP.
- Los datos de NeuroTask comprenden:
  - Catálogo de Anclas Temporales (~5 a 20 registros).
  - Sesión activa de Foco DAG (`FocusState`).
  - Historial de tareas completadas / pendientes de días anteriores.
  - Baúl de Logros Cognitivos (`Achievements`).
  - Preferencias de Usuario (Modo Oscuro, Sonido, Haptics).

### 3.2. Decisión Arquitectural: Patrón Repositorio con Persistencia Dual
Implementar una interfaz abstracta de almacenamiento:
- `IAnchorRepository`: Carga, guarda, edita y elimina anclas.
- `IFocusSessionRepository`: Guarda y restaura el estado completo del grafo y tareas pendientes.
- `ITaskHistoryRepository`: Almacena el historial diario para retomar tareas pendientes de un día para el otro.

**Motor Primario:** `SharedPreferences` con serialización estructurada JSON y esquemas versionados (`v1`).
- **Ventajas:** 100% compatible con Web (Chrome), Android, iOS, Windows, macOS y Linux.
- **Rendimiento:** Latencia de lectura/escritura < 2ms, zero fallos de compilación nativa en Gradle, soporte completo para hot reload.
- **Evolución:** Si a futuro se requiere SQL relacional para millones de registros, la interfaz `IAnchorRepository` permite conectar SQLite sin tocar un solo Widget ni Notifier.

---

## 4. Integración Armónica con el Flujo de NeuroTask (UI/UX)

Para no perder la identidad visual neumórfica, el isotipo del cerebro neural ni el flujo de descompresión cognitiva, proponemos la siguiente arquitectura de navegación:

```
[WelcomeScreen] (Cerebro Neural, UNCuyo, Baúl de Logros)
       │
       ├── Botón "⚓ Mis Anclas" (Acceso al Gestor de Horarios Fijos)
       │         │
       │         └── [AnchorsManagerScreen / Sheet] (Wireframe 2 Neumórfico)
       │
       └── Toque al Cerebro ────────► [BrainDumpScreen] (Descompresión Libre)
                                              │
                                              ▼ (Al presionar "Descomprimir y Secuenciar")
                                     [ScheduleValidationScreen] (Wireframe 3 Neumórfico)
                                     "Tus tareas de hoy encajan con tus anclas"
                                     - Timeline interactivo con saltos de anclas
                                     - Botón "Reorganizar Tareas"
                                     - Botón "Comenzar Foco 1-a-1"
                                              │
                                              ▼
                                     [SingleTaskScreen] (Motor de Foco Zen)
```

---

## 5. Criterios de Aceptación y Calidad (DoD)

1. **Modelo de Anclas:** Entidad `TimeAnchor` con serialización completa JSON y soporte para recurrencia semanal.
2. **Algoritmo Anti-Solapamiento:** Algoritmo matemático puro con pruebas unitarias que demuestren que una tarea nunca se superpone con un ancla horaria.
3. **Gestor de Anclas Neumórfico:** Pantalla o modal sereno donde el usuario puede ver, crear y eliminar sus anclas habituales (Facultad, Gym, Comida, etc.).
4. **Pantalla de Verificación de Horarios:** Vista previa temporal tras el Brain Dump que muestra la distribución de las tareas en los huecos libres del día antes de iniciar el foco.
5. **Persistencia Multi-Día:** Las anclas y las tareas pendientes se conservan al cerrar y reabrir la app.
6. **Validación:** 100% de tests unitarios y de widgets pasando, 0 advertencias en `dart analyze`.
