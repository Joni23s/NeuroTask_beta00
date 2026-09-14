# NT-SPEC-ARCH-004 / ADR-004: Alineación Arquitectónica con el Programa Oficial DAM (Flutter)

- **Estado:** Aprobado e Implementado
- **Fecha:** 2026-09-14
- **Cátedra:** Desarrollo de Aplicaciones Móviles (DAM) — ITU UNCuyo
- **Equipo:** Araujo Jonathan, Batiatto Juan Martín, Belardinelli Agustín, Ortega Mateo
- **Referencia Curricular:** Unidad 2.1.1 — *Introducción al Desarrollo de Aplicaciones Móviles con Flutter*

---

## 1. Contexto y Diagnóstico

Para la evaluación académica de la materia DAM, la cátedra define una serie de convenciones y patrones canónicos en Flutter que los proyectos deben demostrar:
1. Separación de roles en subdirectorios claros (`lib/model/`, `lib/util/`).
2. Modelado de datos con constructores nombrados para registros existentes (`.withId`).
3. Captura e interactividad segura en formularios (`Form`, `GlobalKey<FormState>`, `TextFormField`, validación con `validate()`).
4. Notificaciones dinámicas y temporales en tiempo real (`SnackBar`).
5. Estructuración semántica de colecciones y eventos táctiles (`ListTile`, `onTap`).
6. Respeto estricto a las leyes de usabilidad (*"No me hagas pensar"* - Steve Krug) y ergonomía táctil.

El desafío arquitectónico consistió en **incorporar estos patrones canónicos sin romper la arquitectura modular por features ni degradar la experiencia neurocognitiva serena (DCU para TDAH)** característica de NeuroTask.

---

## 2. Decisiones de Arquitectura (ADRs)

### ADR-004.1: Estructura de Carpetas Canónica con *Barrel Exports*
- **Decisión:** Mantener el dominio modular en `lib/core/domain/models/` y `lib/core/utils/`, y crear archivos de exportación puente (*barrel files*) en la raíz de `lib/`:
  - `lib/model/models.dart`: Expone `TimeAnchor`, `TaskNode`, `TaskGraph` y `Achievement`.
  - `lib/util/utils.dart` y `lib/util/date_time_formatter.dart`: Expone formateadores generales de fechas, horarios y soporte háptico.
- **Consecuencia:** Cumplimiento literal de la nomenclatura solicitada por la cátedra sin desarmar la arquitectura limpia existente.

### ADR-004.2: Constructores Nombrados de Entidad (`.withId`)
- **Decisión:** Incorporar constructores nombrados `TimeAnchor.withId(...)` y `TaskNode.withId(...)` en los modelos inmutables de dominio.
- **Razón:** Reflejar la práctica estándar enseñada en la cátedra para hidratar entidades persistidas en almacenamiento local (SQLite/Preferences).

### ADR-004.3: Validación Declarativa de Formularios (`Form` + `GlobalKey`)
- **Decisión:** Refactorizar el formulario de anclas horarias (`_AddAnchorForm`) para utilizar:
  - `final GlobalKey<FormState> _formKey = GlobalKey<FormState>();`
  - Widget `Form(key: _formKey, child: ...)`
  - `TextFormField` con función `validator:` que previene campos vacíos y exige nombres significativos ($\ge 3$ caracteres).
  - Verificación `if (!_formKey.currentState!.validate()) return;` previa a la persistencia.
- **Diseño Ergonómico:** Los mensajes y bordes de error (`errorBorder`, `errorStyle`) respetan la paleta neumórfica para guiar al usuario sin generar frustración visual ni estridencias cognitivas.

### ADR-004.4: Feedback de Usuario en Tiempo Real (`SnackBar`)
- **Decisión:** Implementar notificaciones mediante `ScaffoldMessenger.of(context).showSnackBar(...)`.
- **Implementación:**
  - `SnackBarBehavior.floating` con esquinas redondeadas y acentos de color de marca.
  - Notificación de éxito al guardar anclas: *"Ancla '<nombre>' agregada correctamente"*.
  - Notificación contextual al eliminar anclas: *"Ancla '<nombre>' eliminada"*.

### ADR-004.5: Colecciones Semánticas con `ListTile` y Navegación `onTap`
- **Decisión:** Reemplazar filas ad-hoc por el widget estándar `ListTile` dentro de las tarjetas neumórficas del listado:
  - `leading`: Badge de rango horario (hora inicio y fin).
  - `title`: Título de la actividad.
  - `subtitle`: Categoría y duración formateada con `DateTimeFormatter.formatDuration(...)`.
  - `trailing`: Botón de acción (eliminar con feedback háptico).
  - `onTap`: Callback interactivo que abre el modal `_onShowAnchorDetails` para inspeccionar el ancla seleccionada.

---

## 3. Matriz de Cumplimiento con la Cátedra (10 Puntos)

| # | Eje Temático del Programa | Evidencia en la Implementación |
|---|---------------------------|--------------------------------|
| **1** | **Multiplataforma** | Base de código única ejecutando en **Web** y compilada nativa en **Android** (`app-release.apk`). |
| **2** | **Organización (`lib/`, `model/`, `util/`)** | Directorios canónicos `lib/model/` y `lib/util/` con formateadores y modelos exportados. |
| **3** | **Modelado y Persistencia** | Clases tipadas inmutables, constructores `.withId`, y servicio `AnchorsStorageService` (Offline First). |
| **4** | **`Widget build()` y `Scaffold`** | Pantallas declarativas estructuradas con `Scaffold`, `appBar`/header y `body` responsivo. |
| **5** | **`Form`, `_formKey` y `SnackBar`** | Formulario `_AddAnchorForm` con validación estricta y `SnackBar` flotante de confirmación. |
| **6** | **`ListTile` y Eventos `onTap`** | Listado de anclas con `ListTile` (`leading`, `title`, `subtitle`, `trailing`) y navegación `onTap`. |
| **7** | **Usabilidad ("No me hagas pensar")** | Volcado libre sin categorización forzada y foco de 1 sola tarea a la vez para evitar parálisis ejecutiva. |
| **8** | **Diseño Táctil y Adaptativo** | Objetivos táctiles $\ge 48\times 48\text{ dp}$, respuesta háptica (`HapticHelper`) y soporte Dark/Light Mode. |
| **9** | **Tolerancia a Errores** | Validación no punitiva en formularios y rescate cognitivo en 3 micro-pasos guiados. |
| **10** | **Enfoque Lean y Prototipado** | Wireframes de Figma, prototipo web interactivo y testing local inmediato (`iniciar_con_qr.bat`). |

---

## 4. Estado de Verificación y Calidad

- **Análisis Estático:** `dart analyze lib/ test/` $\rightarrow$ **0 advertencias / 0 errores**.
- **Pruebas Automatizadas:** `flutter test` $\rightarrow$ **14 de 14 tests pasando (100% OK)**.
- **Compatibilidad:** 100% retrocompatible con la arquitectura y funcionalidades previas.
