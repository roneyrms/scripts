#Requires -RunAsAdministrator
<#
.SYNOPSIS
    Otimizador de Internet ULTRA - RMSTECH

.DESCRIPTION
    Ferramenta avançada de otimização de conexão de internet

.NOTES
    Autor: RoneyRMS
    Versão: 2.0 ULTRA
    Data: 19/12/2024

.COPYRIGHT
    © 2024 RMSTECH. Todos os direitos reservados.
    YouTube: https://www.youtube.com/@rms-tech/
    Instagram: https://www.instagram.com/rms.tech/
#>

$Host.UI.RawUI.WindowTitle = "Otimizador de Internet ULTRA - RMSTECH"
$ErrorActionPreference = "SilentlyContinue"
$Global:OptimizationsApplied = $false

function Show-Banner {
    Clear-Host
    Write-Host ""
    Write-Host "████████████████████████████████████████████████████████████████████████████████" -ForegroundColor Cyan
    Write-Host "██                                                                              ██" -ForegroundColor Cyan
    Write-Host "██                    OTIMIZADOR DE INTERNET ULTRA                              ██" -ForegroundColor White
    Write-Host "██                          Versão 2.0 - RMSTECH                                ██" -ForegroundColor White
    Write-Host "██                          © 2024 RoneyRMS                                     ██" -ForegroundColor Gray
    Write-Host "██                                                                              ██" -ForegroundColor Cyan
    Write-Host "████████████████████████████████████████████████████████████████████████████████" -ForegroundColor Cyan
    Write-Host ""
}

function Get-ActiveNetworkAdapters {
    try {
        return Get-NetAdapter | Where-Object {$_.Status -eq "Up"}
    }
    catch {
        return $null
    }
}

function Show-MainMenu {
    Show-Banner

    Write-Host "════════════════════════════════════════════════════════════════════════════════" -ForegroundColor Gray
    Write-Host "🎥 YouTube: https://www.youtube.com/@rms-tech/" -ForegroundColor Cyan
    Write-Host "📱 Instagram: https://www.instagram.com/rms.tech/" -ForegroundColor Cyan
    Write-Host "════════════════════════════════════════════════════════════════════════════════" -ForegroundColor Gray
    Write-Host ""

    $connectionStatus = Test-Connection -ComputerName 8.8.8.8 -Count 1 -Quiet

    if ($connectionStatus) {
        Write-Host "🌐 STATUS: ✅ ONLINE" -ForegroundColor Green
    }
    else {
        Write-Host "🌐 STATUS: ❌ OFFLINE" -ForegroundColor Red
    }

    $adapters = Get-ActiveNetworkAdapters
    Write-Host "📡 ADAPTADORES: $($adapters.Count)" -ForegroundColor Cyan

    Write-Host ""
    Write-Host "MENU PRINCIPAL" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "[1] 🚀 Aplicar Otimizações" -ForegroundColor White
    Write-Host "[2] ⏮️  Desfazer Otimizações" -ForegroundColor White
    Write-Host "[3] 🧹 Limpar Cache DNS" -ForegroundColor White
    Write-Host "[4] 📊 Diagnóstico de Rede (NOVO!)" -ForegroundColor Yellow
    Write-Host "[5] ⚡ Teste de Velocidade (NOVO!)" -ForegroundColor Yellow
    Write-Host "[6] 🔧 Reparação Avançada (NOVO!)" -ForegroundColor Yellow
    Write-Host "[7] 🌍 DNS Personalizado (NOVO!)" -ForegroundColor Yellow
    Write-Host "[8] 📋 Sobre o Autor" -ForegroundColor White
    Write-Host "[0] ❌ Sair" -ForegroundColor White
    Write-Host ""
    Write-Host "════════════════════════════════════════════════════════════════════════════════" -ForegroundColor Cyan
    Write-Host ""
}

