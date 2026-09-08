# Guía de Ejecución y Prueba Local — NeuroTask Mobile

Esta guía detalla los pasos exactos para que cualquier desarrollador (humano) o asistente inteligente (IA) pueda ejecutar, probar e iterar **NeuroTask** de forma inmediata y ligera en entorno Web local con **Hot Reload**, evitando el costo temporal de tener que empaquetar y transferir el APK a un teléfono físico en cada cambio de código.

---

## 1. Filosofía del Flujo de Trabajo Rápido

- **El Problema del Empaquetado Frecuente:** Compilar un APK de Android (`gradle assembleDebug` o `flutter build apk`) toma entre 2 y 5 minutos por cada cambio, agota los recursos de la máquina y ralentiza el ciclo de feedback de diseño y UX.
- **La Solución (Desarrollo en Web Local):** Al ejecutar `flutter run -d chrome`, Flutter compila la aplicación en un servidor web local liviano. Cualquier cambio que guardes en los archivos Dart se refleja en menos de **1 segundo** mediante **Hot Reload**, conservando el estado de la navegación y las tareas.

---

## 2. Requisitos Previos

1. **Flutter SDK:** Versión `>=3.0.0 <4.0.0` (Dart 3).
2. **Navegador Google Chrome:** Instalado y actualizado.
3. **Terminal:** PowerShell, Git Bash o CMD.

Para verificar que el entorno web esté listo, puedes ejecutar:
```bash
flutter doctor
```
*(Debe mostrar una tilde verde `[✓] Chrome - develop for the web`)*.

---

## 3. Paso a Paso para Lanzar la App en Modo Web

### Paso 1: Ubicarse en el directorio del proyecto Flutter
Abre una terminal y navega hasta la carpeta `flutter_app`:
```bash
cd flutter_app
```

### Paso 2: Asegurar las dependencias
Descarga y valida los paquetes de `pubspec.yaml`:
```bash
flutter pub get
```

### Paso 3: Lanzar la aplicación en Google Chrome
Ejecuta el siguiente comando para iniciar el servidor de desarrollo local:
```bash
flutter run -d chrome
```

> **Consejo Pro (Fijar Puerto para Guardar Marcador o Sesión):**
> Si prefieres que siempre abra en el mismo puerto (ej. `localhost:8080`), usa:
> ```bash
> flutter run -d chrome --web-port=8080
> ```

---

## 4. Cómo Simular la Vista de Teléfono en Chrome (Device Toolbar)

Dado que NeuroTask está diseñada para dispositivos móviles con diseño táctil y neumórfico centrado en el usuario, es fundamental visualizarla en proporciones de pantalla de celular:

1. Cuando Chrome se abra con la app cargada, presiona **`F12`** (o `Ctrl + Shift + I` en Windows / Linux, `Cmd + Option + I` en macOS) para abrir las **DevTools de Chrome**.
2. Presiona **`Ctrl + Shift + M`** (o haz clic en el icono de **"Toggle device toolbar"** 📱 en la esquina superior izquierda de las DevTools).
3. En el menú desplegable superior:
   - Selecciona un modelo de teléfono como **iPhone 14 Pro / iPhone 15**, **Pixel 7**, o establece dimensiones personalizadas: **`390 x 844`** o **`412 x 915`**.
   - Ajusta el zoom a **100%** o **"Fit to Window"**.
4. ¡Listo! Ahora el cursor del mouse actúa como toque táctil, permitiendo probar:
   - El gesto de deslizamiento en las tarjetas de foco (*Swipe-to-Complete*).
   - El borrado progresivo acelerado en el Brain Dump.
   - Las hojas modales inferiores (*BottomSheets*).
   - El selector de anclas y el temporizador Zen.

---

## 5. Control Interactivo en la Terminal (Hot Reload & Hot Restart)

Mientras `flutter run -d chrome` esté ejecutándose en tu consola, no cierres la terminal. Puedes usar las siguientes teclas interactivas:

| Tecla | Acción | Descripción |
| :---: | :--- | :--- |
| **`r`** | **Hot Reload** | Aplica los cambios de código guardados casi instantáneamente sin reiniciar la app ni perder el texto escrito. |
| **`R`** | **Hot Restart** | Reinicia la app completa desde la pantalla de bienvenida (`WelcomeScreen`), recargando el árbol de estado pero manteniendo la pestaña de Chrome abierta. |
| **`p`** | **Toggle Performance Overlay** | Muestra el monitor de FPS y GPU en pantalla para auditar el rendimiento gráfico. |
| **`h`** | **Help** | Muestra la lista completa de comandos y atajos de Flutter. |
| **`q`** | **Quit** | Detiene el servidor local y cierra la ventana de Chrome de forma limpia. |

---

## 6. Instrucciones Especiales para Asistentes de IA (AI Coding Agents)

Si eres un agente de IA (como Antigravity u otro asistente automatizado) trabajando en este repositorio:
1. **No mates el proceso en segundo plano:** Si el comando `flutter run -d chrome` ya está corriendo en la sesión del usuario, **no lo interrumpas**. Al modificar y guardar cualquier archivo `.dart`, Flutter activará el Hot Reload automáticamente.
2. **Validación Previa Obligatoria (SDD):**
   Antes de solicitar feedback al usuario o dar por cerrada una tarea:
   - Ejecuta el análisis estático:
     ```bash
     dart analyze lib/ test/
     ```
     *(Debe retornar `No issues found!` con 0 errores y 0 warnings)*.
   - Ejecuta la suite de pruebas automatizadas:
     ```bash
     flutter test
     ```
     *(Todos los tests de Kahn DAG, Anclas y UI deben pasar al 100%)*.
3. **Persistencia Web:** Las funcionalidades implementadas utilizan `SharedPreferences` con esquemas JSON estructurados, por lo que las anclas, sesiones de foco y logros persisten en el `LocalStorage` de Chrome tal como lo harían en SQLite en un dispositivo real.

---

## 7. Empaquetado Final para Teléfono Móvil (Creación del APK)

Cuando el flujo ya fue probado, validado y se desea instalar la versión compilada en un smartphone Android físico:

### Compilar APK en Modo Release (Producción Optimizada)
Desde `flutter_app/`:
```bash
flutter build apk --release
```

El binario ejecutable generado se guardará en:
```text
flutter_app/build/app/outputs/flutter-apk/app-release.apk
```

### Opciones para Instalarlo en el Teléfono:
1. **Por Cable USB (vía ADB):**
   Con la depuración USB habilitada en el teléfono:
   ```bash
   adb install build/app/outputs/flutter-apk/app-release.apk
   ```
2. **Transferencia Directa:**
   Copia el archivo `app-release.apk` a Google Drive, Telegram o cárgalo directamente a la memoria de tu teléfono y tócalo para instalarlo (permitiendo la instalación de fuentes desconocidas).

---

*NeuroTask: Motor de Foco — Cátedra DAM (ITU UNCuyo) — Metodología SDD (Spec-Driven Development)*
