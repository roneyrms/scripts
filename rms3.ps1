#Requires -RunAsAdministrator
<#
.SYNOPSIS
    RMS Optimizer ULTRA - Sistema Avançado de Otimização

.DESCRIPTION
    Ferramenta completa de limpeza, otimização e manutenção do Windows
    Inclui análise em tempo real, relatórios detalhados e modo automático

.NOTES
    Autor: RMSTECH
    Versão: 4.0 ULTRA
    Data: 19/12/2024
    Requer: Privilégios de Administrador

.COPYRIGHT
    © 2024 RMSTECH. Todos os direitos reservados.
#>

# Configurações iniciais
$Host.UI.RawUI.WindowTitle = "RMS Optimizer ULTRA - RMSTECH"
$ErrorActionPreference = "SilentlyContinue"
$ProgressPreference = "SilentlyContinue"

# Variáveis globais para estatísticas
$Global:SpaceFreed = 0
$Global:FilesDeleted = 0
$Global:StartTime = Get-Date

# Função para exibir banner
function Show-Banner {
    Clear-Host
    Write-Host ""
    Write-Host "████████████████████████████████████████████████████████████████████████████████" -ForegroundColor Green
    Write-Host "██                                                                              ██" -ForegroundColor Green
    Write-Host "██                           RMS OPTIMIZER ULTRA                                ██" -ForegroundColor White
    Write-Host "██                      Sistema Avançado de Otimização                          ██" -ForegroundColor White
    Write-Host "██                          © 2025 RMSTECH                                      ██" -ForegroundColor Gray
    Write-Host "██                                                                              ██" -ForegroundColor Green
    Write-Host "████████████████████████████████████████████████████████████████████████████████" -ForegroundColor Green
    Write-Host ""
}

# Função para calcular espaço liberado
function Get-FolderSize {
    param([string]$Path)

    if (Test-Path $Path) {
        try {
            $size = (Get-ChildItem -Path $Path -Recurse -Force -ErrorAction SilentlyContinue | 
                    Measure-Object -Property Length -Sum -ErrorAction SilentlyContinue).Sum
            return [math]::Round($size / 1MB, 2)
        }
        catch {
            return 0
        }
    }
    return 0
}

# Função para exibir progresso animado
function Show-Progress {
    param(
        [string]$Activity,
        [int]$PercentComplete
    )

    $barLength = 50
    $completed = [math]::Floor($barLength * $PercentComplete / 100)
    $remaining = $barLength - $completed

    $bar = "█" * $completed + "░" * $remaining

    Write-Host "`r  [$bar] $PercentComplete% - $Activity" -NoNewline -ForegroundColor Cyan
}

# Função para limpar com estatísticas
function Remove-ItemsWithStats {
    param(
        [string]$Path,
        [string]$Description
    )

    if (Test-Path $Path) {
        $sizeBefore = Get-FolderSize -Path $Path

        try {
            Get-ChildItem -Path $Path -Recurse -Force -ErrorAction SilentlyContinue | 
                Remove-Item -Force -Recurse -ErrorAction SilentlyContinue

            $sizeAfter = Get-FolderSize -Path $Path
            $freed = $sizeBefore - $sizeAfter

            if ($freed -gt 0) {
                $Global:SpaceFreed += $freed
                Write-Host "  ✓ $Description - Liberado: $freed MB" -ForegroundColor Green
            }
            else {
                Write-Host "  ✓ $Description - Nenhum arquivo para limpar" -ForegroundColor Gray
            }
        }
        catch {
            Write-Host "  ✗ Erro ao limpar: $Description" -ForegroundColor Red
        }
    }
}

# Função para exibir menu principal
function Show-MainMenu {
    Show-Banner

    # Exibe informações do sistema
    $os = Get-CimInstance Win32_OperatingSystem
    $disk = Get-CimInstance Win32_LogicalDisk -Filter "DeviceID='C:'"
    $freeSpace = [math]::Round($disk.FreeSpace / 1GB, 2)
    $totalSpace = [math]::Round($disk.Size / 1GB, 2)
    $usedPercent = [math]::Round((($totalSpace - $freeSpace) / $totalSpace) * 100, 1)

    Write-Host "📊 INFORMAÇÕES DO SISTEMA" -ForegroundColor Cyan
    Write-Host "   Sistema: $($os.Caption) - Build $($os.BuildNumber)" -ForegroundColor White
    Write-Host "   Disco C: $freeSpace GB livre de $totalSpace GB ($usedPercent% usado)" -ForegroundColor White
    Write-Host ""

    Write-Host "MENU PRINCIPAL" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "[1] 🧹 Limpeza Básica do Sistema" -ForegroundColor White
    Write-Host "[2] 🔥 Limpeza Avançada (Recomendado)" -ForegroundColor White
    Write-Host "[3] 🌐 Otimização de Rede" -ForegroundColor White
    Write-Host "[4] 💿 Otimização de Disco" -ForegroundColor White
    Write-Host "[5] 🔍 Verificação de Integridade" -ForegroundColor White
    Write-Host "[6] ⚡ Otimização Completa" -ForegroundColor White
    Write-Host "[7] 🤖 Modo Automático Inteligente (NOVO!)" -ForegroundColor Yellow
    Write-Host "[8] 📊 Análise de Sistema Detalhada (NOVO!)" -ForegroundColor Yellow
    Write-Host "[9] 🗑️  Limpeza de Programas Desnecessários (NOVO!)" -ForegroundColor Yellow
    Write-Host "[0] ❌ Sair" -ForegroundColor White
    Write-Host ""
    Write-Host "████████████████████████████████████████████████████████████████████████████████" -ForegroundColor Green
    Write-Host ""
}

