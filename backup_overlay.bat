@echo off
title Backup HWiNFO + RTSS

:: Richiede privilegi di amministratore
net session >nul 2>&1
if %errorlevel% neq 0 (
    powershell -Command "Start-Process '%~f0' -Verb runAs"
    exit
)

:: Avvia lo script PowerShell nella stessa cartella
powershell -ExecutionPolicy Bypass -File "%~dp0backup_overlay.ps1"

pause
