# =============================================================================
# Script di pulizia per Samsung Galaxy Book 4 Edge
# Rimuove app Samsung non necessarie (senza telefono Galaxy) e OneDrive
# Autore: AI Assistant
# Data: 26/08/2025
# =============================================================================

Write-Host "=== PULIZIA SAMSUNG GALAXY BOOK 4 EDGE ===" -ForegroundColor Cyan
Write-Host "Questo script rimuoverà app Samsung non necessarie e OneDrive" -ForegroundColor Yellow
Write-Host ""

# Verifica se lo script è eseguito come amministratore
if (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "ATTENZIONE: Questo script deve essere eseguito come Amministratore!" -ForegroundColor Red
    Write-Host "Riavvia PowerShell come Amministratore e riesegui lo script." -ForegroundColor Red
    pause
    exit
}

# Lista delle app Samsung da rimuovere (non necessarie senza telefono Galaxy)
$SamsungAppsToRemove = @(
    "SAMSUNGELECTRONICSCO.LTD.SamsungPhone",
    "SAMSUNGELECTRONICSCO.LTD.SmartSwitchforGalaxyBook", 
    "SAMSUNGELECTRONICSCoLtd.SamsungQuickShare",
    "SAMSUNGELECTRONICSCoLtd.MultiControl",
    "SAMSUNGELECTRONICSCoLtd.SamsungContinuityService",
    "SAMSUNGELECTRONICSCO.LTD.SmartThingsWindows",
    "SAMSUNGELECTRONICSCO.LTD.SamsungCloudPlatformManag",
    "SAMSUNGELECTRONICSCO.LTD.Bixby",
    "SAMSUNGELECTRONICSCO.LTD.SamsungPass",
    "SAMSUNGELECTRONICSCO.LTD.SamsungQuickSearch",
    "SAMSUNGELECTRONICSCO.LTD.SamsungWelcome",
    "SAMSUNGELECTRONICSCoLtd.SamsungNotes",
    "SAMSUNGELECTRONICSCO.LTD.SamsungAnalyticsAgent"
)

# Funzione per rimuovere app
function Remove-SamsungApp {
    param([string]$AppName)
    
    $app = Get-AppxPackage -Name $AppName -ErrorAction SilentlyContinue
    if ($app) {
        Write-Host "Rimozione di $AppName..." -ForegroundColor Green
        try {
            Get-AppxPackage -Name $AppName | Remove-AppxPackage -ErrorAction Stop
            Write-Host "✅ $AppName rimosso con successo" -ForegroundColor Green
        }
        catch {
            Write-Host "❌ Errore nella rimozione di $AppName`: $($_.Exception.Message)" -ForegroundColor Red
        }
    }
    else {
        Write-Host "ℹ️ $AppName non trovato o già rimosso" -ForegroundColor Yellow
    }
}

# Mostra le app Samsung installate prima della pulizia
Write-Host "`n--- APP SAMSUNG INSTALLATE PRIMA DELLA PULIZIA ---" -ForegroundColor Magenta
Get-AppxPackage | Where-Object {$_.Name -like "*Samsung*"} | Select-Object Name, Version | Sort-Object Name | Format-Table -AutoSize

Write-Host "`n--- INIZIO RIMOZIONE APP SAMSUNG NON NECESSARIE ---" -ForegroundColor Cyan

# Rimuove tutte le app Samsung non necessarie
foreach ($app in $SamsungAppsToRemove) {
    Remove-SamsungApp -AppName $app
    Start-Sleep -Milliseconds 500  # Pausa breve tra le rimozioni
}

Write-Host "`n--- RIMOZIONE ONEDRIVE ---" -ForegroundColor Cyan

# Termina il processo OneDrive se in esecuzione
$oneDriveProcess = Get-Process -Name "OneDrive" -ErrorAction SilentlyContinue
if ($oneDriveProcess) {
    Write-Host "Terminazione processo OneDrive..." -ForegroundColor Green
    Stop-Process -Name "OneDrive" -Force -ErrorAction SilentlyContinue
    Write-Host "✅ Processo OneDrive terminato" -ForegroundColor Green
}

# Disinstalla OneDrive usando winget
Write-Host "Disinstallazione OneDrive..." -ForegroundColor Green
try {
    $result = winget uninstall "Microsoft OneDrive" 2>&1
    Write-Host "✅ OneDrive disinstallato con successo" -ForegroundColor Green
}
catch {
    Write-Host "❌ Errore nella disinstallazione di OneDrive: $($_.Exception.Message)" -ForegroundColor Red
}

# Rimuove OneDrive dall'avvio automatico
Write-Host "Rimozione OneDrive dall'avvio automatico..." -ForegroundColor Green
try {
    Remove-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" -Name "OneDrive" -ErrorAction SilentlyContinue
    Write-Host "✅ OneDrive rimosso dall'avvio automatico" -ForegroundColor Green
}
catch {
    Write-Host "ℹ️ OneDrive non era nell'avvio automatico" -ForegroundColor Yellow
}


Write-Host "`n--- RISULTATI FINALI ---" -ForegroundColor Magenta

# Mostra le app Samsung rimanenti
Write-Host "`nApp Samsung rimanenti (necessarie per l'hardware):" -ForegroundColor Green
$remainingApps = Get-AppxPackage | Where-Object {$_.Name -like "*Samsung*"} | Select-Object Name | Sort-Object Name
if ($remainingApps) {
    $remainingApps | Format-Table -AutoSize
} else {
    Write-Host "Nessuna app Samsung rimanente" -ForegroundColor Yellow
}

# Mostra i programmi di avvio rimanenti
Write-Host "`nProgrammi di avvio automatico rimanenti:" -ForegroundColor Green
$startupPrograms = Get-CimInstance Win32_StartupCommand | Select-Object Name, Command | Sort-Object Name
if ($startupPrograms) {
    $startupPrograms | Format-Table -AutoSize
} else {
    Write-Host "Nessun programma di avvio automatico trovato" -ForegroundColor Yellow
}

# Mostra i servizi Samsung attivi
Write-Host "`nServizi Samsung attivi (necessari per l'hardware):" -ForegroundColor Green
$samsungServices = Get-Service | Where-Object {$_.Name -like "*Samsung*" -and $_.Status -eq "Running"} | Select-Object Name, DisplayName, Status | Sort-Object Name
if ($samsungServices) {
    $samsungServices | Format-Table -AutoSize
} else {
    Write-Host "Nessun servizio Samsung in esecuzione" -ForegroundColor Yellow
}

Write-Host "`n=== PULIZIA COMPLETATA! ===" -ForegroundColor Cyan
Write-Host "Il tuo Galaxy Book 4 Edge è ora ottimizzato:" -ForegroundColor Green
Write-Host "✅ Rimosse app Samsung non necessarie (senza telefono Galaxy)" -ForegroundColor Green
Write-Host "✅ Rimosso OneDrive e dall'avvio automatico" -ForegroundColor Green
Write-Host "✅ Mantenute solo app Samsung essenziali per l'hardware" -ForegroundColor Green
Write-Host "✅ Sistema più veloce e con meno bloatware" -ForegroundColor Green

Write-Host "`nPer applicare completamente le modifiche, si consiglia di riavviare il computer." -ForegroundColor Yellow
Write-Host "`nPremi un tasto per chiudere..." -ForegroundColor Gray
pause