# Função: Limpeza Básica
function Start-BasicCleanup {
    Show-Banner
    Write-Host "████████████████████████████████████████████████████████████████████████████████" -ForegroundColor Cyan
    Write-Host "██                        LIMPEZA BÁSICA                                        ██" -ForegroundColor Cyan
    Write-Host "████████████████████████████████████████████████████████████████████████████████" -ForegroundColor Cyan
    Write-Host ""

    $Global:SpaceFreed = 0
    Write-Host "Iniciando limpeza básica do sistema..." -ForegroundColor Yellow
    Write-Host ""

    # [1/5] Arquivos temporários
    Write-Host "[1/5] Limpando arquivos temporários..." -ForegroundColor Yellow
    Remove-ItemsWithStats -Path $env:TEMP -Description "Pasta TEMP do usuário"
    Remove-ItemsWithStats -Path "$env:SystemRoot\Temp" -Description "Pasta TEMP do Windows"

    # [2/5] Lixeira
    Write-Host ""
    Write-Host "[2/5] Limpando lixeira..." -ForegroundColor Yellow
    try {
        Clear-RecycleBin -Force -ErrorAction SilentlyContinue
        Write-Host "  ✓ Lixeira esvaziada" -ForegroundColor Green
    }
    catch {
        Write-Host "  ✗ Erro ao esvaziar lixeira" -ForegroundColor Red
    }

    # [3/5] Cache do Windows
    Write-Host ""
    Write-Host "[3/5] Limpando cache do Windows..." -ForegroundColor Yellow
    Remove-ItemsWithStats -Path "$env:SystemRoot\Prefetch" -Description "Prefetch"

    # [4/5] Logs do sistema
    Write-Host ""
    Write-Host "[4/5] Limpando logs do sistema..." -ForegroundColor Yellow
    try {
        $logs = Get-WinEvent -ListLog * -ErrorAction SilentlyContinue | Where-Object {$_.RecordCount -gt 0}
        $logCount = 0
        foreach ($log in $logs) {
            wevtutil.exe cl $log.LogName 2>$null
            $logCount++
        }
        Write-Host "  ✓ $logCount logs limpos" -ForegroundColor Green
    }
    catch {
        Write-Host "  ✗ Erro ao limpar logs" -ForegroundColor Red
    }

    # [5/5] Limpeza de disco
    Write-Host ""
    Write-Host "[5/5] Executando limpeza de disco do Windows..." -ForegroundColor Yellow
    try {
        Start-Process cleanmgr -ArgumentList "/sagerun:1" -Wait -WindowStyle Hidden
        Write-Host "  ✓ Limpeza de disco concluída" -ForegroundColor Green
    }
    catch {
        Write-Host "  ✗ Erro ao executar limpeza de disco" -ForegroundColor Red
    }

    Write-Host ""
    Write-Host "════════════════════════════════════════════════════════════════════════════════" -ForegroundColor Green
    Write-Host "✅ Limpeza básica concluída com sucesso!" -ForegroundColor Green
    Write-Host "📊 Espaço total liberado: $([math]::Round($Global:SpaceFreed, 2)) MB" -ForegroundColor Cyan
    Write-Host "════════════════════════════════════════════════════════════════════════════════" -ForegroundColor Green
    Write-Host ""

    Read-Host "Pressione ENTER para voltar ao menu"
}

# Função: Limpeza Avançada
function Start-AdvancedCleanup {
    Show-Banner
    Write-Host "████████████████████████████████████████████████████████████████████████████████" -ForegroundColor Cyan
    Write-Host "██                      LIMPEZA AVANÇADA                                        ██" -ForegroundColor Cyan
    Write-Host "████████████████████████████████████████████████████████████████████████████████" -ForegroundColor Cyan
    Write-Host ""

    $Global:SpaceFreed = 0
    Write-Host "Iniciando limpeza avançada do sistema..." -ForegroundColor Yellow
    Write-Host ""

    # [1/10] Arquivos temporários
    Write-Host "[1/10] Limpando arquivos temporários..." -ForegroundColor Yellow
    Remove-ItemsWithStats -Path $env:TEMP -Description "TEMP do usuário"
    Remove-ItemsWithStats -Path "$env:SystemRoot\Temp" -Description "TEMP do Windows"

    # [2/10] Cache de navegadores
    Write-Host ""
    Write-Host "[2/10] Limpando cache de navegadores..." -ForegroundColor Yellow

    # Fecha navegadores
    Stop-Process -Name chrome, firefox, msedge, opera, brave -Force -ErrorAction SilentlyContinue
    Start-Sleep -Seconds 2

    # Chrome
    Remove-ItemsWithStats -Path "$env:LOCALAPPDATA\Google\Chrome\User Data\Default\Cache" -Description "Cache do Chrome"
    Remove-ItemsWithStats -Path "$env:LOCALAPPDATA\Google\Chrome\User Data\Default\Code Cache" -Description "Code Cache do Chrome"

    # Edge
    Remove-ItemsWithStats -Path "$env:LOCALAPPDATA\Microsoft\Edge\User Data\Default\Cache" -Description "Cache do Edge"

    # Firefox
    $firefoxProfiles = Get-ChildItem "$env:APPDATA\Mozilla\Firefox\Profiles" -Directory -ErrorAction SilentlyContinue
    foreach ($profile in $firefoxProfiles) {
        Remove-ItemsWithStats -Path "$($profile.FullName)\cache2" -Description "Cache do Firefox"
    }

    # [3/10] Windows Update
    Write-Host ""
    Write-Host "[3/10] Limpando cache do Windows Update..." -ForegroundColor Yellow

    $services = @('wuauserv', 'cryptSvc', 'bits', 'msiserver')
    foreach ($service in $services) {
        Stop-Service -Name $service -Force -ErrorAction SilentlyContinue
    }

    Remove-ItemsWithStats -Path "$env:SystemRoot\SoftwareDistribution\Download" -Description "Downloads do Windows Update"

    foreach ($service in $services) {
        Start-Service -Name $service -ErrorAction SilentlyContinue
    }

    # [4/10] DNS Cache
    Write-Host ""
    Write-Host "[4/10] Limpando cache DNS..." -ForegroundColor Yellow
    try {
        Clear-DnsClientCache
        Write-Host "  ✓ Cache DNS limpo" -ForegroundColor Green
    }
    catch {
        Write-Host "  ✗ Erro ao limpar cache DNS" -ForegroundColor Red
    }

    # [5/10] Thumbnails
    Write-Host ""
    Write-Host "[5/10] Limpando cache de miniaturas..." -ForegroundColor Yellow
    Remove-ItemsWithStats -Path "$env:LOCALAPPDATA\Microsoft\Windows\Explorer" -Description "Cache de miniaturas"

    # [6/10] Delivery Optimization
    Write-Host ""
    Write-Host "[6/10] Limpando Delivery Optimization..." -ForegroundColor Yellow
    Remove-ItemsWithStats -Path "$env:SystemRoot\SoftwareDistribution\DeliveryOptimization" -Description "Delivery Optimization"

    # [7/10] Windows Error Reporting
    Write-Host ""
    Write-Host "[7/10] Limpando relatórios de erro..." -ForegroundColor Yellow
    Remove-ItemsWithStats -Path "$env:LOCALAPPDATA\CrashDumps" -Description "Crash Dumps"
    Remove-ItemsWithStats -Path "$env:ProgramData\Microsoft\Windows\WER" -Description "Windows Error Reporting"

    # [8/10] Logs
    Write-Host ""
    Write-Host "[8/10] Limpando logs do sistema..." -ForegroundColor Yellow
    try {
        $logs = Get-WinEvent -ListLog * -ErrorAction SilentlyContinue | Where-Object {$_.RecordCount -gt 0}
        $logCount = 0
        foreach ($log in $logs) {
            wevtutil.exe cl $log.LogName 2>$null
            $logCount++
        }
        Write-Host "  ✓ $logCount logs limpos" -ForegroundColor Green
    }
    catch {
        Write-Host "  ✗ Erro ao limpar logs" -ForegroundColor Red
    }

    # [9/10] Arquivos de instalação antigos
    Write-Host ""
    Write-Host "[9/10] Limpando instalações antigas do Windows..." -ForegroundColor Yellow
    Remove-ItemsWithStats -Path "$env:SystemRoot\Windows.old" -Description "Windows.old"

    # [10/10] Verificação de sistema
    Write-Host ""
    Write-Host "[10/10] Executando verificação rápida do sistema..." -ForegroundColor Yellow
    try {
        $result = sfc /scannow
        Write-Host "  ✓ Verificação SFC concluída" -ForegroundColor Green
    }
    catch {
        Write-Host "  ✗ Erro na verificação SFC" -ForegroundColor Red
    }

    Write-Host ""
    Write-Host "════════════════════════════════════════════════════════════════════════════════" -ForegroundColor Green
    Write-Host "✅ Limpeza avançada concluída com sucesso!" -ForegroundColor Green
    Write-Host "📊 Espaço total liberado: $([math]::Round($Global:SpaceFreed, 2)) MB" -ForegroundColor Cyan
    Write-Host "════════════════════════════════════════════════════════════════════════════════" -ForegroundColor Green
    Write-Host ""

    Read-Host "Pressione ENTER para voltar ao menu"
}