function Clear-DNSCache {
    Show-Banner
    Write-Host "████████████████████████████████████████████████████████████████████████████████" -ForegroundColor Cyan
    Write-Host "██                    🧹 LIMPEZA DE CACHE DNS                                   ██" -ForegroundColor Cyan
    Write-Host "████████████████████████████████████████████████████████████████████████████████" -ForegroundColor Cyan
    Write-Host ""

    Write-Host "[1/5] Limpando cache DNS..." -ForegroundColor Yellow
    try {
        Clear-DnsClientCache
        ipconfig /flushdns | Out-Null
        Write-Host "  ✓ Cache DNS limpo" -ForegroundColor Green
    }
    catch {
        Write-Host "  ✗ Erro ao limpar cache DNS" -ForegroundColor Red
    }

    Write-Host ""
    Write-Host "[2/5] Reiniciando serviço DNS..." -ForegroundColor Yellow
    try {
        Restart-Service -Name Dnscache -Force
        Write-Host "  ✓ Serviço DNS reiniciado" -ForegroundColor Green
    }
    catch {
        Write-Host "  ✗ Erro ao reiniciar DNS" -ForegroundColor Red
    }

    Write-Host ""
    Write-Host "[3/5] Limpando cache ARP..." -ForegroundColor Yellow
    try {
        arp -d * 2>$null
        Write-Host "  ✓ Cache ARP limpo" -ForegroundColor Green
    }
    catch {
        Write-Host "  ✓ Cache ARP já limpo" -ForegroundColor Green
    }

    Write-Host ""
    Write-Host "[4/5] Renovando IP..." -ForegroundColor Yellow
    try {
        ipconfig /release | Out-Null
        Start-Sleep -Seconds 1
        ipconfig /renew | Out-Null
        Write-Host "  ✓ IP renovado" -ForegroundColor Green
    }
    catch {
        Write-Host "  ✗ Erro ao renovar IP" -ForegroundColor Red
    }

    Write-Host ""
    Write-Host "[5/5] Limpando NetBIOS..." -ForegroundColor Yellow
    try {
        nbtstat -R | Out-Null
        nbtstat -RR | Out-Null
        Write-Host "  ✓ NetBIOS limpo" -ForegroundColor Green
    }
    catch {
        Write-Host "  ✗ Erro ao limpar NetBIOS" -ForegroundColor Red
    }

    Write-Host ""
    Write-Host "✅ Limpeza concluída!" -ForegroundColor Green
    Write-Host ""

    Read-Host "Pressione ENTER para voltar"
}

