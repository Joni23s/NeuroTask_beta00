# NT-SPEC-ARCH-005 / ADR-005: Maquetado en Flutter, Restricciones y Usabilidad de un Solo Usuario

- **Estado:** Aprobado y Documentado
- **Fecha:** 2026-09-14
- **Cátedra:** Desarrollo de Aplicaciones Móviles (DAM) — ITU UNCuyo
- **Equipo:** Araujo Jonathan, Batiatto Juan Martín, Belardinelli Agustín, Ortega Mateo
- **Referencia Curricular:** Unidad 2.2.1 — *Maquetado de Interfaces en Flutter y Pruebas de Usabilidad de un Solo Usuario*

---

## 1. Diagnóstico y Visión Técnica

El desarrollo en Flutter y el diseño para dispositivos móviles imponen dos realidades ineludibles:

1. **La Regla de Oro del Renderizado en Flutter:**
   > *"Las restricciones bajan. Los tamaños suben. Los padres definen las posiciones."*
   Las pantallas móviles no son lienzos de coordenadas absolutas; son árboles de composición jerárquica donde cada widget padre acota el tamaño de sus hijos (`BoxConstraints`) y los hijos negocian su propia dimensión.
2. **Las Restricciones Físicas del Entorno Táctil:**
   - **Tiranía del pequeño espacio:** Pantallas de 5 a 6.7 pulgadas exigen concisión radical. Todo elemento superfluo satura la atención visual.
   - **Ausencia de cursor (Sin Hover):** En pantallas táctiles la salida visual coincide con la entrada táctil. No existen pistas de cursor (*hover*); los botones y campos interactivos deben incorporar **significadores visuales explícitos** (relieve, contraste y bordes) para que su interacción sea autoevidente.
3. **El Enfoque de Usabilidad de Steve Krug (*"No me hagas pensar"*):**
   Los usuarios no leen manuales ni analizan arquitecturas de pantalla; ojean rápidamente buscando pistas familiares y seleccionan la primera opción razonable que resuelve su necesidad (*satisficing*).

---

## 2. Decisiones de Arquitectura y Maquetado (ADRs)

### ADR-005.1: Composición de Widgets y Gestión de Restricciones
- **Decisión:** Construir todos los componentes de interfaz mediante el principio de **composición estricta de bajo nivel**, respetando el flujo unidireccional de restricciones de Flutter:
  - `NeumorphicButton` compone `Material`, `InkWell`, `Padding` y `AnimatedContainer` con doble sombra de luz y sombra.
  - Para listas con desbordamiento (`ListView.separated` en `AnchorsManagerScreen`), se envuelve en `Expanded` o `LayoutBuilder` para proveer límites acotados al padre y prevenir excepciones de tipo `RenderFlex unbounded height`.
- **Impacto:** Cero excepciones de desbordamiento de pantalla en modo portrait y landscape.

### ADR-005.2: Navegación e Itinerarios Estrictamente Lineales
- **Decisión:** Descartar menús laberínticos en red (cajones laterales profundos o árboles anidados) y estructurar un **itinerario lineal paso a paso**:
  $$\text{WelcomeScreen} \longrightarrow \text{BrainDumpScreen} \longrightarrow \text{SingleTaskScreen} \longrightarrow \text{SummaryCelebrationScreen}$$
- **Razón Neurocognitiva:** Reducir la sobrecarga ejecutiva en usuarios con TDAH o fatiga mental. El usuario siempre sabe cuál es el siguiente paso sin tomar decisiones de navegación confusas.

### ADR-005.3: Significadores Táctiles Neumórficos (Affordance sin Cursor)
- **Decisión:** Debido a la falta de cursor en entornos táctiles, compensar la ausencia de *hover* mediante **significadores táctiles tridimensionales**:
  - Elevación neumórfica visual con dobles sombras (luz superior izquierda a $135^\circ$ y sombra inferior derecha).
  - Áreas mínimas táctiles $\ge 48\times 48\text{ dp}$ según las guías de accesibilidad de Material Design y Apple HIG.
  - Retroalimentación auditiva y háptica sutil (`HapticHelper.lightTap()`, `HapticHelper.success()`) que confirma de inmediato la captura de la pulsación física.

### ADR-005.4: Evaluación Empírica (*"Evaluar, No Crear"*) y Eliminación de Debates Religiosos
- **Decisión:** Adoptar el principio de Krug: las pruebas de usabilidad son para **evaluar comportamientos reales, no para rediseñar la app en base a opiniones subjetivas**.
- **Regla de Oro:** Si surgen discusiones de equipo sobre si un botón debe ubicarse arriba o abajo, o sobre colores de acento ("debates religiosos"), se somete a prueba inmediata con **un solo usuario** y se prioriza el dato de su comportamiento observable por sobre las opiniones del equipo.

---

## 3. Matriz de Cumplimiento Curricular (Unidad 2.2.1)

| # | Eje Temático del Programa | Evidencia Concreta en NeuroTask |
|---|---------------------------|----------------------------------|
| **1** | **Composición y Restricciones** | Widgets desacoplados (`NeumorphicButton`, `NeuroModalSheet`, `NeuroBadge`). Flujo de restricciones acotado con `Expanded` y `LayoutBuilder`. |
| **2** | **Widgets de Estructura (`Scaffold`, `ListView`, `ListTile`)** | Todas las vistas implementan `Scaffold`. Colecciones implementadas con `ListView.separated` y tarjetas con `ListTile` canónico (`leading`, `title`, `subtitle`, `trailing`, `onTap`). |
| **3** | **Navegación e Itinerarios Lineales** | Secuencia lineal guiada: Inicio $\rightarrow$ Volcado Mental $\rightarrow$ Tarea Atómica $\rightarrow$ Cierre. Cero laberintos. |
| **4** | **"No me hagas pensar" (Steve Krug)** | Jerarquía tipográfica inmediata, botones primarios contrastados y descompresión libre sin clasificaciones forzadas. |
| **5** | **Entorno Táctil: Sin Cursor y Pequeño Espacio** | Foco de 1 sola tarea en pantalla (respeto al pequeño espacio); relieve neumórfico tridimensional para significadores visuales claros sin hover. |
| **6** | **Evaluar, No Crear** | Medición de fricciones en el flujo real sin agregar características no validadas. |
| **7** | **Enfoque de Guerrilla de un Solo Usuario** | Metodología de micro-pruebas rápidas con 1 usuario al inicio para prevenir reescrituras costosas cerca de la entrega. |
| **8** | **Protocolo "Pensar en Voz Alta"** | Guion estandarizado del estudiante como coordinador neutral con preguntas de intervención no directivas. |
| **9** | **Evitar Debates Religiosos con Datos** | Métricas de comportamiento (tiempo en pantalla, vacilaciones al pulsar, comprensión del rescate cognitivo). |
| **10** | **Prototipado Previo de Baja Fidelidad** | Trazabilidad completa: wireframes conceptuales (`docs/FIGMA_BLUEPRINT_AND_WIREFRAMES.md`), prototipo web (`web_prototype/`) y aplicación Flutter. |

---

## 4. Documentos Complementarios
- Guía y Ficha de Prueba: [docs/PROTOCOLO_PRUEBA_USABILIDAD_1_USUARIO.md](file:///c:/Users/jonat/Downloads/Codigos/NeuroTask_beta00/docs/PROTOCOLO_PRUEBA_USABILIDAD_1_USUARIO.md)
- Ejecución Inmediata en Celular: [iniciar_con_qr.bat](file:///c:/Users/jonat/Downloads/Codigos/NeuroTask_beta00/iniciar_con_qr.bat)