# Função: Otimização de Rede
function Start-NetworkOptimization {
    Show-Banner
    Write-Host "████████████████████████████████████████████████████████████████████████████████" -ForegroundColor Cyan
    Write-Host "██                      OTIMIZAÇÃO DE REDE                                      ██" -ForegroundColor Cyan
    Write-Host "████████████████████████████████████████████████████████████████████████████████" -ForegroundColor Cyan
    Write-Host ""

    Write-Host "Iniciando otimização de rede..." -ForegroundColor Yellow
    Write-Host ""

    # [1/6] Renovar IP
    Write-Host "[1/6] Renovando configurações de IP..." -ForegroundColor Yellow
    try {
        ipconfig /release | Out-Null
        Start-Sleep -Seconds 2
        ipconfig /renew | Out-Null
        Write-Host "  ✓ Configurações de IP renovadas" -ForegroundColor Green
    }
    catch {
        Write-Host "  ✗ Erro ao renovar IP" -ForegroundColor Red
    }

    # [2/6] Flush DNS
    Write-Host ""
    Write-Host "[2/6] Limpando cache DNS..." -ForegroundColor Yellow
    try {
        ipconfig /flushdns | Out-Null
        Clear-DnsClientCache
        Write-Host "  ✓ Cache DNS limpo" -ForegroundColor Green
    }
    catch {
        Write-Host "  ✗ Erro ao limpar DNS" -ForegroundColor Red
    }

    # [3/6] Reset Winsock
    Write-Host ""
    Write-Host "[3/6] Resetando Winsock..." -ForegroundColor Yellow
    try {
        netsh winsock reset | Out-Null
        Write-Host "  ✓ Winsock resetado" -ForegroundColor Green
    }
    catch {
        Write-Host "  ✗ Erro ao resetar Winsock" -ForegroundColor Red
    }

    # [4/6] Reset TCP/IP
    Write-Host ""
    Write-Host "[4/6] Resetando pilha TCP/IP..." -ForegroundColor Yellow
    try {
        netsh int ip reset | Out-Null
        Write-Host "  ✓ TCP/IP resetado" -ForegroundColor Green
    }
    catch {
        Write-Host "  ✗ Erro ao resetar TCP/IP" -ForegroundColor Red
    }

    # [5/6] Otimizar configurações
    Write-Host ""
    Write-Host "[5/6] Aplicando otimizações de rede..." -ForegroundColor Yellow
    try {
        netsh interface tcp set global autotuninglevel=normal | Out-Null
        netsh interface tcp set global rss=enabled | Out-Null
        netsh interface tcp set global chimney=enabled | Out-Null
        netsh interface tcp set global dca=enabled | Out-Null
        netsh interface tcp set global netdma=enabled | Out-Null
        Write-Host "  ✓ Otimizações aplicadas" -ForegroundColor Green
    }
    catch {
        Write-Host "  ✗ Erro ao aplicar otimizações" -ForegroundColor Red
    }

    # [6/6] Reiniciar serviços
    Write-Host ""
    Write-Host "[6/6] Reiniciando serviços de rede..." -ForegroundColor Yellow
    try {
        Restart-Service -Name Dnscache -Force
        Write-Host "  ✓ Serviço DNS reiniciado" -ForegroundColor Green
    }
    catch {
        Write-Host "  ✗ Erro ao reiniciar serviços" -ForegroundColor Red
    }

    Write-Host ""
    Write-Host "════════════════════════════════════════════════════════════════════════════════" -ForegroundColor Green
    Write-Host "✅ Otimização de rede concluída!" -ForegroundColor Green
    Write-Host "⚠️  Recomenda-se reiniciar o computador para aplicar todas as alterações." -ForegroundColor Yellow
    Write-Host "════════════════════════════════════════════════════════════════════════════════" -ForegroundColor Green
    Write-Host ""

    Read-Host "Pressione ENTER para voltar ao menu"
}

