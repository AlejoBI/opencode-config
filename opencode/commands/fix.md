---
description: Debugging: analiza error y propone fix
agent: build
---

Analiza un error específico y propone una solución.

Pasos:
1. Si se pasa un error/mensaje como argumento, analízalo
2. Si no, busca errores recientes en:
   - Consola / terminal
   - Logs de la app
   - Stack traces
3. Investiga la causa raíz:
   - ¿Error de compilación? → Revisa tipos/dependencias
   - ¿Error en runtime? → Revisa la traza
   - ¿Error de tests? → Revisa aserciones
4. Propone fix con código específico
5. Si el fix es seguro, pregúntame si lo aplico

Usa el plan mode para análisis y cambia a build si autorizo el fix.
