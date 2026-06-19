# OpenCode Dotfiles — Full Stack Engineering Setup

Configuración portable de OpenCode para ingenieros full stack. Incluye MCPs, custom commands, keybinds y setup scripts para cualquier máquina.

## Stack incluido

```
Frontend  → Chrome DevTools MCP + Playwright MCP + Context7 MCP
Backend   → Sequential Thinking + Fetch MCP
DevOps    → GitHub MCP + Fetch MCP
General   → Custom commands + Keybinds personalizados + Node.js 22
```

## Instalación rápida

### En máquina nueva (Windows):

```powershell
git clone https://github.com/TU_USUARIO/dotfiles ~/dotfiles
cd ~/dotfiles
.\setup.bat
```

### En máquina nueva (macOS/Linux):

```bash
git clone https://github.com/TU_USUARIO/dotfiles ~/dotfiles
cd ~/dotfiles
chmod +x setup.sh && ./setup.sh
```

El script instala/configura automáticamente:
- OpenCode (lo detecta)
- Config global (`opencode.jsonc` + `tui.json`)
- Custom commands
- Node.js 22 en `~/.node/` (necesario para chrome-devtools-mcp)
- PATH en `.bashrc`

---

## MCPs configurados

| MCP | Versión | Función | Cómo se usa en prompt |
|-----|---------|---------|----------------------|
| **Chrome DevTools MCP** | `npx chrome-devtools-mcp@latest` | Navegación, rendimiento, debugging visual | *"Usando chrome-devtools, navega a..."* |
| **Playwright MCP** | `npx @playwright/mcp@latest` | E2E testing cross-browser | *"Usando playwright, prueba el login en firefox..."* |
| **GitHub MCP** | `npx @modelcontextprotocol/server-github` | PRs, issues, code review, repos | *"Usando github, crea un PR..."* |
| **Sequential Thinking** | `npx @modelcontextprotocol/server-sequential-thinking` | Razonamiento paso a paso | *"Usando sequential-thinking, descompón este problema..."* |
| **Context7 MCP** | `remote` | Documentación técnica al vuelo | *"Usando context7, busca cómo se hace X en React..."* |
| **Fetch MCP** | `npx @modelcontextprotocol/server-fetch` | APIs externas, web scraping | *"Usando fetch, obtén los datos de..."* |

### Requisitos por MCP

| MCP | Requisito | Token necesario |
|-----|-----------|----------------|
| Chrome DevTools | Node.js 18+ | Ninguno |
| Playwright | Node.js 18+ | Ninguno |
| GitHub | Node.js 18+ | `GITHUB_TOKEN` (variable de entorno) |
| Sequential Thinking | Node.js 18+ | Ninguno |
| Context7 | Internet | Ninguno (OAuth implícito) |
| Fetch | Node.js 18+ | Ninguno |

### Cómo configurar el token de GitHub

1. Crear un token en https://github.com/settings/tokens (permisos: `repo`, `read:org`, `read:user`)
2. Configurarlo como variable de entorno:

```bash
# En Windows (PowerShell):
[System.Environment]::SetEnvironmentVariable('GITHUB_TOKEN','ghp_xxxx','User')

# En bash/macOS/Linux:
echo 'export GITHUB_TOKEN=ghp_xxxx' >> ~/.bashrc
source ~/.bashrc
```

---

## Custom Commands

Usa `/comando` dentro de OpenCode (TUI o Desktop).

### `/commit`
**Agent:** build | **Descripción:** Commit estructurado con Conventional Commits

Analiza el diff actual y genera un mensaje de commit en formato:
```
<tipo>(<scope>): <descripción corta>

Cuerpo explicativo...
```

Tipos: feat, fix, refactor, chore, docs, test, style, perf, ci, build

### `/pr`
**Agent:** build | **Descripción:** Crea Pull Request en GitHub

Crea un PR con descripción detallada: resumen, motivación, cambios, screenshots, checklist de review. Usa el GitHub MCP.

### `/review`
**Agent:** plan (read-only) | **Descripción:** Code review automático

Revisa el código sin modificarlo. Evalúa: arquitectura, performance, seguridad, mantenibilidad, buenas prácticas, errores. Prioriza por criticidad (🔴/🟡/🟢).

### `/test`
**Agent:** build | **Descripción:** Tests con cobertura

Detecta el framework de tests, ejecuta tests con cobertura, reporta resultados y sugiere fixes si hay fallos.