# Função: Otimização de Disco
function Start-DiskOptimization {
    Show-Banner
    Write-Host "████████████████████████████████████████████████████████████████████████████████" -ForegroundColor Cyan
    Write-Host "██                    OTIMIZAÇÃO DE DISCO                                       ██" -ForegroundColor Cyan
    Write-Host "████████████████████████████████████████████████████████████████████████████████" -ForegroundColor Cyan
    Write-Host ""

    Write-Host "Analisando e otimizando discos..." -ForegroundColor Yellow
    Write-Host ""

    # Detecta todos os discos
    $drives = Get-Volume | Where-Object {$_.DriveLetter -and $_.DriveType -eq 'Fixed'}

    foreach ($drive in $drives) {
        $driveLetter = $drive.DriveLetter

        Write-Host "Processando disco $driveLetter..." -ForegroundColor Cyan

        # Verifica se é SSD ou HDD
        $disk = Get-PhysicalDisk | Where-Object {$_.DeviceID -eq (Get-Partition -DriveLetter $driveLetter).DiskNumber}
        $mediaType = $disk.MediaType

        if ($mediaType -eq "SSD") {
            Write-Host "  ℹ️  Disco $driveLetter é SSD - Executando TRIM..." -ForegroundColor Cyan
            try {
                Optimize-Volume -DriveLetter $driveLetter -ReTrim -Verbose
                Write-Host "  ✓ TRIM executado no disco $driveLetter" -ForegroundColor Green
            }
            catch {
                Write-Host "  ✗ Erro ao executar TRIM" -ForegroundColor Red
            }
        }
        else {
            Write-Host "  ℹ️  Disco $driveLetter é HDD - Analisando fragmentação..." -ForegroundColor Cyan
            try {
                $analysis = Optimize-Volume -DriveLetter $driveLetter -Analyze -Verbose
                Write-Host "  ✓ Análise concluída" -ForegroundColor Green

                Write-Host "  ℹ️  Iniciando desfragmentação..." -ForegroundColor Cyan
                Optimize-Volume -DriveLetter $driveLetter -Defrag -Verbose
                Write-Host "  ✓ Desfragmentação concluída no disco $driveLetter" -ForegroundColor Green
            }
            catch {
                Write-Host "  ✗ Erro na otimização do disco" -ForegroundColor Red
            }
        }
        Write-Host ""
    }

    Write-Host "════════════════════════════════════════════════════════════════════════════════" -ForegroundColor Green
    Write-Host "✅ Otimização de disco concluída!" -ForegroundColor Green
    Write-Host "════════════════════════════════════════════════════════════════════════════════" -ForegroundColor Green
    Write-Host ""

    Read-Host "Pressione ENTER para voltar ao menu"
}

# Função: Verificação de Integridade
function Start-IntegrityCheck {
    Show-Banner
    Write-Host "████████████████████████████████████████████████████████████████████████████████" -ForegroundColor Cyan
    Write-Host "██                  VERIFICAÇÃO DE INTEGRIDADE                                  ██" -ForegroundColor Cyan
    Write-Host "████████████████████████████████████████████████████████████████████████████████" -ForegroundColor Cyan
    Write-Host ""

    Write-Host "Verificando integridade do sistema..." -ForegroundColor Yellow
    Write-Host ""

    # [1/4] SFC
    Write-Host "[1/4] Verificando arquivos do sistema (SFC)..." -ForegroundColor Yellow
    Write-Host "      Esta operação pode demorar vários minutos..." -ForegroundColor Gray
    try {
        $sfcResult = sfc /scannow
        Write-Host "  ✓ Verificação SFC concluída" -ForegroundColor Green
    }
    catch {
        Write-Host "  ✗ Erro na verificação SFC" -ForegroundColor Red
    }

    # [2/4] DISM CheckHealth
    Write-Host ""
    Write-Host "[2/4] Verificando saúde da imagem do Windows..." -ForegroundColor Yellow
    try {
        DISM /Online /Cleanup-Image /CheckHealth | Out-Null
        Write-Host "  ✓ Verificação de saúde concluída" -ForegroundColor Green
    }
    catch {
        Write-Host "  ✗ Erro na verificação de saúde" -ForegroundColor Red
    }

    # [3/4] DISM RestoreHealth
    Write-Host ""
    Write-Host "[3/4] Reparando imagem do Windows (se necessário)..." -ForegroundColor Yellow
    Write-Host "      Esta operação pode demorar bastante tempo..." -ForegroundColor Gray
    try {
        DISM /Online /Cleanup-Image /RestoreHealth | Out-Null
        Write-Host "  ✓ Reparo da imagem concluído" -ForegroundColor Green
    }
    catch {
        Write-Host "  ✗ Erro no reparo da imagem" -ForegroundColor Red
    }

    # [4/4] ChkDsk
    Write-Host ""
    Write-Host "[4/4] Agendando verificação de disco para próxima reinicialização..." -ForegroundColor Yellow
    try {
        echo Y | chkdsk C: /F /R | Out-Null
        Write-Host "  ✓ Verificação de disco agendada" -ForegroundColor Green
        Write-Host "  ℹ️  A verificação será executada na próxima reinicialização" -ForegroundColor Cyan
    }
    catch {
        Write-Host "  ✗ Erro ao agendar verificação de disco" -ForegroundColor Red
    }

    Write-Host ""
    Write-Host "════════════════════════════════════════════════════════════════════════════════" -ForegroundColor Green
    Write-Host "✅ Verificação de integridade concluída!" -ForegroundColor Green
    Write-Host "════════════════════════════════════════════════════════════════════════════════" -ForegroundColor Green
    Write-Host ""

    Read-Host "Pressione ENTER para voltar ao menu"
}

