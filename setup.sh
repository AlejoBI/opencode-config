#!/usr/bin/env bash
#
# ─────────────────────────────────────────────────────────────
# OpenCode Config — Setup Script (Unix/macOS/Linux/WSL)
# ─────────────────────────────────────────────────────────────
# Uso:
#   git clone https://github.com/AlejoBI/opencode-config ~/opencode-config
#   cd ~/opencode-config && bash setup.sh
#
# Hace TODO:
#   1. Instala OpenCode si no está presente
#   2. Agrega opencode y Node.js 22 al PATH permanentemente
#   3. Instala Node.js 22 en ~/.node/ (necesario para chrome-devtools-mcp)
#   4. Configura variables de entorno (GITHUB_TOKEN, etc.)
#   5. Copia configs globales y custom commands
# ─────────────────────────────────────────────────────────────

set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"
OPENCODE_CONFIG_DIR="$HOME/.config/opencode"
ENV_FILE="$HOME/.env"
BASHRC="$HOME/.bashrc"
ZSHRC="$HOME/.zshrc"
PROFILE="$HOME/.profile"

# ─── Colores ───
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "\n${BLUE}╔══════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║${NC}  OpenCode Config — Setup                          ${BLUE}║${NC}"
echo -e "${BLUE}╚══════════════════════════════════════════════════════╝${NC}"
echo ""

# ──────────────────────────────────────────────
# 1. Instalar OpenCode si no existe
# ──────────────────────────────────────────────
echo -e "${BLUE}[1/7]${NC} OpenCode..."

if ! command -v opencode &>/dev/null; then
  echo -e "  ${YELLOW}→ No está instalado. Instalando...${NC}"

  # Intentar método oficial
  if command -v curl &>/dev/null; then
    echo "  Ejecutando: curl -fsSL https://opencode.ai/install | bash"
    curl -fsSL https://opencode.ai/install | bash || true
  fi

  # Si sigue sin funcionar, intentar con npm
  if ! command -v opencode &>/dev/null; then
    if command -v npm &>/dev/null; then
      echo "  Fallback: npm install -g opencode-ai"
      npm install -g opencode-ai 2>/dev/null || true
    fi
  fi

  # Verificar
  if command -v opencode &>/dev/null; then
    echo -e "  ${GREEN}✓ OpenCode instalado: $(opencode --version)${NC}"
  else
    echo -e "  ${RED}✗ No se pudo instalar OpenCode automáticamente.${NC}"
    echo "    Instálalo manualmente:"
    echo "      curl -fsSL https://opencode.ai/install | bash"
    echo "    O con npm: npm install -g opencode-ai"
    echo "    Luego ejecuta este script de nuevo."
    exit 1
  fi
else
  echo -e "  ${GREEN}✓ Ya instalado: $(opencode --version)${NC}"
fi

# ──────────────────────────────────────────────
# 2. Agregar opencode al PATH permanente
# ──────────────────────────────────────────────
echo -e "${BLUE}[2/7]${NC} PATH para OpenCode..."

# Posibles rutas donde opencode puede estar instalado
OPCODE_PATHS=(
  "$HOME/.opencode/bin"
  "$HOME/.local/bin"
  "/usr/local/bin"
)

for p in "${OPCODE_PATHS[@]}"; do
  if [ -f "$p/opencode" ] || [ -f "$p/opencode.exe" ]; then
    PATH_ENTRY="$p"
    break
  fi
done

