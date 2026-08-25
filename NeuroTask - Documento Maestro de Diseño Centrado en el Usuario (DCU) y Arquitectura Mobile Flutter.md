# **NeuroTask Mobile: Documento Maestro de Diseño Centrado en el Usuario (DCU)**

**Especificación Metodológica, Arquitectura de Experiencia y Diseño de Interfaz Mobile-First (Flutter)**

| Cátedra / Carrera | Desarrollo de Aplicaciones Móviles — ITU, Universidad Nacional de Cuyo |
| :---- | :---- |
| **Trabajo Práctico** | Ejercitación \- Tema 1: Aplicación del Diseño Centrado en el Usuario (DCU) |
| **Equipo de Desarrollo** | Araujo Jonathan, Batiatto Juan Martín, Belardinelli Agustín, Ortega Mateo |
| **Stack Mobile** | Flutter (Dart) / Clean Architecture / StateNotifier (Riverpod) |
| **Estilo Visual** | Light Soft Paper / Soft Neumorphism (Baja Carga Sensorial y Cognitiva) |

## **1\. Resumen Ejecutivo y Marco Teórico**

### **1.1 La Paradoja de la Productividad en Dispositivos Móviles**

Las herramientas de gestión de tareas y proyectos más difundidas en el mercado móvil (como Notion, Trello, Jira o Asana) han trasladado la complejidad de sus ecosistemas de escritorio directamente a las pantallas de los smartphones. En un teléfono móvil, este paradigma resulta contraproducente: la sobreabundancia de menús contextuales, selectores de fechas, etiquetas multidimensionales y tableros kanban en pantallas reducidas genera una severa sobrecarga visual y cognitiva.  
Para un estudiante o profesional que sufre de fatiga mental, estrés crónico o condiciones neurodivergentes (como el Trastorno por Déficit de Atención e Hiperactividad \- TDAH), abrir una aplicación móvil y encontrarse con una lista de 15 o 20 pendientes desencadena inmediatamente *disfunción ejecutiva* y *parálisis por análisis*. El cerebro no logra discriminar la jerarquía ni el orden temporal de las acciones, provocando postergación evitativa y el abandono de la aplicación.

### **1.2 Propuesta de Valor: El Enfoque NeuroTask**

**NeuroTask** invierte por completo la carga operativa en el smartphone. En lugar de obligar al usuario a organizar manualmente sus obligaciones, el sistema ofrece:

> * **Ingesta Cruda Asíncrona (Brain Dump):** Una pantalla limpia donde volcar ideas mediante texto libre o notas de voz en lenguaje cotidiano, sin requerir fechas ni etiquetas previas.  
> * **Secuenciación Algorítmica (Grafo DAG):** Procesamiento y descomposición del texto en micro-tareas atómicas conectadas mediante un Grafo Acíclico Dirigido (DAG) con ordenamiento topológico automático.  
> * **Single-Task Focus Viewport Mobile:** La interfaz oculta la totalidad de la lista de pendientes y presenta estrictamente **una única tarea ejecutable a la vez** en pantalla completa, eliminando la ansiedad visual.  
> * **Mecanismo de Desbloqueo Adaptativo:** Si el usuario se siente abrumado o trabado en una tarea, un solo toque recalcula el camino óptimo o subdivide la tarea en micro-pasos inmediatos sin generar culpa.

### **1.3 Justificación de la Estética Light Soft Paper & Soft Neumorphism**

