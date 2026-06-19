@echo off
setlocal enabledelayedexpansion

:: ─────────────────────────────────────────────────────────────
:: OpenCode Config — Setup Script (Windows)
:: ─────────────────────────────────────────────────────────────
:: Uso:
::   git clone https://github.com/AlejoBI/opencode-config %%USERPROFILE%%\opencode-config
::   cd %%USERPROFILE%%\opencode-config
::   setup.bat
::
:: Hace TODO:
::   1. Instala OpenCode si no está presente
::   2. Agrega opencode y Node.js al PATH del sistema (setx)
::   3. Instala Node.js 22 en %%USERPROFILE%%\.node\
::   4. Configura variables de entorno (GITHUB_TOKEN)
::   5. Copia configs globales y custom commands
:: ─────────────────────────────────────────────────────────────

set "DOTFILES_DIR=%~dp0"
set "OPENCODE_CONFIG_DIR=%USERPROFILE%\.config\opencode"
set "NODE_DIR=%USERPROFILE%\.node"
set "ENV_FILE=%USERPROFILE%\.env"

echo.
echo ============================================
echo   OpenCode Config - Setup Windows
echo ============================================
echo.

:: ──────────────────────────────────────────────
:: 1. Instalar OpenCode si no existe
:: ──────────────────────────────────────────────
echo [1/7] OpenCode...

where opencode >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo   OpenCode no esta instalado. Instalando...

    :: Intentar con npm primero
    where npm >nul 2>&1
    if !ERRORLEVEL! EQU 0 (
        echo   Ejecutando: npm install -g opencode-ai
        npm install -g opencode-ai 2>nul
    )

    :: Si no funciono, intentar con Git Bash
    where opencode >nul 2>&1
    if !ERRORLEVEL! NEQ 0 (
        where bash >nul 2>&1
        if !ERRORLEVEL! EQU 0 (
            echo   Ejecutando: curl -fsSL https://opencode.ai/install ^| bash
            bash -c "curl -fsSL https://opencode.ai/install | bash" 2>nul
        )
    )

    :: Verificar
    where opencode >nul 2>&1
    if !ERRORLEVEL! EQU 0 (
        for /f "tokens=*" %%i in ('opencode --version') do echo   [OK] OpenCode instalado: %%i
    ) else (
        echo   [ERROR] No se pudo instalar OpenCode automaticamente.
        echo          Instalalo manualmente y vuelve a ejecutar este script.
        echo          Opciones:
        echo            - npm install -g opencode-ai
        echo            - Desde Git Bash: curl -fsSL https://opencode.ai/install ^| bash
        echo            - scoope install opencode
        echo            - choco install opencode
        pause
        exit /b 1
    )
) else (
    for /f "tokens=*" %%i in ('opencode --version 2^>nul') do echo   [OK] Ya instalado: %%i
)

:: ──────────────────────────────────────────────
:: 2. Agregar al PATH del sistema
:: ──────────────────────────────────────────────
echo [2/7] PATH permanente...

:: Obtener PATH actual del usuario
for /f "skip=2 tokens=3*" %%a in ('reg query HKCU\Environment /v PATH 2^>nul') do set "USER_PATH=%%a %%b"
if not defined USER_PATH set "USER_PATH="

:: Verificar si las rutas ya estan en el PATH
set "NEEDS_NODE=1"
set "NEEDS_OPENCODE=1"

echo !USER_PATH! | findstr /I /C:"!NODE_DIR!" >nul 2>&1
if !ERRORLEVEL! EQU 0 set "NEEDS_NODE=0"

echo !USER_PATH! | findstr /I /C:"!USERPROFILE!\.opencode\bin" >nul 2>&1
if !ERRORLEVEL! EQU 0 set "NEEDS_OPENCODE=0"

:: Agregar rutas al PATH del usuario
set "NEW_PATH="
if !NEEDS_NODE! EQU 1 (
    set "NEW_PATH=!NODE_DIR!;"
    echo   [OK] Se agregara !NODE_DIR! al PATH del sistema
)
if !NEEDS_OPENCODE! EQU 1 (
    set "NEW_PATH=!NEW_PATH!!USERPROFILE!\.opencode\bin;"
    echo   [OK] Se agregara !USERPROFILE!\.opencode\bin al PATH del sistema
)

if defined NEW_PATH (
    reg add HKCU\Environment /v PATH /t REG_EXPAND_SZ /d "!NEW_PATH!!USER_PATH!" /f >nul
    echo   [OK] PATH del sistema actualizado
) else (
    echo   [OK] Las rutas ya estaban en el PATH del sistema
)

:: Actualizar PATH de esta sesion
set "PATH=%USERPROFILE%\.opencode\bin;%PATH%"

:: ──────────────────────────────────────────────
:: 3. Instalar Node.js (latest LTS)
:: ──────────────────────────────────────────────
echo [3/7] Node.js (latest LTS)...

