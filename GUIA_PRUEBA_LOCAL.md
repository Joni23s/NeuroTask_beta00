# Guía de Ejecución y Prueba Local — NeuroTask Mobile

> El documento maestro detallado se encuentra en [docs/GUIA_PRUEBA_LOCAL.md](file:///c:/Users/jonat/Downloads/Codigos/NeuroTask_beta00/docs/GUIA_PRUEBA_LOCAL.md).

---

## Resumen Rápido de Ejecución

Para probar e iterar **NeuroTask** en tu navegador Web con **Hot Reload** instantáneo sin tener que compilar y enviar el APK a tu teléfono en cada cambio:

### 1. Iniciar en Chrome
```bash
cd flutter_app
flutter pub get
flutter run -d chrome
```

### 2. Simular Vista de Celular (Device Toolbar)
- Presiona **`F12`** en Chrome para abrir las DevTools.
- Presiona **`Ctrl + Shift + M`** para activar el modo responsive móvil.
- Elige dimensiones de pantalla de celular (ej. **390 x 844** o **Pixel 7**).

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
