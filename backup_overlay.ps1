# HWiNFO + RTSS Backup/Restore Script
# ASCII-safe version

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

function Read-NonEmpty($prompt) {
    while ($true) {
        $v = Read-Host $prompt
        if (-not [string]::IsNullOrWhiteSpace($v)) { return $v.Trim() }
        Write-Host "Inserisci un valore valido." -ForegroundColor Yellow
    }
}

function Ensure-Dir($path) {
    if (-not (Test-Path $path)) { New-Item -ItemType Directory -Path $path | Out-Null }
}

function Copy-IfExists($src, $dst) {
    if (Test-Path $src) {
        Ensure-Dir (Split-Path $dst -Parent)
        Copy-Item -Path $src -Destination $dst -Recurse -Force
        return $true
    }
    return $false
}

function Get-HwinfoRegKey {
    $candidates = @(
        "HKCU\Software\HWiNFO64",
        "HKCU\Software\HWiNFO"
    )
    foreach ($k in $candidates) {
        try {
            reg.exe query $k *> $null
            return $k
        } catch { }
    }
    return $null
}

function Backup-All {
    $outRoot = Read-NonEmpty "Dove vuoi salvare il backup? (es: D:\BackupOverlay)"
    $timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
    $work = Join-Path $outRoot "HWiNFO_RTSS_BACKUP_$timestamp"
    Ensure-Dir $work

    Write-Host "`n[1/4] Backup HWiNFO registro..." -ForegroundColor Cyan
    $hwKey = Get-HwinfoRegKey
    if ($null -eq $hwKey) {
        Write-Host "Chiave registro HWiNFO non trovata." -ForegroundColor Yellow
    } else {
        $regFile = Join-Path $work "hwinfo_settings.reg"
        reg.exe export $hwKey $regFile /y | Out-Null
        Write-Host "Backup registro OK." -ForegroundColor Green
    }

    Write-Host "`n[2/4] Backup RTSS..." -ForegroundColor Cyan
    $rtssBase = "${env:ProgramFiles(x86)}\RivaTuner Statistics Server"
    $rtssOut = Join-Path $work "RTSS"
    Ensure-Dir $rtssOut

    $foundAny = $false
    $foundAny = (Copy-IfExists (Join-Path $rtssBase "RTSS.cfg") (Join-Path $rtssOut "RTSS.cfg")) -or $foundAny
    $foundAny = (Copy-IfExists (Join-Path $rtssBase "Profiles") (Join-Path $rtssOut "Profiles")) -or $foundAny
    $foundAny = (Copy-IfExists (Join-Path $rtssBase "ProfileTemplates") (Join-Path $rtssOut "ProfileTemplates")) -or $foundAny

    if ($foundAny) {
        Write-Host "Backup RTSS OK." -ForegroundColor Green
    } else {
        Write-Host "RTSS non trovato." -ForegroundColor Yellow
    }

    Write-Host "`n[3/4] Creo ZIP..." -ForegroundColor Cyan
    $zipPath = Join-Path $outRoot "HWiNFO_RTSS_BACKUP_$timestamp.zip"
    if (Test-Path $zipPath) { Remove-Item $zipPath -Force }
    Compress-Archive -Path (Join-Path $work "*") -DestinationPath $zipPath -Force
    Write-Host "ZIP creato: $zipPath" -ForegroundColor Green

    Write-Host "`n[4/4] Pulizia temporanei..." -ForegroundColor Cyan
    Remove-Item $work -Recurse -Force
    Write-Host "Backup completato." -ForegroundColor Green
}

function Restore-All {
    $zipPath = Read-NonEmpty "Percorso ZIP di backup?"
    if (-not (Test-Path $zipPath)) { throw "ZIP non trovato." }

    $tempRoot = Join-Path $env:TEMP ("HWiNFO_RTSS_RESTORE_" + (Get-Date -Format "yyyyMMdd_HHmmss"))
    Ensure-Dir $tempRoot

    Write-Host "`n[1/3] Estraggo ZIP..." -ForegroundColor Cyan
    Expand-Archive -Path $zipPath -DestinationPath $tempRoot -Force

    Write-Host "`n[2/3] Ripristino HWiNFO..." -ForegroundColor Cyan
    $regFile = Join-Path $tempRoot "hwinfo_settings.reg"
    if (Test-Path $regFile) {
        reg.exe import $regFile | Out-Null
        Write-Host "Registro HWiNFO ripristinato." -ForegroundColor Green
    }

    Write-Host "`n[3/3] Ripristino RTSS..." -ForegroundColor Cyan
    $rtssBase = "${env:ProgramFiles(x86)}\RivaTuner Statistics Server"
    $rtssIn = Join-Path $tempRoot "RTSS"

    if (Test-Path (Join-Path $rtssIn "RTSS.cfg")) {
        Copy-Item (Join-Path $rtssIn "RTSS.cfg") -Destination (Join-Path $rtssBase "RTSS.cfg") -Force
    }
    if (Test-Path (Join-Path $rtssIn "Profiles")) {
        Copy-Item (Join-Path $rtssIn "Profiles") -Destination (Join-Path $rtssBase "Profiles") -Recurse -Force
    }
    if (Test-Path (Join-Path $rtssIn "ProfileTemplates")) {
        Copy-Item (Join-Path $rtssIn "ProfileTemplates") -Destination (Join-Path $rtssBase "ProfileTemplates") -Recurse -Force
    }

    Write-Host "Ripristino completato." -ForegroundColor Green
    Remove-Item $tempRoot -Recurse -Force
}

Write-Host "=============================" -ForegroundColor Cyan
Write-Host " HWiNFO + RTSS Backup/Restore " -ForegroundColor Cyan
Write-Host "=============================" -ForegroundColor Cyan
Write-Host "1) Backup"
Write-Host "2) Restore"
Write-Host ""

$choice = Read-NonEmpty "Scegli 1 o 2"

switch ($choice) {
    "1" { Backup-All }
    "2" { Restore-All }
    default { Write-Host "Scelta non valida." -ForegroundColor Yellow }
}