function Apply-NetworkOptimizations {
    Show-Banner
    Write-Host "████████████████████████████████████████████████████████████████████████████████" -ForegroundColor Cyan
    Write-Host "██                    🚀 APLICANDO OTIMIZAÇÕES                                  ██" -ForegroundColor Cyan
    Write-Host "████████████████████████████████████████████████████████████████████████████████" -ForegroundColor Cyan
    Write-Host ""

    Write-Host "⚠️  ATENÇÃO: Crie um Ponto de Restauração antes de continuar!" -ForegroundColor Yellow
    Write-Host ""

    $confirm = Read-Host "Deseja continuar? (S/N)"
    if ($confirm -ne "S" -and $confirm -ne "s") {
        return
    }

    Write-Host ""

    Write-Host "[1/12] Configurando DNS Google..." -ForegroundColor Yellow
    $adapters = Get-ActiveNetworkAdapters
    foreach ($adapter in $adapters) {
        try {
            Set-DnsClientServerAddress -InterfaceAlias $adapter.Name -ServerAddresses ("8.8.8.8", "8.8.4.4")
            Write-Host "  ✓ DNS configurado em $($adapter.Name)" -ForegroundColor Green
        }
        catch {
            Write-Host "  ✗ Erro em $($adapter.Name)" -ForegroundColor Red
        }
    }

    Write-Host ""
    Write-Host "[2/12] Desabilitando limitação de banda..." -ForegroundColor Yellow
    try {
        New-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" -Force | Out-Null
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" -Name "NetworkThrottlingIndex" -Value 0xffffffff -Type DWord -Force
        Write-Host "  ✓ Limitação desabilitada" -ForegroundColor Green
    }
    catch {
        Write-Host "  ✗ Erro" -ForegroundColor Red
    }

    Write-Host ""
    Write-Host "[3/12] Otimizando TCP/IP..." -ForegroundColor Yellow
    $tcpSettings = @{
        "TcpAckFrequency" = 1
        "TCPNoDelay" = 1
        "TcpWindowSize" = 372300
        "GlobalMaxTcpWindowSize" = 372300
    }

    foreach ($setting in $tcpSettings.Keys) {
        try {
            Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" -Name $setting -Value $tcpSettings[$setting] -Type DWord -Force
            Write-Host "  ✓ $setting otimizado" -ForegroundColor Green
        }
        catch {
            Write-Host "  ✗ Erro em $setting" -ForegroundColor Red
        }
    }

    Write-Host ""
    Write-Host "[4/12] Otimizando buffers..." -ForegroundColor Yellow
    $bufferSettings = @{
        "TcpTimedWaitDelay" = 30
        "DefaultTTL" = 64
        "TcpMaxDataRetransmissions" = 3
    }

    foreach ($setting in $bufferSettings.Keys) {
        try {
            Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" -Name $setting -Value $bufferSettings[$setting] -Type DWord -Force
            Write-Host "  ✓ $setting otimizado" -ForegroundColor Green
        }
        catch {
            Write-Host "  ✗ Erro" -ForegroundColor Red
        }
    }

    Write-Host ""
    Write-Host "[5/12] Desabilitando QoS..." -ForegroundColor Yellow
    try {
        Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\Psched" -Name "NonBestEffortLimit" -Value 0 -Type DWord -Force
        Write-Host "  ✓ QoS desabilitado" -ForegroundColor Green
    }
    catch {
        Write-Host "  ✗ Erro" -ForegroundColor Red
    }

    Write-Host ""
    Write-Host "[6/12] Otimizando adaptador..." -ForegroundColor Yellow
    try {
        New-Item -Path "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces" -Force | Out-Null
        Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces" -Name "TcpAckFrequency" -Value 1 -Type DWord -Force
        Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces" -Name "TcpDelAckTicks" -Value 0 -Type DWord -Force
        Write-Host "  ✓ Adaptador otimizado" -ForegroundColor Green
    }
    catch {
        Write-Host "  ✗ Erro" -ForegroundColor Red
    }

    Write-Host ""
    Write-Host "[7/12] Limpando cache DNS..." -ForegroundColor Yellow
    try {
        Clear-DnsClientCache
        ipconfig /flushdns | Out-Null
        Write-Host "  ✓ Cache limpo" -ForegroundColor Green
    }
    catch {
        Write-Host "  ✗ Erro" -ForegroundColor Red
    }

    Write-Host ""
    Write-Host "[8/12] Resetando Winsock..." -ForegroundColor Yellow
    try {
        netsh winsock reset | Out-Null
        Write-Host "  ✓ Winsock resetado" -ForegroundColor Green
    }
    catch {
        Write-Host "  ✗ Erro" -ForegroundColor Red
    }

    Write-Host ""
    Write-Host "[9/12] Resetando TCP/IP..." -ForegroundColor Yellow
    try {
        netsh int ip reset | Out-Null
        Write-Host "  ✓ TCP/IP resetado" -ForegroundColor Green
    }
    catch {
        Write-Host "  ✗ Erro" -ForegroundColor Red
    }

    Write-Host ""
    Write-Host "[10/12] Reiniciando DNS..." -ForegroundColor Yellow
    try {
        Restart-Service -Name Dnscache -Force
        Write-Host "  ✓ DNS reiniciado" -ForegroundColor Green
    }
    catch {
        Write-Host "  ✗ Erro" -ForegroundColor Red
    }

    Write-Host ""
    Write-Host "[11/12] Otimizando bandwidth..." -ForegroundColor Yellow
    try {
        New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Psched" -Force | Out-Null
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Psched" -Name "NonBestEffortLimit" -Value 0 -Type DWord -Force
        Write-Host "  ✓ Bandwidth otimizado" -ForegroundColor Green
    }
    catch {
        Write-Host "  ✗ Erro" -ForegroundColor Red
    }

    Write-Host ""
    Write-Host "[12/12] Configurando Large Send Offload..." -ForegroundColor Yellow
    try {
        Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" -Name "EnableTCPChimney" -Value 1 -Type DWord -Force
        Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" -Name "EnableRSS" -Value 1 -Type DWord -Force
        Write-Host "  ✓ Large Send Offload configurado" -ForegroundColor Green
    }
    catch {
        Write-Host "  ✗ Erro" -ForegroundColor Red
    }

    $Global:OptimizationsApplied = $true

    Write-Host ""
    Write-Host "════════════════════════════════════════════════════════════════════════════════" -ForegroundColor Green
    Write-Host "✅ Otimizações aplicadas com sucesso!" -ForegroundColor Green
    Write-Host "════════════════════════════════════════════════════════════════════════════════" -ForegroundColor Green
    Write-Host ""
    Write-Host "⚠️  Reinicie o sistema para aplicar todas as alterações." -ForegroundColor Yellow
    Write-Host ""
    Write-Host "🎥 Inscreva-se: https://www.youtube.com/@rms-tech/" -ForegroundColor Cyan
    Write-Host ""

    Read-Host "Pressione ENTER para voltar"
}

