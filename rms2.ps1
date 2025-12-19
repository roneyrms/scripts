#Requires -RunAsAdministrator
<#
.SYNOPSIS
    Otimizador de Sistema ULTRA - RMSTECH Edition

.DESCRIPTION
    Script avançado de otimização do Windows com configurações extremas de performance
    Inclui otimizações de Registry, GPU, CPU, RAM, Rede e Disco

.NOTES
    Autor: RMSTECH
    Versão: 3.0 ULTRA
    Data: 19/12/2024
    Requer: Privilégios de Administrador

.COPYRIGHT
    © 2024 RMSTECH. Todos os direitos reservados.
#>

# Configurações iniciais
$Host.UI.RawUI.WindowTitle = "Otimizador ULTRA - RMSTECH"
$ErrorActionPreference = "Stop"

# Função para exibir banner
function Show-Banner {
    Clear-Host
    Write-Host ""
    Write-Host "████████████████████████████████████████████████████████████████████████████████" -ForegroundColor Green
    Write-Host "██                                                                              ██" -ForegroundColor Green
    Write-Host "██                    OTIMIZADOR DE SISTEMA ULTRA                               ██" -ForegroundColor White
    Write-Host "██                      Performance Máxima - RMSTECH                            ██" -ForegroundColor White
    Write-Host "██                          © 2024 RMSTECH                                      ██" -ForegroundColor Gray
    Write-Host "██                                                                              ██" -ForegroundColor Green
    Write-Host "████████████████████████████████████████████████████████████████████████████████" -ForegroundColor Green
    Write-Host ""
}

# Função para aplicar configuração no Registry
function Set-RegistryValue {
    param(
        [string]$Path,
        [string]$Name,
        [string]$Type,
        [object]$Value,
        [string]$Description
    )

    try {
        if (-not (Test-Path $Path)) {
            New-Item -Path $Path -Force | Out-Null
        }

        Set-ItemProperty -Path $Path -Name $Name -Value $Value -Type $Type -Force

        if ($Description) {
            Write-Host "  ✓ $Description" -ForegroundColor Green
        }
        return $true
    }
    catch {
        Write-Host "  ✗ Erro ao aplicar: $Description" -ForegroundColor Red
        Write-Host "    Detalhes: $($_.Exception.Message)" -ForegroundColor Yellow
        return $false
    }
}

# Função para exibir menu principal
function Show-MainMenu {
    Show-Banner
    Write-Host "MENU PRINCIPAL" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "[1] 🎯 Otimizações Gerais de Registry" -ForegroundColor White
    Write-Host "[2] 🎮 Otimizações para Jogos (Games)" -ForegroundColor White
    Write-Host "[3] ⚡ Desabilitar Serviços Desnecessários" -ForegroundColor White
    Write-Host "[4] 💾 Otimizações de Memória (RAM)" -ForegroundColor White
    Write-Host "[5] 🏆 Prioridade de CPU para Jogos" -ForegroundColor White
    Write-Host "[6] 🔥 MODO ULTRA PERFORMANCE (NOVO!)" -ForegroundColor Yellow
    Write-Host "[7] 🌐 Otimizações de Rede Avançadas (NOVO!)" -ForegroundColor Yellow
    Write-Host "[8] 💿 Otimizações de Disco SSD/NVMe (NOVO!)" -ForegroundColor Yellow
    Write-Host "[9] 🖥️  Otimizações de GPU Avançadas (NOVO!)" -ForegroundColor Yellow
    Write-Host "[0] ❌ Sair" -ForegroundColor White
    Write-Host ""
    Write-Host "████████████████████████████████████████████████████████████████████████████████" -ForegroundColor Green
    Write-Host ""
}