# Função: Otimização Completa
function Start-CompleteOptimization {
    Show-Banner
    Write-Host "████████████████████████████████████████████████████████████████████████████████" -ForegroundColor Red
    Write-Host "██                    OTIMIZAÇÃO COMPLETA                                       ██" -ForegroundColor Red
    Write-Host "████████████████████████████████████████████████████████████████████████████████" -ForegroundColor Red
    Write-Host ""
    Write-Host "⚠️  Esta operação executará TODAS as otimizações disponíveis!" -ForegroundColor Yellow
    Write-Host "    Pode demorar de 15 a 30 minutos dependendo do sistema." -ForegroundColor Yellow
    Write-Host ""

    $confirm = Read-Host "Deseja continuar? (S/N)"
    if ($confirm -ne "S" -and $confirm -ne "s") {
        return
    }

    $Global:SpaceFreed = 0
    $totalSteps = 10
    $currentStep = 0

    Write-Host ""
    Write-Host "Executando otimização completa do sistema..." -ForegroundColor Cyan
    Write-Host ""

    # Passo 1
    $currentStep++
    Show-Progress -Activity "Limpando arquivos temporários" -PercentComplete (($currentStep / $totalSteps) * 100)
    Remove-ItemsWithStats -Path $env:TEMP -Description ""
    Remove-ItemsWithStats -Path "$env:SystemRoot\Temp" -Description ""
    Write-Host ""

    # Passo 2
    $currentStep++
    Show-Progress -Activity "Limpando cache de navegadores" -PercentComplete (($currentStep / $totalSteps) * 100)
    Stop-Process -Name chrome, firefox, msedge -Force -ErrorAction SilentlyContinue
    Remove-ItemsWithStats -Path "$env:LOCALAPPDATA\Google\Chrome\User Data\Default\Cache" -Description ""
    Write-Host ""

    # Passo 3
    $currentStep++
    Show-Progress -Activity "Otimizando rede" -PercentComplete (($currentStep / $totalSteps) * 100)
    ipconfig /flushdns | Out-Null
    netsh winsock reset | Out-Null
    Write-Host ""

    # Passo 4
    $currentStep++
    Show-Progress -Activity "Limpando logs do sistema" -PercentComplete (($currentStep / $totalSteps) * 100)
    $logs = Get-WinEvent -ListLog * -ErrorAction SilentlyContinue | Where-Object {$_.RecordCount -gt 0}
    foreach ($log in $logs) { wevtutil.exe cl $log.LogName 2>$null }
    Write-Host ""

    # Passo 5
    $currentStep++
    Show-Progress -Activity "Verificando sistema (SFC)" -PercentComplete (($currentStep / $totalSteps) * 100)
    sfc /scannow | Out-Null
    Write-Host ""

    # Passo 6
    $currentStep++
    Show-Progress -Activity "Otimizando registro" -PercentComplete (($currentStep / $totalSteps) * 100)
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" -Name "Max Cached Icons" -Value 2048 -Force -ErrorAction SilentlyContinue
    Write-Host ""

    # Passo 7
    $currentStep++
    Show-Progress -Activity "Limpando lixeira" -PercentComplete (($currentStep / $totalSteps) * 100)
    Clear-RecycleBin -Force -ErrorAction SilentlyContinue
    Write-Host ""

    # Passo 8
    $currentStep++
    Show-Progress -Activity "Otimizando memória" -PercentComplete (($currentStep / $totalSteps) * 100)
    [System.GC]::Collect()
    Write-Host ""

    # Passo 9
    $currentStep++
    Show-Progress -Activity "Otimizando discos" -PercentComplete (($currentStep / $totalSteps) * 100)
    $drives = Get-Volume | Where-Object {$_.DriveLetter -eq 'C'}
    Optimize-Volume -DriveLetter C -Analyze -ErrorAction SilentlyContinue
    Write-Host ""

    # Passo 10
    $currentStep++
    Show-Progress -Activity "Finalizando otimização" -PercentComplete 100
    Start-Process cleanmgr -ArgumentList "/sagerun:1" -Wait -WindowStyle Hidden -ErrorAction SilentlyContinue
    Write-Host ""

    Write-Host ""
    Write-Host "════════════════════════════════════════════════════════════════════════════════" -ForegroundColor Green
    Write-Host "✅ Otimização completa finalizada!" -ForegroundColor Green
    Write-Host "📊 Espaço total liberado: $([math]::Round($Global:SpaceFreed, 2)) MB" -ForegroundColor Cyan
    Write-Host "⏱️  Tempo decorrido: $((New-TimeSpan -Start $Global:StartTime -End (Get-Date)).ToString('mm\:ss'))" -ForegroundColor Cyan
    Write-Host "⚠️  Recomenda-se reiniciar o computador para melhor performance." -ForegroundColor Yellow
    Write-Host "════════════════════════════════════════════════════════════════════════════════" -ForegroundColor Green
    Write-Host ""

    Read-Host "Pressione ENTER para voltar ao menu"
}