if [ -n "${PATH_ENTRY:-}" ]; then
  # Agregar a bashrc
  if [ -f "$BASHRC" ]; then
    if ! grep -q "PATH.*${PATH_ENTRY}" "$BASHRC" 2>/dev/null; then
      echo "export PATH=\"$PATH_ENTRY\":\"\$PATH\"" >> "$BASHRC"
      echo -e "  ${GREEN}✓ Añadido a $BASHRC${NC}"
    else
      echo -e "  ${GREEN}✓ Ya está en $BASHRC${NC}"
    fi
  fi

  # Agregar a zshrc (macOS usa zsh por defecto)
  if [ -f "$ZSHRC" ]; then
    if ! grep -q "PATH.*${PATH_ENTRY}" "$ZSHRC" 2>/dev/null; then
      echo "export PATH=\"$PATH_ENTRY\":\"\$PATH\"" >> "$ZSHRC"
      echo -e "  ${GREEN}✓ Añadido a $ZSHRC${NC}"
    fi
  fi

  # Agregar a profile (fallback)
  if [ -f "$PROFILE" ]; then
    if ! grep -q "PATH.*${PATH_ENTRY}" "$PROFILE" 2>/dev/null; then
      echo "export PATH=\"$PATH_ENTRY\":\"\$PATH\"" >> "$PROFILE"
      echo -e "  ${GREEN}✓ Añadido a $PROFILE${NC}"
    fi
  fi

  export PATH="$PATH_ENTRY:$PATH"
else
  echo -e "  ${YELLOW}→ No se detectó ruta de opencode. El instalador ya debería haberla configurado.${NC}"
fi

# ──────────────────────────────────────────────
# 3. Instalar Node.js 22 en ~/.node/
# ──────────────────────────────────────────────
echo -e "${BLUE}[3/7]${NC} Node.js 22 (para chrome-devtools-mcp)..."

NODE_DIR="$HOME/.node"