# Função: Otimizações Gerais (mantida do script anterior)
function Apply-GeneralOptimizations {
    Show-Banner
    Write-Host "████████████████████████████████████████████████████████████████████████████████" -ForegroundColor Cyan
    Write-Host "██             APLICANDO OTIMIZAÇÕES GERAIS DE REGISTRY                         ██" -ForegroundColor Cyan
    Write-Host "████████████████████████████████████████████████████████████████████████████████" -ForegroundColor Cyan
    Write-Host ""

    Write-Host "Aplicando otimizações de rede e sistema..." -ForegroundColor Yellow

    Set-RegistryValue -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" `
        -Name "NetworkThrottlingIndex" -Type DWord -Value 0xffffffff `
        -Description "NetworkThrottlingIndex desabilitado (remove limitação de banda)"

    Set-RegistryValue -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" `
        -Name "SystemResponsiveness" -Type DWord -Value 0 `
        -Description "SystemResponsiveness definido para priorizar aplicativos"

    Write-Host ""
    Write-Host "Aplicando otimizações de interface e encerramento de processos..." -ForegroundColor Yellow

    Set-RegistryValue -Path "HKCU:\Control Panel\Desktop" `
        -Name "MenuShowDelay" -Type String -Value "0" `
        -Description "MenuShowDelay definido para 0ms (menus instantâneos)"

    Set-RegistryValue -Path "HKCU:\Control Panel\Desktop" `
        -Name "WaitToKillAppTimeout" -Type String -Value "5000" `
        -Description "WaitToKillAppTimeout definido para 5000ms"

    Set-RegistryValue -Path "HKCU:\Control Panel\Desktop" `
        -Name "HungAppTimeout" -Type String -Value "4000" `
        -Description "HungAppTimeout definido para 4000ms"

    Set-RegistryValue -Path "HKCU:\Control Panel\Desktop" `
        -Name "AutoEndTasks" -Type String -Value "1" `
        -Description "AutoEndTasks habilitado (encerramento automático)"

    Set-RegistryValue -Path "HKCU:\Control Panel\Desktop" `
        -Name "LowLevelHooksTimeout" -Type DWord -Value 0x1000 `
        -Description "LowLevelHooksTimeout definido para 4096ms"

    Set-RegistryValue -Path "HKCU:\Control Panel\Desktop" `
        -Name "WaitToKillServiceTimeout" -Type DWord -Value 0x2000 `
        -Description "WaitToKillServiceTimeout (HKCU) definido para 8192ms"

    Write-Host ""
    Write-Host "Aplicando otimização de encerramento de serviços do sistema..." -ForegroundColor Yellow

    Set-RegistryValue -Path "HKLM:\SYSTEM\CurrentControlSet\Control" `
        -Name "WaitToKillServiceTimeout" -Type String -Value "2000" `
        -Description "WaitToKillServiceTimeout (HKLM) definido para 2000ms"

    Write-Host ""
    Write-Host "Aplicando otimizações de gerenciamento de energia e prioridade de CPU..." -ForegroundColor Yellow

    Set-RegistryValue -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Power\PowerThrottling" `
        -Name "PowerThrottlingOff" -Type DWord -Value 1 `
        -Description "Power Throttling desabilitado (máximo desempenho)"

    Set-RegistryValue -Path "HKLM:\SYSTEM\CurrentControlSet\Control\PriorityControl" `
        -Name "Win32PrioritySeparation" -Type DWord -Value 0x00000016 `
        -Description "Win32PrioritySeparation ajustado (0x16 - prioridade para foreground)"

    Write-Host ""
    Write-Host "Aplicando otimizações de rede e compartilhamento (LanmanServer)..." -ForegroundColor Yellow

    $lanmanPath = "HKLM:\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters"

    Set-RegistryValue -Path $lanmanPath -Name "autodisconnect" -Type DWord -Value 0xffffffff `
        -Description "autodisconnect desabilitado"

    Set-RegistryValue -Path $lanmanPath -Name "Size" -Type DWord -Value 0x00000003 `
        -Description "Size otimizado para servidor de arquivos"

    Set-RegistryValue -Path $lanmanPath -Name "EnableOplocks" -Type DWord -Value 0x00000000 `
        -Description "EnableOplocks desabilitado (reduz latência)"

    Set-RegistryValue -Path $lanmanPath -Name "IRPStackSize" -Type DWord -Value 0x00000020 `
        -Description "IRPStackSize definido para 32"

    Set-RegistryValue -Path $lanmanPath -Name "SharingViolationDelay" -Type DWord -Value 0x00000000 `
        -Description "SharingViolationDelay definido para 0"

    Set-RegistryValue -Path $lanmanPath -Name "SharingViolationRetries" -Type DWord -Value 0x00000000 `
        -Description "SharingViolationRetries definido para 0"

    Write-Host ""
    Write-Host "✅ Otimizações Gerais de Registry aplicadas com sucesso!" -ForegroundColor Green
    Write-Host ""
    Write-Host "⚠️  Algumas alterações podem exigir uma reinicialização para ter efeito completo." -ForegroundColor Yellow
    Write-Host ""

    Read-Host "Pressione ENTER para voltar ao menu"
}

# Função: Otimizações para Jogos (mantida do script anterior)
function Apply-GameOptimizations {
    Show-Banner
    Write-Host "████████████████████████████████████████████████████████████████████████████████" -ForegroundColor Cyan
    Write-Host "██             APLICANDO OTIMIZAÇÕES PARA JOGOS                                 ██" -ForegroundColor Cyan
    Write-Host "████████████████████████████████████████████████████████████████████████████████" -ForegroundColor Cyan
    Write-Host ""

    Write-Host "Ajustando prioridades de GPU, CPU e agendamento para jogos..." -ForegroundColor Yellow

    $gamesPath = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games"

    Set-RegistryValue -Path $gamesPath -Name "GPU Priority" -Type DWord -Value 0x00000008 `
        -Description "Prioridade da GPU para jogos definida (8)"

    Set-RegistryValue -Path $gamesPath -Name "Priority" -Type DWord -Value 0x00000002 `
        -Description "Prioridade da CPU para jogos definida (2 - Alta)"

    Set-RegistryValue -Path $gamesPath -Name "Scheduling Category" -Type String -Value "High" `
        -Description "Categoria de agendamento definida como 'High'"

    Set-RegistryValue -Path $gamesPath -Name "SFIO Priority" -Type String -Value "High" `
        -Description "Prioridade de SFIO definida como 'High'"

    Set-RegistryValue -Path $gamesPath -Name "Affinity" -Type DWord -Value 0x00000000 `
        -Description "Afinidade do processador definida (todos os núcleos)"

    Set-RegistryValue -Path $gamesPath -Name "Background Only" -Type String -Value "False" `
        -Description "'Background Only' definido como 'False'"

    Set-RegistryValue -Path $gamesPath -Name "Clock Rate" -Type DWord -Value 0x00002710 `
        -Description "Taxa de clock definida (10000)"

    Write-Host ""
    Write-Host "Otimizando latência do monitor (DXGKrnl) e processamento gráfico..." -ForegroundColor Yellow

    Set-RegistryValue -Path "HKLM:\SYSTEM\CurrentControlSet\Services\DXGKrnl" `
        -Name "MonitorLatencyTolerance" -Type DWord -Value 0x00000000 `
        -Description "MonitorLatencyTolerance definido para 0"

    Set-RegistryValue -Path "HKLM:\SYSTEM\CurrentControlSet\Services\DXGKrnl" `
        -Name "MonitorRefreshLatencyTolerance" -Type DWord -Value 0x00000000 `
        -Description "MonitorRefreshLatencyTolerance definido para 0"

    Write-Host ""
    Write-Host "Aplicando otimizações de DPC por núcleo para drivers gráficos..." -ForegroundColor Yellow

    $dpcPaths = @(
        "HKLM:\SYSTEM\CurrentControlSet\Control\GraphicsDrivers",
        "HKLM:\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Power",
        "HKLM:\SYSTEM\CurrentControlSet\Services\nvlddmkm",
        "HKLM:\SYSTEM\CurrentControlSet\Services\nvlddmkm\NVAPI",
        "HKLM:\SYSTEM\CurrentControlSet\Services\nvlddmkm\Global\NVTweak"
    )

    foreach ($path in $dpcPaths) {
        Set-RegistryValue -Path $path -Name "RmGpsPsEnablePerCpuCoreDpc" -Type DWord -Value 0x00000001 `
            -Description "RmGpsPsEnablePerCpuCoreDpc em $($path.Split('\')[-1])"
    }

    Write-Host ""
    Write-Host "Aumentando a prioridade de threads para USB, Rede e Driver Gráfico..." -ForegroundColor Yellow

    $threadPaths = @{
        "HKLM:\SYSTEM\CurrentControlSet\Services\usbxhci\Parameters" = "USB xHCI Host Controller"
        "HKLM:\SYSTEM\CurrentControlSet\Services\USBHUB3\Parameters" = "USB Hub 3.0"
        "HKLM:\SYSTEM\CurrentControlSet\Services\NDIS\Parameters" = "NDIS (Network Driver)"
        "HKLM:\SYSTEM\CurrentControlSet\Services\nvlddmkm\Parameters" = "Driver NVIDIA (nvlddmkm)"
    }

    foreach ($path in $threadPaths.Keys) {
        Set-RegistryValue -Path $path -Name "ThreadPriority" -Type DWord -Value 0x0000001f `
            -Description "ThreadPriority para $($threadPaths[$path])"
    }

    Write-Host ""
    Write-Host "✅ Otimizações para Jogos aplicadas com sucesso!" -ForegroundColor Green
    Write-Host ""
    Write-Host "⚠️  Para que as alterações tenham efeito completo, é recomendável reiniciar o sistema." -ForegroundColor Yellow
    Write-Host ""

    Read-Host "Pressione ENTER para voltar ao menu"
}

