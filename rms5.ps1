#Requires -RunAsAdministrator
<#
.SYNOPSIS
    Otimizador Gaming Extremo - RMSTECH

.DESCRIPTION
    Remove processos e serviços desnecessários do Windows para maximizar performance em jogos

.NOTES
    Autor: RoneyRMS
    Versão: 2.0 ULTRA
    Data: 19/12/2024
    Requer: Privilégios de Administrador

.COPYRIGHT
    © 2024 RMSTECH. Todos os direitos reservados.

    YouTube: https://www.youtube.com/@rms-tech/
    Instagram: https://www.instagram.com/rms.tech/

    PERMISSÕES:
    - Uso pessoal: PERMITIDO
    - Modificação para uso próprio: PERMITIDO
    - Redistribuição: PROIBIDA sem autorização
    - Uso comercial: PROIBIDO sem licenciamento
#>

$Host.UI.RawUI.WindowTitle = "Otimizador Gaming Extremo - RMSTECH"
$ErrorActionPreference = "SilentlyContinue"

$Global:ServicesDisabled = 0
$Global:ProcessesKilled = 0
$Global:TasksDisabled = 0

function Show-Banner {
    Clear-Host
    Write-Host ""
    Write-Host "████████████████████████████████████████████████████████████████████████████████" -ForegroundColor Green
    Write-Host "██                                                                              ██" -ForegroundColor Green
    Write-Host "██                    OTIMIZADOR GAMING EXTREMO                                 ██" -ForegroundColor White
    Write-Host "██                          Versão 2.0 - RMSTECH                                ██" -ForegroundColor White
    Write-Host "██                          © 2024 RoneyRMS                                     ██" -ForegroundColor Gray
    Write-Host "██                                                                              ██" -ForegroundColor Green
    Write-Host "████████████████████████████████████████████████████████████████████████████████" -ForegroundColor Green
    Write-Host ""
}

function Show-MainMenu {
    Show-Banner

    Write-Host "════════════════════════════════════════════════════════════════════════════════" -ForegroundColor Gray
    Write-Host "🎥 YouTube: https://www.youtube.com/@rms-tech/" -ForegroundColor Cyan
    Write-Host "📱 Instagram: https://www.instagram.com/rms.tech/" -ForegroundColor Cyan
    Write-Host "════════════════════════════════════════════════════════════════════════════════" -ForegroundColor Gray
    Write-Host ""

    Write-Host "MENU PRINCIPAL" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "[1] 🎮 Otimização Gaming Extrema" -ForegroundColor White
    Write-Host "[2] ⏮️  Reverter Otimizações" -ForegroundColor White
    Write-Host "[3] 📊 Análise de Processos Ativos (NOVO!)" -ForegroundColor Yellow
    Write-Host "[4] 🔍 Verificar Serviços Desabilitados (NOVO!)" -ForegroundColor Yellow
    Write-Host "[5] ⚡ Modo Gaming Rápido (NOVO!)" -ForegroundColor Yellow
    Write-Host "[6] 📋 Sobre o Autor" -ForegroundColor White
    Write-Host "[0] ❌ Sair" -ForegroundColor White
    Write-Host ""
    Write-Host "════════════════════════════════════════════════════════════════════════════════" -ForegroundColor Cyan
    Write-Host ""
}

