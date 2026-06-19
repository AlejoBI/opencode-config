---
description: Genera diagrama de arquitectura desde el código
agent: plan
---

Analiza el proyecto y genera un diagrama de arquitectura.

Pasos:
1. Detecta la estructura del proyecto
2. Identifica:
   - Componentes principales (carpetas, módulos, servicios)
   - Relaciones entre ellos (imports, dependencias)
   - Flujo de datos (APIs, DBs, colas)
3. Genera el diagrama en formato Mermaid

El diagrama debe incluir:
- Frontend (componentes, rutas, estado)
- Backend (API endpoints, servicios, middleware)
- Base de datos (tablas principales, relaciones)
- Servicios externos (APIs, colas, almacenamiento)

Devuelve el código Mermaid listo para copiar a un .md.
