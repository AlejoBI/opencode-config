---
description: Crea un Pull Request con descripción detallada
agent: build
---

Crea un Pull Request en GitHub para la rama actual.
Primero analiza los cambios en el diff contra la rama base.

Incluye en la descripción del PR:
1. Resumen de los cambios
2. Motivación / contexto
3. Cambios principales (bullet points)
4. Cómo se probó
5. Screenshots si aplica (frontend)
6. Checklist de review:
   - [ ] Tests pasan
   - [ ] Linter OK
   - [ ] Sin breaking changes sin documentar

Usa el GitHub MCP para crear el PR. Trabajo en build mode.