# 🤖 NOVA FUNÇÃO: Modo Automático Inteligente
function Start-AutomaticMode {
    Show-Banner
    Write-Host "████████████████████████████████████████████████████████████████████████████████" -ForegroundColor Magenta
    Write-Host "██                    🤖 MODO AUTOMÁTICO INTELIGENTE                            ██" -ForegroundColor Magenta
    Write-Host "████████████████████████████████████████████████████████████████████████████████" -ForegroundColor Magenta
    Write-Host ""

    Write-Host "O Modo Automático Inteligente irá:" -ForegroundColor Yellow
    Write-Host "  • Analisar o estado do sistema" -ForegroundColor White
    Write-Host "  • Identificar problemas automaticamente" -ForegroundColor White
    Write-Host "  • Aplicar apenas as otimizações necessárias" -ForegroundColor White
    Write-Host "  • Gerar relatório detalhado" -ForegroundColor White
    Write-Host ""

    $confirm = Read-Host "Deseja continuar? (S/N)"
    if ($confirm -ne "S" -and $confirm -ne "s") {
        return
    }

    Write-Host ""
    Write-Host "Analisando sistema..." -ForegroundColor Cyan
    Write-Host ""

    # Análise do disco
    $disk = Get-CimInstance Win32_LogicalDisk -Filter "DeviceID='C:'"
    $freeSpacePercent = ($disk.FreeSpace / $disk.Size) * 100

    # Análise de memória
    $os = Get-CimInstance Win32_OperatingSystem
    $memoryUsedPercent = (($os.TotalVisibleMemorySize - $os.FreePhysicalMemory) / $os.TotalVisibleMemorySize) * 100

    # Análise de processos
    $processes = Get-Process
    $highMemoryProcesses = $processes | Where-Object {$_.WorkingSet -gt 500MB} | Measure-Object

    Write-Host "📊 ANÁLISE DO SISTEMA:" -ForegroundColor Cyan
    Write-Host "   Espaço livre em disco: $([math]::Round($freeSpacePercent, 1))%" -ForegroundColor White
    Write-Host "   Uso de memória RAM: $([math]::Round($memoryUsedPercent, 1))%" -ForegroundColor White
    Write-Host "   Processos com alto uso de memória: $($highMemoryProcesses.Count)" -ForegroundColor White
    Write-Host ""

    # Decisões inteligentes
    $actions = @()

    if ($freeSpacePercent -lt 20) {
        $actions += "Limpeza profunda de disco (espaço crítico)"
        Write-Host "  ⚠️  Espaço em disco crítico - Limpeza necessária!" -ForegroundColor Yellow
    }
    elseif ($freeSpacePercent -lt 30) {
        $actions += "Limpeza básica de disco"
        Write-Host "  ℹ️  Espaço em disco baixo - Limpeza recomendada" -ForegroundColor Cyan
    }

    if ($memoryUsedPercent -gt 80) {
        $actions += "Otimização de memória"
        Write-Host "  ⚠️  Uso de memória alto - Otimização necessária!" -ForegroundColor Yellow
    }

    # Verifica cache de navegador
    $chromeCache = Get-FolderSize -Path "$env:LOCALAPPDATA\Google\Chrome\User Data\Default\Cache"
    if ($chromeCache -gt 500) {
        $actions += "Limpeza de cache de navegadores"
        Write-Host "  ℹ️  Cache de navegador grande ($chromeCache MB) - Limpeza recomendada" -ForegroundColor Cyan
    }

    # Verifica TEMP
    $tempSize = Get-FolderSize -Path $env:TEMP
    if ($tempSize -gt 1000) {
        $actions += "Limpeza de arquivos temporários"
        Write-Host "  ℹ️  Muitos arquivos temporários ($tempSize MB) - Limpeza recomendada" -ForegroundColor Cyan
    }

    if ($actions.Count -eq 0) {
        Write-Host ""
        Write-Host "✅ Sistema em bom estado! Nenhuma ação crítica necessária." -ForegroundColor Green
        Write-Host ""
        Read-Host "Pressione ENTER para voltar ao menu"
        return
    }

    Write-Host ""
    Write-Host "🔧 AÇÕES RECOMENDADAS:" -ForegroundColor Cyan
    foreach ($action in $actions) {
        Write-Host "   • $action" -ForegroundColor White
    }
    Write-Host ""

    $execute = Read-Host "Executar otimizações recomendadas? (S/N)"
    if ($execute -ne "S" -and $execute -ne "s") {
        return
    }

    Write-Host ""
    Write-Host "Executando otimizações..." -ForegroundColor Cyan
    Write-Host ""

    $Global:SpaceFreed = 0

    # Executa ações necessárias
    if ($actions -contains "Limpeza profunda de disco (espaço crítico)" -or $actions -contains "Limpeza básica de disco") {
        Write-Host "Limpando disco..." -ForegroundColor Yellow
        Remove-ItemsWithStats -Path $env:TEMP -Description "Arquivos temporários"
        Remove-ItemsWithStats -Path "$env:SystemRoot\Temp" -Description "TEMP do Windows"
        Clear-RecycleBin -Force -ErrorAction SilentlyContinue
    }

    if ($actions -contains "Limpeza de cache de navegadores") {
        Write-Host "Limpando cache de navegadores..." -ForegroundColor Yellow
        Stop-Process -Name chrome, firefox, msedge -Force -ErrorAction SilentlyContinue
        Remove-ItemsWithStats -Path "$env:LOCALAPPDATA\Google\Chrome\User Data\Default\Cache" -Description "Cache do Chrome"
    }

    if ($actions -contains "Otimização de memória") {
        Write-Host "Otimizando memória..." -ForegroundColor Yellow
        [System.GC]::Collect()
        Write-Host "  ✓ Memória otimizada" -ForegroundColor Green
    }

    Write-Host ""
    Write-Host "════════════════════════════════════════════════════════════════════════════════" -ForegroundColor Green
    Write-Host "✅ Modo Automático concluído!" -ForegroundColor Green
    Write-Host "📊 Espaço liberado: $([math]::Round($Global:SpaceFreed, 2)) MB" -ForegroundColor Cyan
    Write-Host "🎯 Ações executadas: $($actions.Count)" -ForegroundColor Cyan
    Write-Host "════════════════════════════════════════════════════════════════════════════════" -ForegroundColor Green
    Write-Host ""

    Read-Host "Pressione ENTER para voltar ao menu"
}

