@echo off
title Desplegar NeuroTask en GitHub Pages
echo ========================================================
echo        Desplegando NeuroTask a GitHub Pages...
echo ========================================================
powershell -ExecutionPolicy Bypass -File "%~dp0scripts\desplegar_github_pages.ps1"
echo.
pause
