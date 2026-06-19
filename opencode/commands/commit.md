---
description: Commit estructurado con Conventional Commits
agent: build
---

Haz un análisis completo del diff actual (git diff --staged si hay, si no git diff).
Genera un commit estructurado siguiendo Conventional Commits:

Formato: <tipo>(<scope>): <descripción>

Tipos: feat, fix, refactor, chore, docs, test, style, perf, ci, build
Scope: el módulo o paquete afectado

Incluye:
1. Título claro y descriptivo
2. Cuerpo explicando el qué y el por qué
3. Si aplica, referencia a issues (#123)

NO hagas git add ni git commit, solo devuélveme el mensaje de commit listo para copiar.
