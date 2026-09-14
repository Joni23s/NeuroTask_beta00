# NT-SPEC-ARCH-006 / ADR-006: Arquitectura, Persistencia y Capa de Datos en Flutter

- **Estado:** Aprobado e Implementado
- **Fecha:** 2026-09-14
- **Cátedra:** Desarrollo de Aplicaciones Móviles (DAM) — ITU UNCuyo
- **Equipo:** Araujo Jonathan, Batiatto Juan Martín, Belardinelli Agustín, Ortega Mateo
- **Referencia Curricular:** Unidad 3.1.1 — *Arquitectura y Capa de Datos en Flutter*

---

## 1. Contexto y Diagnóstico de Ingeniería

En el desarrollo de aplicaciones móviles con Flutter, la interfaz visual se rige por el principio declarativo fundamental:
$$\text{UI} = f(\text{Estado})$$

La interfaz de usuario no es una estructura imperativa que deba manipularse manualmente píxel a píxel; es una **función pura del estado actual de los datos**. Por ello, el desarrollo sigue un enfoque **Bottom-to-Top (De Abajo hacia Arriba)**: consolidar primero el motor de persistencia, los modelos de dominio tipados y las funciones puras antes de construir las pantallas en el método `build()`.

---

## 2. Organización del Directorio `lib/` (Bajo Acoplamiento y Alta Cohesión)

Para garantizar un código mantenible y escalable, la arquitectura se estructura en capas independientes:

```text
lib/
├── main.dart                 <-- Punto de entrada con ProviderScope reactivo
├── util/
│   ├── utils.dart            <-- Barrel export de utilidades
│   └── date_time_formatter.dart <-- Funciones puras independientes
├── model/
│   ├── model.dart            <-- Definición y exportación de entidades de datos
│   └── dbhelper.dart         <-- Persistencia local encapsulada (Patrón Singleton)
└── features/
    ├── brain_dump/           <-- UI y controladores de volcado mental
    ├── anchors/              <-- UI y controladores de anclas horarias
    └── focus/                <-- UI y controladores de modo foco
```

- **Alta Cohesión (High Cohesion):** Cada módulo tiene una responsabilidad única. `DateTimeFormatter` en `lib/util/` no conoce la existencia de bases de datos ni de widgets de UI; solo transforma datos primitivos.
- **Bajo Acoplamiento (Low Coupling):** Las vistas en `features/` nunca interactúan directamente con cadenas SQL o almacenamiento de bajo nivel; consumen objetos Dart tipados (`TimeAnchor`, `TaskNode`) y delegan la persistencia a `DbHelper`.

---

## 3. Decisiones de Arquitectura (ADRs)

### ADR-006.1: Funciones Puras en `utils.dart` (*Shifting Left*)
- **Decisión:** Alojar la lógica de cálculo y formateo de fechas y horarios en `DateTimeFormatter` como **funciones puras** (deterministas y sin efectos secundarios).
- **Ventaja de Ingeniería:** Permite realizar pruebas unitarias inmediatas (*Shifting Left*) en milisegundos sin emuladores ni mocks de base de datos.

### ADR-006.2: Constructores Nombrados y Mapeo Bidireccional (`toMap` y `fromObject`)
- **Decisión:** Implementar serialización relacional plana en cada entidad del modelo:
  ```text
  [ Objeto Dart: TimeAnchor ]  ====== toMap() ======>   [ Map<String, dynamic> ]  ======> [ Persistencia ]
  [ Objeto Dart: TimeAnchor ]  <== fromObject(map) ===  [ Map<String, dynamic> ]  <====== [ Persistencia ]
  ```
- **Constructor Nombrado `.withId`:** Utilizado para reconstruir objetos preexistentes desde la persistencia garantizando la integridad referencial.

### ADR-006.3: Concurrencia Asíncrona en el Event Loop
- **Decisión:** Ejecutar todas las lecturas y escrituras de persistencia de forma asíncrona mediante `Future`, `async` y `await`.
- **Regla de Oro:** **Nunca bloquear el hilo principal (UI Thread / Main Isolate)**. Las consultas se resuelven en segundo plano mientras la interfaz continúa renderizando fluidamente a 60/120 FPS.