# 📊 NOVA FUNÇÃO: Análise Detalhada
function Start-DetailedAnalysis {
    Show-Banner
    Write-Host "████████████████████████████████████████████████████████████████████████████████" -ForegroundColor Cyan
    Write-Host "██                    📊 ANÁLISE DE SISTEMA DETALHADA                           ██" -ForegroundColor Cyan
    Write-Host "████████████████████████████████████████████████████████████████████████████████" -ForegroundColor Cyan
    Write-Host ""

    Write-Host "Coletando informações do sistema..." -ForegroundColor Yellow
    Write-Host ""

    # Informações do SO
    $os = Get-CimInstance Win32_OperatingSystem
    $computer = Get-CimInstance Win32_ComputerSystem
    $cpu = Get-CimInstance Win32_Processor
    $gpu = Get-CimInstance Win32_VideoController

    Write-Host "═══════════════════════════════════════════════════════════════════════════════" -ForegroundColor Green
    Write-Host "💻 INFORMAÇÕES DO SISTEMA" -ForegroundColor Cyan
    Write-Host "═══════════════════════════════════════════════════════════════════════════════" -ForegroundColor Green
    Write-Host "   Sistema Operacional: $($os.Caption)" -ForegroundColor White
    Write-Host "   Versão: $($os.Version) - Build $($os.BuildNumber)" -ForegroundColor White
    Write-Host "   Arquitetura: $($os.OSArchitecture)" -ForegroundColor White
    Write-Host "   Fabricante: $($computer.Manufacturer)" -ForegroundColor White
    Write-Host "   Modelo: $($computer.Model)" -ForegroundColor White
    Write-Host ""

    # CPU
    Write-Host "═══════════════════════════════════════════════════════════════════════════════" -ForegroundColor Green
    Write-Host "⚙️  PROCESSADOR" -ForegroundColor Cyan
    Write-Host "═══════════════════════════════════════════════════════════════════════════════" -ForegroundColor Green
    Write-Host "   Nome: $($cpu.Name)" -ForegroundColor White
    Write-Host "   Núcleos: $($cpu.NumberOfCores)" -ForegroundColor White
    Write-Host "   Threads: $($cpu.NumberOfLogicalProcessors)" -ForegroundColor White
    Write-Host "   Velocidade: $($cpu.MaxClockSpeed) MHz" -ForegroundColor White
    Write-Host ""

    # Memória
    $totalRAM = [math]::Round($os.TotalVisibleMemorySize / 1MB, 2)
    $freeRAM = [math]::Round($os.FreePhysicalMemory / 1MB, 2)
    $usedRAM = $totalRAM - $freeRAM
    $ramPercent = [math]::Round(($usedRAM / $totalRAM) * 100, 1)

    Write-Host "═══════════════════════════════════════════════════════════════════════════════" -ForegroundColor Green
    Write-Host "💾 MEMÓRIA RAM" -ForegroundColor Cyan
    Write-Host "═══════════════════════════════════════════════════════════════════════════════" -ForegroundColor Green
    Write-Host "   Total: $totalRAM GB" -ForegroundColor White
    Write-Host "   Usada: $usedRAM GB ($ramPercent%)" -ForegroundColor White
    Write-Host "   Livre: $freeRAM GB" -ForegroundColor White

    if ($ramPercent -gt 80) {
        Write-Host "   Status: ⚠️  CRÍTICO - Uso muito alto!" -ForegroundColor Red
    }
    elseif ($ramPercent -gt 60) {
        Write-Host "   Status: ⚠️  ALTO - Considere fechar programas" -ForegroundColor Yellow
    }
    else {
        Write-Host "   Status: ✅ NORMAL" -ForegroundColor Green
    }
    Write-Host ""

    # Discos
    Write-Host "═══════════════════════════════════════════════════════════════════════════════" -ForegroundColor Green
    Write-Host "💿 DISCOS" -ForegroundColor Cyan
    Write-Host "═══════════════════════════════════════════════════════════════════════════════" -ForegroundColor Green

    $disks = Get-CimInstance Win32_LogicalDisk -Filter "DriveType=3"
    foreach ($disk in $disks) {
        $totalSize = [math]::Round($disk.Size / 1GB, 2)
        $freeSpace = [math]::Round($disk.FreeSpace / 1GB, 2)
        $usedSpace = $totalSize - $freeSpace
        $usedPercent = [math]::Round(($usedSpace / $totalSize) * 100, 1)

        Write-Host "   Disco $($disk.DeviceID)" -ForegroundColor White
        Write-Host "      Total: $totalSize GB" -ForegroundColor Gray
        Write-Host "      Usado: $usedSpace GB ($usedPercent%)" -ForegroundColor Gray
        Write-Host "      Livre: $freeSpace GB" -ForegroundColor Gray

        if ($usedPercent -gt 90) {
            Write-Host "      Status: ⚠️  CRÍTICO - Espaço quase esgotado!" -ForegroundColor Red
        }
        elseif ($usedPercent -gt 80) {
            Write-Host "      Status: ⚠️  ALERTA - Pouco espaço livre" -ForegroundColor Yellow
        }
        else {
            Write-Host "      Status: ✅ NORMAL" -ForegroundColor Green
        }
        Write-Host ""
    }

    # GPU
    Write-Host "═══════════════════════════════════════════════════════════════════════════════" -ForegroundColor Green
    Write-Host "🎮 PLACA DE VÍDEO" -ForegroundColor Cyan
    Write-Host "═══════════════════════════════════════════════════════════════════════════════" -ForegroundColor Green
    foreach ($card in $gpu) {
        Write-Host "   Nome: $($card.Name)" -ForegroundColor White
        Write-Host "   Memória: $([math]::Round($card.AdapterRAM / 1GB, 2)) GB" -ForegroundColor White
        Write-Host "   Driver: $($card.DriverVersion)" -ForegroundColor White
        Write-Host ""
    }

    # Processos com alto uso
    Write-Host "═══════════════════════════════════════════════════════════════════════════════" -ForegroundColor Green
    Write-Host "🔝 TOP 10 PROCESSOS (USO DE MEMÓRIA)" -ForegroundColor Cyan
    Write-Host "═══════════════════════════════════════════════════════════════════════════════" -ForegroundColor Green

    $topProcesses = Get-Process | Sort-Object WorkingSet -Descending | Select-Object -First 10
    foreach ($proc in $topProcesses) {
        $memMB = [math]::Round($proc.WorkingSet / 1MB, 2)
        Write-Host "   $($proc.Name.PadRight(30)) - $memMB MB" -ForegroundColor White
    }
    Write-Host ""

    # Tamanho de pastas importantes
    Write-Host "═══════════════════════════════════════════════════════════════════════════════" -ForegroundColor Green
    Write-Host "📁 TAMANHO DE PASTAS (Possível Limpeza)" -ForegroundColor Cyan
    Write-Host "═══════════════════════════════════════════════════════════════════════════════" -ForegroundColor Green

    $tempSize = Get-FolderSize -Path $env:TEMP
    $winTempSize = Get-FolderSize -Path "$env:SystemRoot\Temp"
    $chromeCache = Get-FolderSize -Path "$env:LOCALAPPDATA\Google\Chrome\User Data\Default\Cache"

    Write-Host "   TEMP do usuário: $tempSize MB" -ForegroundColor White
    Write-Host "   TEMP do Windows: $winTempSize MB" -ForegroundColor White
    Write-Host "   Cache do Chrome: $chromeCache MB" -ForegroundColor White

    $totalCleanable = $tempSize + $winTempSize + $chromeCache
    Write-Host ""
    Write-Host "   💡 Espaço potencial para limpeza: ~$totalCleanable MB" -ForegroundColor Yellow
    Write-Host ""

    Write-Host "════════════════════════════════════════════════════════════════════════════════" -ForegroundColor Green
    Write-Host "✅ Análise detalhada concluída!" -ForegroundColor Green
    Write-Host "════════════════════════════════════════════════════════════════════════════════" -ForegroundColor Green
    Write-Host ""

    Read-Host "Pressione ENTER para voltar ao menu"
}

