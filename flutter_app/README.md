# NeuroTask Flutter Application 🧠📱

> **Motor de Foco, Descompresión Cognitiva y Secuenciación DAG**  
> Proyecto desarrollado para la cátedra **Desarrollo de Aplicaciones Móviles (DAM)** — ITU UNCuyo.  
> Implementación del **Tema 1: Arquitectura y Capa de Datos**.

---

## 🏛️ Arquitectura del Proyecto (`lib/`)

El código sigue una arquitectura por capas desacoplada y orientada a la **UI Declarativa**:

$$\text{UI} = f(\text{Estado})$$

```text
lib/
├── main.dart                       # Entrada principal, ProviderScope y MaterialApp con temas
│
├── model/                          # Persistencia física y exports canónicos
│   ├── model.dart                  # Barrel export de entidades del sistema
│   ├── models.dart                 # Barrel export alternativo canónico
│   └── dbhelper.dart               # Singleton con transacciones CRUD no bloqueantes (Event Loop)
│
├── data/                           # Capa de Repositorios (Tema 1 DAM)
│   └── repositories/
│       ├── task_repository.dart    # Repositorio de tareas y presets de Brain Dump
│       ├── anchor_repository.dart  # Repositorio de anclas y malla temporal
│       ├── user_repository.dart    # Repositorio de usuario, autenticación y métricas
│       ├── achievement_repository.dart # Repositorio de logros cognitivos
│       ├── providers.dart          # Inyección de dependencias para Riverpod
│       └── repositories.dart       # Barrel export de la capa de datos
│
├── core/                           # Núcleo compartido del sistema
│   ├── domain/
│   │   ├── models/                 # Entidades tipadas (TaskNode, TimeAnchor, UserProfile, FocusState, Achievement, TaskGraph)
│   │   └── services/               # Algoritmos puros: TopologicalSorter (Kahn), AnchorScheduleFitter
│   ├── services/                   # Storage, Audio y Speech Services desacoplados
│   ├── theme/                      # AppColors, NeumorphicTheme, ThemeController
│   ├── utils/                      # HapticHelper
│   └── widgets/                    # NeumorphicCard, NeumorphicButton, NeuroBadge, FlowIndicator, etc.
│
├── util/                           # Funciones puras independientes
│   ├── utils.dart                  # Barrel export
│   └── date_time_formatter.dart    # Funciones deterministas de tiempo (Shifting Left testing)
│
└── features/                       # Capa de Presentación organizada por features
    ├── splash/                     # SplashScreen interactiva
    ├── onboarding/                 # OnboardingScreen y WelcomeScreen
    ├── auth/                       # LoginRegisterScreen (conectada a UserRepository)
    ├── brain_dump/                 # BrainDumpScreen (conectada a TaskRepository)
    ├── focus/                      # SingleTaskScreen, FocusController, CognitiveRescueSheet
    ├── anchors/                    # AnchorsManagerScreen (100% dinámico)
    ├── achievements/               # AchievementsVaultScreen
    ├── profile/                    # ProfileScreen (ConsumerWidget reactivo con métricas dinámicas)
    └── settings/                   # SettingsScreen
```

---

## 🚀 Comandos Rápidos

```bash
# 1. Instalar paquetes
flutter pub get

# 2. Ejecutar pruebas unitarias
flutter test

# 3. Lanzar en Google Chrome
flutter run -d chrome

# 4. Lanzar en Emulador Android o Dispositivo conectado
flutter run
```

---

## 🧪 Pruebas Unitarias

Ubicadas en `test/`:
* `pure_domain_test.dart`: Serialización de modelos y ordenamiento topológico DAG con Kahn.
* `anchors_test.dart`: Filtrado por día de la semana y cálculo de bloques ocupados.
* `achievements_test.dart`: Lógica condicional de desbloqueo de logros cognitivos.
* `repositories_test.dart`: Validación de serialización de `UserProfile` y transacciones en `TaskRepository` y `AnchorRepository`.
