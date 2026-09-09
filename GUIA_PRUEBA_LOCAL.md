# Guía de Ejecución y Prueba Local — NeuroTask Mobile

> El documento maestro detallado se encuentra en [docs/GUIA_PRUEBA_LOCAL.md](file:///c:/Users/jonat/Downloads/Codigos/NeuroTask_beta00/docs/GUIA_PRUEBA_LOCAL.md).

---

## Resumen Rápido de Ejecución

### Opción A (Recomendada): Probar en tu Celular Físico mediante Código QR
Para ver la app en tu propio celular con **Hot Reload en vivo** sin cables ni instalar APKs:
1. Haz doble clic en **`iniciar_con_qr.bat`** (o corre `.\iniciar_con_qr.bat` en la terminal).
2. Se abrirá una ventana en tu PC con un **código QR**.
3. Abre la cámara de tu celular (conectado al mismo Wi-Fi que la PC) y escanea el QR.
4. La app se abrirá en el navegador de tu celular. Cada vez que guardes cambios y toques **`r`** en la consola, ¡tu teléfono se actualizará al instante!

---

### Opción B: Probar en Google Chrome de la PC
```bash
cd flutter_app
flutter pub get
flutter run -d chrome
```
- Presiona **`F12`** $\rightarrow$ **`Ctrl + Shift + M`** para activar la vista responsive de celular (ej. 390 x 844).

### 3. Teclas de Control en Terminal
- **`r`**: Hot Reload (aplica cambios en < 1 segundo sin perder el estado).
- **`R`**: Hot Restart (reinicia el flujo conservando Chrome abierto).
- **`q`**: Salir.

### 4. Empaquetar APK para Teléfono
Cuando desees generar el archivo para instalar en tu celular físico:
```bash
cd flutter_app
flutter build apk --release
```
El archivo final queda en:
`flutter_app/build/app/outputs/flutter-apk/app-release.apk`

---
*Para ver la guía completa con instrucciones para agentes de IA y resolución de problemas, consulta [docs/GUIA_PRUEBA_LOCAL.md](file:///c:/Users/jonat/Downloads/Codigos/NeuroTask_beta00/docs/GUIA_PRUEBA_LOCAL.md).*