# 🗑️ NOVA FUNÇÃO: Limpeza de Programas Desnecessários
function Start-ProgramCleanup {
    Show-Banner
    Write-Host "████████████████████████████████████████████████████████████████████████████████" -ForegroundColor Cyan
    Write-Host "██                    🗑️  LIMPEZA DE PROGRAMAS DESNECESSÁRIOS                   ██" -ForegroundColor Cyan
    Write-Host "████████████████████████████████████████████████████████████████████████████████" -ForegroundColor Cyan
    Write-Host ""

    Write-Host "Esta função irá:" -ForegroundColor Yellow
    Write-Host "  • Listar programas de inicialização automática" -ForegroundColor White
    Write-Host "  • Identificar programas que consomem recursos" -ForegroundColor White
    Write-Host "  • Permitir desabilitar programas desnecessários" -ForegroundColor White
    Write-Host ""

    Write-Host "Analisando programas de inicialização..." -ForegroundColor Cyan
    Write-Host ""

    # Lista programas de inicialização
    $startupApps = Get-CimInstance Win32_StartupCommand | Select-Object Name, Command, Location, User

    if ($startupApps.Count -eq 0) {
        Write-Host "✅ Nenhum programa de inicialização encontrado!" -ForegroundColor Green
        Write-Host ""
        Read-Host "Pressione ENTER para voltar ao menu"
        return
    }

    Write-Host "═══════════════════════════════════════════════════════════════════════════════" -ForegroundColor Green
    Write-Host "📋 PROGRAMAS DE INICIALIZAÇÃO AUTOMÁTICA ($($startupApps.Count) encontrados)" -ForegroundColor Cyan
    Write-Host "═══════════════════════════════════════════════════════════════════════════════" -ForegroundColor Green
    Write-Host ""

    $counter = 1
    foreach ($app in $startupApps) {
        Write-Host "[$counter] $($app.Name)" -ForegroundColor White
        Write-Host "    Local: $($app.Location)" -ForegroundColor Gray
        Write-Host ""
        $counter++
    }

    Write-Host "════════════════════════════════════════════════════════════════════════════════" -ForegroundColor Green
    Write-Host ""
    Write-Host "💡 RECOMENDAÇÃO:" -ForegroundColor Yellow
    Write-Host "   Para desabilitar programas de inicialização, use o Gerenciador de Tarefas:" -ForegroundColor White
    Write-Host "   1. Pressione Ctrl + Shift + Esc" -ForegroundColor White
    Write-Host "   2. Vá para a aba 'Inicializar'" -ForegroundColor White
    Write-Host "   3. Clique com botão direito e selecione 'Desabilitar'" -ForegroundColor White
    Write-Host ""

    $openTaskMgr = Read-Host "Deseja abrir o Gerenciador de Tarefas agora? (S/N)"
    if ($openTaskMgr -eq "S" -or $openTaskMgr -eq "s") {
        Start-Process taskmgr
    }

    Write-Host ""
    Read-Host "Pressione ENTER para voltar ao menu"
}

# Função Principal
function Main {
    # Verifica privilégios de administrador
    $currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
    $isAdmin = $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

    if (-not $isAdmin) {
        Write-Host "ERRO: Este script requer privilégios de Administrador!" -ForegroundColor Red
        Write-Host "Por favor, execute o PowerShell como Administrador e tente novamente." -ForegroundColor Yellow
        Read-Host "Pressione ENTER para sair"
        exit
    }

    do {
        Show-MainMenu
        $opcao = Read-Host "Digite sua escolha (0-9)"

        $Global:StartTime = Get-Date

        switch ($opcao) {
            "1" { Start-BasicCleanup }
            "2" { Start-AdvancedCleanup }
            "3" { Start-NetworkOptimization }
            "4" { Start-DiskOptimization }
            "5" { Start-IntegrityCheck }
            "6" { Start-CompleteOptimization }
            "7" { Start-AutomaticMode }
            "8" { Start-DetailedAnalysis }
            "9" { Start-ProgramCleanup }
            "0" { 
                Show-Banner
                Write-Host "████████████████████████████████████████████████████████████████████████████████" -ForegroundColor Green
                Write-Host "██                                                                              ██" -ForegroundColor Green
                Write-Host "██                     Obrigado por usar o RMS Optimizer ULTRA!                 ██" -ForegroundColor White
                Write-Host "██                          © 2025 RMSTECH                                      ██" -ForegroundColor Gray
                Write-Host "██                                                                              ██" -ForegroundColor Green
                Write-Host "████████████████████████████████████████████████████████████████████████████████" -ForegroundColor Green
                Write-Host ""
                Write-Host "Sistema otimizado com sucesso!" -ForegroundColor Cyan
                Write-Host ""
                Start-Sleep -Seconds 2
                break
            }
            default {
                Write-Host ""
                Write-Host "Opção inválida! Tente novamente." -ForegroundColor Red
                Start-Sleep -Seconds 2
            }
        }
    } while ($opcao -ne "0")
}

# Executa o script
Main

