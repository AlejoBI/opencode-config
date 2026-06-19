@echo off
setlocal enabledelayedexpansion

:: ──────────────────────────────────────────────
:: OpenCode Dotfiles — Setup Script (Windows)
:: ──────────────────────────────────────────────

set "DOTFILES_DIR=%~dp0"
set "OPENCODE_CONFIG_DIR=%USERPROFILE%\.config\opencode"

echo --------------------------------------------
echo  OpenCode Dotfiles — Setup Windows
echo --------------------------------------------

:: ── 1. Verificar OpenCode ──
where opencode >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] OpenCode no esta instalado.
    echo        Instalalo: curl -fsSL https://opencode.ai/install ^| bash
    echo        O: npm install -g opencode-ai
    pause
    exit /b 1
)
echo [OK] OpenCode detectado

:: ── 2. Crear directorios ──
if not exist "%OPENCODE_CONFIG_DIR%\commands" mkdir "%OPENCODE_CONFIG_DIR%\commands"

:: ── 3. Copiar configuracion ──
echo    - opencode.jsonc
copy /Y "%DOTFILES_DIR%opencode\opencode.jsonc" "%OPENCODE_CONFIG_DIR%\opencode.jsonc" >nul

echo    - tui.json
copy /Y "%DOTFILES_DIR%opencode\tui.json" "%OPENCODE_CONFIG_DIR%\tui.json" >nul

echo    - custom commands
copy /Y "%DOTFILES_DIR%opencode\commands\*.md" "%OPENCODE_CONFIG_DIR%\commands\" >nul

:: ── 4. Verificar Node.js ──
set "NODE_PATH=%USERPROFILE%\.node"
if exist "%NODE_PATH%\node.exe" (
    echo [OK] Node.js 22 ya esta instalado en %%USERPROFILE%%\.node
) else (
    echo.
    echo [INFO] Node.js 22 no encontrado en %%USERPROFILE%%\.node
    echo        Descargando Node.js 22 para Windows...
    curl -fsSL https://nodejs.org/dist/v22.14.0/node-v22.14.0-win-x64.zip -o "%TEMP%\node.zip"
    if exist "%TEMP%\node.zip" (
        powershell -Command "Expand-Archive -Path '%TEMP%\node.zip' -DestinationPath '%TEMP%\node-install' -Force"
        if not exist "%NODE_PATH%" mkdir "%NODE_PATH%"
        copy /Y "%TEMP%\node-install\node-v22.14.0-win-x64\*" "%NODE_PATH%\" >nul
        rmdir /S /Q "%TEMP%\node-install" 2>nul
        del "%TEMP%\node.zip" 2>nul
        echo [OK] Node.js 22 instalado en %%USERPROFILE%%\.node
    ) else (
        echo [WARN] No se pudo descargar Node.js. Hazlo manualmente desde:
        echo        https://nodejs.org/dist/v22.14.0/node-v22.14.0-win-x64.zip
    )
)

:: ── 5. Agregar al PATH del sistema ──
set "PATH=%USERPROFILE%\.node;%PATH%"
echo [INFO] Para hacer permanente el PATH, agrega %%USERPROFILE%%\.node a tus variables de entorno del sistema.

:: ── 6. Recordatorio de tokens ──
echo.
echo ============================================
echo   IMPORTANTE - Tokens requeridos
echo ============================================
echo   Configura estas variables de entorno en tu sistema:
echo.
echo   GITHUB_TOKEN=ghp_xxxx
echo   (opcional) DATABASE_URL=postgresql://...
echo.
echo   O crea un archivo .env en %%USERPROFILE%%\.env
echo   y cargalo en cada terminal.
echo ============================================
echo.
echo Instalacion completada.
echo Abre una nueva terminal y ejecuta: opencode mcp list
pause
