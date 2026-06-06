@echo off
title LeadBot - Automacao de Anuncios
cd /d "%~dp0"

echo ============================================
echo       LeadBot - Automacao de Anuncios
echo ============================================
echo.
echo Iniciando servidor...
echo Abrindo http://localhost:8787 no navegador...
echo.
start http://localhost:8787
npx tsx src/index.ts
pause
