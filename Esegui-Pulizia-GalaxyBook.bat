@echo off
echo ========================================
echo  PULIZIA SAMSUNG GALAXY BOOK 4 EDGE
echo ========================================
echo.
echo Questo script rimuovera':
echo - App Samsung non necessarie (senza telefono Galaxy)
echo - OneDrive dall'avvio automatico
echo - Manterra' solo app essenziali per l'hardware
echo.
echo ATTENZIONE: Lo script verra' eseguito come Amministratore!
echo.
pause

:: Esegue lo script PowerShell come amministratore
powershell -ExecutionPolicy Bypass -Command "Start-Process PowerShell -ArgumentList '-ExecutionPolicy Bypass -File \"%~dp0Cleanup-GalaxyBook.ps1\"' -Verb RunAs"

echo.
echo Script completato!
pause