function Stop-UnnecessaryServices {
    Write-Host ""
    Write-Host "════════════════════════════════════════════════════════════════════════════════" -ForegroundColor Cyan
    Write-Host "[1/6] PARANDO E DESABILITANDO SERVIÇOS DESNECESSÁRIOS" -ForegroundColor Cyan
    Write-Host "════════════════════════════════════════════════════════════════════════════════" -ForegroundColor Cyan
    Write-Host ""

    $services = @{
        "WSearch" = "Windows Search"
        "Spooler" = "Spooler de Impressão"
        "Fax" = "Fax"
        "TabletInputService" = "Serviço de Entrada de Tablet"
        "Themes" = "Temas"
        "SysMain" = "Superfetch/Prefetch"
        "PcaSvc" = "Assistente de Compatibilidade"
        "WerSvc" = "Relatório de Erros do Windows"
        "DiagTrack" = "Telemetria e Diagnóstico"
        "dmwappushservice" = "WAP Push Message Routing"
        "MapsBroker" = "Gerenciador de Mapas"
        "lfsvc" = "Serviço de Geolocalização"
        "SharedAccess" = "Compartilhamento de Conexão"
        "lmhosts" = "TCP/IP NetBIOS Helper"
        "TrkWks" = "Distributed Link Tracking Client"
        "WbioSrvc" = "Serviço de Biometria"
        "WMPNetworkSvc" = "Compartilhamento de Rede do Windows Media Player"
        "FontCache" = "Cache de Fontes do Windows"
        "iphlpsvc" = "IP Helper"
        "WpcMonSvc" = "Controle dos Pais"
        "WinHttpAutoProxySvc" = "WinHTTP Web Proxy Auto-Discovery"
        "BDESVC" = "BitLocker Drive Encryption"
        "EFS" = "Encrypting File System"
        "WinDefend" = "Windows Defender Antivirus"
        "wscsvc" = "Central de Segurança"
    }

    foreach ($service in $services.Keys) {
        Write-Host "   Processando: $($services[$service])..." -NoNewline

        try {
            $svc = Get-Service -Name $service -ErrorAction SilentlyContinue

            if ($svc) {
                Stop-Service -Name $service -Force -ErrorAction SilentlyContinue
                Set-Service -Name $service -StartupType Disabled -ErrorAction SilentlyContinue
                $Global:ServicesDisabled++
                Write-Host " ✓ Desabilitado" -ForegroundColor Green
            }
            else {
                Write-Host " ℹ️  Não encontrado" -ForegroundColor Gray
            }
        }
        catch {
            Write-Host " ✗ Erro" -ForegroundColor Red
        }
    }
}

function Stop-UnnecessaryProcesses {
    Write-Host ""
    Write-Host "════════════════════════════════════════════════════════════════════════════════" -ForegroundColor Cyan
    Write-Host "[2/6] FINALIZANDO PROCESSOS DESNECESSÁRIOS" -ForegroundColor Cyan
    Write-Host "════════════════════════════════════════════════════════════════════════════════" -ForegroundColor Cyan
    Write-Host ""

    $processes = @{
        "SearchUI" = "Pesquisa do Windows"
        "cortana" = "Cortana"
        "backgroundTaskHost" = "Host de Tarefas em Segundo Plano"
        "RuntimeBroker" = "Runtime Broker"
        "ApplicationFrameHost" = "Application Frame Host"
        "SkypeApp" = "Skype"
        "SkypeBackgroundHost" = "Skype Background Host"
        "YourPhone" = "Seu Telefone"
        "PhoneExperienceHost" = "Phone Experience Host"
        "Microsoft.Photos" = "Fotos da Microsoft"
        "WinStore.App" = "Microsoft Store"
        "HxTsr" = "Microsoft Help"
        "HxAccounts" = "Microsoft Help Accounts"
        "smartscreen" = "SmartScreen"
    }

    foreach ($process in $processes.Keys) {
        Write-Host "   Finalizando: $($processes[$process])..." -NoNewline

        try {
            $proc = Get-Process -Name $process -ErrorAction SilentlyContinue

            if ($proc) {
                Stop-Process -Name $process -Force -ErrorAction SilentlyContinue
                $Global:ProcessesKilled++
                Write-Host " ✓ Finalizado" -ForegroundColor Green
            }
            else {
                Write-Host " ℹ️  Não está em execução" -ForegroundColor Gray
            }
        }
        catch {
            Write-Host " ✗ Erro" -ForegroundColor Red
        }
    }
}