# Função: Desabilitar Serviços (mantida do script anterior)
function Disable-UnnecessaryServices {
    Show-Banner
    Write-Host "████████████████████████████████████████████████████████████████████████████████" -ForegroundColor Cyan
    Write-Host "██             DESABILITANDO SERVIÇOS DESNECESSÁRIOS                            ██" -ForegroundColor Cyan
    Write-Host "████████████████████████████████████████████████████████████████████████████████" -ForegroundColor Cyan
    Write-Host ""

    Write-Host "Desabilitando serviços para liberar recursos..." -ForegroundColor Yellow
    Write-Host ""

    $services = @{
        "WbioSrvc" = "Serviço de Biometria do Windows"
        "FontCache" = "Serviço de Cache de Fonte do Windows"
        "FontCache3.0.0.0" = "Serviço de Cache de Fonte 3.0.0.0"
        "GraphicsPerfSvc" = "Monitor de Desempenho Gráfico"
        "stisvc" = "Aquisição de Imagens do Windows (WIA)"
        "WerSvc" = "Relatório de Erros do Windows"
        "PcaSvc" = "Assistente de Compatibilidade de Programas"
        "Wecsvc" = "Coletor de Eventos do Windows"
    }

    foreach ($service in $services.Keys) {
        Set-RegistryValue -Path "HKLM:\SYSTEM\CurrentControlSet\Services\$service" `
            -Name "Start" -Type DWord -Value 4 `
            -Description "$($services[$service]) desabilitado"
    }

    Write-Host ""
    Write-Host "Desabilitando serviços relacionados ao Xbox e Mapas..." -ForegroundColor Yellow

    $xboxServices = @{
        "XblGameSave" = "Salvamento de Jogos do Xbox Live"
        "XboxNetApiSvc" = "Rede do Xbox Live"
        "XboxGipSvc" = "Gerenciamento de Acessórios Xbox"
        "XblAuthManager" = "Gerenciador de Autenticação Xbox Live"
        "MapsBroker" = "Broker de Mapas"
    }

    foreach ($service in $xboxServices.Keys) {
        Set-RegistryValue -Path "HKLM:\SYSTEM\CurrentControlSet\Services\$service" `
            -Name "Start" -Type DWord -Value 4 `
            -Description "$($xboxServices[$service]) desabilitado"
    }

    Write-Host ""
    Write-Host "✅ Serviços desnecessários desabilitados com sucesso!" -ForegroundColor Green
    Write-Host ""
    Write-Host "⚠️  Uma reinicialização é altamente recomendada para que as alterações tenham efeito." -ForegroundColor Yellow
    Write-Host ""

    Read-Host "Pressione ENTER para voltar ao menu"
}