function Undo-NetworkOptimizations {
    Show-Banner
    Write-Host "████████████████████████████████████████████████████████████████████████████████" -ForegroundColor Cyan
    Write-Host "██                    ⏮️  DESFAZENDO OTIMIZAÇÕES                                 ██" -ForegroundColor Cyan
    Write-Host "████████████████████████████████████████████████████████████████████████████████" -ForegroundColor Cyan
    Write-Host ""

    Write-Host "[1/8] Revertendo DNS..." -ForegroundColor Yellow
    $adapters = Get-ActiveNetworkAdapters
    foreach ($adapter in $adapters) {
        try {
            Set-DnsClientServerAddress -InterfaceAlias $adapter.Name -ResetServerAddresses
            Write-Host "  ✓ DNS revertido em $($adapter.Name)" -ForegroundColor Green
        }
        catch {
            Write-Host "  ✗ Erro" -ForegroundColor Red
        }
    }

    Write-Host ""
    Write-Host "[2/8] Revertendo limitação de banda..." -ForegroundColor Yellow
    try {
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" -Name "NetworkThrottlingIndex" -Value 0x0000000a -Type DWord -Force
        Write-Host "  ✓ Revertido" -ForegroundColor Green
    }
    catch {
        Write-Host "  ✗ Erro" -ForegroundColor Red
    }

    Write-Host ""
    Write-Host "[3/8] Removendo configurações TCP/IP..." -ForegroundColor Yellow
    $keys = @("TcpAckFrequency", "TCPNoDelay", "TcpWindowSize", "GlobalMaxTcpWindowSize", "TcpTimedWaitDelay", "DefaultTTL", "TcpMaxDataRetransmissions", "EnableTCPChimney", "EnableRSS")

    foreach ($key in $keys) {
        try {
            Remove-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" -Name $key -Force -ErrorAction SilentlyContinue
            Write-Host "  ✓ $key removido" -ForegroundColor Green
        }
        catch { }
    }

    Write-Host ""
    Write-Host "[4/8] Revertendo QoS..." -ForegroundColor Yellow
    try {
        Remove-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\Psched" -Name "NonBestEffortLimit" -Force -ErrorAction SilentlyContinue
        Remove-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Psched" -Name "NonBestEffortLimit" -Force -ErrorAction SilentlyContinue
        Write-Host "  ✓ QoS revertido" -ForegroundColor Green
    }
    catch { }

    Write-Host ""
    Write-Host "[5/8] Removendo configurações de interface..." -ForegroundColor Yellow
    try {
        Remove-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces" -Name "TcpAckFrequency" -Force -ErrorAction SilentlyContinue
        Remove-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces" -Name "TcpDelAckTicks" -Force -ErrorAction SilentlyContinue
        Write-Host "  ✓ Removido" -ForegroundColor Green
    }
    catch { }

    Write-Host ""
    Write-Host "[6/8] Limpando cache DNS..." -ForegroundColor Yellow
    try {
        Clear-DnsClientCache
        ipconfig /flushdns | Out-Null
        Write-Host "  ✓ Cache limpo" -ForegroundColor Green
    }
    catch { }

    Write-Host ""
    Write-Host "[7/8] Reiniciando adaptadores..." -ForegroundColor Yellow
    try {
        foreach ($adapter in $adapters) {
            Restart-NetAdapter -Name $adapter.Name -Confirm:$false
        }
        Write-Host "  ✓ Adaptadores reiniciados" -ForegroundColor Green
    }
    catch { }

    Write-Host ""
    Write-Host "[8/8] Finalizando..." -ForegroundColor Yellow
    $Global:OptimizationsApplied = $false
    Write-Host "  ✓ Concluído" -ForegroundColor Green

    Write-Host ""
    Write-Host "✅ Otimizações desfeitas!" -ForegroundColor Green
    Write-Host ""

    Read-Host "Pressione ENTER para voltar"
}

