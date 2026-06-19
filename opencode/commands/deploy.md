---
description: Build + test + deploy según entorno
agent: build
---

Ejecuta el pipeline de deploy para el entorno indicado ($ARGUMENTS o dev por defecto).

Pasos:
1. Detecta el stack (Vercel, Railway, Docker, etc.)
2. Corre build
3. Ejecuta tests
4. Si todo OK, procede con deploy:
   - dev → deploy a dev/staging
   - prod → deploy a producción (preguntar confirmación)
5. Reporta URL del deploy y estado

Si no hay un pipeline configurado, sugiere cómo configurarlo.