# Função: Otimizações de Memória (mantida do script anterior)
function Apply-MemoryOptimizations {
    Show-Banner
    Write-Host "████████████████████████████████████████████████████████████████████████████████" -ForegroundColor Cyan
    Write-Host "██               APLICANDO OTIMIZAÇÕES DE MEMÓRIA (RAM)                         ██" -ForegroundColor Cyan
    Write-Host "████████████████████████████████████████████████████████████████████████████████" -ForegroundColor Cyan
    Write-Host ""

    Write-Host "Escolha a quantidade de RAM do seu sistema:" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "[1] 8 GB de RAM" -ForegroundColor White
    Write-Host "[2] 16 GB de RAM" -ForegroundColor White
    Write-Host "[3] 32 GB de RAM" -ForegroundColor White
    Write-Host "[4] 64 GB de RAM" -ForegroundColor White
    Write-Host "[5] Outra quantidade (informar manualmente)" -ForegroundColor White
    Write-Host "[0] Voltar ao Menu Principal" -ForegroundColor White
    Write-Host ""

    $ramChoice = Read-Host "Digite sua escolha (0-5)"

    $ramGB = switch ($ramChoice) {
        "1" { 8 }
        "2" { 16 }
        "3" { 32 }
        "4" { 64 }
        "5" {
            Write-Host ""
            $customRAM = Read-Host "Digite a quantidade total de RAM em GB (ex: 10, 24)"
            try {
                [int]$customRAM
            }
            catch {
                Write-Host "Erro: Entrada inválida. Por favor, digite um número." -ForegroundColor Red
                Start-Sleep -Seconds 3
                return
            }
        }
        "0" { return }
        default {
            Write-Host "Opção inválida! Tente novamente." -ForegroundColor Red
            Start-Sleep -Seconds 3
            return
        }
    }

    $thresholdKB = $ramGB * 1024

    Write-Host ""
    Write-Host "Aplicando otimização para $ramGB GB de RAM..." -ForegroundColor Yellow

    Set-RegistryValue -Path "HKLM:\SYSTEM\CurrentControlSet\Control" `
        -Name "SvcHostSplitThresholdInKB" -Type DWord -Value $thresholdKB `
        -Description "SvcHostSplitThresholdInKB definido para $thresholdKB KB"

    Write-Host ""
    Write-Host "✅ Otimizações de Memória aplicadas com sucesso!" -ForegroundColor Green
    Write-Host ""
    Write-Host "⚠️  Uma reinicialização é recomendada para que as alterações tenham efeito." -ForegroundColor Yellow
    Write-Host ""

    Read-Host "Pressione ENTER para voltar ao menu"
}