function Apply-RegistryTweaks {
    Write-Host ""
    Write-Host "════════════════════════════════════════════════════════════════════════════════" -ForegroundColor Cyan
    Write-Host "[3/6] APLICANDO OTIMIZAÇÕES NO REGISTRO" -ForegroundColor Cyan
    Write-Host "════════════════════════════════════════════════════════════════════════════════" -ForegroundColor Cyan
    Write-Host ""

    Write-Host "   Desabilitando Assistência Remota..." -NoNewline
    try {
        Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Remote Assistance" -Name "fAllowToGetHelp" -Value 0 -Type DWord -Force
        Write-Host " ✓" -ForegroundColor Green
    }
    catch {
        Write-Host " ✗" -ForegroundColor Red
    }

    Write-Host "   Desabilitando Área de Trabalho Remota..." -NoNewline
    try {
        Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server" -Name "fDenyTSConnections" -Value 1 -Type DWord -Force
        Write-Host " ✓" -ForegroundColor Green
    }
    catch {
        Write-Host " ✗" -ForegroundColor Red
    }

    Write-Host "   Desabilitando Apps em Segundo Plano..." -NoNewline
    try {
        New-Item -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" -Force | Out-Null
        Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" -Name "GlobalUserDisabled" -Value 1 -Type DWord -Force
        Write-Host " ✓" -ForegroundColor Green
    }
    catch {
        Write-Host " ✗" -ForegroundColor Red
    }

    Write-Host "   Desabilitando Cortana..." -NoNewline
    try {
        New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search" -Force | Out-Null
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search" -Name "AllowCortana" -Value 0 -Type DWord -Force
        Write-Host " ✓" -ForegroundColor Green
    }
    catch {
        Write-Host " ✗" -ForegroundColor Red
    }

    Write-Host "   Desabilitando Pesquisa Web..." -NoNewline
    try {
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search" -Name "DisableWebSearch" -Value 1 -Type DWord -Force
        Write-Host " ✓" -ForegroundColor Green
    }
    catch {
        Write-Host " ✗" -ForegroundColor Red
    }

    Write-Host "   Desabilitando Windows Search..." -NoNewline
    try {
        Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\WSearch" -Name "Start" -Value 4 -Type DWord -Force
        Write-Host " ✓" -ForegroundColor Green
    }
    catch {
        Write-Host " ✗" -ForegroundColor Red
    }
}