function Start-NetworkDiagnostics {
    Show-Banner
    Write-Host "████████████████████████████████████████████████████████████████████████████████" -ForegroundColor Cyan
    Write-Host "██                    📊 DIAGNÓSTICO DE REDE                                    ██" -ForegroundColor Cyan
    Write-Host "████████████████████████████████████████████████████████████████████████████████" -ForegroundColor Cyan
    Write-Host ""

    Write-Host "═══════════════════════════════════════════════════════════════════════════════" -ForegroundColor Green
    Write-Host "📡 ADAPTADORES DE REDE" -ForegroundColor Cyan
    Write-Host "═══════════════════════════════════════════════════════════════════════════════" -ForegroundColor Green

    $adapters = Get-NetAdapter
    foreach ($adapter in $adapters) {
        $status = if ($adapter.Status -eq "Up") { "✅ ATIVO" } else { "❌ INATIVO" }
        Write-Host "   $($adapter.Name) - $status" -ForegroundColor White
        Write-Host "      Velocidade: $($adapter.LinkSpeed)" -ForegroundColor Gray
        Write-Host ""
    }

    Write-Host "═══════════════════════════════════════════════════════════════════════════════" -ForegroundColor Green
    Write-Host "🔌 TESTE DE CONECTIVIDADE" -ForegroundColor Cyan
    Write-Host "═══════════════════════════════════════════════════════════════════════════════" -ForegroundColor Green

    $testHosts = @{
        "Google DNS" = "8.8.8.8"
        "Cloudflare" = "1.1.1.1"
        "Google.com" = "www.google.com"
    }

    foreach ($host in $testHosts.Keys) {
        Write-Host "   Testando $host..." -NoNewline
        $result = Test-Connection -ComputerName $testHosts[$host] -Count 1 -Quiet

        if ($result) {
            $ping = Test-Connection -ComputerName $testHosts[$host] -Count 1
            Write-Host " ✅ OK ($($ping.ResponseTime)ms)" -ForegroundColor Green
        }
        else {
            Write-Host " ❌ FALHOU" -ForegroundColor Red
        }
    }

    Write-Host ""
    Write-Host "✅ Diagnóstico concluído!" -ForegroundColor Green
    Write-Host ""

    Read-Host "Pressione ENTER para voltar"
}