Para una aplicación orientada a la descompresión cognitiva, el lenguaje visual debe transmitir calma, tactilidad y orden orgánico. La estética *Light Soft Paper* combinada con *Soft Neumorphism* utiliza fondos cálidos en blanco roto/gris suave (\#F5F6F8), superficies elevadas con sombras difusas dobles y ausencia de contrastes estridentes o alertas rojas punitivas. Esto recrea la serenidad de una hoja de papel físico de alta calidad, reforzada por la fluidez de renderizado a 60/120 fps de Flutter.

## **2\. Etapa 1: Empatizar (Investigación y Modelado de Usuarios)**

El objetivo central de esta fase es comprender profundamente las necesidades, fricciones emocionales y modelos mentales del usuario frente a las aplicaciones móviles de productividad.

### **2.1 Artefacto 1: User Persona — Juan Martín**

| Perfil de Usuario: Juan Martín |  |
| :---- | :---- |
| **Datos Demográficos** | 23 años, estudiante de Ingeniería / Desarrollo de Software y programador freelance. |
| **Contexto Neurocognitivo** | Diagnosticado con TDAH predominantemente inatento. Experimenta sobrecarga sensorial en smartphones y dificultades severas en la función ejecutiva para iniciar proyectos. |
| **Dispositivos y Hábitos** | Uso intensivo de smartphone Android/iOS. Consulta el móvil entre 80 y 120 veces al día. Utiliza el celular en tránsitos, pausas de estudio y momentos de procrastinación. |
| **Objetivos Principales** | Iniciar entregas académicas y tareas laborales sin demoras excesivas. Volcar rápidamente compromisos que surgen de golpe sin tener que estructurarlos en el acto. Sentir que progresa de forma tangible y sostenida durante su jornada. |
| **Frustraciones y Dolores** | Abrir una app móvil y ver un listado infinito de pendientes con fechas de vencimiento vencidas en color rojo. La fricción de tener que escribir título, elegir proyecto, poner prioridad, tag y hora para cada idea. La sensación de culpa y abandono recurrente de las herramientas tradicionales. |

### **2.2 Artefacto 2: Mapa de Empatía**

| ¿Qué piensa y siente? | ¿Qué oye? |
| :---- | :---- |
| • *"Tengo mil cosas por entregar y no tengo idea de cuál es el primer paso."* • *"Me da ansiedad abrir la aplicación porque me recuerda todo lo que tengo retrasado."* • *"Siento que gasto más energía organizando las tareas que programando."* | • Compañeros y profesores: *"Tenés que armar un cronograma y respetarlo a rajatabla."* • Redes y gurús de productividad: *"Usá Notion, sincronizalo con Google Calendar y organizá por bloques."* • Su entorno: *"Te distraés con cualquier cosa, concentrate."* |
| ¿Qué ve? | ¿Qué dice y hace? |
| • Notificaciones intrusivas de alertas móviles de calendario que descarta por costumbre. • Tableros de Trello o Jira abarrotados de tarjetas sin mover. • Notas dispersas en borradores de WhatsApp, cuadernos físicos y notas rápidas del celular. | • Dice: *"Hoy me pongo las pilas y liquido todo"*, pero se sienta y no sabe por dónde empezar. • Hace: Se pierde en detalles menores antes de encarar el núcleo del problema. • Instala una app de tareas, la usa dos días de forma obsesiva y la abandona al tercer día cuando se desfasa. |

## **3\. Etapa 2: Definir (El Problema y Oportunidad de Diseño)**

En esta etapa sintetizamos los hallazgos de investigación para articular con precisión el desafío de diseño que resolverá la aplicación móvil.

### **3.1 Point of View (POV) Canónico**

| \[Usuario\]: Un estudiante universitario y profesional de tecnología con sobrecarga cognitiva y TDAH... \[Necesita\]: Una interfaz móvil que capture sus pensamientos de forma desestructurada y le presente exactamente una única micro-tarea a la vez sin fricción de configuración previa... \[Porque / Insight\]: Enfrentarse visualmente a listas extensas de pendientes y tener que categorizar manualmente fechas, prioridades y etiquetas activa disfunción ejecutiva, provocando parálisis por análisis y procrastinación evitativa. |
| :---- |

### **3.2 Problem Statement Formal**

*"Las interfaces móviles de gestión de proyectos actuales fallan al exigir un esfuerzo de categorización y estructuración manual excesivo previo a la acción, lo cual abruma a los usuarios con sobrecarga cognitiva e interrumpe el flujo productivo natural. Se requiere un sistema móvil reactivo que automatice el desglose y ordenamiento lógico de tareas, permitiendo una ejecución atómica 1 a 1 libre de distracciones visuales."*

### **3.3 Preguntas How Might We (HMW) — Ejes de Ideación**

> * **HMW 1 (Ingesta Cero Fricción):** ¿Cómo podríamos permitir que el usuario descargue un torbellino de ideas en menos de 10 segundos desde su pantalla de bloqueo o inicio?  
> * **HMW 2 (Descompresión Algorítmica):** ¿Cómo podríamos traducir un bloque caótico de texto en una secuencia lógica ordenada sin que el usuario tenga que arrastrar tarjetas ni crear dependencias manualmente?  
> * **HMW 3 (Ejecución Atómica):** ¿Cómo podríamos diseñar una pantalla de enfoque móvil que proporcione certidumbre y tranquilidad, blindando al usuario contra la tentación de multitarea o pánico por el volumen total?

## **4\. Etapa 3: Idear (Arquitectura de Información y Flujo de Interacción)**

En esta etapa transformamos las respuestas al POV y HMW en un flujo de navegación móvil ultra optimizado y una arquitectura de información con jerarquía plana.

### **4.1 User Flow Mobile (Paso a Paso)**

| Paso | Acción del Usuario | Respuesta del Sistema (Mobile Engine) | Estado de UX Emocional   |
| :---: | :---- | :---- | :---- |
| **1** | Abre la app móvil y pulsa el área central de *Brain Dump* (o botón de micrófono). | Despliega un lienzo limpio tipo hoja de papel suave. El teclado se activa automáticamente. | Alivio, sin exigencia de llenar formularios. |
| **2** | Escribe un párrafo libre o dicta por voz todo lo que tiene que hacer para su entrega. | Captura el texto crudo sin validación ortográfica restrictiva y habilita el botón flotante *"Secuenciar"*. | Sensación de descarga mental inmediata. |
| **3** | Presiona *"Secuenciar"*. | Micro-animación de respiración visual mientras el parser construye el Grafo DAG y ordena topológicamente los nodos. | Anticipación serena, cero ruido visual. |
| **4** | Entra en el *Single-Task Focus Viewport*. | Muestra únicamente la Tarea \#1 con su descripción concisa, temporizador suave y dos botones principales (*Completar* / *Bloqueado*). | Claridad absoluta de acción ("Sé exactamente qué hacer ahora"). |
| **5A** | Completa la tarea y desliza o presiona *"Completada"*. | Feedback háptico sutil, animación de desvanecimiento suave y transición inmediata a la Tarea \#2 según el grafo. | Recompensa dopaminérgica sana y avance continuo. |
| **5B** | Se encuentra trabado y pulsa *"Estoy bloqueado"* o *"Dividir más"*. | El grafo detecta la rama alternativa viable o subdivide el nodo actual en 2 micro-pasos de 3 minutos sin penalización. | Seguridad emocional y rescate del bloqueo. |

### **4.2 Arquitectura de Información (IA Mobile Minimalista)**

A diferencia de las arquitecturas en árbol profundas de Notion o Jira, NeuroTask implementa un modelo de **profundidad 1** (Single Level Focus) estructurado en 3 vistas principales accesibles mediante gestos naturales:

`[ APP ROOT / FLUTTER SCAFFOLD ]`  
  `│`  
  `├── 1. Pantalla de Ingesta (Brain Dump Canvas)`  
  `│     ├── Campo de texto libre autoexpandible`  
  `│     ├── Botón de Ingesta de Voz (Speech-to-Text)`  
  `│     └── Botón de Acción Principal: "Secuenciar Pensamientos"`  
  `│`  
  `├── 2. Pantalla de Ejecución Activa (Single-Task Viewport) [HOME PRINCIPAL]`  
  `│     ├── Indicador Minimalista de Progreso ("Nodo 1 de 4")`  
  `│     ├── Card Neumórfica Central: Tarea Activa + Sub-paso inmediato`  
  `│     ├── Temporizador de Flujo Suave (Modo Focus / Descanso)`  
  `│     ├── Botón de Acción Principal: "Completar y Siguiente" (Verde Calma)`  
  `│     └── Botón de Rescate Cognitivo: "Estoy Bloqueado / Dividir" (Gris Neutro)`  
  `│`  
  `└── 3. Vista de Descompresión & Grafo (Modal Inferior / BottomSheet)`  
        `├── Visualización abstracta del camino crítico (DAG)`  
        `├── Modo "Baja Energía" (Reordenar tareas livianas)`  
        `└── Historial de Nodos Completados con refuerzo positivo`

## **5\. Etapa 4: Prototipar (Especificación de Pantallas y Diseño Flutter)**

En esta etapa especificamos los componentes estructurales de UI, los tokens del Design System y la implementación técnica en Flutter con enfoque en microinteracciones táctiles y accesibilidad sensorial.

### **5.1 Design System y Tokens Visuales (Light Soft Paper)**

| Token / Elemento | Valor Hex / Configuración | Justificación Neuro-Ergonómica   |
| :---- | :---- | :---- |
| **Background Base** | \#F5F6F8 (Soft Paper Light) | Blanco roto que previene el deslumbramiento y la fatiga ocular producida por el blanco puro (\#FFFFFF). |
| **Superficie Card (Neumórfica)** | \#FFFFFF con sombras dobles: \-4px \-4px 10px \#FFFFFF y 4px 4px 12px rgba(166,175,195,0.4) | Crea una sensación física táctil de tarjeta de papel elevada sin bordes afilados ni saturación estridente. |
| **Color Primario de Éxito** | \#10B981 / Sage Green \#059669 | Verde salvia relajante que transmite avance completado sin la estridencia de un verde fluorescente. |
| **Color de Acento / Focus** | \#4F46E5 / Soft Indigo \#6366F1 | Azul índigo sereno para elementos interactivos principales y cronómetros de concentración. |
| **Tipografía Principal** | Inter / Roboto (San Serif) | Alta legibilidad en pantallas móviles, altura de x amplia y espaciado optimizado para evitar saltos visuales. |

### **5.2 Wireframes y Pantallas Clave en Flutter**

#### **Pantalla A: Ingesta Cruda (Brain Dump View)**

• **Estructura:** Scaffold con fondo \#F5F6F8. En el tercio superior, una pregunta suave: *"¿Qué ronda por tu cabeza?"*. En el cuerpo central, un TextField multilínea sin bordes marcados con aspecto de cuaderno limpio. En la parte inferior, una barra flotante con botón de dictado por voz y botón con animación neumórfica *"Descomprimir y Ordenar"*.  
• **Comportamiento Flutter:** Auto-foco inteligente, persistencia local instantánea (evita pérdida de datos ante interrupciones) y respuesta háptica al pulsar.

#### **Pantalla B: Foco Único Activo (Single-Task Viewport)**

• **Estructura:** Ocupa el 100% de la pantalla. En el encabezado superior solo aparece un micro-badge: *"Paso actual en curso"* y un interruptor de sonido ambiente suave. En el centro, una NeumorphicCard amplia con la acción inmediata escrita en tipografía de 20pt (ej. *"Redactar los primeros dos párrafos de la introducción"*). Debajo, un indicador de tiempo sugerido (15 min) y dos botones de acción de gran tamaño para pulsación táctil con el pulgar.  
• **Comportamiento Flutter:** Gestos de deslizamiento (Swipe to complete) con Dismissible customizado, transiciones curvas con Curves.easeInOutCubic que no generan destellos bruscos.

#### **Pantalla C: Modal Adaptativo de Rescate Cognitivo (Unblock Sheet)**

• **Estructura:** ModalBottomSheet neumórfico con esquinas redondeadas. Ofrece 3 opciones de rescate con un solo toque: *"1. Dividir en pasos más chicos"*, *"2. Saltar a otra rama desbloqueada"* y *"3. Activar Modo Baja Energía (tareas fáciles)"*.

### **5.3 Arquitectura de Código Mobile en Flutter**

`lib/`  
`├── core/`  
`│   ├── theme/          # Neumorphic Soft Paper Tokens, AppColors, AppTypography`  
`│   ├── utils/          # HapticFeedbackHelper, AccessibilityModifiers`  
`│   └── network/        # Dio Client, SSE EventStreamHandler`  
`├── features/`  
`│   ├── brain_dump/     # Ingesta cruda, Speech-to-Text Controller, IngestionScreen`  
`│   ├── graph_engine/   # TopologicalSortClient, DAG Models (TaskNode, Edge)`  
`│   ├── focus_viewport/ # SingleTaskScreen, TaskTimerWidget, ActionButtons`  
`│   └── unblock_mode/   # CognitiveRescueSheet, FrictionAnalyzer`  
`└── main.dart           # App Entrypoint con Riverpod ProviderScope`

## **6\. Etapa 5: Evaluar (Protocolo de Usabilidad y Reporte de Feedback)**

La validación se diseñó mediante pruebas de usabilidad moderadas con usuarios de perfil objetivo (estudiantes universitarios con sobrecarga cognitiva y TDAH).

### **6.1 Protocolo de Pruebas de Usabilidad (3 Tareas Críticas)**

| Tarea | Consigna Pedida al Usuario | Criterio de Éxito | Tasa de Éxito   |
| :---: | :---- | :---- | ----- |
| **T1** | Volcar en el Brain Dump un texto desordenado con 4 compromisos de la semana sin configurar fechas. | Completar el volcado y presionar "Secuenciar" en menos de 25 segundos. | **100% (5/5)** |
| **T2** | Iniciar y marcar como completada la primera micro-tarea en el Single-Task Viewport. | Comprender de inmediato cuál es la acción activa y avanzar sin buscar menús ocultos. | **100% (5/5)** |
| **T3** | Simular bloqueo mental en la tarea actual y solicitar un rescate cognitivo / subdivisión. | Pulsar "Estoy bloqueado" y seleccionar una alternativa en menos de 3 clics. | **80% (4/5)** |

### **6.2 Reporte de Feedback y Matriz de Iteración de Diseño**

| Hallazgo / Fricción Detectada | Impacto en la UX | Mejora e Iteración Implementada en Flutter   |
| :---- | :---- | :---- |
| **1\. Ansiedad de "Caja Negra"** | Medio | El usuario se preguntaba qué pasó con el resto de sus ideas al ver solo una tarea. **Solución:** Se incorporó un indicador sutil en la esquina superior tipo *"Paso 1 de 4 (Tus ideas están seguras en el Grafo)"* con un gesto de deslizamiento para ver el mapa general si lo desea. |
| **2\. Temporizador Punzante** | Alto | El conteo regresivo tradicional en segundos generaba estrés por presión temporal. **Solución:** Se sustituyó por un círculo de respiración visual continuo sin números en rojo, que simplemente marca ritmo orgánico. |
| **3\. Sensibilidad del Botón "Bloqueado"** | Bajo | Algunos usuarios dudaban si al presionar "Bloqueado" la tarea se eliminaba para siempre. **Solución:** Se renombró el botón a *"Pausar o Dividir"* para transmitir que la tarea simplemente se pospone o se simplifica. |

## **7\. Conclusión y Hoja de Ruta de Presentación**

La aplicación integral de las 5 fases del Diseño Centrado en el Usuario ha permitido transformar una problemática neurocognitiva real (la disfunción ejecutiva frente a las listas de pendientes tradicionales) en una solución móvil elegante, factible y altamente diferenciada. La arquitectura de interfaz *Light Soft Paper* y la implementación reactiva en Flutter garantizan que NeuroTask no sea otra herramienta de control administrativo, sino un auténtico motor de acompañamiento y descompresión cognitiva.  
Este marco teórico y metodológico constituye la base directa para la construcción de los wireframes, componentes interactivos y la presentación visual de 7 diapositivas requerida para la entrega de la cátedra.