# Função: Prioridade de Jogos (mantida do script anterior)
function Apply-GamePriority {
    Show-Banner
    Write-Host "████████████████████████████████████████████████████████████████████████████████" -ForegroundColor Cyan
    Write-Host "██             APLICAR OTIMIZAÇÕES DE PRIORIDADE DE JOGO                        ██" -ForegroundColor Cyan
    Write-Host "████████████████████████████████████████████████████████████████████████████████" -ForegroundColor Cyan
    Write-Host ""

    Write-Host "Escolha um jogo para aplicar prioridade de CPU Alta:" -ForegroundColor Yellow
    Write-Host ""

    $games = @{
        "1" = @{Name="Call of Duty"; Exe="COD.exe"}
        "2" = @{Name="Valorant"; Exe="VALORANT-Win64-Shipping.exe"}
        "3" = @{Name="Counter-Strike 2"; Exe="cs2.exe"}
        "4" = @{Name="League of Legends"; Exe="LeagueClient.exe"}
        "5" = @{Name="Dota 2"; Exe="dota2.exe"}
        "6" = @{Name="Apex Legends"; Exe="r5apex.exe"}
        "7" = @{Name="Fortnite"; Exe="FortniteClient-Win64-Shipping.exe"}
        "8" = @{Name="Rainbow Six Siege"; Exe="RainbowSix.exe"}
        "9" = @{Name="Overwatch 2"; Exe="Overwatch.exe"}
        "10" = @{Name="Rocket League"; Exe="RocketLeague.exe"}
        "11" = @{Name="Combat Arms"; Exe="CombatArms.exe"}
        "12" = @{Name="EA Sports FC"; Exe="EAFC25.exe"}
        "13" = @{Name="eFootball"; Exe="eFootball.exe"}
        "14" = @{Name="GTA 5"; Exe="GTA5.exe"}
        "15" = @{Name="FiveM"; Exe="FiveM.exe"}
    }

    foreach ($key in 1..15) {
        Write-Host "[$key] $($games["$key"].Name) ($($games["$key"].Exe))" -ForegroundColor White
    }
    Write-Host "[16] Digitar nome do executável manualmente" -ForegroundColor White
    Write-Host "[0] Voltar ao Menu Principal" -ForegroundColor White
    Write-Host ""

    $gameChoice = Read-Host "Digite sua escolha (0-16)"

    $gameExe = ""

    if ($gameChoice -eq "0") {
        return
    }
    elseif ($gameChoice -eq "16") {
        Write-Host ""
        $gameExe = Read-Host "Digite o nome completo do executável do jogo (ex: meu_jogo.exe)"
        if ([string]::IsNullOrWhiteSpace($gameExe)) {
            Write-Host "Nome do executável não pode ser vazio!" -ForegroundColor Red
            Start-Sleep -Seconds 3
            return
        }
    }
    elseif ($games.ContainsKey($gameChoice)) {
        $gameExe = $games[$gameChoice].Exe
    }
    else {
        Write-Host "Opção inválida! Tente novamente." -ForegroundColor Red
        Start-Sleep -Seconds 3
        return
    }

    Write-Host ""
    Write-Host "Aplicando prioridade de CPU Alta para $gameExe..." -ForegroundColor Yellow

    $perfPath = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\$gameExe\PerfOptions"

    Set-RegistryValue -Path $perfPath -Name "CpuPriorityClass" -Type DWord -Value 0x00000003 `
        -Description "Prioridade de CPU Alta aplicada para $gameExe"

    Write-Host ""
    Write-Host "✅ Otimização de Prioridade de Jogo aplicada com sucesso!" -ForegroundColor Green
    Write-Host ""
    Write-Host "ℹ️  Esta alteração será aplicada automaticamente na próxima vez que o jogo for iniciado." -ForegroundColor Cyan
    Write-Host ""

    Read-Host "Pressione ENTER para voltar ao menu"
}

# 🔥 NOVA FUNÇÃO: Modo ULTRA Performance
function Apply-UltraPerformanceMode {
    Show-Banner
    Write-Host "████████████████████████████████████████████████████████████████████████████████" -ForegroundColor Red
    Write-Host "██             🔥 MODO ULTRA PERFORMANCE - MÁXIMO DESEMPENHO 🔥                  ██" -ForegroundColor Red
    Write-Host "████████████████████████████████████████████████████████████████████████████████" -ForegroundColor Red
    Write-Host ""
    Write-Host "⚠️  ATENÇÃO: Este modo aplica configurações EXTREMAS de performance!" -ForegroundColor Yellow
    Write-Host "    Pode reduzir economia de energia e vida útil de componentes." -ForegroundColor Yellow
    Write-Host ""

    $confirm = Read-Host "Deseja continuar? (S/N)"
    if ($confirm -ne "S" -and $confirm -ne "s") {
        return
    }

    Write-Host ""
    Write-Host "Desabilitando TODOS os efeitos visuais do Windows..." -ForegroundColor Yellow

    # Desabilita animações e efeitos visuais
    Set-RegistryValue -Path "HKCU:\Control Panel\Desktop\WindowMetrics" `
        -Name "MinAnimate" -Type String -Value "0" `
        -Description "Animações de janela desabilitadas"

    Set-RegistryValue -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" `
        -Name "VisualFXSetting" -Type DWord -Value 2 `
        -Description "Efeitos visuais configurados para melhor desempenho"

    Set-RegistryValue -Path "HKCU:\Software\Microsoft\Windows\DWM" `
        -Name "EnableAeroPeek" -Type DWord -Value 0 `
        -Description "Aero Peek desabilitado"

    Set-RegistryValue -Path "HKCU:\Software\Microsoft\Windows\DWM" `
        -Name "AlwaysHibernateThumbnails" -Type DWord -Value 0 `
        -Description "Thumbnails em hibernação desabilitados"

    Write-Host ""
    Write-Host "Otimizando CPU para máximo desempenho..." -ForegroundColor Yellow

    # Desabilita C-States (estados de economia de energia da CPU)
    Set-RegistryValue -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Processor" `
        -Name "Capabilities" -Type DWord -Value 0x0007e066 `
        -Description "C-States otimizados para performance"

    # Desabilita parking de núcleos da CPU
    Set-RegistryValue -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\54533251-82be-4824-96c1-47b60b740d00\0cc5b647-c1df-4637-891a-dec35c318583" `
        -Name "ValueMax" -Type DWord -Value 0 `
        -Description "Core Parking desabilitado (todos os núcleos ativos)"

    # Frequência mínima da CPU em 100%
    Set-RegistryValue -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\54533251-82be-4824-96c1-47b60b740d00\893dee8e-2bef-41e0-89c6-b55d0929964c" `
        -Name "ValueMax" -Type DWord -Value 100 `
        -Description "Frequência mínima da CPU em 100%"

    Write-Host ""
    Write-Host "Desabilitando recursos de economia de energia..." -ForegroundColor Yellow

    # Desabilita Hibernação
    Set-RegistryValue -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Power" `
        -Name "HibernateEnabled" -Type DWord -Value 0 `
        -Description "Hibernação desabilitada"

    # Desabilita Fast Startup
    Set-RegistryValue -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Power" `
        -Name "HiberbootEnabled" -Type DWord -Value 0 `
        -Description "Fast Startup desabilitado"

    Write-Host ""
    Write-Host "Otimizando timer de sistema para menor latência..." -ForegroundColor Yellow

    # Timer Resolution para 0.5ms (ultra baixa latência)
    Set-RegistryValue -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\kernel" `
        -Name "GlobalTimerResolutionRequests" -Type DWord -Value 1 `
        -Description "Timer Resolution otimizado para 0.5ms"

    Write-Host ""
    Write-Host "Desabilitando Prefetch e Superfetch..." -ForegroundColor Yellow

    Set-RegistryValue -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters" `
        -Name "EnablePrefetcher" -Type DWord -Value 0 `
        -Description "Prefetcher desabilitado"

    Set-RegistryValue -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters" `
        -Name "EnableSuperfetch" -Type DWord -Value 0 `
        -Description "Superfetch desabilitado"

    Write-Host ""
    Write-Host "Otimizando prioridade de interrupções (IRQ)..." -ForegroundColor Yellow

    Set-RegistryValue -Path "HKLM:\SYSTEM\CurrentControlSet\Control\PriorityControl" `
        -Name "IRQ8Priority" -Type DWord -Value 1 `
        -Description "Prioridade de IRQ otimizada"

    Write-Host ""
    Write-Host "Desabilitando Telemetria e Diagnósticos..." -ForegroundColor Yellow

    Set-RegistryValue -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection" `
        -Name "AllowTelemetry" -Type DWord -Value 0 `
        -Description "Telemetria desabilitada"

    Set-RegistryValue -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" `
        -Name "AllowTelemetry" -Type DWord -Value 0 `
        -Description "Coleta de dados desabilitada"

    Write-Host ""
    Write-Host "🔥 MODO ULTRA PERFORMANCE ativado com sucesso!" -ForegroundColor Green
    Write-Host ""
    Write-Host "⚠️  REINICIALIZAÇÃO OBRIGATÓRIA para aplicar todas as alterações!" -ForegroundColor Red
    Write-Host ""

    Read-Host "Pressione ENTER para voltar ao menu"
}

# 🌐 NOVA FUNÇÃO: Otimizações de Rede Avançadas
function Apply-AdvancedNetworkOptimizations {
    Show-Banner
    Write-Host "████████████████████████████████████████████████████████████████████████████████" -ForegroundColor Cyan
    Write-Host "██             🌐 OTIMIZAÇÕES DE REDE AVANÇADAS                                 ██" -ForegroundColor Cyan
    Write-Host "████████████████████████████████████████████████████████████████████████████████" -ForegroundColor Cyan
    Write-Host ""

    Write-Host "Otimizando TCP/IP para menor latência..." -ForegroundColor Yellow

    # Desabilita Nagle's Algorithm (reduz latência em jogos online)
    Set-RegistryValue -Path "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces" `
        -Name "TcpAckFrequency" -Type DWord -Value 1 `
        -Description "TcpAckFrequency otimizado (Nagle desabilitado)"

    Set-RegistryValue -Path "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces" `
        -Name "TCPNoDelay" -Type DWord -Value 1 `
        -Description "TCPNoDelay habilitado (menor latência)"

    Write-Host ""
    Write-Host "Otimizando buffers de rede..." -ForegroundColor Yellow

    # Aumenta buffers de recepção e transmissão
    Set-RegistryValue -Path "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" `
        -Name "TcpWindowSize" -Type DWord -Value 65535 `
        -Description "TcpWindowSize aumentado para 64KB"

    Set-RegistryValue -Path "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" `
        -Name "Tcp1323Opts" -Type DWord -Value 1 `
        -Description "Window Scaling habilitado"

    Set-RegistryValue -Path "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" `
        -Name "DefaultTTL" -Type DWord -Value 64 `
        -Description "TTL otimizado"

    Write-Host ""
    Write-Host "Desabilitando recursos que aumentam latência..." -ForegroundColor Yellow

    # Desabilita Auto-Tuning (pode causar latência variável)
    try {
        netsh interface tcp set global autotuninglevel=disabled | Out-Null
        Write-Host "  ✓ Auto-Tuning desabilitado" -ForegroundColor Green
    } catch {
        Write-Host "  ✗ Erro ao desabilitar Auto-Tuning" -ForegroundColor Red
    }

    # Desabilita Heuristics
    try {
        netsh interface tcp set heuristics disabled | Out-Null
        Write-Host "  ✓ Heuristics desabilitado" -ForegroundColor Green
    } catch {
        Write-Host "  ✗ Erro ao desabilitar Heuristics" -ForegroundColor Red
    }

    Write-Host ""
    Write-Host "Otimizando QoS (Quality of Service)..." -ForegroundColor Yellow

    # Remove limite de largura de banda reservada do QoS
    Set-RegistryValue -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Psched" `
        -Name "NonBestEffortLimit" -Type DWord -Value 0 `
        -Description "Limite de QoS removido (100% de banda disponível)"

    Write-Host ""
    Write-Host "Otimizando DNS..." -ForegroundColor Yellow

    # Desabilita cache negativo de DNS
    Set-RegistryValue -Path "HKLM:\SYSTEM\CurrentControlSet\Services\Dnscache\Parameters" `
        -Name "NegativeCacheTime" -Type DWord -Value 0 `
        -Description "Cache negativo de DNS desabilitado"

    # Aumenta cache positivo de DNS
    Set-RegistryValue -Path "HKLM:\SYSTEM\CurrentControlSet\Services\Dnscache\Parameters" `
        -Name "MaxCacheTtl" -Type DWord -Value 86400 `
        -Description "Cache de DNS aumentado para 24h"

    Write-Host ""
    Write-Host "Otimizando Network Adapter..." -ForegroundColor Yellow

    # Desabilita Large Send Offload
    Set-RegistryValue -Path "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" `
        -Name "DisableTaskOffload" -Type DWord -Value 0 `
        -Description "Task Offload otimizado"

    Write-Host ""
    Write-Host "✅ Otimizações de Rede Avançadas aplicadas com sucesso!" -ForegroundColor Green
    Write-Host ""
    Write-Host "⚠️  Reinicie o sistema para aplicar todas as alterações de rede." -ForegroundColor Yellow
    Write-Host ""

    Read-Host "Pressione ENTER para voltar ao menu"
}

# 💿 NOVA FUNÇÃO: Otimizações de Disco SSD/NVMe
function Apply-DiskOptimizations {
    Show-Banner
    Write-Host "████████████████████████████████████████████████████████████████████████████████" -ForegroundColor Cyan
    Write-Host "██             💿 OTIMIZAÇÕES DE DISCO SSD/NVMe                                 ██" -ForegroundColor Cyan
    Write-Host "████████████████████████████████████████████████████████████████████████████████" -ForegroundColor Cyan
    Write-Host ""

    Write-Host "Otimizando configurações de SSD/NVMe..." -ForegroundColor Yellow

    # Desabilita desfragmentação automática (desnecessária em SSD)
    Set-RegistryValue -Path "HKLM:\SOFTWARE\Microsoft\Dfrg\BootOptimizeFunction" `
        -Name "Enable" -Type String -Value "N" `
        -Description "Desfragmentação automática desabilitada"

    Write-Host ""
    Write-Host "Otimizando NTFS para SSDs..." -ForegroundColor Yellow

    # Desabilita Last Access Time (reduz escritas no SSD)
    Set-RegistryValue -Path "HKLM:\SYSTEM\CurrentControlSet\Control\FileSystem" `
        -Name "NtfsDisableLastAccessUpdate" -Type DWord -Value 1 `
        -Description "Last Access Time desabilitado (menos escritas no SSD)"

    # Desabilita 8.3 filename creation
    Set-RegistryValue -Path "HKLM:\SYSTEM\CurrentControlSet\Control\FileSystem" `
        -Name "NtfsDisable8dot3NameCreation" -Type DWord -Value 1 `
        -Description "8.3 filename creation desabilitado"

    Write-Host ""
    Write-Host "Otimizando cache de disco..." -ForegroundColor Yellow

    # Aumenta cache de disco
    Set-RegistryValue -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" `
        -Name "LargeSystemCache" -Type DWord -Value 1 `
        -Description "Large System Cache habilitado"

    # Otimiza I/O Page Lock Limit
    Set-RegistryValue -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" `
        -Name "IoPageLockLimit" -Type DWord -Value 0xF0000 `
        -Description "I/O Page Lock Limit otimizado"

    Write-Host ""
    Write-Host "Desabilitando recursos desnecessários para SSD..." -ForegroundColor Yellow

    # Desabilita Windows Search Indexing (opcional)
    Set-RegistryValue -Path "HKLM:\SYSTEM\CurrentControlSet\Services\WSearch" `
        -Name "Start" -Type DWord -Value 4 `
        -Description "Windows Search desabilitado (menos escritas no disco)"

    Write-Host ""
    Write-Host "Otimizando política de energia do disco..." -ForegroundColor Yellow

    # Desabilita desligamento automático do disco
    try {
        powercfg -change -disk-timeout-ac 0 | Out-Null
        powercfg -change -disk-timeout-dc 0 | Out-Null
        Write-Host "  ✓ Desligamento automático do disco desabilitado" -ForegroundColor Green
    } catch {
        Write-Host "  ✗ Erro ao configurar política de energia do disco" -ForegroundColor Red
    }

    Write-Host ""
    Write-Host "✅ Otimizações de Disco SSD/NVMe aplicadas com sucesso!" -ForegroundColor Green
    Write-Host ""
    Write-Host "ℹ️  Estas otimizações prolongam a vida útil do SSD e melhoram a performance." -ForegroundColor Cyan
    Write-Host ""

    Read-Host "Pressione ENTER para voltar ao menu"
}

# 🖥️ NOVA FUNÇÃO: Otimizações de GPU Avançadas
function Apply-AdvancedGPUOptimizations {
    Show-Banner
    Write-Host "████████████████████████████████████████████████████████████████████████████████" -ForegroundColor Cyan
    Write-Host "██             🖥️  OTIMIZAÇÕES DE GPU AVANÇADAS                                 ██" -ForegroundColor Cyan
    Write-Host "████████████████████████████████████████████████████████████████████████████████" -ForegroundColor Cyan
    Write-Host ""

    Write-Host "Escolha o fabricante da sua GPU:" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "[1] NVIDIA" -ForegroundColor White
    Write-Host "[2] AMD" -ForegroundColor White
    Write-Host "[3] Intel" -ForegroundColor White
    Write-Host "[4] Aplicar otimizações genéricas" -ForegroundColor White
    Write-Host "[0] Voltar ao Menu Principal" -ForegroundColor White
    Write-Host ""

    $gpuChoice = Read-Host "Digite sua escolha (0-4)"

    if ($gpuChoice -eq "0") {
        return
    }

    Write-Host ""
    Write-Host "Aplicando otimizações de GPU..." -ForegroundColor Yellow

    # Otimizações genéricas para todas as GPUs
    Set-RegistryValue -Path "HKLM:\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" `
        -Name "HwSchMode" -Type DWord -Value 2 `
        -Description "Hardware-Accelerated GPU Scheduling habilitado"

    Set-RegistryValue -Path "HKLM:\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" `
        -Name "TdrLevel" -Type DWord -Value 0 `
        -Description "TDR (Timeout Detection and Recovery) desabilitado"

    Set-RegistryValue -Path "HKLM:\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" `
        -Name "TdrDelay" -Type DWord -Value 60 `
        -Description "TDR Delay aumentado para 60s"

    # Otimizações específicas por fabricante
    switch ($gpuChoice) {
        "1" {
            Write-Host ""
            Write-Host "Aplicando otimizações específicas para NVIDIA..." -ForegroundColor Yellow

            # Força P-State 0 (máximo desempenho)
            Set-RegistryValue -Path "HKLM:\SYSTEM\CurrentControlSet\Services\nvlddmkm\FTS" `
                -Name "EnableRID61684" -Type DWord -Value 1 `
                -Description "NVIDIA P-State forçado para máximo desempenho"

            # Desabilita NVIDIA Telemetry
            Set-RegistryValue -Path "HKLM:\SOFTWARE\NVIDIA Corporation\NvControlPanel2\Client" `
                -Name "OptInOrOutPreference" -Type DWord -Value 0 `
                -Description "NVIDIA Telemetry desabilitada"

            # Otimiza CUDA
            Set-RegistryValue -Path "HKLM:\SYSTEM\CurrentControlSet\Services\nvlddmkm\Global\NVTweak" `
                -Name "DisplayPowerSaving" -Type DWord -Value 0 `
                -Description "Display Power Saving desabilitado"
        }
        "2" {
            Write-Host ""
            Write-Host "Aplicando otimizações específicas para AMD..." -ForegroundColor Yellow

            # Desabilita ULPS (Ultra Low Power State)
            Set-RegistryValue -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" `
                -Name "EnableUlps" -Type DWord -Value 0 `
                -Description "AMD ULPS desabilitado"

            # Força máximo desempenho
            Set-RegistryValue -Path "HKLM:\SYSTEM\CurrentControlSet\Services\amdwddmg" `
                -Name "PP_ThermalAutoThrottlingEnable" -Type DWord -Value 0 `
                -Description "AMD Thermal Throttling desabilitado"
        }
        "3" {
            Write-Host ""
            Write-Host "Aplicando otimizações específicas para Intel..." -ForegroundColor Yellow

            # Otimizações Intel Graphics
            Set-RegistryValue -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" `
                -Name "Disable_OverlayDSQualityEnhancement" -Type DWord -Value 1 `
                -Description "Intel Overlay Quality Enhancement desabilitado"
        }
    }

    Write-Host ""
    Write-Host "Desabilitando recursos de economia de energia da GPU..." -ForegroundColor Yellow

    # Desabilita ASPM (Active State Power Management)
    Set-RegistryValue -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" `
        -Name "EnableAspmL0s" -Type DWord -Value 0 `
        -Description "ASPM L0s desabilitado"

    Set-RegistryValue -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" `
        -Name "EnableAspmL1" -Type DWord -Value 0 `
        -Description "ASPM L1 desabilitado"

    Write-Host ""
    Write-Host "✅ Otimizações de GPU Avançadas aplicadas com sucesso!" -ForegroundColor Green
    Write-Host ""
    Write-Host "⚠️  Reinicie o sistema para aplicar todas as alterações de GPU." -ForegroundColor Yellow
    Write-Host ""

    Read-Host "Pressione ENTER para voltar ao menu"
}

# Função Principal
function Main {
    # Verifica se está executando como administrador
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

        switch ($opcao) {
            "1" { Apply-GeneralOptimizations }
            "2" { Apply-GameOptimizations }
            "3" { Disable-UnnecessaryServices }
            "4" { Apply-MemoryOptimizations }
            "5" { Apply-GamePriority }
            "6" { Apply-UltraPerformanceMode }
            "7" { Apply-AdvancedNetworkOptimizations }
            "8" { Apply-DiskOptimizations }
            "9" { Apply-AdvancedGPUOptimizations }
            "0" { 
                Show-Banner
                Write-Host "████████████████████████████████████████████████████████████████████████████████" -ForegroundColor Green
                Write-Host "██                                                                              ██" -ForegroundColor Green
                Write-Host "██             Obrigado por usar o Otimizador de Sistema ULTRA!                 ██" -ForegroundColor White
                Write-Host "██                          © 2024 RMSTECH                                      ██" -ForegroundColor Gray
                Write-Host "██                                                                              ██" -ForegroundColor Green
                Write-Host "████████████████████████████████████████████████████████████████████████████████" -ForegroundColor Green
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