function Start-SpeedTest {
    Show-Banner
    Write-Host "████████████████████████████████████████████████████████████████████████████████" -ForegroundColor Cyan
    Write-Host "██                    ⚡ TESTE DE VELOCIDADE                                     ██" -ForegroundColor Cyan
    Write-Host "████████████████████████████████████████████████████████████████████████████████" -ForegroundColor Cyan
    Write-Host ""

    Write-Host "[1/2] Testando latência..." -ForegroundColor Yellow

    $servers = @{
        "Google" = "8.8.8.8"
        "Cloudflare" = "1.1.1.1"
    }

    foreach ($server in $servers.Keys) {
        $ping = Test-Connection -ComputerName $servers[$server] -Count 4
        $avgLatency = ($ping | Measure-Object -Property ResponseTime -Average).Average
        Write-Host "   $server : $([math]::Round($avgLatency, 2)) ms" -ForegroundColor White
    }

    Write-Host ""
    Write-Host "[2/2] Testando DNS..." -ForegroundColor Yellow

    $domains = @("www.google.com", "www.youtube.com")

    foreach ($domain in $domains) {
        $startTime = Get-Date
        Resolve-DnsName -Name $domain -QuickTimeout -ErrorAction SilentlyContinue | Out-Null
        $endTime = Get-Date

        $dnsTime = ($endTime - $startTime).TotalMilliseconds
        Write-Host "   $domain : $([math]::Round($dnsTime, 2)) ms" -ForegroundColor White
    }

    Write-Host ""
    Write-Host "✅ Teste concluído!" -ForegroundColor Green
    Write-Host ""

    Read-Host "Pressione ENTER para voltar"
}

function Start-AdvancedRepair {
    Show-Banner
    Write-Host "████████████████████████████████████████████████████████████████████████████████" -ForegroundColor Cyan
    Write-Host "██                    🔧 REPARAÇÃO AVANÇADA                                     ██" -ForegroundColor Cyan
    Write-Host "████████████████████████████████████████████████████████████████████████████████" -ForegroundColor Cyan
    Write-Host ""

    $confirm = Read-Host "Executar reparação? (S/N)"
    if ($confirm -ne "S" -and $confirm -ne "s") {
        return
    }

    Write-Host ""

    Write-Host "[1/6] Resetando Winsock..." -ForegroundColor Yellow
    netsh winsock reset | Out-Null
    Write-Host "  ✓ Concluído" -ForegroundColor Green

    Write-Host ""
    Write-Host "[2/6] Resetando TCP/IP..." -ForegroundColor Yellow
    netsh int ip reset | Out-Null
    Write-Host "  ✓ Concluído" -ForegroundColor Green

    Write-Host ""
    Write-Host "[3/6] Limpando cache DNS..." -ForegroundColor Yellow
    Clear-DnsClientCache
    ipconfig /flushdns | Out-Null
    Write-Host "  ✓ Concluído" -ForegroundColor Green

    Write-Host ""
    Write-Host "[4/6] Limpando cache ARP..." -ForegroundColor Yellow
    arp -d * 2>$null
    Write-Host "  ✓ Concluído" -ForegroundColor Green

    Write-Host ""
    Write-Host "[5/6] Renovando IP..." -ForegroundColor Yellow
    ipconfig /release | Out-Null
    Start-Sleep -Seconds 2
    ipconfig /renew | Out-Null
    Write-Host "  ✓ Concluído" -ForegroundColor Green

    Write-Host ""
    Write-Host "[6/6] Reiniciando serviços..." -ForegroundColor Yellow
    Restart-Service -Name Dnscache -Force
    Write-Host "  ✓ Concluído" -ForegroundColor Green

    Write-Host ""
    Write-Host "✅ Reparação concluída!" -ForegroundColor Green
    Write-Host ""

    Read-Host "Pressione ENTER para voltar"
}