### `/deploy`
**Agent:** build | **Descripción:** Build + test + deploy

Ejecuta el pipeline completo según el entorno (dev/prod). Detecta el stack (Vercel, Docker, Railway, etc.).

### `/migrate`
**Agent:** build | **Descripción:** Gestión de migraciones de DB

Comandos: `/migrate create <nombre>`, `/migrate run`, `/migrate rollback`, `/migrate status`. Detecta el ORM (Prisma, TypeORM, Drizzle, Knex, Alembic, etc.).

### `/log`
**Agent:** build | **Descripción:** Análisis de logs

Busca logs recientes, analiza patrones de error, stack traces, propone causas raíz y fixes.

### `/fix`
**Agent:** build | **Descripción:** Debugging de errores

Analiza un error específico, investiga la causa raíz y propone fix con código. Pide autorización antes de modificar.

### `/docs`
**Agent:** build | **Descripción:** Documentación técnica

Busca documentación actualizada usando Context7 MCP y Fetch MCP. Devuelve resúmenes, fragmentos y enlaces.

### `/clean`
**Agent:** build | **Descripción:** Limpieza del proyecto

Limpia cachés, dependencias, contenedores Docker, node_modules/.cache, archivos temporales. Reporta espacio liberado.

### `/diagram`
**Agent:** plan (read-only) | **Descripción:** Diagrama de arquitectura

Analiza la estructura del proyecto y genera un diagrama Mermaid con componentes, relaciones y flujo de datos.

---

## Keybinds (atajos de teclado)

| Atajo | Acción |
|-------|--------|
| `Ctrl+X` (leader) | Tecla líder para comandos multi-key |
| `Ctrl+X` → `n` | Nueva sesión |
| `Ctrl+X` → `l` | Listar sesiones |
| `Ctrl+X` → `u` | Undo (deshacer cambios) |
| `Ctrl+X` → `r` | Redo |
| `Ctrl+X` → `c` | Compactar contexto |
| `Ctrl+X` → `y` | Copiar mensaje |
| `Ctrl+X` → `e` | Abrir archivo en editor |
| `Ctrl+X` → `s` | Ver estado |
| `Ctrl+X` → `b` | Toggle sidebar |
| `Ctrl+X` → `t` | Cambiar tema |
| `Tab` / `Shift+Tab` | Cambiar entre agentes (build ↔ plan) |
| `Ctrl+P` | Lista de comandos (`/`) |
| `Ctrl+A` | Cambiar proveedor/modelo |
| `Ctrl+T` | Cambiar variante (effort del modelo) |
| `F2` | Ciclar modelo reciente |
| `Ctrl+R` | Renombrar sesión |
| `Esc` | Interrumpir agente |
| `Ctrl+Alt+K` | Which-key: muestra todos los atajos disponibles |

---

## Estructura del repositorio

```
dotfiles/
├── setup.sh                    # Setup para Unix/macOS
├── setup.bat                   # Setup para Windows
├── .gitignore
├── .env.example                # Template de variables de entorno
├── README.md
└── opencode/
    ├── opencode.jsonc          # Config global de OpenCode + MCPs
    ├── tui.json                # Keybinds personalizados
    └── commands/               # Custom commands
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

1. Crea un repo en GitHub: `https://github.com/TU_USUARIO/dotfiles`
2. En la primera máquina:
   ```bash
   cd ~/dotfiles
   git init
   git add .
   git commit -m "feat: inicial setup de OpenCode dotfiles"
   git remote add origin https://github.com/TU_USUARIO/dotfiles.git
   git push -u origin main
   ```
3. En cualquier otra máquina:
   ```bash
   git clone https://github.com/TU_USUARIO/dotfiles ~/dotfiles
   cd ~/dotfiles && ./setup.sh  # o setup.bat en Windows
   ```

---

## Verificación

Después de la instalación, verifica que todo funcione:

```bash
# Listar MCPs conectados
opencode mcp list

# Ver Node.js 22
node --version  # debe mostrar v22.x

# Probar un custom command (dentro de opencode)
# teclea: /test
```

---

## Personalización

- **Agregar un nuevo MCP:** edita `opencode/opencode.jsonc` en la sección `mcp`
- **Agregar un custom command:** crea un `.md` en `opencode/commands/`
- **Cambiar keybinds:** edita `opencode/tui.json`
- Haz commit y push para sincronizar a otras máquinas
