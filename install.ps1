# SPDX-FileCopyrightText: 2026 Rafael Meira Gonçalves
# SPDX-License-Identifier: PolyForm-Noncommercial-1.0.0
# Lagrange installer for Windows, for a terminal. Run in PowerShell (Windows PowerShell 5.1 or 7):
#   irm https://raw.githubusercontent.com/rafa210587/lagrange/main/install.ps1 | iex
# It downloads LagrangeSetup.exe from the latest release, checks its SHA-256 and runs it: the same
# per-user installer as the download link, with its window showing the progress. Run it again to update.
$ErrorActionPreference = 'Stop'
$ProgressPreference = 'SilentlyContinue'
[Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls12
if ($env:PROCESSOR_ARCHITECTURE -ne 'AMD64') { throw 'O Lagrange é publicado para Windows x64.' }
$source = 'https://github.com/rafa210587/lagrange/releases/latest/download/LagrangeSetup.exe'
$work = Join-Path ([IO.Path]::GetTempPath()) ('lagrange-install-' + [guid]::NewGuid().ToString('N'))
New-Item -ItemType Directory -Path $work | Out-Null
try {
    $setup = Join-Path $work 'LagrangeSetup.exe'
    Write-Host 'Baixando o instalador do Lagrange...'
    Invoke-WebRequest -UseBasicParsing -Uri $source -OutFile $setup
    Invoke-WebRequest -UseBasicParsing -Uri "$source.sha256" -OutFile "$setup.sha256"
    $expected = ((Get-Content -LiteralPath "$setup.sha256" -Raw).Trim() -split '\s+')[0]
    $actual = (Get-FileHash -LiteralPath $setup -Algorithm SHA256).Hash
    if ($actual -ne $expected) { throw "O instalador baixado não confere com o SHA-256 publicado ($actual, esperado $expected)." }
    $process = Start-Process -FilePath $setup -ArgumentList '--auto' -PassThru -Wait
    if ($process.ExitCode -ne 0) { throw "A instalação não terminou; o registro está em $([IO.Path]::GetTempPath())lagrange-setup.log" }
    Write-Host 'Lagrange instalado. Abra pelo Menu Iniciar ou digite lagrange num terminal novo.'
}
finally {
    Remove-Item -LiteralPath $work -Recurse -Force -ErrorAction SilentlyContinue
}
