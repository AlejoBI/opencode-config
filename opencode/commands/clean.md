---
description: Limpia cachés, contenedores y dependencias
agent: build
---

Limpia archivos temporales, cachés y recursos no utilizados del proyecto.

Acciones que realiza:
1. Limpia cachés del stack detectado:
   - node_modules/.cache, .next/cache, etc.
   - pip cache, cargo cache, etc.
2. npm/pnpm/yarn cache clean
3. Docker: limpia contenedores stopped, networks no usadas, imágenes dangling
4. Busca y elimina node_modules viejos si hay monorepo
5. node_modules/.cache
6. Archivos .log, .tmp, .bak

Muestra cuánto espacio liberaste.
Pregunta antes de hacer cambios destructivos.
