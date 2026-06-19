#!/usr/bin/env bash
set -euo pipefail

# ──────────────────────────────────────────────
# OpenCode Dotfiles — Setup Script (Unix/macOS)
# ──────────────────────────────────────────────

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"
OPENCODE_CONFIG_DIR="$HOME/.config/opencode"

echo "⚡ Configurando OpenCode dotfiles..."

# ── 1. Verificar OpenCode instalado ──
if ! command -v opencode &>/dev/null; then
  echo "❌ OpenCode no está instalado."
  echo "   Instálalo primero: curl -fsSL https://opencode.ai/install | bash"
  echo "   O: npm install -g opencode-ai"
  exit 1
fi
echo "✅ OpenCode detectado: $(opencode --version)"

# ── 2. Crear directorio de configuración ──
mkdir -p "$OPENCODE_CONFIG_DIR/commands"

# ── 3. Copiar configuración ──
echo "   → opencode.jsonc"
cp "$DOTFILES_DIR/opencode/opencode.jsonc" "$OPENCODE_CONFIG_DIR/opencode.jsonc"

echo "   → tui.json"
cp "$DOTFILES_DIR/opencode/tui.json" "$OPENCODE_CONFIG_DIR/tui.json"

echo "   → custom commands"
cp "$DOTFILES_DIR/opencode/commands/"*.md "$OPENCODE_CONFIG_DIR/commands/"

# ── 4. Configurar Node.js 22 si no existe (para chrome-devtools-mcp) ──
if [ ! -f "$HOME/.node/node.exe" ] && [ ! -f "$HOME/.node/node" ]; then
  echo "   → Instalando Node.js 22 en ~/.node/..."
  if [[ "$OSTYPE" == "msys" || "$OSTYPE" == "cygwin" ]]; then
    echo "     Windows detectado. Usa setup.bat para instalar Node.js o instálalo manualmente."
  else
    curl -fsSL https://nodejs.org/dist/v22.14.0/node-v22.14.0-$(uname -m | sed 's/x86_64/linux-x64/;s/aarch64/linux-arm64/').tar.xz | tar -xJ -C /tmp/
    mkdir -p "$HOME/.node"
    cp -r /tmp/node-v22.14.0-*/* "$HOME/.node/"
    rm -rf /tmp/node-v22.14.0-*
    echo "     Node.js 22 instalado en ~/.node/"
  fi
else
  echo "✅ Node.js 22 ya está instalado en ~/.node/"
fi

# ── 5. Agregar ~/.node al PATH en .bashrc ──
if ! grep -q 'export PATH="$HOME/.node:$PATH"' "$HOME/.bashrc" 2>/dev/null; then
  echo 'export PATH="$HOME/.node:$PATH"' >> "$HOME/.bashrc"
  echo "   → PATH actualizado en .bashrc"
fi
if ! grep -q 'export PATH="$HOME/.node:$PATH"' "$HOME/.bash_profile" 2>/dev/null; then
  echo 'export PATH="$HOME/.node:$PATH"' >> "$HOME/.bash_profile" 2>/dev/null || true
fi

# ── 6. Recordatorio de tokens ──
echo ""
echo "╔══════════════════════════════════════════════════════╗"
echo "║  ⚠️  TOKENS REQUERIDOS                              ║"
echo "╠══════════════════════════════════════════════════════╣"
echo "║  Crea un archivo ~/.env con:                        ║"
echo "║                                                      ║"
echo "║  GITHUB_TOKEN=ghp_xxxx                              ║"
echo "║  (opcional) DATABASE_URL=postgresql://...           ║"
echo "║                                                      ║"
echo "║  Luego en cada terminal:                            ║"
echo "║  export GITHUB_TOKEN=ghp_xxxx                       ║"
echo "╚══════════════════════════════════════════════════════╝"
echo ""
echo "✅ Configuración completada."
echo "   Abre una nueva terminal o ejecuta: source ~/.bashrc"
echo "   Luego verifica: opencode mcp list"
