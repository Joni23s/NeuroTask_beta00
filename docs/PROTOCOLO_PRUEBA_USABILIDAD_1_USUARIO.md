# Protocolo de Prueba de Usabilidad de Guerrilla (1 Usuario)

- **Proyecto:** NeuroTask — Motor de Foco y Descompresión Cognitiva
- **Marco Metodológico:** Steve Krug (*"No me hagas pensar"* y *"Pruebas de Guerrilla de un Solo Usuario"*)
- **Cátedra:** Desarrollo de Aplicaciones Móviles (DAM) — ITU UNCuyo
- **Equipo:** Araujo Jonathan, Batiatto Juan Martín, Belardinelli Agustín, Ortega Mateo

---

## 1. Ficha Técnica de la Sesión

- **Fecha de la Prueba:** `____ / ____ / 2026`
- **Coordinador (Estudiante DAM):** `_____________________________________`
- **Participante (Usuario de Prueba):** `Estudiante Universitario / Perfil General (Anónimo)`
- **Entorno de Ejecución:** Smartphone personal (Android) conectado vía red local mediante `iniciar_con_qr.bat`.
- **Duración Estimada:** 10 a 15 minutos en total.

---

## 2. Encuadre y Guion de Bienvenida para el Coordinador

> [!TIP]
> **Instrucción al Coordinador:** Leé el siguiente texto al usuario de forma tranquila y empática antes de entregarle el teléfono. El objetivo es eliminar cualquier ansiedad de evaluación.

```text
"Hola, muchas gracias por darnos unos minutos para probar esta aplicación.
Antes de empezar, quiero dejarte algo muy claro: te estamos probando a la aplicación, 
no a vos ni a tus capacidades. No podés equivocarte en nada de lo que hagas. 

Cualquier duda, confusión o traba que encuentres no es tu culpa; es una falla 
en nuestro diseño que necesitamos descubrir para mejorarla.

Mientras uses la aplicación, te voy a pedir un gran favor: 'Pensá en voz alta'. 
Decime en todo momento qué estás mirando, qué estás intentando hacer, qué esperás 
que pase antes de tocar un botón y qué sentís. 

Yo no voy a poder responder preguntas como '¿debo tocar acá?', porque quiero ver 
cómo reacciona la aplicación por sí sola. Si te parece bien, arrancamos."
```

---

## 3. Reglas de Intervención del Coordinador (Protocolo "Think-Aloud")

1. **Neutralidad Absoluta:** No defiendas el código ni justifiques las decisiones de diseño.
2. **Cero Pistas Directas:** No le digas al usuario dónde tocar.
3. **Preguntas Guía Permitidas (No Intrusivas):**
   - Si el usuario se queda en silencio mirando la pantalla:
     *— "¿Qué estás pensando o buscando en este momento?"*
   - Si el usuario duda antes de pulsar un botón:
     *— "¿Qué creés que va a pasar si tocás esa opción?"*
   - Si el usuario realiza una acción inesperada:
     *— "¿Qué esperabas que ocurriera recién?"*

---

## 4. Las 3 Tareas Típicas Observables

### Tarea 1: El Volcado Mental Inicial (Brain Dump)
- **Consigna al Usuario:**
  > *"Imaginate que arranca tu semana y tenés la cabeza llena de cosas. Abrí la app, anotá 3 actividades que tengas que hacer esta semana (por ejemplo: estudiar DAM, comprar café y lavar la ropa) y poné a funcionar el sistema."*
- **Comportamiento a Observar:**
  - ¿Identifica inmediatamente la caja de texto central?
  - ¿Duda sobre cómo formatear las tareas o escribe con naturalidad?
  - ¿Localiza y presiona el botón principal *"Iniciar Secuencia"*?

### Tarea 2: Enfoque Atómico y Activación de Rescate Cognitivo
- **Consigna al Usuario:**
  > *"Ahora estás frente a tu primera tarea. Imaginá que te sentís abrumado o trabado y no sabés cómo arrancar. Buscá si la app te ofrece alguna ayuda para desbloquearte. Después de probarla, marcá la tarea como terminada."*
- **Comportamiento a Observar:**
  - ¿Nota visualmente el botón de *"Rescate Cognitivo"*?
  - ¿Lee y comprende los 3 micro-pasos guiados?
  - ¿Interactúa con el mecanismo para completar la tarea (*Swipe* o botón de completar)?

### Tarea 3: Configuración de una Nueva Ancla Horaria Fija
- **Consigna al Usuario:**
  > *"Tenés clases fijas de DAM los lunes por la mañana y no querés que se te superpongan con tus tareas. Buscá dónde gestionar tus horarios fijos y agregá una ancla llamada 'Clase DAM' de 08:00 a 12:00."*
- **Comportamiento a Observar:**
  - ¿Reconoce el ícono del reloj en la cabecera para abrir las anclas?
  - ¿Encuentra el botón flotante `(+)` para abrir el formulario?
  - ¿El formulario con validación (`Form` / `TextFormField`) le resulta claro?
  - ¿Percibe el mensaje de feedback flotante (`SnackBar`) al guardar?

---

## 5. Planilla de Registro de Observación en Vivo

| Tarea | Tiempo Aprox. | ¿Completó la tarea? | Expresiones verbales y dudas observadas | Puntos de fricción / Confusiones detectadas | Severidad (Baja / Media / Alta) |
|---|---|---|---|---|---|
| **T1: Brain Dump** | `___ min` | Sí / No | *Ej: "Pensé que tenía que poner hora a cada una"* | *Ninguna / Duda sobre puntuación* | `______` |
| **T2: Modo Foco** | `___ min` | Sí / No | *Ej: "¿Esto me divide la tarea en partes?"* | *Descubrimiento del botón de rescate* | `______` |
| **T3: Anclas Horarias** | `___ min` | Sí / No | *Ej: "Ah, me apareció el cartelito abajo de que se guardó"* | *Selección de hora inicio / fin* | `______` |

---

## 6. Resolución de Debates Religiosos (Criterio Lean Krug)

Al concluir la prueba, el equipo de desarrollo no debate opiniones hipotéticas. Se responde con los datos recolectados:
1. **¿El usuario necesitó explicaciones externas para avanzar?** Si la respuesta es Sí, el elemento visual no cumplió con *"No me hagas pensar"*.
2. **¿Los botones táctiles fueron reconocidos sin dudar?** Comprueba la efectividad de los significadores neumórficos frente a la ausencia de cursor.
3. **Acciones de Mejora Inmediatas:** Se listan únicamente 1 o 2 cambios de alta prioridad observados en la sesión antes de comprometer más horas de programación.
