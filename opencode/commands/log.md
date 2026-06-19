---
description: Analiza logs y diagnóstica errores
agent: build
---

Analiza logs de errores o archivos de log en el proyecto.

Pasos:
1. Busca archivos de log recientes (log/, logs/, errores, etc.)
2. Si no hay logs locales, pregunta qué buscar
3. Analiza patrones de error:
   - Frecuencia de errores
   - Stack traces más comunes
   - Correlación temporal
4. Propone causas raíz y posibles fixes
5. Si hay un error específico ($ARGUMENTS), enfócate en ese

Usa herramientas como grep, awk, y análisis de patrones.