if exist "%NODE_DIR%\node.exe" (
    for /f "tokens=*" %%i in ('"%NODE_DIR%\node.exe" --version') do echo   [OK] Node.js %%i ya instalado en !NODE_DIR!
) else (
    :: Detectar última versión LTS dinámicamente
    echo   Detectando última versión LTS de Node.js...
    for /f "delims=" %%i in ('powershell -NoProfile -Command "(Invoke-RestMethod https://nodejs.org/dist/index.json | Where-Object { $_.lts -ne $false } | Select-Object -First 1).version"') do set "LTS_VERSION=%%i"
    if not defined LTS_VERSION (
        set "LTS_VERSION=v22.14.0"
        echo   [WARN] No se pudo detectar version online. Usando !LTS_VERSION! como fallback.
    ) else (
        echo   [OK] Ultima LTS detectada: !LTS_VERSION!
    )
    set "LTS_FULL=node-!LTS_VERSION!"

    echo   Descargando !LTS_FULL! para Windows...
    curl -fsSL "https://nodejs.org/dist/!LTS_VERSION!/!LTS_FULL!-win-x64.zip" -o "%TEMP%\node.zip"

    if exist "%TEMP%\node.zip" (
        powershell -Command "Expand-Archive -Path '%TEMP%\node.zip' -DestinationPath '%TEMP%\node-install' -Force" >nul

        if not exist "!NODE_DIR!" mkdir "!NODE_DIR!"
        xcopy /E /Y /Q "%TEMP%\node-install\!LTS_FULL!-win-x64\*" "!NODE_DIR!\" >nul

        rmdir /S /Q "%TEMP%\node-install" 2>nul
        del "%TEMP%\node.zip" 2>nul

        echo   [OK] Node.js !LTS_VERSION! instalado en !NODE_DIR!
    ) else (
        echo   [WARN] No se pudo descargar Node.js.
        echo          Descargalo manualmente desde:
        echo          https://nodejs.org/dist/!LTS_VERSION!/!LTS_FULL!-win-x64.zip
        echo          Extrae el contenido en !NODE_DIR!
    )
)

:: ──────────────────────────────────────────────
:: 4. Variables de entorno
:: ──────────────────────────────────────────────
echo [4/7] Variables de entorno...

:: Copiar .env.example si no existe .env
if not exist "%ENV_FILE%" (
    copy /Y "%DOTFILES_DIR%.env.example" "%ENV_FILE%" >nul
    echo   [OK] Creado %ENV_FILE% (editalo con tus tokens)
) else (
    echo   [OK] Ya existe %ENV_FILE%
)

:: Preguntar por GITHUB_TOKEN
echo.
echo ============================================
echo   IMPORTANTE - Token de GitHub
echo ============================================
echo   El MCP de GitHub necesita un token.
echo   Crear en: https://github.com/settings/tokens
echo   Permisos minimos: repo, read:org, read:user
echo.
set /p GITHUB_TOKEN="Token (o Enter para omitir): "

if defined GITHUB_TOKEN (
    :: Actualizar .env
    powershell -Command "(Get-Content '%ENV_FILE%') -replace 'GITHUB_TOKEN=.*', 'GITHUB_TOKEN=%GITHUB_TOKEN%' | Set-Content '%ENV_FILE%'"

    :: Configurar como variable de entorno del sistema
    reg add HKCU\Environment /v GITHUB_TOKEN /t REG_SZ /d "%GITHUB_TOKEN%" /f >nul
    echo.
    echo   [OK] Token guardado en .env y en variables de entorno del sistema
    echo   Nota: Necesitas reiniciar la terminal para que surta efecto
) else (
    echo.
    echo   [INFO] Omitido. Puedes configurarlo despues editando %ENV_FILE%
    echo         O con: reg add HKCU\Environment /v GITHUB_TOKEN /t REG_SZ /d "ghp_xxx" /f
)

:: ──────────────────────────────────────────────
:: 5. Playwright browsers
:: ──────────────────────────────────────────────
echo.
echo [5/7] Playwright browser...

where npx >nul 2>&1
if !ERRORLEVEL! EQU 0 (
    set "PATH=%NODE_DIR%;%PATH%"
    echo   Instalando Chromium para Playwright...
    call npx playwright install chromium 2>nul
    if !ERRORLEVEL! EQU 0 (
        echo   [OK] Chromium instalado para Playwright
    ) else (
        echo   [INFO] Se instalara al primer uso
    )
)

:: ──────────────────────────────────────────────
:: 6. Copiar configuracion de OpenCode
:: ──────────────────────────────────────────────
echo [6/7] Configuracion de OpenCode...

if not exist "%OPENCODE_CONFIG_DIR%" mkdir "%OPENCODE_CONFIG_DIR%"
if not exist "%OPENCODE_CONFIG_DIR%\commands" mkdir "%OPENCODE_CONFIG_DIR%\commands"

echo    - opencode.jsonc
copy /Y "%DOTFILES_DIR%opencode\opencode.jsonc" "%OPENCODE_CONFIG_DIR%\opencode.jsonc" >nul

echo    - tui.json
copy /Y "%DOTFILES_DIR%opencode\tui.json" "%OPENCODE_CONFIG_DIR%\tui.json" >nul

echo    - custom commands
if exist "%DOTFILES_DIR%opencode\commands\*.md" (
    copy /Y "%DOTFILES_DIR%opencode\commands\*.md" "%OPENCODE_CONFIG_DIR%\commands\" >nul
)

echo   [OK] Configuracion copiada

:: ──────────────────────────────────────────────
:: 7. Resumen final
:: ──────────────────────────────────────────────
echo.
echo ============================================
echo   ✅  Configuracion completada
echo ============================================
echo.
echo   MCPs configurados:
echo     [OK] chrome-devtools    (rendimiento y browser)
echo     [OK] playwright          (E2E testing)
echo     [OK] github              (PRs, issues, code review)
echo     [OK] sequential-thinking (razonamiento paso a paso)
echo     [OK] context7            (documentacion tecnica)
echo     [OK] fetch               (APIs externas)
echo.
echo   Custom commands:
echo     /commit  /pr  /review  /test  /deploy
echo     /migrate /log /fix     /docs  /clean  /diagram
echo.
echo   Proximos pasos:
echo     1. CIERRA y ABRE una NUEVA terminal (para que el PATH surta efecto)
echo     2. Verifica: opencode mcp list
echo     3. Si falta el GITHUB_TOKEN, edita: %ENV_FILE%
echo     4. Lee el README completo: %DOTFILES_DIR%README.md
echo.
pause
