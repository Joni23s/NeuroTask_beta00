# NT-SPEC-CI-004: Pipeline CI/CD de Compilación y Liberación Continua de Android APK

- **Estado:** Especificación Activa (SDD)
- **Fecha:** 2026-11-24
- **Cátedra:** DAM — ITU UNCuyo
- **Equipo:** Araujo Jonathan, Batiatto Juan Martín, Belardinelli Agustín, Ortega Mateo
- **Ámbito:** Entrega Continua (CD), GitHub Actions, GitHub Releases y UX de Descarga Directa

---

## 1. Diagnóstico y Objetivos Medibles

### 1.1. Diagnóstico del Cuello de Botella Actual
Hasta la fecha, probar **NeuroTask** de forma nativa en un teléfono Android físico requería que el evaluador, docente o integrante del equipo:
1. Clonara el repositorio completo (`git clone`).
2. Instalara y configurara localmente **Flutter SDK**, **Android SDK**, **Gradle** y **JDK** compatibles.
3. Ejecutara `flutter pub get` y `flutter build apk --release` (con tiempos de compilación local de 2 a 5 minutos y alto consumo de RAM/disco).
4. Transfiriera manualmente `app-release.apk` por USB, ADB o mensajería al dispositivo.

Esta fricción técnica impedía que evaluadores externos o usuarios finales instalaran la versión más reciente desde GitHub en segundos.

### 1.2. Objetivos Medibles
1. **Instalación en 1 Clic (Cero SDK Local):** Proveer una URL estable y permanente (`https://github.com/Joni23s/NeuroTask_beta00/releases/latest/download/NeuroTask.apk`) accesible desde botón directo en `README.md` y mediante código QR vectorial (`docs/egi_assets/qr_apk_download.svg`).
2. **Automatización Total en cada Push a `main`:** Generar, validar y publicar el binario `NeuroTask.apk` automáticamente mediante GitHub Actions sin intervención manual.
3. **Integridad Verificable:** Publicar en cada GitHub Release el archivo de suma criptográfica `NeuroTask.apk.sha256` junto al binario oficial.
4. **Calidad Cero-Regresión:** Ningún APK se publica si `dart analyze lib/ test/` o `flutter test` fallan en el mismo flujo de CI.

---

## 2. Plan de Ejecución Incremental

### Fase 1: Pipeline CI/CD en GitHub Actions (`.github/workflows/release-apk.yml`)
- **Disparadores:**
  - `push` sobre la rama `main` (ignorando cambios exclusivos en documentación si corresponde o asegurando consistencia en código/workflow), además de `workflow_dispatch` para ejecuciones manuales bajo demanda.
- **Permisos:** `contents: write` para crear etiquetas/releases y adjuntar los artefactos compilados.
- **Pasos del Job:**
  1. `actions/checkout` del repositorio.
  2. Configuración de **Java (JDK 17)** y **Flutter SDK** estable con caché de dependencias.
  3. Instalación de dependencias (`flutter pub get` dentro de `flutter_app/`).
  4. Puerta de calidad estática y pruebas unitarias/widget (`dart analyze lib/ test/` y `flutter test`).
  5. **Versionado Incremental (`--build-number`):** Compilación mediante `flutter build apk --release --build-number=${{ github.run_number }}` para garantizar que cada release posea un `versionCode` estrictamente creciente compatible con actualizaciones in-place en Android.
  6. Normalización del artefacto de salida a `NeuroTask.apk` y generación de huella `NeuroTask.apk.sha256`.
  7. **Publicación en GitHub Releases (`Latest Release`):** Creación/actualización de Release no borrador (`draft: false`, `prerelease: false`) con tag versionado (ej. `v1.0.<run_number>`) adjuntando `NeuroTask.apk` y `NeuroTask.apk.sha256`, habilitando la URL permanente `releases/latest/download/NeuroTask.apk`.

### Fase 2: Artefacto Visual QR Vectorial (`docs/egi_assets/qr_apk_download.svg`)
- Generar un código QR vectorial determinista en formato SVG limpio (`viewBox` explícito, zona de silencio `quiet zone >= 4`, módulos Deep Navy `#0F2E49` sobre fondo `#FFFFFF`) que codifique exactamente:
  `https://github.com/Joni23s/NeuroTask_beta00/releases/latest/download/NeuroTask.apk`