function Disable-ScheduledTasks {
    Write-Host ""
    Write-Host "════════════════════════════════════════════════════════════════════════════════" -ForegroundColor Cyan
    Write-Host "[4/6] DESABILITANDO TAREFAS AGENDADAS" -ForegroundColor Cyan
    Write-Host "════════════════════════════════════════════════════════════════════════════════" -ForegroundColor Cyan
    Write-Host ""

    $tasks = @(
        "\Microsoft\Windows\Application Experience\Microsoft Compatibility Appraiser",
        "\Microsoft\Windows\Application Experience\ProgramDataUpdater",
        "\Microsoft\Windows\Autochk\Proxy",
        "\Microsoft\Windows\Customer Experience Improvement Program\Consolidator",
        "\Microsoft\Windows\Customer Experience Improvement Program\UsbCeip",
        "\Microsoft\Windows\DiskDiagnostic\Microsoft-Windows-DiskDiagnosticDataCollector",
        "\Microsoft\Windows\Feedback\Siuf\DmClient",
        "\Microsoft\Windows\Feedback\Siuf\DmClientOnScenarioDownload",
        "\Microsoft\Windows\Windows Error Reporting\QueueReporting",
        "\Microsoft\Windows\WindowsUpdate\Automatic App Update",
        "\Microsoft\Windows\License Manager\TempSignedLicenseExchange",
        "\Microsoft\Windows\Clip\License Validation"
    )

    foreach ($task in $tasks) {
        $taskName = $task.Split('\')[-1]
        Write-Host "   Desabilitando: $taskName..." -NoNewline

        try {
            Disable-ScheduledTask -TaskName $task -ErrorAction SilentlyContinue | Out-Null
            $Global:TasksDisabled++
            Write-Host " ✓" -ForegroundColor Green
        }
        catch {
            Write-Host " ℹ️  Não encontrada" -ForegroundColor Gray
        }
    }
}

function Optimize-MemoryAndCPU {
    Write-Host ""
    Write-Host "════════════════════════════════════════════════════════════════════════════════" -ForegroundColor Cyan
    Write-Host "[5/6] OTIMIZANDO MEMÓRIA E CPU" -ForegroundColor Cyan
    Write-Host "════════════════════════════════════════════════════════════════════════════════" -ForegroundColor Cyan
    Write-Host ""

    Write-Host "   Limpando memória RAM..." -NoNewline
    try {
        [System.GC]::Collect()
        [System.GC]::WaitForPendingFinalizers()
        Write-Host " ✓" -ForegroundColor Green
    }
    catch {
        Write-Host " ✗" -ForegroundColor Red
    }

    Write-Host "   Definindo prioridade alta para processos de jogos..." -NoNewline
    try {
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" -Name "Priority" -Value 6 -Type DWord -Force -ErrorAction SilentlyContinue
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" -Name "GPU Priority" -Value 8 -Type DWord -Force -ErrorAction SilentlyContinue
        Write-Host " ✓" -ForegroundColor Green
    }
    catch {
        Write-Host " ✗" -ForegroundColor Red
    }
}

function Show-OptimizationSummary {
    Write-Host ""
    Write-Host "════════════════════════════════════════════════════════════════════════════════" -ForegroundColor Cyan
    Write-Host "[6/6] RESUMO DA OTIMIZAÇÃO" -ForegroundColor Cyan
    Write-Host "════════════════════════════════════════════════════════════════════════════════" -ForegroundColor Cyan
    Write-Host ""

    Write-Host "   📊 Serviços desabilitados: $Global:ServicesDisabled" -ForegroundColor White
    Write-Host "   🔄 Processos finalizados: $Global:ProcessesKilled" -ForegroundColor White
    Write-Host "   📅 Tarefas agendadas desabilitadas: $Global:TasksDisabled" -ForegroundColor White
    Write-Host ""
}

function Start-GamingOptimization {
    Show-Banner
    Write-Host "████████████████████████████████████████████████████████████████████████████████" -ForegroundColor Green
    Write-Host "██                    🎮 OTIMIZAÇÃO GAMING EXTREMA                              ██" -ForegroundColor Green
    Write-Host "████████████████████████████████████████████████████████████████████████████████" -ForegroundColor Green
    Write-Host ""

    Write-Host "⚠️  ATENÇÃO: Esta otimização desabilitará diversos serviços do Windows!" -ForegroundColor Yellow
    Write-Host "    Recomenda-se criar um Ponto de Restauração antes de continuar." -ForegroundColor Yellow
    Write-Host ""

    $confirm = Read-Host "Deseja continuar? (S/N)"
    if ($confirm -ne "S" -and $confirm -ne "s") {
        return
    }

    $Global:ServicesDisabled = 0
    $Global:ProcessesKilled = 0
    $Global:TasksDisabled = 0

    Write-Host ""
    Write-Host "Iniciando otimização do sistema para gaming..." -ForegroundColor Cyan

    Stop-UnnecessaryServices
    Stop-UnnecessaryProcesses
    Apply-RegistryTweaks
    Disable-ScheduledTasks
    Optimize-MemoryAndCPU
    Show-OptimizationSummary

    Write-Host ""
    Write-Host "════════════════════════════════════════════════════════════════════════════════" -ForegroundColor Green
    Write-Host "✅ OTIMIZAÇÃO CONCLUÍDA COM SUCESSO!" -ForegroundColor Green
    Write-Host "════════════════════════════════════════════════════════════════════════════════" -ForegroundColor Green
    Write-Host ""
    Write-Host "⚠️  Reinicie o computador para aplicar todas as mudanças." -ForegroundColor Yellow
    Write-Host ""
    Write-Host "🎥 Gostou? Inscreva-se: https://www.youtube.com/@rms-tech/" -ForegroundColor Cyan
    Write-Host ""

    Read-Host "Pressione ENTER para voltar ao menu"
}

function Restore-Services {
    Show-Banner
    Write-Host "████████████████████████████████████████████████████████████████████████████████" -ForegroundColor Cyan
    Write-Host "██                    ⏮️  REVERTENDO OTIMIZAÇÕES                                 ██" -ForegroundColor Cyan
    Write-Host "████████████████████████████████████████████████████████████████████████████████" -ForegroundColor Cyan
    Write-Host ""

    Write-Host "Revertendo serviços para configuração automática..." -ForegroundColor Yellow
    Write-Host ""

    $services = @(
        "WSearch", "Spooler", "Fax", "TabletInputService", "Themes", "SysMain",
        "PcaSvc", "WerSvc", "DiagTrack", "dmwappushservice", "MapsBroker", "lfsvc",
        "SharedAccess", "lmhosts", "TrkWks", "WbioSrvc", "WMPNetworkSvc", "FontCache",
        "iphlpsvc", "WpcMonSvc", "WinHttpAutoProxySvc", "BDESVC", "EFS"
    )

    $count = 0
    foreach ($service in $services) {
        Write-Host "   Revertendo: $service..." -NoNewline

        try {
            $svc = Get-Service -Name $service -ErrorAction SilentlyContinue

            if ($svc) {
                Set-Service -Name $service -StartupType Manual -ErrorAction SilentlyContinue
                $count++
                Write-Host " ✓" -ForegroundColor Green
            }
            else {
                Write-Host " ℹ️  Não encontrado" -ForegroundColor Gray
            }
        }
        catch {
            Write-Host " ✗" -ForegroundColor Red
        }
    }

    Write-Host ""
    Write-Host "Revertendo configurações do registro..." -ForegroundColor Yellow
    Write-Host ""

    try {
        Remove-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search" -Name "AllowCortana" -Force -ErrorAction SilentlyContinue
        Remove-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search" -Name "DisableWebSearch" -Force -ErrorAction SilentlyContinue
        Write-Host "   ✓ Configurações do registro revertidas" -ForegroundColor Green
    }
    catch {
        Write-Host "   ✗ Erro ao reverter registro" -ForegroundColor Red
    }

    Write-Host ""
    Write-Host "════════════════════════════════════════════════════════════════════════════════" -ForegroundColor Green
    Write-Host "✅ Otimizações revertidas!" -ForegroundColor Green
    Write-Host "════════════════════════════════════════════════════════════════════════════════" -ForegroundColor Green
    Write-Host ""
    Write-Host "   📊 Serviços revertidos: $count" -ForegroundColor White
    Write-Host ""
    Write-Host "⚠️  Reinicie o computador para aplicar as alterações." -ForegroundColor Yellow
    Write-Host ""

    Read-Host "Pressione ENTER para voltar ao menu"
}

function Show-ProcessAnalysis {
    Show-Banner
    Write-Host "████████████████████████████████████████████████████████████████████████████████" -ForegroundColor Cyan
    Write-Host "██                    📊 ANÁLISE DE PROCESSOS ATIVOS                            ██" -ForegroundColor Cyan
    Write-Host "████████████████████████████████████████████████████████████████████████████████" -ForegroundColor Cyan
    Write-Host ""

    Write-Host "Analisando processos em execução..." -ForegroundColor Yellow
    Write-Host ""

    Write-Host "═══════════════════════════════════════════════════════════════════════════════" -ForegroundColor Green
    Write-Host "🔝 TOP 15 PROCESSOS (USO DE MEMÓRIA)" -ForegroundColor Cyan
    Write-Host "═══════════════════════════════════════════════════════════════════════════════" -ForegroundColor Green
    Write-Host ""

    $processes = Get-Process | Sort-Object WorkingSet -Descending | Select-Object -First 15

    foreach ($proc in $processes) {
        $memMB = [math]::Round($proc.WorkingSet / 1MB, 2)
        $cpuPercent = [math]::Round($proc.CPU, 2)

        Write-Host "   $($proc.Name.PadRight(30))" -NoNewline -ForegroundColor White
        Write-Host " RAM: $($memMB.ToString().PadLeft(8)) MB" -NoNewline -ForegroundColor Gray
        Write-Host " CPU: $cpuPercent s" -ForegroundColor Gray
    }

    Write-Host ""
    Write-Host "═══════════════════════════════════════════════════════════════════════════════" -ForegroundColor Green
    Write-Host "📈 ESTATÍSTICAS GERAIS" -ForegroundColor Cyan
    Write-Host "═══════════════════════════════════════════════════════════════════════════════" -ForegroundColor Green
    Write-Host ""

    $totalProcesses = (Get-Process).Count
    $totalMemory = [math]::Round((Get-Process | Measure-Object WorkingSet -Sum).Sum / 1GB, 2)

    Write-Host "   Total de processos em execução: $totalProcesses" -ForegroundColor White
    Write-Host "   Memória total em uso: $totalMemory GB" -ForegroundColor White
    Write-Host ""

    Read-Host "Pressione ENTER para voltar ao menu"
}

function Show-DisabledServices {
    Show-Banner
    Write-Host "████████████████████████████████████████████████████████████████████████████████" -ForegroundColor Cyan
    Write-Host "██                    🔍 SERVIÇOS DESABILITADOS                                 ██" -ForegroundColor Cyan
    Write-Host "████████████████████████████████████████████████████████████████████████████████" -ForegroundColor Cyan
    Write-Host ""

    Write-Host "Verificando serviços desabilitados..." -ForegroundColor Yellow
    Write-Host ""

    $disabledServices = Get-Service | Where-Object {$_.StartType -eq "Disabled"} | Sort-Object DisplayName

    Write-Host "═══════════════════════════════════════════════════════════════════════════════" -ForegroundColor Green
    Write-Host "📋 SERVIÇOS DESABILITADOS ($($disabledServices.Count) encontrados)" -ForegroundColor Cyan
    Write-Host "═══════════════════════════════════════════════════════════════════════════════" -ForegroundColor Green
    Write-Host ""

    foreach ($service in $disabledServices) {
        $status = if ($service.Status -eq "Stopped") { "⏹️  Parado" } else { "▶️  Em execução" }
        Write-Host "   $($service.DisplayName.PadRight(50)) - $status" -ForegroundColor White
    }

    Write-Host ""
    Read-Host "Pressione ENTER para voltar ao menu"
}

function Start-QuickGamingMode {
    Show-Banner
    Write-Host "████████████████████████████████████████████████████████████████████████████████" -ForegroundColor Cyan
    Write-Host "██                    ⚡ MODO GAMING RÁPIDO                                      ██" -ForegroundColor Cyan
    Write-Host "████████████████████████████████████████████████████████████████████████████████" -ForegroundColor Cyan
    Write-Host ""

    Write-Host "Este modo finaliza apenas processos desnecessários sem alterar serviços." -ForegroundColor Yellow
    Write-Host ""

    $confirm = Read-Host "Ativar Modo Gaming Rápido? (S/N)"
    if ($confirm -ne "S" -and $confirm -ne "s") {
        return
    }

    Write-Host ""
    Write-Host "Finalizando processos desnecessários..." -ForegroundColor Cyan
    Write-Host ""

    $processes = @(
        "SearchUI", "cortana", "backgroundTaskHost", "RuntimeBroker",
        "ApplicationFrameHost", "SkypeApp", "YourPhone", "PhoneExperienceHost",
        "Microsoft.Photos", "WinStore.App", "smartscreen"
    )

    $killed = 0
    foreach ($process in $processes) {
        Write-Host "   Finalizando: $process..." -NoNewline

        try {
            $proc = Get-Process -Name $process -ErrorAction SilentlyContinue

            if ($proc) {
                Stop-Process -Name $process -Force -ErrorAction SilentlyContinue
                $killed++
                Write-Host " ✓" -ForegroundColor Green
            }
            else {
                Write-Host " ℹ️  Não está em execução" -ForegroundColor Gray
            }
        }
        catch {
            Write-Host " ✗" -ForegroundColor Red
        }
    }

    Write-Host ""
    Write-Host "Limpando memória RAM..." -NoNewline
    [System.GC]::Collect()
    [System.GC]::WaitForPendingFinalizers()
    Write-Host " ✓" -ForegroundColor Green

    Write-Host ""
    Write-Host "════════════════════════════════════════════════════════════════════════════════" -ForegroundColor Green
    Write-Host "✅ Modo Gaming Rápido ativado!" -ForegroundColor Green
    Write-Host "════════════════════════════════════════════════════════════════════════════════" -ForegroundColor Green
    Write-Host ""
    Write-Host "   📊 Processos finalizados: $killed" -ForegroundColor White
    Write-Host ""

    Read-Host "Pressione ENTER para voltar ao menu"
}

function Show-AboutAuthor {
    Show-Banner
    Write-Host "████████████████████████████████████████████████████████████████████████████████" -ForegroundColor Cyan
    Write-Host "██                            SOBRE O AUTOR                                     ██" -ForegroundColor Cyan
    Write-Host "████████████████████████████████████████████████████████████████████████████████" -ForegroundColor Cyan
    Write-Host ""

    Write-Host "Script: Otimizador Gaming Extremo" -ForegroundColor White
    Write-Host "Autor: RoneyRMS" -ForegroundColor White
    Write-Host "Versão: 2.0 ULTRA" -ForegroundColor White
    Write-Host "Data: 19/12/2024" -ForegroundColor White
    Write-Host ""

    Write-Host "════════════════════════════════════════════════════════════════════════════════" -ForegroundColor Gray
    Write-Host "REDES SOCIAIS:" -ForegroundColor Cyan
    Write-Host "════════════════════════════════════════════════════════════════════════════════" -ForegroundColor Gray
    Write-Host ""
    Write-Host "🎥 YouTube: https://www.youtube.com/@rms-tech/" -ForegroundColor White
    Write-Host "📱 Instagram: https://www.instagram.com/rms.tech/" -ForegroundColor White
    Write-Host ""

    Write-Host "════════════════════════════════════════════════════════════════════════════════" -ForegroundColor Gray
    Write-Host "DIREITOS AUTORAIS:" -ForegroundColor Cyan
    Write-Host "════════════════════════════════════════════════════════════════════════════════" -ForegroundColor Gray
    Write-Host ""
    Write-Host "© 2024 RMSTECH. Todos os direitos reservados." -ForegroundColor White
    Write-Host ""
    Write-Host "PERMISSÕES:" -ForegroundColor Yellow
    Write-Host "  • Uso pessoal: PERMITIDO" -ForegroundColor Green
    Write-Host "  • Modificação: PERMITIDO" -ForegroundColor Green
    Write-Host "  • Redistribuição: PROIBIDA" -ForegroundColor Red
    Write-Host "  • Uso comercial: PROIBIDO" -ForegroundColor Red
    Write-Host ""

    Read-Host "Pressione ENTER para voltar"
}

function Main {
    $currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
    $isAdmin = $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

    if (-not $isAdmin) {
        Write-Host "ERRO: Execute como Administrador!" -ForegroundColor Red
        Read-Host "Pressione ENTER para sair"
        exit
    }

    do {
        Show-MainMenu
        $opcao = Read-Host "Digite sua escolha (0-6)"

        switch ($opcao) {
            "1" { Start-GamingOptimization }
            "2" { Restore-Services }
            "3" { Show-ProcessAnalysis }
            "4" { Show-DisabledServices }
            "5" { Start-QuickGamingMode }
            "6" { Show-AboutAuthor }
            "0" { 
                Show-Banner
                Write-Host "════════════════════════════════════════════════════════════════════════════════" -ForegroundColor Green
                Write-Host "Obrigado por usar o Otimizador Gaming Extremo!" -ForegroundColor White
                Write-Host ""
                Write-Host "🎥 YouTube: https://www.youtube.com/@rms-tech/" -ForegroundColor Cyan
                Write-Host "📱 Instagram: https://www.instagram.com/rms.tech/" -ForegroundColor Cyan
                Write-Host ""
                Write-Host "© 2024 RMSTECH - Todos os direitos reservados" -ForegroundColor Gray
                Write-Host "════════════════════════════════════════════════════════════════════════════════" -ForegroundColor Green
                Write-Host ""
                Start-Sleep -Seconds 2
                break
            }
            default {
                Write-Host "Opção inválida!" -ForegroundColor Red
                Start-Sleep -Seconds 2
            }
        }
    } while ($opcao -ne "0")
}

Main