function Set-CustomDNS {
    Show-Banner
    Write-Host "████████████████████████████████████████████████████████████████████████████████" -ForegroundColor Cyan
    Write-Host "██                    🌍 ESCOLHER SERVIDOR DNS                                  ██" -ForegroundColor Cyan
    Write-Host "████████████████████████████████████████████████████████████████████████████████" -ForegroundColor Cyan
    Write-Host ""

    Write-Host "[1] Google DNS (8.8.8.8)" -ForegroundColor White
    Write-Host "[2] Cloudflare DNS (1.1.1.1)" -ForegroundColor White
    Write-Host "[3] OpenDNS (208.67.222.222)" -ForegroundColor White
    Write-Host "[4] Quad9 (9.9.9.9)" -ForegroundColor White
    Write-Host "[5] DNS Automático" -ForegroundColor White
    Write-Host "[0] Voltar" -ForegroundColor White
    Write-Host ""

    $choice = Read-Host "Digite sua escolha (0-5)"

    $primaryDNS = ""
    $secondaryDNS = ""

    switch ($choice) {
        "1" { $primaryDNS = "8.8.8.8"; $secondaryDNS = "8.8.4.4"; $dnsName = "Google DNS" }
        "2" { $primaryDNS = "1.1.1.1"; $secondaryDNS = "1.0.0.1"; $dnsName = "Cloudflare DNS" }
        "3" { $primaryDNS = "208.67.222.222"; $secondaryDNS = "208.67.220.220"; $dnsName = "OpenDNS" }
        "4" { $primaryDNS = "9.9.9.9"; $secondaryDNS = "149.112.112.112"; $dnsName = "Quad9 DNS" }
        "5" {
            Write-Host ""
            $adapters = Get-ActiveNetworkAdapters
            foreach ($adapter in $adapters) {
                Set-DnsClientServerAddress -InterfaceAlias $adapter.Name -ResetServerAddresses
                Write-Host "  ✓ DNS automático em $($adapter.Name)" -ForegroundColor Green
            }
            Write-Host ""
            Read-Host "Pressione ENTER para voltar"
            return
        }
        "0" { return }
        default {
            Write-Host "Opção inválida!" -ForegroundColor Red
            Start-Sleep -Seconds 2
            return
        }
    }

    if ($primaryDNS) {
        Write-Host ""
        Write-Host "Configurando $dnsName..." -ForegroundColor Yellow

        $adapters = Get-ActiveNetworkAdapters
        foreach ($adapter in $adapters) {
            try {
                Set-DnsClientServerAddress -InterfaceAlias $adapter.Name -ServerAddresses ($primaryDNS, $secondaryDNS)
                Write-Host "  ✓ $dnsName configurado em $($adapter.Name)" -ForegroundColor Green
            }
            catch {
                Write-Host "  ✗ Erro em $($adapter.Name)" -ForegroundColor Red
            }
        }

        Write-Host ""
        Write-Host "✅ DNS configurado!" -ForegroundColor Green
    }

    Write-Host ""
    Read-Host "Pressione ENTER para voltar"
}

function Show-AboutAuthor {
    Show-Banner
    Write-Host "████████████████████████████████████████████████████████████████████████████████" -ForegroundColor Cyan
    Write-Host "██                            SOBRE O AUTOR                                     ██" -ForegroundColor Cyan
    Write-Host "████████████████████████████████████████████████████████████████████████████████" -ForegroundColor Cyan
    Write-Host ""

    Write-Host "Script: Otimizador de Internet ULTRA" -ForegroundColor White
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
        $opcao = Read-Host "Digite sua escolha (0-8)"

        switch ($opcao) {
            "1" { Apply-NetworkOptimizations }
            "2" { Undo-NetworkOptimizations }
            "3" { Clear-DNSCache }
            "4" { Start-NetworkDiagnostics }
            "5" { Start-SpeedTest }
            "6" { Start-AdvancedRepair }
            "7" { Set-CustomDNS }
            "8" { Show-AboutAuthor }
            "0" { 
                Show-Banner
                Write-Host "════════════════════════════════════════════════════════════════════════════════" -ForegroundColor Green
                Write-Host "Obrigado por usar o Otimizador de Internet ULTRA!" -ForegroundColor White
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