- El uso de SVG garantiza nitidez infinita tanto en GitHub Markdown como en presentaciones o defensa oral proyectada.

### Fase 3: Experiencia de Descarga en Documentación (`README.md` y Guías Locales)
- Incorporar en la cabecera de `README.md` la sección **`## 📲 Descarga Directa (Android APK) y Demo Web`** con:
  - Badges interactivos (Shields.io) para descarga directa de APK, acceso a GitHub Releases (historial y SHA-256), Web App en GitHub Pages y estado en vivo del workflow `release-apk.yml`.
  - Bloque estructurado con el QR SVG (`docs/egi_assets/qr_apk_download.svg`) y 3 pasos breves de instalación en Android (incluyendo la guía serena ante el aviso de *Google Play Protect* para APKs académicos).
- Actualizar `GUIA_PRUEBA_LOCAL.md` (Sección 4) y `docs/GUIA_PRUEBA_LOCAL.md` (Sección 7) agregando la **Opción Rápida sin Compilar** con enlace directo al último APK, y corrigiendo enlaces locales absolutos obsoletos a rutas relativas del repositorio.

---

## 3. Criterios de Aceptación y Calidad (DoD)

1. **Workflow Operativo:** `.github/workflows/release-apk.yml` se ejecuta en `main` con estado `success`, genera `NeuroTask.apk` con `--build-number` incremental y publica un Release público (`draft == false`, `prerelease == false`).
2. **Integridad del Artefacto:** El Release más reciente (`releases/latest`) contiene `NeuroTask.apk` y `NeuroTask.apk.sha256` cuyo hash coincide exactamente con el binario descargado; el APK es un paquete Android válido (`AndroidManifest.xml`, `classes.dex`, `lib/arm64-v8a/libapp.so`).
3. **QR SVG Determinista:** `docs/egi_assets/qr_apk_download.svg` es XML/SVG válido con `#0F2E49` / `#FFFFFF` y codifica exactamente la URL `releases/latest/download/NeuroTask.apk`.
4. **Documentación Sincronizada:** `README.md`, `GUIA_PRUEBA_LOCAL.md` y `docs/GUIA_PRUEBA_LOCAL.md` contienen enlaces relativos válidos, sin rutas locales `c:/Users/...`, y documentan tanto la descarga directa en 1 clic como la compilación local.
5. **Cumplimiento SDD:** Esta especificación (`NT-SPEC-CI-004`) contiene las 5 secciones obligatorias definidas en `.antigravityrules`.

---

## 4. Validación Automatizada

Toda actualización que dispare el pipeline de liberación ejecuta de forma obligatoria en CI sobre `flutter_app/`:

1. **Análisis estático (0 advertencias y 0 errores):**
   ```bash
   dart analyze lib/ test/
   ```
2. **Suite de pruebas unitarias y de widgets:**
   ```bash
   flutter test
   ```
3. **Compilación de producción Android con build-number incremental:**
   ```bash
   flutter build apk --release --build-number=$GITHUB_RUN_NUMBER
   ```
4. **Verificación de checksum y descarga end-to-end:** Validación mediante `sha256sum` en CI y comprobación de descarga HTTP 200 desde `https://github.com/Joni23s/NeuroTask_beta00/releases/latest/download/NeuroTask.apk`.

---

## 5. Sincronización Continua con Git

- Siguiendo `.antigravityrules`, los cambios de infraestructura CI (`.github/workflows/release-apk.yml`), especificación (`docs/NT-SPEC-CI-004-ANDROID-APK-CONTINUOUS-RELEASE.md`), recurso QR (`docs/egi_assets/qr_apk_download.svg`) y documentación (`README.md`, `GUIA_PRUEBA_LOCAL.md`, `docs/GUIA_PRUEBA_LOCAL.md`) se integran en la rama `main` y se sincronizan con `origin main`.
- Cada nuevo `push` a `main` dispara automáticamente la regeneración del APK y la actualización del `Latest Release`, manteniendo el enlace de descarga y el código QR siempre apuntando a la última versión validada.