### ADR-006.4: Patrón Singleton en `DbHelper`
- **Decisión:** Implementar el patrón creacional **Singleton** en `DbHelper`:
  ```dart
  class DbHelper {
    static final DbHelper _dbHelper = DbHelper._internal();
    DbHelper._internal();
    factory DbHelper() => _dbHelper;
  }
  ```
- **Razón Técnica:** Evita la apertura de múltiples conexiones concurrentes al almacenamiento, previniendo condiciones de carrera, corrupción de datos y fugas de memoria.

### ADR-006.5: Transacciones CRUD y Tolerancia Heurística (`deleteRows`)
- **Decisión:** Exponer operaciones CRUD limpias con firmas asíncronas de control:
  - `Future<int> insertAnchor(TimeAnchor anchor)`
  - `Future<List<Map<String, dynamic>>> getAnchors()`
  - `Future<int> updateAnchor(TimeAnchor anchor)`
  - `Future<int> deleteAnchor(String id)`
  - `Future<int> deleteRows()`: Truncado seguro de la tabla para reseteo y recuperación ante fallos.

---

## 4. Matriz de Cumplimiento Curricular (Unidad 3.1.1)

| # | Eje Temático del Programa | Evidencia en la Implementación de NeuroTask |
|---|---------------------------|---------------------------------------------|
| **1** | **Enfoque Bottom-to-Top y UI Declarativa** | Los modelos de dominio y el motor DAG se desarrollaron previamente a las pantallas; la UI es una función pura del estado de Riverpod. |
| **2** | **Estructura `lib/` (Bajo Acoplamiento y Cohesión)** | Carpetas canónicas [lib/model/](file:///c:/Users/jonat/Downloads/Codigos/NeuroTask_beta00/flutter_app/lib/model/model.dart) y [lib/util/](file:///c:/Users/jonat/Downloads/Codigos/NeuroTask_beta00/flutter_app/lib/util/utils.dart) con separación total de UI y persistencia. |
| **3** | **Funciones Puras en `utils.dart`** | [DateTimeFormatter](file:///c:/Users/jonat/Downloads/Codigos/NeuroTask_beta00/flutter_app/lib/util/date_time_formatter.dart) con funciones deterministas probadas en milisegundos sin emulador. |
| **4** | **Modelado Tipado y Null Safety** | Entidades Dart 3 inmutables con atributos estrictamente tipados. |
| **5** | **Constructores Nombrados (`.withId`)** | `TimeAnchor.withId` y `TaskNode.withId` para instancias leídas desde persistencia. |
| **6** | **Serialización `toMap()` y `fromObject()`** | Métodos canónicos de mapeo bidireccional en `TimeAnchor` y `TaskNode`. |
| **7** | **Concurrencia en el Event Loop** | Operaciones de persistencia encapsuladas en `Future` sin bloquear los 60/120 FPS de la UI. |
| **8** | **Patrón Singleton en `DbHelper`** | Constructor privado `_internal()` y `factory DbHelper()` garantizando instancia única en memoria. |
| **9** | **Transacciones CRUD (`Future<int>`)** | Métodos `insertAnchor`, `getAnchors`, `updateAnchor`, `deleteAnchor` con retorno de filas afectadas. |
| **10** | **Tolerancia Heurística y `deleteRows()`** | Método de vaciado seguro `deleteRows()`, reset a defaults y validación preventiva con `_formKey.currentState.validate()`. |

---

## 5. Verificación de Integración
- Código fuente del helper: [lib/model/dbhelper.dart](file:///c:/Users/jonat/Downloads/Codigos/NeuroTask_beta00/flutter_app/lib/model/dbhelper.dart)
- Servicio integrado: [lib/core/services/anchors_storage_service.dart](file:///c:/Users/jonat/Downloads/Codigos/NeuroTask_beta00/flutter_app/lib/core/services/anchors_storage_service.dart)
