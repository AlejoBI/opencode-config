---
description: Gestiona migraciones de base de datos
agent: build
---

Gestiona migraciones de base de datos según el comando.

Usos:
- /migrate create <nombre>  → Crea nueva migración
- /migrate run              → Ejecuta migraciones pendientes
- /migrate rollback         → Revierte última migración
- /migrate status           → Muestra estado de migraciones

Detecta el ORM/herramienta (Prisma, TypeORM, Drizzle, Knex, Alembic, etc.)
y usa los comandos apropiados.
