---
description: Corre tests con cobertura y sugiere fixes
agent: build
---

Ejecuta los tests del proyecto.

Pasos:
1. Detecta el framework de tests (jest, vitest, pytest, etc.)
2. Corre los tests con reporte de cobertura
3. Si hay fallos:
   - Analiza cada fallo
   - Propone fixes concretos
   - NO modifiques código sin preguntar
4. Si todo pasa, reporta:
   - Tests totales / pasados / fallidos
   - % de cobertura por módulo
   - Archivos sin cubrir

Usa herramientas nativas del proyecto (npm test, pytest, etc.).
