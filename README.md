# OpenCode Config — Full Stack Engineering Setup

Configuración portable de OpenCode para ingenieros full stack. Incluye 6 MCPs, 11 custom commands, keybinds personalizados, y scripts de instalación automática para cualquier máquina.

**Repo:** https://github.com/AlejoBI/opencode-config

---

## Índice

- [Instalación rápida](#instalaci%C3%B3n-r%C3%A1pida)
- [Prerrequisitos](#prerrequisitos)
- [Qué instala el setup](#qu%C3%A9-instala-el-setup)
- [MCPs configurados](#mcps-configurados)
  - [Chrome DevTools MCP](#1-chrome-devtools-mcp)
  - [Playwright MCP](#2-playwright-mcp)
  - [GitHub MCP](#3-github-mcp)
  - [Sequential Thinking MCP](#4-sequential-thinking-mcp)
  - [Context7 MCP](#5-context7-mcp)
  - [Fetch MCP](#6-fetch-mcp)
- [Custom commands](#custom-commands)
- [Keybinds](#keybinds)
- [Variables de entorno](#variables-de-entorno)
- [Estructura del repositorio](#estructura-del-repositorio)
- [Cómo sincronizar entre máquinas](#c%C3%B3mo-sincronizar-entre-m%C3%A1quinas)
- [Verificación](#verificaci%C3%B3n)
- [Troubleshooting](#troubleshooting)

---

## Instalación rápida

### Windows

```powershell
# 1. Clonar el repo
git clone https://github.com/AlejoBI/opencode-config %USERPROFILE%\opencode-config

# 2. Ejecutar setup
%USERPROFILE%\opencode-config\setup.bat

# 3. CERRAR y ABRIR nueva terminal
# 4. Verificar
opencode mcp list
```

### macOS / Linux / WSL

```bash
# 1. Clonar el repo
git clone https://github.com/AlejoBI/opencode-config ~/opencode-config

# 2. Ejecutar setup
cd ~/opencode-config && bash setup.sh

# 3. Cargar los cambios
source ~/.bashrc

# 4. Verificar
opencode mcp list
```

**Nota:** Si no tienes Git instalado, ve a la sección [Prerrequisitos](#prerrequisitos).

---

## Prerrequisitos

### Necesario en cualquier máquina

| Requisito | Versión mínima | Para qué |
|-----------|---------------|----------|
| **Git** | 2.x | Clonar repos, GitHub MCP, custom commands de git |
| **Conexión a Internet** | — | Descargar MCPs, docs, APIs |

### Recomendado

| Software | Versión | Para qué |
|----------|---------|----------|
| **Chrome** o **Chromium** | Cualquiera | Chrome DevTools MCP (si no está, lo descarga automáticamente) |
| **Node.js** | 18+ | Se instala automáticamente en `~/.node/` (v22) |

### Opcional

| Software | Para qué |
|----------|----------|
| **Firefox** | Playwright E2E testing cross-browser |
| **Docker** | Si usas el MCP de Docker (no incluido en config por defecto) |

### Cómo instalar Git en cada OS

**Windows:**
```powershell
# Opción 1 — Git for Windows (recomendado)
# Descargar: https://git-scm.com/download/win

# Opción 2 — winget
winget install Git.Git

# Opción 3 — chocolatey
choco install git
```

**macOS:**
```bash
# Opción 1 — Xcode CLI Tools
xcode-select --install

# Opción 2 — Homebrew
brew install git
```

**Linux (Debian/Ubuntu):**
```bash
sudo apt update && sudo apt install git -y
```

**Linux (Arch):**
```bash
sudo pacman -S git
```

---

## Qué instala el setup

El script `setup.sh` (Unix) o `setup.bat` (Windows) hace automáticamente:

| Paso | Descripción |
|------|-------------|
| 1 | **OpenCode** — Si no está instalado, lo instala (curl o npm) |
| 2 | **PATH permanente** — Agrega `~/.opencode/bin` y `~/.node/` al PATH del sistema |
| 3 | **Node.js 22** — Descarga e instala en `~/.node/` (necesario para chrome-devtools-mcp) |
| 4 | **Variables de entorno** — Crea `~/.env`, lo configura para que se cargue automáticamente, y pregunta por GITHUB_TOKEN |
| 5 | **Playwright Chromium** — Descarga el navegador Chromium para E2E testing |
| 6 | **Configs de OpenCode** — Copia `opencode.jsonc`, `tui.json` y custom commands a `~/.config/opencode/` |

---

## MCPs configurados

### Visión general

| # | MCP | Tipo | Versión | Función |
|---|-----|------|---------|---------|
| 1 | **Chrome DevTools** | local | `chrome-devtools-mcp@latest` | Rendimiento web, navegación, debugging visual |
| 2 | **Playwright** | local | `@playwright/mcp@latest` | E2E testing cross-browser (Chromium + Firefox + WebKit) |
| 3 | **GitHub** | local | `@modelcontextprotocol/server-github` | PRs, issues, code review, repos |
| 4 | **Sequential Thinking** | local | `@modelcontextprotocol/server-sequential-thinking` | Razonamiento paso a paso para problemas complejos |
| 5 | **Context7** | remote | `https://mcp.context7.com/mcp` | Documentación técnica bajo demanda |
| 6 | **Fetch** | local | `@modelcontextprotocol/server-fetch` | APIs externas, web scraping |

### Configuración por MCP

#### 1. Chrome DevTools MCP

**Qué hace:** Controla Chrome/Chromium para navegar, medir rendimiento (Core Web Vitals, LCP, FCP, CLS), tomar screenshots, inspeccionar red, auditar accesibilidad, y debugging visual.

**Usa Puppeteer** para conectarse a Chrome. Si no tienes Chrome instalado, Puppeteer descarga Chromium automáticamente.

**Configuración:** Ninguna adicional. Se instala con `npx chrome-devtools-mcp@latest`.

**Ejemplos de uso en OpenCode:**
```
/usando chrome-devtools, navega a mi-app.com y dime las métricas Core Web Vitals
/usando chrome-devtools, haz click en el botón de login y captura las peticiones de red
/usando chrome-devtools, toma un screenshot de la página de inicio
```

**Más info:** https://github.com/ChromeDevTools/chrome-devtools-mcp

---

#### 2. Playwright MCP

**Qué hace:** E2E testing automatizado. Soporta Chromium, Firefox y WebKit (Safari). Usa el árbol de accesibilidad en vez de screenshots, lo que es más preciso y consume menos tokens.

**Instalación de browsers:**
```bash
# Instalar Chromium (ya lo hace setup.sh/bat)
npx playwright install chromium

# Para testing cross-browser (opcional):
npx playwright install firefox webkit
```

⚠️ **Nota:** WebKit (Safari) **no funciona en Windows**. En Windows solo Chromium + Firefox.

**Configuración:** Ninguna adicional. Se instala con `npx @playwright/mcp@latest`.

**Ejemplos de uso:**
```
/usando playwright, navega a mi-app.com y prueba el flujo de registro
/usando playwright, prueba el login en firefox
/usando playwright, busca un elemento con el texto "Enviar" y haz click
```

**Más info:** https://www.npmjs.com/package/@playwright/mcp

---

#### 3. GitHub MCP

**Qué hace:** Accede a la API de GitHub para crear PRs, revisar issues, gestionar repos, hacer code review, y automatizar flujos de trabajo.

**Requisito:** Necesita un **token de GitHub** con permisos.

**Cómo crear el token:**

1. Ve a https://github.com/settings/tokens
2. Haz click en **"Generate new token (classic)"**
3. Dale un nombre descriptivo (ej: "opencode-mcp")
4. Selecciona estos permisos mínimos:
   - `repo` (acceso a repositorios privados)
   - `read:org` (leer organizaciones)
   - `read:user` (leer datos de usuario)
5. Haz click en **"Generate token"**
6. **Copia el token** (se muestra una sola vez)

**Cómo configurarlo:**

El setup.sh/bat te preguntará por el token durante la instalación.

Si lo haces después de la instalación:

**En Unix/macOS/WSL:**
```bash
echo 'export GITHUB_TOKEN=ghp_TU_TOKEN_AQUI' >> ~/.env
source ~/.env
```

**En Windows (PowerShell como Administrador):**
```powershell
[System.Environment]::SetEnvironmentVariable('GITHUB_TOKEN','ghp_TU_TOKEN_AQUI','User')
```

**En Windows (cmd como Administrador):**
```cmd
reg add HKCU\Environment /v GITHUB_TOKEN /t REG_SZ /d "ghp_TU_TOKEN_AQUI" /f
```

> **Importante:** Después de configurar la variable de entorno, **cierra y abre una nueva terminal**.

**Verificar que funciona:**
```bash
opencode mcp list
# Deberías ver: github connected
```

**Ejemplos de uso:**
```
/usando github, crea un PR desde la rama actual con descripción detallada
/usando github, lista los issues abiertos del repo actual
/usando github, revisa el PR #12 y sugiere cambios
```

**Más info:** https://github.com/modelcontextprotocol/servers/tree/main/src/github

---

#### 4. Sequential Thinking MCP

**Qué hace:** Ayuda a descomponer problemas complejos en pasos manejables. Esencial para debugging, planificación de arquitectura, y problemas de lógica.

**Configuración:** Ninguna. Se instala con `npx @modelcontextprotocol/server-sequential-thinking`.

**Ejemplos de uso:**
```
/usando sequential-thinking, descompón el problema de performance que tenemos en el endpoint /api/users
/usando sequential-thinking, planifica la migración de la base de datos de SQLite a Postgres
```

**Más info:** https://github.com/modelcontextprotocol/servers/tree/main/src/sequentialthinking

---

#### 5. Context7 MCP

**Qué hace:** Busca documentación técnica actualizada de librerías, frameworks y herramientas al vuelo. No necesitas salir de OpenCode para buscar docs.

**Configuración:** Ninguna. Es un servidor remoto (no necesita instalación local).

**Ejemplos de uso:**
```
/usando context7, busca cómo migrar de React Router v5 a v6
/usando context7, busca la documentación de la API de Prisma para relaciones many-to-many
```

**Más info:** https://github.com/upstash/context7

---

#### 6. Fetch MCP

**Qué hace:** Hace peticiones HTTP a APIs externas. Útil para consultar APIs REST, web scraping simple, y obtener datos de servicios externos.

**Configuración:** Ninguna. Se instala con `npx @modelcontextprotocol/server-fetch`.

**Ejemplos de uso:**
```
/usando fetch, haz una petición GET a https://api.github.com/repos/AlejoBI/opencode-config
/usando fetch, obtén el contenido de https://ejemplo.com/api/data
```

**Más info:** https://github.com/modelcontextprotocol/servers/tree/main/src/fetch

---

## Custom commands

Los custom commands se usan escribiendo `/comando` dentro de OpenCode (TUI o Desktop).

Están definidos en `opencode/commands/*.md` y se copian automáticamente a `~/.config/opencode/commands/`.

### Lista completa

| Comando | Agente | Descripción |
|---------|--------|-------------|
| `/commit` | build | Analiza el diff y genera commit estructurado (Conventional Commits) |
| `/pr` | build | Crea Pull Request en GitHub con descripción detallada |
| `/review` | plan | Code review automático (solo lectura, no modifica) |
| `/test` | build | Corre tests con cobertura y sugiere fixes |
| `/deploy` | build | Build + test + deploy según el entorno |
| `/migrate` | build | Gestiona migraciones de base de datos |
| `/log` | build | Analiza logs y diagnostica errores |
| `/fix` | build | Debugging: analiza error y propone fix |
| `/docs` | build | Busca documentación técnica con Context7 MCP |
| `/clean` | build | Limpia cachés, contenedores y dependencias |
| `/diagram` | plan | Genera diagrama Mermaid de la arquitectura del proyecto |

### Detalle por comando

#### `/commit`
**Agent:** build | **Formato:** `/commit`

Analiza el diff actual (`git diff --staged` o `git diff`) y genera un mensaje de commit en formato Conventional Commits.

Tipo sugerido según el cambio:
- `feat:` — Nueva funcionalidad
- `fix:` — Corrección de bug
- `refactor:` — Refactorización sin cambios funcionales
- `chore:` — Tareas de mantenimiento
- `docs:` — Cambios en documentación
- `test:` — Añadir o modificar tests
- `style:` — Cambios de formato (lint, prettier)
- `perf:` — Mejora de rendimiento
- `ci:` — Cambios en CI/CD
- `build:` — Cambios en el sistema de build

```
Ejemplo de output:
feat(api): añadir endpoint de autenticación con JWT

- Implementado login con email y contraseña
- Generación de tokens JWT con refresh
- Middleware de verificación de token
- Tests de integración para el flujo completo
```

#### `/pr`
**Agent:** build | **Formato:** `/pr` (desde una rama de feature)

Crea un Pull Request en GitHub usando el GitHub MCP. Incluye:
- Resumen de cambios
- Motivación y contexto
- Lista de cambios principales
- Cómo se probó
- Checklist de code review

#### `/review`
**Agent:** plan (read-only) | **Formato:** `/review` o `/review src/archivo.ts`

Hace code review del proyecto completo o de archivos específicos. Evalúa:
- **Arquitectura** — diseño, acoplamiento
- **Performance** — cuellos de botella, N+1 queries
- **Seguridad** — inyecciones, validación de inputs
- **Mantenibilidad** — claridad, tests, duplicación
- **Buenas prácticas** — estándares del lenguaje
- **Errores** — bugs, manejo de errores

Clasifica los hallazgos por criticidad: 🔴 Alto / 🟡 Medio / 🟢 Bajo

#### `/test`
**Agent:** build | **Formato:** `/test`

Detecta el framework de tests (Vitest, Jest, Mocha, PyTest, etc.), ejecuta los tests con cobertura, reporta resultados y sugiere fixes para fallos.

#### `/deploy`
**Agent:** build | **Formato:** `/deploy dev` o `/deploy prod`

Ejecuta el pipeline de deploy:
1. Detecta el stack (package.json, Dockerfile, vercel.json, etc.)
2. Corre build
3. Ejecuta tests
4. Si es prod, pide confirmación
5. Despliega y reporta URL

#### `/migrate`
**Agent:** build | **Formato:** `/migrate create <nombre>`, `/migrate run`, `/migrate rollback`, `/migrate status`

Detecta el ORM/configuración (Prisma, TypeORM, Drizzle, Knex, Alembic, etc.) y usa los comandos apropiados.

#### `/log`
**Agent:** build | **Formato:** `/log` o `/log "error de conexión"`

Busca logs recientes, analiza patrones de error, stack traces, y propone causas raíz con posibles fixes.

#### `/fix`
**Agent:** build | **Formato:** `/fix "TypeError: Cannot read property"` o `/fix` (detecta error automáticamente)

Analiza un error, investiga la causa raíz, propone fix con código. Pide autorización antes de modificar.

#### `/docs`
**Agent:** build | **Formato:** `/docs "useReducer en React"`

Busca documentación técnica usando Context7 MCP y Fetch MCP. Devuelve resumen, fragmentos clave y enlaces.

#### `/clean`
**Agent:** build | **Formato:** `/clean`

Limpia: cachés de node_modules/.next/.cache, npm/pnpm cache, contenedores Docker no usados, imágenes dangling, archivos .log/.tmp.

#### `/diagram`
**Agent:** plan (read-only) | **Formato:** `/diagram`

Analiza la estructura del proyecto y genera un diagrama en formato Mermaid (componentes, relaciones, flujo de datos). Devuelve el código Mermaid listo para copiar a un `.md`.

---

## Keybinds

Atajos de teclado configurados en `opencode/tui.json`.

### Tecla líder

La tecla `Ctrl+X` es la **tecla líder**. Muchos atajos requieren presionarla primero y luego otra tecla.

```
Ctrl+X → n   = Nueva sesión
Ctrl+X → l   = Listar sesiones
Ctrl+X → u   = Undo
Ctrl+X → r   = Redo
```

### Atajos principales

| Atajo | Acción |
|-------|--------|
| `Ctrl+X` → `n` | Nueva sesión |
| `Ctrl+X` → `l` | Listar sesiones |
| `Ctrl+X` → `u` | Undo (deshacer cambios) |
| `Ctrl+X` → `r` | Redo |
| `Ctrl+X` → `c` | Compactar contexto |
| `Ctrl+X` → `y` | Copiar mensaje |
| `Ctrl+X` → `e` | Abrir archivo en editor externo |
| `Ctrl+X` → `s` | Ver estado de la sesión |
| `Ctrl+X` → `b` | Mostrar/ocultar sidebar |
| `Ctrl+X` → `t` | Cambiar tema |
| `Ctrl+X` → `↓` | Ir al primer hijo (subagente) |
| `Tab` | Cambiar al siguiente agente |
| `Shift+Tab` | Cambiar al agente anterior |
| `Ctrl+P` | Lista de comandos (`/`) |
| `Ctrl+A` | Cambiar proveedor / modelo |
| `Ctrl+T` | Cambiar variante (effort del modelo) |
| `F2` | Ciclar al siguiente modelo reciente |
| `Shift+F2` | Ciclar al modelo reciente anterior |
| `Ctrl+R` | Renombrar sesión |
| `Esc` | Interrumpir al agente |
| `Ctrl+Alt+K` | **Which-key:** muestra todos los atajos disponibles |

### Atajos en el input (modo Readline/Emacs)

| Atajo | Acción |
|-------|--------|
| `Ctrl+A` / `Ctrl+E` | Ir al inicio / final de línea |
| `Ctrl+←` / `Ctrl+→` | Saltar palabra anterior / siguiente |
| `Ctrl+K` | Borrar hasta el final de línea |
| `Ctrl+U` | Borrar toda la línea |
| `Ctrl+W` | Borrar palabra anterior |
| `Ctrl+D` | Borrar carácter bajo el cursor |
| `Shift+Enter` | Nueva línea (input multilínea) |
| `Ctrl+Z` | Undo en el input (también `Ctrl+-`) |

### Cómo personalizar

Edita `opencode/tui.json` y haz commit:

```jsonc
{
  "keybinds": {
    "session_compact": "<leader>c",     // Cambiar atajo
    "session_compact": "none"           // Deshabilitar atajo
  }
}
```

---

## Variables de entorno

### Configuración automática

El setup crea `~/.env` y lo configura para que se cargue automáticamente en cada terminal (bash/zsh).

Contenido de `~/.env`:

```bash
# GitHub Personal Access Token (necesario para GitHub MCP)
# Crear en: https://github.com/settings/tokens
# Permisos: repo, read:org, read:user
GITHUB_TOKEN=ghp_TU_TOKEN_AQUI

# (Opcional) URL de base de datos para futuros MCPs de DB
DATABASE_URL=postgresql://usuario:password@localhost:5432/mi_db
```

### Variables requeridas

| Variable | Requerido | Para qué |
|----------|-----------|----------|
| `GITHUB_TOKEN` | Sí (para GitHub MCP) | Acceso a API de GitHub |

### Variables opcionales

| Variable | Para qué |
|----------|----------|
| `DATABASE_URL` | Conexión a base de datos (para futuros MCPs) |
| `OPENCODE_CONFIG` | Ruta personalizada al archivo de configuración |
| `OPENCODE_DISABLE_AUTOUPDATE` | `true` para deshabilitar auto-actualizaciones |

### Cómo cargar las variables manualmente

```bash
# En bash/zsh
source ~/.env

# Verificar que se cargó
echo $GITHUB_TOKEN
```

---

## Estructura del repositorio

```
opencode-config/
├── setup.sh                    # Setup para Unix/macOS/Linux/WSL
├── setup.bat                   # Setup para Windows
├── .gitignore
├── .env.example                # Template de variables de entorno
├── README.md                   # Este archivo
└── opencode/
    ├── opencode.jsonc          # Config global de OpenCode + MCPs
    ├── tui.json                # Keybinds personalizados
    └── commands/               # Custom commands (/comando)
        ├── commit.md
        ├── pr.md
        ├── review.md
        ├── test.md
        ├── deploy.md
        ├── migrate.md
        ├── log.md
        ├── fix.md
        ├── docs.md
        ├── clean.md
        └── diagram.md
```

---

## Cómo sincronizar entre máquinas

### En la máquina actual (ya está)

El repo ya está subido a GitHub en `main`. Cualquier cambio que hagas:

```bash
cd ~/opencode-config  # o C:\Users\SF065\Desktop\opencode-config
git add .
git commit -m "feat: añadir nuevo MCP de Docker"
git push
```

### En una máquina nueva

```bash
# Windows
git clone https://github.com/AlejoBI/opencode-config %USERPROFILE%\opencode-config
%USERPROFILE%\opencode-config\setup.bat

# macOS / Linux / WSL
git clone https://github.com/AlejoBI/opencode-config ~/opencode-config
cd ~/opencode-config && bash setup.sh
```

### Para mantener actualizado

```bash
cd ~/opencode-config
git pull
bash setup.sh   # o .\setup.bat
```

El setup es **idempotente**: puedes ejecutarlo cuantas veces quieras sin romper nada.

---

## Verificación

Después de la instalación, verifica que todo funciona:

```bash
# 1. Listar MCPs
opencode mcp list
# Deberías ver: chrome-devtools ✓, playwright ✓, github ✓, etc.

# 2. Ver versión de Node.js
node --version
# Debería mostrar: v22.x

# 3. Ver versión de OpenCode
opencode --version

# 4. Probar un custom command (dentro de OpenCode)
# /test

# 5. Probar un MCP (dentro de OpenCode)
# "usando chrome-devtools, navega a https://ejemplo.com y dime el título"
```

### Quick check de salud

```bash
opencode mcp list
echo "Node: $(node --version)"
echo "OpenCode: $(opencode --version)"
echo "GitHub Token: $(if [ -n "$GITHUB_TOKEN" ]; then echo '✓ configurado'; else echo '✗ no configurado'; fi)"
```

---

## Troubleshooting

### `opencode mcp list` muestra `failed` para un MCP

**Causa posible:** Node.js versión incorrecta o MCP no instalado.

**Solución:**
```bash
# Verificar Node.js
node --version   # Debe ser 18+
export PATH="$HOME/.node:$PATH"

# Reiniciar MCP (desde OpenCode: /reconnect o reiniciar OpenCode)
```

### `github` MCP muestra `failed` o `disconnected`

**Causa probable:** `GITHUB_TOKEN` no configurado.

**Solución:**
```bash
# Verificar si está configurado
echo $GITHUB_TOKEN   # Debe mostrar el token

# Si no, configurarlo
echo 'export GITHUB_TOKEN=ghp_TU_TOKEN_AQUI' >> ~/.env
source ~/.env
```

### `chrome-devtools` MCP falla

**Causa posible:** Node.js < 18 o Chrome no instalado.

**Solución:**
```bash
# Verificar Node.js
node --version

# Chrome DevTools MCP descarga Chromium automáticamente si no hay Chrome
# Asegúrate de tener Node.js 18+
```

### `opencode` no se encuentra después de instalar

**Causa:** El PATH no se actualizó en la terminal actual.

**Solución:**
```bash
# Cargar el PATH actualizado
source ~/.bashrc

# O abrir una terminal nueva completamente
```

### En Windows, `opencode` no funciona en PowerShell/cmd

**Causa:** El PATH del sistema no se actualizó.

**Solución:**
```powershell
# Opción 1 — Cerrar y abrir nueva terminal
# Opción 2 — Actualizar PATH manualmente
$env:PATH = "$env:USERPROFILE\.opencode\bin;$env:PATH"
```

### El setup dice que no encuentra Git

**Solución:** Instalar Git (ver [Prerrequisitos](#prerrequisitos)) y volver a ejecutar el setup.

### Error `Unexpected token import` con chrome-devtools-mcp

**Causa:** Node.js versión 8 (la que viene con algunos sistemas).

**Solución:** El instala Node.js 22 en `~/.node/`, pero necesitas que esté en el PATH del sistema. Ejecuta el setup de nuevo o verifica manualmente:
```bash
export PATH="$HOME/.node:$PATH"
node --version   # Debe ser v22.x
```

---

## Personalización

### Agregar un nuevo MCP

1. Edita `opencode/opencode.jsonc`
2. Añade la configuración del MCP en la sección `mcp`
3. Haz commit y push
4. En las otras máquinas: `git pull && bash setup.sh`

### Agregar un custom command

1. Crea un archivo `.md` en `opencode/commands/`
2. El nombre del archivo será el nombre del comando (`/nombre`)
3. Haz commit y push

### Cambiar keybinds

1. Edita `opencode/tui.json`
2. Haz commit y push

### Personalización local (solo esta máquina)

Para cambios que no quieras sincronizar, edita directamente:
- `~/.config/opencode/opencode.jsonc`
- `~/.config/opencode/tui.json`
- `~/.config/opencode/commands/` (agrega comandos aquí)

---

## License

MIT — Alejandro Bravo Isajar
