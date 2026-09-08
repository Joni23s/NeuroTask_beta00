---
title: "Metodología Spec-Driven Development (SDD)"
description: "Regla obligatoria para el proyecto NeuroTask: desarrollo guiado por especificaciones formales."
---

# Metodología de Desarrollo: Spec-Driven Development (SDD)

En este repositorio (`NeuroTask`), cualquier cambio de arquitectura, nuevo componente, refactorización o corrección de comportamiento debe seguir el marco de **Spec-Driven Development (SDD)**:

1. **Especificación en `docs/`**: Documentar en archivos `NT-SPEC-*.md` el alcance, la comparativa antes/después y los criterios de aceptación.
2. **Pragmatismo**: Evitar sobreingeniería innecesaria; priorizar componentes reutilizables simples, cohesivos y bien tipados.
3. **Calidad y Linter**: Código limpio que compile con `dart analyze` sin errores ni advertencias (0 warnings).
4. **Verificación Automatizada**: Toda feature o refactor debe pasar la suite de tests (`flutter test`) al 100%.
5. **Versionado**: Commits atómicos descriptivos por especificación (`feat(...)`, `refactor(...)`, `fix(...)`) y push a remoto tras testeo.