install_node() {
  local url="$1"
  local tmp_dir="/tmp/node-install-$$"

  echo "  Descargando Node.js 22..."
  mkdir -p "$tmp_dir"

  if command -v curl &>/dev/null; then
    curl -fsSL "$url" | tar -xJ -C "$tmp_dir" 2>/dev/null
  elif command -v wget &>/dev/null; then
    wget -qO- "$url" | tar -xJ -C "$tmp_dir" 2>/dev/null
  else
    echo -e "  ${RED}✗ Necesitas curl o wget para descargar Node.js${NC}"
    return 1
  fi

  mkdir -p "$NODE_DIR"
  cp -r "$tmp_dir"/*/* "$NODE_DIR/"
  rm -rf "$tmp_dir"
  echo -e "  ${GREEN}✓ Node.js $(node --version) instalado en $NODE_DIR${NC}"
}

if [ -f "$NODE_DIR/node" ] || [ -f "$NODE_DIR/node.exe" ]; then
  NODE_PATH="$NODE_DIR"
else
  # Detectar arquitectura
  ARCH=$(uname -m)
  OS=$(uname -s)

  case "$OS" in
    Linux)
      case "$ARCH" in
        x86_64)  install_node "https://nodejs.org/dist/v22.14.0/node-v22.14.0-linux-x64.tar.xz" ;;
        aarch64) install_node "https://nodejs.org/dist/v22.14.0/node-v22.14.0-linux-arm64.tar.xz" ;;
        *)       echo -e "  ${YELLOW}→ Arquitectura no soportada: $ARCH. Instala Node.js 18+ manualmente.${NC}" ;;
      esac
      ;;
    Darwin)
      case "$ARCH" in
        x86_64)  install_node "https://nodejs.org/dist/v22.14.0/node-v22.14.0-darwin-x64.tar.xz" ;;
        arm64)   install_node "https://nodejs.org/dist/v22.14.0/node-v22.14.0-darwin-arm64.tar.xz" ;;
        *)       echo -e "  ${YELLOW}→ Arquitectura no soportada: $ARCH. Instala Node.js 18+ manualmente.${NC}" ;;
      esac
      ;;
    *)
      echo -e "  ${YELLOW}→ OS no detectado para instalación automática. Usa setup.bat en Windows.${NC}"
      ;;
  esac
fi

# Agregar Node.js al PATH si se instaló
if [ -d "$NODE_DIR" ] && { [ -f "$NODE_DIR/node" ] || [ -f "$NODE_DIR/node.exe" ]; }; then
  NODE_PATH="$NODE_DIR"

  for rc in "$BASHRC" "$ZSHRC" "$PROFILE"; do
    if [ -f "$rc" ]; then
      if ! grep -q "PATH.*${NODE_DIR}" "$rc" 2>/dev/null; then
        echo "export PATH=\"$NODE_DIR\":\"\$PATH\"" >> "$rc"
      fi
    fi
  done

  export PATH="$NODE_DIR:$PATH"
  echo -e "  ${GREEN}✓ Node.js en PATH${NC}"
fi

# ──────────────────────────────────────────────
# 4. Configurar variables de entorno
# ──────────────────────────────────────────────
echo -e "${BLUE}[4/7]${NC} Variables de entorno..."

# Crear ~/.env si no existe
if [ ! -f "$ENV_FILE" ]; then
  cp "$DOTFILES_DIR/.env.example" "$ENV_FILE"
  echo -e "  ${YELLOW}→ Creado $ENV_FILE (edítalo con tus tokens)${NC}"
else
  echo -e "  ${GREEN}✓ Ya existe $ENV_FILE${NC}"
fi

# Auto-source ~/.env en bashrc/zshrc si no está
ENV_SOURCE_LINE="[ -f \"$ENV_FILE\" ] && source \"$ENV_FILE\""

for rc in "$BASHRC" "$ZSHRC" "$PROFILE"; do
  if [ -f "$rc" ]; then
    if ! grep -q 'source.*\.env' "$rc" 2>/dev/null; then
      echo "" >> "$rc"
      echo "# Cargar variables de entorno de OpenCode" >> "$rc"
      echo "$ENV_SOURCE_LINE" >> "$rc"
      echo -e "  ${GREEN}✓ Auto-source ~/.env añadido a $rc${NC}"
    fi
  fi
done

# Si no existe ningún rc, crear .bashrc
if [ ! -f "$BASHRC" ] && [ ! -f "$ZSHRC" ] && [ ! -f "$PROFILE" ]; then
  echo "" >> "$BASHRC"
  echo "# Cargar variables de entorno de OpenCode" >> "$BASHRC"
  echo "$ENV_SOURCE_LINE" >> "$BASHRC"
  echo -e "  ${GREEN}✓ Creado $BASHRC con auto-source${NC}"
fi

# Preguntar por GITHUB_TOKEN si no está configurado
if [ -z "${GITHUB_TOKEN:-}" ]; then
  # Verificar si ya está en .env
  if ! grep -q "GITHUB_TOKEN=" "$ENV_FILE" 2>/dev/null || grep -q "GITHUB_TOKEN=ghp_TU_TOKEN_AQUI" "$ENV_FILE" 2>/dev/null; then
    echo ""
    echo -e "  ${YELLOW}╔══════════════════════════════════════════════════════╗${NC}"
    echo -e "  ${YELLOW}║${NC}  ¿Tienes un token de GitHub? (opcional)          ${YELLOW}║${NC}"
    echo -e "  ${YELLOW}║${NC}  Sin él, el MCP de GitHub no funcionará.         ${YELLOW}║${NC}"
    echo -e "  ${YELLOW}║${NC}  Crear en: https://github.com/settings/tokens    ${YELLOW}║${NC}"
    echo -e "  ${YELLOW}╚══════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo -n "  Token (o Enter para omitir): "
    read -r token
    if [ -n "$token" ]; then
      # Actualizar .env
      if [ -f "$ENV_FILE" ]; then
        sed -i.bak "s/GITHUB_TOKEN=.*/GITHUB_TOKEN=$token/" "$ENV_FILE" 2>/dev/null || \
          echo "GITHUB_TOKEN=$token" >> "$ENV_FILE"
        rm -f "$ENV_FILE.bak"
      fi
      export GITHUB_TOKEN="$token"
      echo -e "  ${GREEN}✓ Token guardado en $ENV_FILE${NC}"
    else
      echo -e "  ${YELLOW}→ Omitido. Puedes configurarlo después editando $ENV_FILE${NC}"
    fi
  fi
else
  echo -e "  ${GREEN}✓ GITHUB_TOKEN ya configurado${NC}"
fi

# Cargar .env para el resto del script
[ -f "$ENV_FILE" ] && set -a && source "$ENV_FILE" && set +a

# ──────────────────────────────────────────────
# 5. Instalar Playwright browsers (si aplica)
# ──────────────────────────────────────────────
echo -e "${BLUE}[5/7]${NC} Playwright browsers (para E2E testing)..."

if command -v npx &>/dev/null; then
  if npx playwright --version &>/dev/null; then
    npx playwright install chromium 2>/dev/null && echo -e "  ${GREEN}✓ Chromium instalado${NC}" || \
      echo -e "  ${YELLOW}→ Chromium no instalado (se instalará al primer uso)${NC}"
  fi
else
  echo -e "  ${YELLOW}→ npx no disponible. Los browsers se instalarán al primer uso.${NC}"
fi

# ──────────────────────────────────────────────
# 6. Copiar configuración de OpenCode
# ──────────────────────────────────────────────
echo -e "${BLUE}[6/7]${NC} Configuración de OpenCode..."

mkdir -p "$OPENCODE_CONFIG_DIR/commands"

echo "   → opencode.jsonc"
cp "$DOTFILES_DIR/opencode/opencode.jsonc" "$OPENCODE_CONFIG_DIR/opencode.jsonc"

echo "   → tui.json"
cp "$DOTFILES_DIR/opencode/tui.json" "$OPENCODE_CONFIG_DIR/tui.json"

echo "   → custom commands"
cp "$DOTFILES_DIR/opencode/commands/"*.md "$OPENCODE_CONFIG_DIR/commands/" 2>/dev/null

echo -e "  ${GREEN}✓ Configuración copiada${NC}"

# ──────────────────────────────────────────────
# 7. Resumen final
# ──────────────────────────────────────────────
echo ""
echo -e "${GREEN}╔══════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║${NC}  ✅  Configuración completada                       ${GREEN}║${NC}"
echo -e "${GREEN}╚══════════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "  ${BLUE}MCPs configurados:${NC}"
echo -e "    ${GREEN}✓${NC} chrome-devtools   (rendimiento y browser)"
echo -e "    ${GREEN}✓${NC} playwright         (E2E testing)"
echo -e "    ${GREEN}✓${NC} github             (PRs, issues, code review)"
echo -e "    ${GREEN}✓${NC} sequential-thinking (razonamiento paso a paso)"
echo -e "    ${GREEN}✓${NC} context7           (documentación técnica)"
echo -e "    ${GREEN}✓${NC} fetch              (APIs externas)"
echo ""
echo -e "  ${BLUE}Custom commands:${NC}"
echo -e "    /commit  /pr  /review  /test  /deploy"
echo -e "    /migrate /log /fix     /docs  /clean  /diagram"
echo ""
echo -e "  ${BLUE}Próximos pasos:${NC}"
echo -e "    1. Abre una NUEVA terminal (o: source ~/.bashrc)"
echo -e "    2. Verifica: ${YELLOW}opencode mcp list${NC}"
echo -e "    3. Si falta el GITHUB_TOKEN, edita: ${YELLOW}~/.env${NC}"
echo -e "    4. Lee el README completo: ${YELLOW}cat ~/opencode-config/README.md${NC}"
echo ""

# ──────────────────────────────────────────────
# También configurar esta misma máquina si es el repo local
# ──────────────────────────────────────────────
# Si estamos ejecutando desde el repo clonado en el escritorio (Windows),
# también actualizar esa copia
REPO_DIR="C:/Users/SF065/Desktop/opencode-config"
if [ -d "$REPO_DIR/.git" ]; then
  cp "$DOTFILES_DIR/opencode/opencode.jsonc" "$REPO_DIR/opencode/"
  cp "$DOTFILES_DIR/opencode/tui.json" "$REPO_DIR/opencode/"
  cp "$DOTFILES_DIR/opencode/commands/"*.md "$REPO_DIR/opencode/commands/" 2>/dev/null || true
fi
