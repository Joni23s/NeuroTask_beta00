# NT-SPEC-ARCH-005 / ADR-005: Maquetado en Flutter, Restricciones y Usabilidad de un Solo Usuario

- **Estado:** Aprobado y Actualizado
- **Fecha:** 2026-09-24 (Actualizado tras Implementación de Pantallas y Rutas)
- **Cátedra:** Desarrollo de Aplicaciones Móviles (DAM) — ITU UNCuyo
- **Equipo:** Araujo Jonathan, Batiatto Juan Martín, Belardinelli Agustín, Ortega Mateo
- **Referencia Curricular:** Unidad 2.2.1 — *Maquetado de Interfaces en Flutter y Pruebas de Usabilidad de un Solo Usuario*

---

## 1. Diagnóstico y Visión Técnica

El desarrollo en Flutter y el diseño para dispositivos móviles imponen tres realidades ineludibles:

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
  - Para listas con desbordamiento (`ListView.separated` en `AnchorsManagerScreen`, `ProfileScreen`, `SettingsScreen`), se envuelve en `Expanded` o `LayoutBuilder` para proveer límites acotados al padre y prevenir excepciones de tipo `RenderFlex unbounded height`.
- **Impacto:** Cero excepciones de desbordamiento de pantalla en modo portrait y landscape.

### ADR-005.2: Navegación e Itinerario Guiado con Rutas Centralizadas (11 Pantallas + 6 Modales)
- **Decisión:** Implementar un mapa de **rutas nombradas centralizado en `main.dart`** que soporta tanto la secuencia lineal de foco como el acceso a herramientas globales (Perfil, Configuración, Anclas, Logros):
  - **Secuencia de Inicio:** `Splash (/)` ➔ `Onboarding (/onboarding)` ➔ `Login (/auth)` ➔ `Welcome (/welcome)`
  - **Secuencia de Foco:** `Welcome` ➔ `BrainDump (/brain-dump)` ➔ `SingleTask (/single-task)` ➔ `Celebration (/celebration)`
  - **Herramientas Complementarias:** `AnchorsManager (/anchors)`, `AchievementsVault (/achievements)`, `ProfileScreen (/profile)`, `SettingsScreen (/settings)`
- **Impacto:** Cumplimiento total de la consigna práctica (11 pantallas full-screen + 6 modales = 17 superficies).

### ADR-005.3: Significadores Táctiles Neumórficos (Affordance sin Cursor)
- **Decisión:** Debido a la falta de cursor en entornos táctiles, compensar la ausencia de *hover* mediante **significadores táctiles tridimensionales**:
  - Elevación neumórfica visual con dobles sombras (luz superior izquierda a $135^\circ$ y sombra inferior derecha).
  - Áreas mínimas táctiles $\ge 48\times 48\text{ dp}$ según las guías de accesibilidad de Material Design y Apple HIG.
  - Retroalimentación auditiva y háptica sutil (`HapticHelper.lightTap()`, `HapticHelper.success()`) que confirma de inmediato la captura de la pulsación física.

### ADR-005.4: Evaluación Empírica (*"Evaluar, No Crear"*) y Eliminación de Debates Religiosos
- **Decisión:** Adoptar el principio de Krug: las pruebas de usabilidad son para **evaluar comportamientos reales, no para rediseñar la app en base a opiniones subjetivas**.
- **Regla de Oro:** Si surgen discusiones de equipo sobre si un botón debe ubicarse arriba o abajo, o sobre colores de acento ("debates religiosos"), se somete a prueba inmediata con **un solo usuario** y se prioriza el dato de su comportamiento observable por sobre las opiniones del equipo.

---

## 3. Matriz de Inventario de Superficies (11 Full-Screen + 6 Modales)

| # | Identificador | Nombre de Pantalla / Modal | Ruta | Tipo |
|---|---------------|----------------------------|------|------|
| 1 | `SCR_00` | **SplashScreen** | `/` | Full Screen |
| 2 | `SCR_01` | **OnboardingScreen** | `/onboarding` | Full Screen |
| 3 | `SCR_02` | **LoginRegisterScreen** | `/auth` | Full Screen |
| 4 | `SCR_03` | **WelcomeScreen** | `/welcome` | Full Screen |
| 5 | `SCR_04` | **BrainDumpScreen** | `/brain-dump` | Full Screen |
| 6 | `SCR_05` | **SingleTaskScreen** | `/single-task` | Full Screen |
| 7 | `SCR_06` | **SummaryCelebrationScreen** | `/celebration` | Full Screen |
| 8 | `SCR_07` | **AnchorsManagerScreen** | `/anchors` | Full Screen |
| 9 | `SCR_08` | **AchievementsVaultScreen** | `/achievements` | Full Screen |
| 10 | `SCR_09` | **ProfileScreen** | `/profile` | Full Screen |
| 11 | `SCR_10` | **SettingsScreen** | `/settings` | Full Screen |
| + | `MDL_01..06` | **VoiceDictation, Processing, CognitiveRescue, GraphOverview, ReportPreview, AchievementDetail** | Modales | BottomSheet / Dialog |

---

## 4. Documentos Complementarios
- Catálogo Completo de Pantallas: [SCREEN_CATALOG.md](file:///c:/Users/Agus/Desktop/NeuroTask%20Igna/NeuroTask_beta00/SCREEN_CATALOG.md)
- Guía y Ficha de Prueba de Usabilidad: [docs/PROTOCOLO_PRUEBA_USABILIDAD_1_USUARIO.md](file:///c:/Users/Agus/Desktop/NeuroTask%20Igna/NeuroTask_beta00/docs/PROTOCOLO_PRUEBA_USABILIDAD_1_USUARIO.md)
- Plan de Implementación: [plan_implementacion.md](file:///C:/Users/Agus/.gemini/antigravity-ide/brain/c3606168-217f-45b4-ad50-3306ad83c729/plan_implementacion.md)
