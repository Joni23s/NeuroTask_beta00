@echo off
title NeuroTask - Servidor con QR para Movil
echo Iniciando NeuroTask en red local...
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0scripts\iniciar_con_qr.ps1"
pause
