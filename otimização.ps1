#Requires -Version 5.1
#Requires -RunAsAdministrator

<#
.SYNOPSIS
    Script de Otimização Avançada do Windows para Gaming
.DESCRIPTION
    Script completo de otimização do Windows com funcionalidades avançadas:
    - Remoção de bloatware e apps desnecessários
    - Desativação de telemetria e serviços
    - Otimização de performance
    - Sistema de logging e relatórios
.NOTES
    Autor: Convertido e melhorado para PowerShell
    Versão: 2.0
#>

# ==================== CONFIGURAÇÕES GLOBAIS ====================
$ErrorActionPreference = 'SilentlyContinue'
$ProgressPreference = 'Continue'

# Caminhos
$LogPath = "$env:USERPROFILE\Desktop\WindowsOptimization_$(Get-Date -Format 'yyyyMMdd_HHmmss').log"
$BackupRegPath = "$env:USERPROFILE\Desktop\RegistryBackup_$(Get-Date -Format 'yyyyMMdd_HHmmss').reg"

# Cores
$ColorScheme = @{
    Header = 'Cyan'
    Success = 'Green'
    Warning = 'Yellow'
    Error = 'Red'
    Info = 'White'
    Highlight = 'Magenta'
}

# ==================== FUNÇÕES AUXILIARES ====================

function Write-ColorOutput {
    param(
        [Parameter(Mandatory=$true)]
        [string]$Message,
        
        [Parameter(Mandatory=$false)]
        [string]$Color = 'White',
        
        [Parameter(Mandatory=$false)]
        [switch]$NoNewline
    )
    
    $timestamp = Get-Date -Format 'HH:mm:ss'
    $logMessage = "[$timestamp] $Message"
    
    # Escreve no console com cor
    if ($NoNewline) {
        Write-Host $Message -ForegroundColor $Color -NoNewline
    } else {
        Write-Host $Message -ForegroundColor $Color
    }
    
    # Adiciona ao log
    Add-Content -Path $LogPath -Value $logMessage -ErrorAction SilentlyContinue
}

function Write-Header {
    param([string]$Title)
    
    $line = "=" * 100
    Write-ColorOutput -Message "`n$line" -Color $ColorScheme.Header
    Write-ColorOutput -Message "  $Title" -Color $ColorScheme.Header
    Write-ColorOutput -Message "$line`n" -Color $ColorScheme.Header
}

function Write-SubHeader {
    param([string]$Title)
    
    Write-ColorOutput -Message "`n>> $Title" -Color $ColorScheme.Highlight
}

function Test-Administrator {
    $currentUser = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = New-Object Security.Principal.WindowsPrincipal($currentUser)
    return $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

function Backup-RegistryKey {
    param(
        [string]$KeyPath,
        [string]$BackupFile = $BackupRegPath
    )
    
    try {
        $regExe = "reg export `"$KeyPath`" `"$BackupFile`" /y"
        Invoke-Expression $regExe | Out-Null
        return $true
    } catch {
        Write-ColorOutput -Message "  ⚠ Aviso: Não foi possível fazer backup de $KeyPath" -Color $ColorScheme.Warning
        return $false
    }
}

function Set-RegistryValue {
    param(
        [string]$Path,
        [string]$Name,
        [string]$Type,
        $Value,
        [string]$Description
    )
    
    try {
        # Cria o caminho se não existir
        if (!(Test-Path $Path)) {
            New-Item -Path $Path -Force | Out-Null
        }
        
        # Define o valor
        Set-ItemProperty -Path $Path -Name $Name -Value $Value -Type $Type -Force | Out-Null
        
        Write-ColorOutput -Message "  ✓ $Description" -Color $ColorScheme.Success
        return $true
    } catch {
        Write-ColorOutput -Message "  ✗ Falha: $Description - $($_.Exception.Message)" -Color $ColorScheme.Error
        return $false
    }
}

function Remove-RegistryKey {
    param(
        [string]$Path,
        [string]$Description
    )
    
    try {
        if (Test-Path $Path) {
            Remove-Item -Path $Path -Recurse -Force | Out-Null
            Write-ColorOutput -Message "  ✓ $Description" -Color $ColorScheme.Success
            return $true
        } else {
            Write-ColorOutput -Message "  ℹ Chave não encontrada: $Description" -Color $ColorScheme.Info
            return $false
        }
    } catch {
        Write-ColorOutput -Message "  ✗ Falha: $Description - $($_.Exception.Message)" -Color $ColorScheme.Error
        return $false
    }
}

function Set-ServiceStartup {
    param(
        [string]$ServiceName,
        [string]$StartupType,
        [string]$Description
    )
    
    try {
        $service = Get-Service -Name $ServiceName -ErrorAction SilentlyContinue
        
        if ($service) {
            Set-Service -Name $ServiceName -StartupType $StartupType -ErrorAction Stop
            Write-ColorOutput -Message "  ✓ $Description ($ServiceName -> $StartupType)" -Color $ColorScheme.Success
            return $true
        } else {
            Write-ColorOutput -Message "  ℹ Serviço não encontrado: $ServiceName" -Color $ColorScheme.Info
            return $false
        }
    } catch {
        Write-ColorOutput -Message "  ✗ Falha ao configurar $ServiceName - $($_.Exception.Message)" -Color $ColorScheme.Error
        return $false
    }
}

function Stop-ServiceSafely {
    param(
        [string]$ServiceName,
        [string]$Description
    )
    
    try {
        $service = Get-Service -Name $ServiceName -ErrorAction SilentlyContinue
        
        if ($service -and $service.Status -eq 'Running') {
            Stop-Service -Name $ServiceName -Force -ErrorAction Stop
            Write-ColorOutput -Message "  ✓ $Description parado" -Color $ColorScheme.Success
            return $true
        }
        return $false
    } catch {
        Write-ColorOutput -Message "  ✗ Falha ao parar $ServiceName" -Color $ColorScheme.Error
        return $false
    }
}

function Remove-AppxPackageSafely {
    param(
        [string]$PackageName,
        [string]$Description
    )
    
    try {
        $package = Get-AppxPackage -Name "*$PackageName*" -ErrorAction SilentlyContinue
        
        if ($package) {
            $package | Remove-AppxPackage -ErrorAction Stop
            Write-ColorOutput -Message "  ✓ Removido: $Description" -Color $ColorScheme.Success
            return $true
        } else {
            Write-ColorOutput -Message "  ℹ Não instalado: $Description" -Color $ColorScheme.Info
            return $false
        }
    } catch {
        Write-ColorOutput -Message "  ✗ Falha ao remover $Description - $($_.Exception.Message)" -Color $ColorScheme.Error
        return $false
    }
}

# ==================== FUNÇÕES PRINCIPAIS ====================

function Initialize-Script {
    Clear-Host
    
    Write-Header "SCRIPT DE OTIMIZAÇÃO AVANÇADA DO WINDOWS"
    
    Write-ColorOutput -Message "Versão: 2.0 PowerShell Edition" -Color $ColorScheme.Info
    Write-ColorOutput -Message "Data: $(Get-Date -Format 'dd/MM/yyyy HH:mm:ss')" -Color $ColorScheme.Info
    Write-ColorOutput -Message "Log será salvo em: $LogPath`n" -Color $ColorScheme.Info
    
    # Verifica privilégios de administrador
    if (-not (Test-Administrator)) {
        Write-ColorOutput -Message "❌ ERRO: Este script requer privilégios de administrador!" -Color $ColorScheme.Error
        Write-ColorOutput -Message "Por favor, execute o PowerShell como Administrador.`n" -Color $ColorScheme.Error
        pause
        exit
    }
    
    Write-ColorOutput -Message "✓ Privilégios de administrador confirmados" -Color $ColorScheme.Success
    
    # Verifica versão do Windows
    $osInfo = Get-CimInstance -ClassName Win32_OperatingSystem
    Write-ColorOutput -Message "✓ Sistema: $($osInfo.Caption) - Build $($osInfo.BuildNumber)" -Color $ColorScheme.Success
    
    Start-Sleep -Seconds 2
}

function New-RestorePoint {
    Write-Header "CRIANDO PONTO DE RESTAURAÇÃO"
    
    try {
        # Habilita a criação de pontos de restauração
        Enable-ComputerRestore -Drive "$env:SystemDrive\" -ErrorAction Stop
        
        Write-ColorOutput -Message "Criando ponto de restauração... (isso pode levar alguns minutos)" -Color $ColorScheme.Info
        
        # Cria o ponto de restauração
        Checkpoint-Computer -Description "WindowsOptimization_$(Get-Date -Format 'yyyyMMdd_HHmmss')" -RestorePointType "MODIFY_SETTINGS" -ErrorAction Stop
        
        Write-ColorOutput -Message "`n✓ Ponto de restauração criado com sucesso!" -Color $ColorScheme.Success
        Write-ColorOutput -Message "  Você pode reverter as mudanças usando 'Restauração do Sistema' no Painel de Controle.`n" -Color $ColorScheme.Info
        
        Start-Sleep -Seconds 2
        return $true
    } catch {
        Write-ColorOutput -Message "`n⚠ Aviso: Não foi possível criar o ponto de restauração" -Color $ColorScheme.Warning
        Write-ColorOutput -Message "  Erro: $($_.Exception.Message)" -Color $ColorScheme.Warning
        Write-ColorOutput -Message "  O script continuará, mas recomendamos criar um backup manual.`n" -Color $ColorScheme.Warning
        
        $continue = Read-Host "Deseja continuar mesmo assim? (S/N)"
        if ($continue -ne 'S' -and $continue -ne 's') {
            exit
        }
        return $false
    }
}

function Remove-OneDriveCompletely {
    Write-Header "REMOVENDO ONEDRIVE (MANTENDO ARQUIVOS)"
    
    $results = @{
        Success = 0
        Failed = 0
        Skipped = 0
    }
    
    Write-SubHeader "Encerrando processos do OneDrive"
    
    $onedriveProcesses = Get-Process -Name "OneDrive*" -ErrorAction SilentlyContinue
    if ($onedriveProcesses) {
        $onedriveProcesses | Stop-Process -Force -ErrorAction SilentlyContinue
        Write-ColorOutput -Message "  ✓ Processos do OneDrive encerrados" -Color $ColorScheme.Success
        $results.Success++
    } else {
        Write-ColorOutput -Message "  ℹ Nenhum processo do OneDrive em execução" -Color $ColorScheme.Info
        $results.Skipped++
    }
    
    Write-SubHeader "Desinstalando aplicativo OneDrive"
    
    $oneDriveSetupPaths = @(
        "$env:SystemRoot\System32\OneDriveSetup.exe",
        "$env:SystemRoot\SysWOW64\OneDriveSetup.exe"
    )
    
    foreach ($setupPath in $oneDriveSetupPaths) {
        if (Test-Path $setupPath) {
            try {
                Start-Process -FilePath $setupPath -ArgumentList "/uninstall" -Wait -NoNewWindow -ErrorAction Stop
                Write-ColorOutput -Message "  ✓ OneDrive desinstalado via $setupPath" -Color $ColorScheme.Success
                $results.Success++
            } catch {
                Write-ColorOutput -Message "  ✗ Falha ao desinstalar via $setupPath" -Color $ColorScheme.Error
                $results.Failed++
            }
        }
    }
    
    Write-SubHeader "Removendo chaves de registro do OneDrive"
    
    $registryKeys = @(
        "HKCR:\WOW6432Node\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}",
        "HKCR:\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}"
    )
    
    foreach ($key in $registryKeys) {
        if (Remove-RegistryKey -Path $key -Description "Chave OneDrive: $key") {
            $results.Success++
        } else {
            $results.Skipped++
        }
    }
    
    Write-ColorOutput -Message "`n✓ Remoção do OneDrive concluída!" -Color $ColorScheme.Success
    Write-ColorOutput -Message "  ℹ Seus arquivos na pasta OneDrive local foram preservados" -Color $ColorScheme.Info
    Write-ColorOutput -Message "  ℹ Arquivos na nuvem permanecem intactos`n" -Color $ColorScheme.Info
    
    return $results
}

function Remove-BloatwareApps {
    Write-Header "REMOVENDO APLICATIVOS DESNECESSÁRIOS (BLOATWARE)"
    
    $results = @{
        Success = 0
        Failed = 0
        Skipped = 0
    }
    
    # Lista de apps para remover
    $appsToRemove = @(
        @{Name="ZuneVideo"; Description="Filmes e TV"},
        @{Name="ZuneMusic"; Description="Groove Música"},
        @{Name="Microsoft.BingWeather"; Description="Clima"},
        @{Name="Microsoft.BingNews"; Description="Notícias"},
        @{Name="Microsoft.BingFinance"; Description="Finanças"},
        @{Name="Microsoft.BingSports"; Description="Esportes"},
        @{Name="Microsoft.Maps"; Description="Mapas"},
        @{Name="Microsoft.People"; Description="Pessoas"},
        @{Name="Microsoft.GetHelp"; Description="Obter Ajuda"},
        @{Name="Microsoft.Getstarted"; Description="Introdução"},
        @{Name="Microsoft.Messaging"; Description="Mensagens"},
        @{Name="Microsoft.MicrosoftSolitaireCollection"; Description="Solitaire Collection"},
        @{Name="Microsoft.MixedReality.Portal"; Description="Portal Mixed Reality"},
        @{Name="Microsoft.Office.OneNote"; Description="OneNote"},
        @{Name="Microsoft.Paint3D"; Description="Paint 3D"},
        @{Name="Microsoft.SkypeApp"; Description="Skype"},
        @{Name="Microsoft.Todos"; Description="Microsoft To Do"},
        @{Name="Microsoft.WindowsAlarms"; Description="Alarmes e Relógio"},
        @{Name="Microsoft.WindowsCamera"; Description="Câmera"},
        @{Name="microsoft.windowscommunicationsapps"; Description="Email e Calendário"},
        @{Name="Microsoft.WindowsFeedbackHub"; Description="Hub de Comentários"},
        @{Name="Microsoft.WindowsMaps"; Description="Mapas do Windows"},
        @{Name="Microsoft.WindowsSoundRecorder"; Description="Gravador de Som"},
        @{Name="Microsoft.YourPhone"; Description="Seu Telefone"},
        @{Name="Microsoft.Xbox.TCUI"; Description="Xbox TCUI"},
        @{Name="Microsoft.XboxApp"; Description="Xbox (Console Companion)"},
        @{Name="Microsoft.XboxGameOverlay"; Description="Xbox Game Overlay"},
        @{Name="Microsoft.XboxGamingOverlay"; Description="Xbox Gaming Overlay"},
        @{Name="Microsoft.XboxIdentityProvider"; Description="Xbox Identity Provider"},
        @{Name="Microsoft.XboxSpeechToTextOverlay"; Description="Xbox Speech to Text"}
    )
    
    $totalApps = $appsToRemove.Count
    $currentApp = 0
    
    foreach ($app in $appsToRemove) {
        $currentApp++
        $percentComplete = ($currentApp / $totalApps) * 100
        
        Write-Progress -Activity "Removendo Bloatware" -Status "Processando: $($app.Description)" -PercentComplete $percentComplete
        
        if (Remove-AppxPackageSafely -PackageName $app.Name -Description $app.Description) {
            $results.Success++
        } else {
            $results.Skipped++
        }
        
        Start-Sleep -Milliseconds 100
    }
    
    Write-Progress -Activity "Removendo Bloatware" -Completed
    
    Write-ColorOutput -Message "`n✓ Remoção de bloatware concluída!" -Color $ColorScheme.Success
    Write-ColorOutput -Message "  Removidos: $($results.Success) | Não instalados: $($results.Skipped) | Falhas: $($results.Failed)`n" -Color $ColorScheme.Info
    
    return $results
}

function Optimize-Privacy {
    Write-Header "OTIMIZANDO CONFIGURAÇÕES DE PRIVACIDADE"
    
    $results = @{
        Success = 0
        Failed = 0
    }
    
    Write-SubHeader "Desabilitando Telemetria e Coleta de Dados"
    
    $privacySettings = @(
        @{Path="HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection"; Name="AllowTelemetry"; Type="DWord"; Value=0; Description="Telemetria desabilitada"},
        @{Path="HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection"; Name="CommercialDataOptIn"; Type="DWord"; Value=0; Description="Dados comerciais desabilitados"},
        @{Path="HKLM:\SOFTWARE\Policies\Microsoft\Windows\AppCompat"; Name="DisableInventory"; Type="DWord"; Value=1; Description="Inventário de apps desabilitado"},
        @{Path="HKLM:\SOFTWARE\Policies\Microsoft\Windows\AppCompat"; Name="DisableEngine"; Type="DWord"; Value=1; Description="Motor de compatibilidade desabilitado"},
        @{Path="HKLM:\SOFTWARE\Policies\Microsoft\Windows\AppCompat"; Name="DisableUAR"; Type="DWord"; Value=1; Description="UAR desabilitado"},
        @{Path="HKLM:\SOFTWARE\Policies\Microsoft\Windows\AppCompat"; Name="AITEnable"; Type="DWord"; Value=0; Description="AIT desabilitado"}
    )
    
    foreach ($setting in $privacySettings) {
        if (Set-RegistryValue @setting) {
            $results.Success++
        } else {
            $results.Failed++
        }
    }
    
    Write-SubHeader "Desabilitando Dicas e Sugestões"
    
    $tipsSettings = @(
        @{Path="HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager"; Name="SubscribedContent-338387Enabled"; Type="DWord"; Value=0; Description="Dicas na tela de bloqueio"},
        @{Path="HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager"; Name="SubscribedContent-338388Enabled"; Type="DWord"; Value=0; Description="Sugestões no menu Iniciar"},
        @{Path="HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager"; Name="SubscribedContent-338389Enabled"; Type="DWord"; Value=0; Description="Dicas do Windows"},
        @{Path="HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager"; Name="SubscribedContent-338393Enabled"; Type="DWord"; Value=0; Description="Sugestões de configurações"},
        @{Path="HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager"; Name="SubscribedContent-353694Enabled"; Type="DWord"; Value=0; Description="Conteúdo sugerido"},
        @{Path="HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager"; Name="SubscribedContent-353696Enabled"; Type="DWord"; Value=0; Description="Conteúdo sugerido (2)"},
        @{Path="HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager"; Name="SystemPaneSuggestionsEnabled"; Type="DWord"; Value=0; Description="Sugestões no painel do sistema"}
    )
    
    foreach ($setting in $tipsSettings) {
        if (Set-RegistryValue @setting) {
            $results.Success++
        } else {
            $results.Failed++
        }
    }
    
    Write-SubHeader "Desabilitando Publicidade Personalizada"
    
    $adSettings = @(
        @{Path="HKCU:\Software\Microsoft\Windows\CurrentVersion\Privacy"; Name="TailoredExperiencesWithDiagnosticDataEnabled"; Type="DWord"; Value=0; Description="Experiências personalizadas"},
        @{Path="HKCU:\Software\Microsoft\Windows\CurrentVersion\AdvertisingInfo"; Name="Enabled"; Type="DWord"; Value=0; Description="ID de publicidade"},
        @{Path="HKLM:\SOFTWARE\Policies\Microsoft\Windows\AdvertisingInfo"; Name="DisabledByGroupPolicy"; Type="DWord"; Value=1; Description="Publicidade via política de grupo"}
    )
    
    foreach ($setting in $adSettings) {
        if (Set-RegistryValue @setting) {
            $results.Success++
        } else {
            $results.Failed++
        }
    }
    
    Write-ColorOutput -Message "`n✓ Otimizações de privacidade concluídas!" -Color $ColorScheme.Success
    Write-ColorOutput -Message "  Configurações aplicadas: $($results.Success) | Falhas: $($results.Failed)`n" -Color $ColorScheme.Info
    
    return $results
}

function Optimize-Services {
    Write-Header "OTIMIZANDO SERVIÇOS DO WINDOWS"
    
    $results = @{
        Success = 0
        Failed = 0
        Skipped = 0
    }
    
    Write-ColorOutput -Message "Configurando serviços para inicialização manual ou desabilitada...`n" -Color $ColorScheme.Info
    
    # Lista de serviços para otimizar
    $servicesToOptimize = @(
        @{Name="AJRouter"; StartupType="Disabled"; Description="AllJoyn Router Service"},
        @{Name="ALG"; StartupType="Manual"; Description="Application Layer Gateway Service"},
        @{Name="AppIDSvc"; StartupType="Manual"; Description="Application Identity"},
        @{Name="Appinfo"; StartupType="Manual"; Description="Application Information"},
        @{Name="AppReadiness"; StartupType="Manual"; Description="App Readiness"},
        @{Name="AppVClient"; StartupType="Disabled"; Description="Microsoft App-V Client"},
        @{Name="AppXSvc"; StartupType="Manual"; Description="AppX Deployment Service"},
        @{Name="BITS"; StartupType="Manual"; Description="Background Intelligent Transfer Service"},
        @{Name="Browser"; StartupType="Disabled"; Description="Computer Browser"},
        @{Name="BthAvctpSvc"; StartupType="Manual"; Description="AVCTP service"},
        @{Name="bthserv"; StartupType="Manual"; Description="Bluetooth Support Service"},
        @{Name="camsvc"; StartupType="Manual"; Description="Capability Access Manager Service"},
        @{Name="cbdhsvc"; StartupType="Manual"; Description="Clipboard User Service"},
        @{Name="cloudidsvc"; StartupType="Manual"; Description="Microsoft Cloud Identity Service"},
        @{Name="dcsvc"; StartupType="Manual"; Description="Declared Configuration Service"},
        @{Name="defragsvc"; StartupType="Manual"; Description="Optimize Drives"},
        @{Name="diagnosticshub.standardcollector.service"; StartupType="Manual"; Description="Diagnostics Hub Standard Collector"},
        @{Name="DiagSvc"; StartupType="Manual"; Description="Diagnostic Execution Service"},
        @{Name="dmwappushservice"; StartupType="Disabled"; Description="Device Management Wireless Application Protocol"},
        @{Name="dot3svc"; StartupType="Manual"; Description="Wired AutoConfig"},
        @{Name="DPS"; StartupType="Automatic"; Description="Diagnostic Policy Service (manter auto)"},
        @{Name="edgeupdate"; StartupType="Manual"; Description="Microsoft Edge Update Service"},
        @{Name="edgeupdatem"; StartupType="Manual"; Description="Microsoft Edge Update Service (edgeupdatem)"},
        @{Name="embeddedmode"; StartupType="Manual"; Description="Embedded Mode"},
        @{Name="fdPHost"; StartupType="Manual"; Description="Function Discovery Provider Host"},
        @{Name="FDResPub"; StartupType="Manual"; Description="Function Discovery Resource Publication"},
        @{Name="fhsvc"; StartupType="Manual"; Description="File History Service"},
        @{Name="HvHost"; StartupType="Manual"; Description="HV Host Service"},
        @{Name="icssvc"; StartupType="Manual"; Description="Windows Mobile Hotspot Service"},
        @{Name="lfsvc"; StartupType="Manual"; Description="Geolocation Service"},
        @{Name="lltdsvc"; StartupType="Manual"; Description="Link-Layer Topology Discovery Mapper"},
        @{Name="lmhosts"; StartupType="Manual"; Description="TCP/IP NetBIOS Helper"},
        @{Name="MapsBroker"; StartupType="Disabled"; Description="Downloaded Maps Manager"},
        @{Name="MessagingService"; StartupType="Manual"; Description="Messaging Service"},
        @{Name="MSiSCSI"; StartupType="Manual"; Description="Microsoft iSCSI Initiator Service"},
        @{Name="msiserver"; StartupType="Manual"; Description="Windows Installer"},
        @{Name="NcbService"; StartupType="Manual"; Description="Network Connection Broker"},
        @{Name="Netlogon"; StartupType="Manual"; Description="Netlogon"},
        @{Name="Netman"; StartupType="Manual"; Description="Network Connections"},
        @{Name="netprofm"; StartupType="Manual"; Description="Network List Service"},
        @{Name="NetTcpPortSharing"; StartupType="Disabled"; Description="Net.Tcp Port Sharing Service"},
        @{Name="p2pimsvc"; StartupType="Manual"; Description="Peer Networking Identity Manager"},
        @{Name="p2psvc"; StartupType="Manual"; Description="Peer Networking Grouping"},
        @{Name="PcaSvc"; StartupType="Automatic"; Description="Program Compatibility Assistant (manter auto)"},
        @{Name="PerfHost"; StartupType="Manual"; Description="Performance Counter DLL Host"},
        @{Name="PhoneSvc"; StartupType="Manual"; Description="Phone Service"},
        @{Name="pla"; StartupType="Manual"; Description="Performance Logs & Alerts"},
        @{Name="PNRPAutoReg"; StartupType="Manual"; Description="PNRP Machine Name Publication Service"},
        @{Name="PNRPsvc"; StartupType="Manual"; Description="Peer Name Resolution Protocol"},
        @{Name="PrintNotify"; StartupType="Manual"; Description="Printer Extensions and Notifications"},
        @{Name="QWAVE"; StartupType="Manual"; Description="Quality Windows Audio Video Experience"},
        @{Name="RemoteAccess"; StartupType="Disabled"; Description="Routing and Remote Access"},
        @{Name="RemoteRegistry"; StartupType="Disabled"; Description="Remote Registry"},
        @{Name="RetailDemo"; StartupType="Disabled"; Description="Retail Demo Service"},
        @{Name="RmSvc"; StartupType="Manual"; Description="Radio Management Service"},
        @{Name="seclogon"; StartupType="Manual"; Description="Secondary Logon"},
        @{Name="SensorDataService"; StartupType="Manual"; Description="Sensor Data Service"},
        @{Name="SensorService"; StartupType="Manual"; Description="Sensor Service"},
        @{Name="SensrSvc"; StartupType="Manual"; Description="Sensor Monitoring Service"},
        @{Name="SessionEnv"; StartupType="Manual"; Description="Remote Desktop Configuration"},
        @{Name="SharedAccess"; StartupType="Manual"; Description="Internet Connection Sharing (ICS)"},
        @{Name="ShellHWDetection"; StartupType="Automatic"; Description="Shell Hardware Detection (manter auto)"},
        @{Name="shpamsvc"; StartupType="Disabled"; Description="Shared PC Account Manager"},
        @{Name="smphost"; StartupType="Manual"; Description="Microsoft Storage Spaces SMP"},
        @{Name="SNMPTRAP"; StartupType="Manual"; Description="SNMP Trap"},
        @{Name="spectrum"; StartupType="Manual"; Description="Windows Perception Service"},
        @{Name="SSDPSRV"; StartupType="Manual"; Description="SSDP Discovery"},
        @{Name="ssh-agent"; StartupType="Disabled"; Description="OpenSSH Authentication Agent"},
        @{Name="SstpSvc"; StartupType="Manual"; Description="Secure Socket Tunneling Protocol Service"},
        @{Name="stisvc"; StartupType="Automatic"; Description="Windows Image Acquisition (manter auto)"},
        @{Name="StorSvc"; StartupType="Manual"; Description="Storage Service"},
        @{Name="svsvc"; StartupType="Manual"; Description="Spot Verifier"},
        @{Name="swprv"; StartupType="Manual"; Description="Microsoft Software Shadow Copy Provider"},
        @{Name="SysMain"; StartupType="Disabled"; Description="SysMain (Superfetch/Prefetch)"},
        @{Name="TabletInputService"; StartupType="Manual"; Description="Touch Keyboard and Handwriting Panel Service"},
        @{Name="TapiSrv"; StartupType="Manual"; Description="Telephony"},
        @{Name="TermService"; StartupType="Manual"; Description="Remote Desktop Services"},
        @{Name="TrkWks"; StartupType="Automatic"; Description="Distributed Link Tracking Client (manter auto)"},
        @{Name="TrustedInstaller"; StartupType="Manual"; Description="Windows Modules Installer"},
        @{Name="tzautoupdate"; StartupType="Disabled"; Description="Auto Time Zone Updater"},
        @{Name="UevAgentService"; StartupType="Disabled"; Description="User Experience Virtualization Service"},
        @{Name="upnphost"; StartupType="Manual"; Description="UPnP Device Host"},
        @{Name="VaultSvc"; StartupType="Manual"; Description="Credential Manager"},
        @{Name="vds"; StartupType="Manual"; Description="Virtual Disk"},
        @{Name="vmicguestinterface"; StartupType="Manual"; Description="Hyper-V Guest Service Interface"},
        @{Name="vmicheartbeat"; StartupType="Manual"; Description="Hyper-V Heartbeat Service"},
        @{Name="vmickvpexchange"; StartupType="Manual"; Description="Hyper-V Data Exchange Service"},
        @{Name="vmicrdv"; StartupType="Manual"; Description="Hyper-V Remote Desktop Virtualization Service"},
        @{Name="vmicshutdown"; StartupType="Manual"; Description="Hyper-V Guest Shutdown Service"},
        @{Name="vmictimesync"; StartupType="Manual"; Description="Hyper-V Time Synchronization Service"},
        @{Name="vmicvmsession"; StartupType="Manual"; Description="Hyper-V PowerShell Direct Service"},
        @{Name="vmicvss"; StartupType="Manual"; Description="Hyper-V Volume Shadow Copy Requestor"},
        @{Name="vmvss"; StartupType="Manual"; Description="Hyper-V Virtual Machine Management"},
        @{Name="VSS"; StartupType="Manual"; Description="Volume Shadow Copy"},
        @{Name="W32Time"; StartupType="Manual"; Description="Windows Time"},
        @{Name="WalletService"; StartupType="Disabled"; Description="WalletService"},
        @{Name="WbioSrvc"; StartupType="Manual"; Description="Windows Biometric Service"},
        @{Name="Wcmsvc"; StartupType="Automatic"; Description="Windows Connection Manager (manter auto)"},
        @{Name="wcncsvc"; StartupType="Manual"; Description="Windows Connect Now - Config Registrar"},
        @{Name="WdiServiceHost"; StartupType="Manual"; Description="Diagnostic Service Host"},
        @{Name="WdiSystemHost"; StartupType="Manual"; Description="Diagnostic System Host"},
        @{Name="WebClient"; StartupType="Manual"; Description="WebClient"},
        @{Name="Wecsvc"; StartupType="Manual"; Description="Windows Event Collector"},
        @{Name="WEPHOSTSVC"; StartupType="Manual"; Description="Windows Encryption Provider Host Service"},
        @{Name="wercplsupport"; StartupType="Manual"; Description="Problem Reports and Solutions Control Panel Support"},
        @{Name="WerSvc"; StartupType="Manual"; Description="Windows Error Reporting Service"},
        @{Name="WiaRpc"; StartupType="Manual"; Description="Still Image Acquisition Events"},
        @{Name="WinHttpAutoProxySvc"; StartupType="Manual"; Description="WinHTTP Web Proxy Auto-Discovery Service"},
        @{Name="WinRM"; StartupType="Manual"; Description="Windows Remote Management (WS-Management)"},
        @{Name="wisvc"; StartupType="Manual"; Description="Windows Insider Service"},
        @{Name="wlidsvc"; StartupType="Manual"; Description="Microsoft Account Sign-in Assistant"},
        @{Name="wlpasvc"; StartupType="Manual"; Description="Local Profile Assistant Service"},
        @{Name="WManSvc"; StartupType="Manual"; Description="Windows Management Service"},
        @{Name="wmiApSrv"; StartupType="Manual"; Description="WMI Performance Adapter"},
        @{Name="WMPNetworkSvc"; StartupType="Manual"; Description="Windows Media Player Network Sharing Service"},
        @{Name="workfolderssvc"; StartupType="Manual"; Description="Work Folders"},
        @{Name="WPDBusEnum"; StartupType="Manual"; Description="Portable Device Enumerator Service"},
        @{Name="WpnService"; StartupType="Automatic"; Description="Windows Push Notifications System Service (manter auto)"},
        @{Name="WpnUserService"; StartupType="Automatic"; Description="Windows Push Notifications User Service (manter auto)"},
        @{Name="wscsvc"; StartupType="Automatic"; Description="Security Center (manter auto)"},
        @{Name="WSearch"; StartupType="Automatic"; Description="Windows Search (manter auto)"},
        @{Name="wuauserv"; StartupType="Manual"; Description="Windows Update"},
        @{Name="wudfsvc"; StartupType="Manual"; Description="Windows Driver Foundation - User-mode Driver Framework"},
        @{Name="XblAuthManager"; StartupType="Disabled"; Description="Xbox Live Auth Manager"},
        @{Name="XblGameSave"; StartupType="Disabled"; Description="Xbox Live Game Save"},
        @{Name="XboxGipSvc"; StartupType="Manual"; Description="Xbox Accessory Management Service"},
        @{Name="XboxNetApiSvc"; StartupType="Disabled"; Description="Xbox Live Networking Service"}
    )
    
    $totalServices = $servicesToOptimize.Count
    $currentService = 0
    
    foreach ($service in $servicesToOptimize) {
        $currentService++
        $percentComplete = ($currentService / $totalServices) * 100
        
        Write-Progress -Activity "Otimizando Serviços" -Status "Processando: $($service.Description)" -PercentComplete $percentComplete
        
        if (Set-ServiceStartup -ServiceName $service.Name -StartupType $service.StartupType -Description $service.Description) {
            $results.Success++
        } else {
            $results.Skipped++
        }
        
        Start-Sleep -Milliseconds 50
    }
    
    Write-Progress -Activity "Otimizando Serviços" -Completed
    
    Write-ColorOutput -Message "`n✓ Otimização de serviços concluída!" -Color $ColorScheme.Success
    Write-ColorOutput -Message "  Configurados: $($results.Success) | Não encontrados: $($results.Skipped) | Falhas: $($results.Failed)`n" -Color $ColorScheme.Info
    
    return $results
}

function Optimize-WindowsDefender {
    Write-Header "OTIMIZANDO WINDOWS DEFENDER"
    
    $results = @{
        Success = 0
        Failed = 0
    }
    
    Write-ColorOutput -Message "Limitando uso de CPU do Windows Defender para 25%...`n" -Color $ColorScheme.Info
    
    $defenderSettings = @(
        @{Path="HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender\Scan"; Name="AvgCPULoadFactor"; Type="DWord"; Value=25; Description="Limite de CPU do Defender (25%)"},
        @{Path="HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender\Scan"; Name="DisableCatchupFullScan"; Type="DWord"; Value=1; Description="Desabilitar varredura completa de recuperação"},
        @{Path="HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender\Scan"; Name="DisableCatchupQuickScan"; Type="DWord"; Value=1; Description="Desabilitar varredura rápida de recuperação"}
    )
    
    foreach ($setting in $defenderSettings) {
        if (Set-RegistryValue @setting) {
            $results.Success++
        } else {
            $results.Failed++
        }
    }
    
    Write-ColorOutput -Message "`n✓ Windows Defender otimizado!" -Color $ColorScheme.Success
    Write-ColorOutput -Message "  Configurações aplicadas: $($results.Success) | Falhas: $($results.Failed)`n" -Color $ColorScheme.Info
    
    return $results
}

function Optimize-VisualEffects {
    Write-Header "OTIMIZANDO EFEITOS VISUAIS PARA DESEMPENHO"
    
    $results = @{
        Success = 0
        Failed = 0
    }
    
    Write-ColorOutput -Message "Configurando para melhor desempenho...`n" -Color $ColorScheme.Info
    
    $visualSettings = @(
        @{Path="HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects"; Name="VisualFXSetting"; Type="DWord"; Value=2; Description="Ajustar para melhor desempenho"},
        @{Path="HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"; Name="ListviewAlphaSelect"; Type="DWord"; Value=0; Description="Desabilitar seleção alpha"},
        @{Path="HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"; Name="TaskbarAnimations"; Type="DWord"; Value=0; Description="Desabilitar animações da barra de tarefas"},
        @{Path="HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"; Name="IconsOnly"; Type="DWord"; Value=1; Description="Mostrar apenas ícones (sem miniaturas)"},
        @{Path="HKCU:\Control Panel\Desktop"; Name="DragFullWindows"; Type="String"; Value="0"; Description="Desabilitar arrasto de janelas completas"},
        @{Path="HKCU:\Control Panel\Desktop"; Name="FontSmoothing"; Type="String"; Value="2"; Description="Habilitar ClearType"},
        @{Path="HKCU:\Control Panel\Desktop"; Name="FontSmoothingType"; Type="DWord"; Value=2; Description="Tipo de suavização de fonte"},
        @{Path="HKCU:\Control Panel\Desktop"; Name="UserPreferencesMask"; Type="Binary"; Value=([byte[]](0x90,0x12,0x03,0x80,0x10,0x00,0x00,0x00)); Description="Máscara de preferências do usuário"},
        @{Path="HKCU:\Control Panel\Desktop\WindowMetrics"; Name="MinAnimate"; Type="String"; Value="0"; Description="Desabilitar animação de minimizar/maximizar"},
        @{Path="HKCU:\Software\Microsoft\Windows\DWM"; Name="EnableAeroPeek"; Type="DWord"; Value=0; Description="Desabilitar Aero Peek"},
        @{Path="HKCU:\Software\Microsoft\Windows\DWM"; Name="AlwaysHibernateThumbnails"; Type="DWord"; Value=0; Description="Não hibernar miniaturas"},
        @{Path="HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"; Name="DisallowShaking"; Type="DWord"; Value=1; Description="Desabilitar Aero Shake"}
    )
    
    foreach ($setting in $visualSettings) {
        if (Set-RegistryValue @setting) {
            $results.Success++
        } else {
            $results.Failed++
        }
    }
    
    Write-ColorOutput -Message "`n✓ Efeitos visuais otimizados!" -Color $ColorScheme.Success
    Write-ColorOutput -Message "  Configurações aplicadas: $($results.Success) | Falhas: $($results.Failed)`n" -Color $ColorScheme.Info
    
    return $results
}

function Optimize-SystemSettings {
    Write-Header "OTIMIZAÇÕES ADICIONAIS DO SISTEMA"
    
    $results = @{
        Success = 0
        Failed = 0
    }
    
    Write-SubHeader "Desabilitando Sensor de Armazenamento"
    if (Set-RegistryValue -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\StorageSense\Parameters\StoragePolicy" -Name "01" -Type "DWord" -Value 0 -Description "Sensor de Armazenamento desabilitado") {
        $results.Success++
    } else {
        $results.Failed++
    }
    
    Write-SubHeader "Desabilitando Hibernação"
    try {
        powercfg.exe /hibernate off | Out-Null
        Write-ColorOutput -Message "  ✓ Hibernação desabilitada" -Color $ColorScheme.Success
        $results.Success++
    } catch {
        Write-ColorOutput -Message "  ✗ Falha ao desabilitar hibernação" -Color $ColorScheme.Error
        $results.Failed++
    }
    
    Write-SubHeader "Desabilitando Snap Assist"
    if (Set-RegistryValue -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "EnableSnapAssistFlyout" -Type "DWord" -Value 0 -Description "Snap Assist desabilitado") {
        $results.Success++
    } else {
        $results.Failed++
    }
    
    Write-SubHeader "Otimizando Configurações de Rede"
    $networkSettings = @(
        @{Path="HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters"; Name="TcpAckFrequency"; Type="DWord"; Value=1; Description="TCP ACK Frequency otimizado"},
        @{Path="HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters"; Name="TCPNoDelay"; Type="DWord"; Value=1; Description="TCP No Delay habilitado"},
        @{Path="HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters"; Name="TcpDelAckTicks"; Type="DWord"; Value=0; Description="TCP Delayed ACK otimizado"}
    )
    
    foreach ($setting in $networkSettings) {
        if (Set-RegistryValue @setting) {
            $results.Success++
        } else {
            $results.Failed++
        }
    }
    
    Write-SubHeader "Limpando Arquivos Temporários"
    
    $tempPaths = @(
        "$env:TEMP",
        "$env:SystemRoot\Temp",
        "$env:SystemRoot\Prefetch"
    )
    
    $totalCleaned = 0
    foreach ($path in $tempPaths) {
        if (Test-Path $path) {
            try {
                $filesBefore = (Get-ChildItem -Path $path -Recurse -Force -ErrorAction SilentlyContinue | Measure-Object).Count
                Get-ChildItem -Path $path -Recurse -Force -ErrorAction SilentlyContinue | Remove-Item -Force -Recurse -ErrorAction SilentlyContinue
                $filesAfter = (Get-ChildItem -Path $path -Recurse -Force -ErrorAction SilentlyContinue | Measure-Object).Count
                $cleaned = $filesBefore - $filesAfter
                $totalCleaned += $cleaned
                Write-ColorOutput -Message "  ✓ Limpo: $path ($cleaned arquivos)" -Color $ColorScheme.Success
                $results.Success++
            } catch {
                Write-ColorOutput -Message "  ⚠ Aviso: Alguns arquivos em $path não puderam ser removidos" -Color $ColorScheme.Warning
            }
        }
    }
    
    Write-ColorOutput -Message "`n  Total de arquivos temporários removidos: $totalCleaned" -Color $ColorScheme.Info
    
    Write-ColorOutput -Message "`n✓ Otimizações adicionais concluídas!" -Color $ColorScheme.Success
    Write-ColorOutput -Message "  Operações bem-sucedidas: $($results.Success) | Falhas: $($results.Failed)`n" -Color $ColorScheme.Info
    
    return $results
}

function Show-FinalReport {
    param(
        [hashtable]$AllResults
    )
    
    Write-Header "RELATÓRIO FINAL DE OTIMIZAÇÃO"
    
    $totalSuccess = 0
    $totalFailed = 0
    $totalSkipped = 0
    
    Write-ColorOutput -Message "Resumo das operações realizadas:`n" -Color $ColorScheme.Info
    
    foreach ($key in $AllResults.Keys) {
        $result = $AllResults[$key]
        
        Write-ColorOutput -Message "[$key]" -Color $ColorScheme.Highlight
        Write-ColorOutput -Message "  ✓ Sucesso: $($result.Success)" -Color $ColorScheme.Success
        if ($result.ContainsKey('Failed')) {
            Write-ColorOutput -Message "  ✗ Falhas: $($result.Failed)" -Color $ColorScheme.Error
        }
        if ($result.ContainsKey('Skipped')) {
            Write-ColorOutput -Message "  ℹ Ignorados: $($result.Skipped)" -Color $ColorScheme.Info
        }
        Write-Host ""
        
        $totalSuccess += $result.Success
        if ($result.ContainsKey('Failed')) { $totalFailed += $result.Failed }
        if ($result.ContainsKey('Skipped')) { $totalSkipped += $result.Skipped }
    }
    
    Write-ColorOutput -Message "═══════════════════════════════════════════════════════════" -Color $ColorScheme.Header
    Write-ColorOutput -Message "TOTAL GERAL:" -Color $ColorScheme.Highlight
    Write-ColorOutput -Message "  ✓ Operações bem-sucedidas: $totalSuccess" -Color $ColorScheme.Success
    Write-ColorOutput -Message "  ✗ Operações com falha: $totalFailed" -Color $ColorScheme.Error
    Write-ColorOutput -Message "  ℹ Operações ignoradas: $totalSkipped" -Color $ColorScheme.Info
    Write-ColorOutput -Message "═══════════════════════════════════════════════════════════`n" -Color $ColorScheme.Header
    
    Write-ColorOutput -Message "Log completo salvo em: $LogPath" -Color $ColorScheme.Info
    
    if ($totalFailed -gt 0) {
        Write-ColorOutput -Message "`n⚠ Algumas operações falharam. Verifique o log para mais detalhes." -Color $ColorScheme.Warning
    }
    
    Write-ColorOutput -Message "`n✓ Otimização concluída com sucesso!" -Color $ColorScheme.Success
    Write-ColorOutput -Message "  Recomendamos reiniciar o computador para aplicar todas as mudanças.`n" -Color $ColorScheme.Info
}

function Show-Menu {
    Clear-Host
    Write-Header "MENU DE OTIMIZAÇÃO"
    
    Write-ColorOutput -Message "Escolha uma opção:`n" -Color $ColorScheme.Info
    Write-ColorOutput -Message "[1] Otimização COMPLETA (remove OneDrive e bloatware)" -Color $ColorScheme.Highlight
    Write-ColorOutput -Message "[2] Otimização BÁSICA (ignora OneDrive e bloatware)" -Color $ColorScheme.Highlight
    Write-ColorOutput -Message "[3] Apenas remover OneDrive" -Color $ColorScheme.Highlight
    Write-ColorOutput -Message "[4] Apenas remover Bloatware" -Color $ColorScheme.Highlight
    Write-ColorOutput -Message "[5] Apenas otimizar Privacidade" -Color $ColorScheme.Highlight
    Write-ColorOutput -Message "[6] Apenas otimizar Serviços" -Color $ColorScheme.Highlight
    Write-ColorOutput -Message "[7] Apenas otimizar Efeitos Visuais" -Color $ColorScheme.Highlight
    Write-ColorOutput -Message "[8] Sair`n" -Color $ColorScheme.Highlight
    
    $choice = Read-Host "Digite sua escolha (1-8)"
    return $choice
}

# ==================== EXECUÇÃO PRINCIPAL ====================

# Inicializa o script
Initialize-Script

# Cria ponto de restauração
New-RestorePoint

# Variável para armazenar todos os resultados
$allResults = @{}

# Menu principal
do {
    $choice = Show-Menu
    
    switch ($choice) {
        "1" {
            # Otimização completa
            $allResults["OneDrive"] = Remove-OneDriveCompletely
            $allResults["Bloatware"] = Remove-BloatwareApps
            $allResults["Privacidade"] = Optimize-Privacy
            $allResults["Serviços"] = Optimize-Services
            $allResults["Defender"] = Optimize-WindowsDefender
            $allResults["Efeitos Visuais"] = Optimize-VisualEffects
            $allResults["Sistema"] = Optimize-SystemSettings
            
            Show-FinalReport -AllResults $allResults
            
            Write-ColorOutput -Message "`nO Explorer será reiniciado para aplicar as mudanças..." -Color $ColorScheme.Warning
            Start-Sleep -Seconds 3
            
            Stop-Process -Name explorer -Force -ErrorAction SilentlyContinue
            Start-Process explorer
            
            pause
            exit
        }
        "2" {
            # Otimização básica (sem OneDrive e bloatware)
            $allResults["Privacidade"] = Optimize-Privacy
            $allResults["Serviços"] = Optimize-Services
            $allResults["Defender"] = Optimize-WindowsDefender
            $allResults["Efeitos Visuais"] = Optimize-VisualEffects
            $allResults["Sistema"] = Optimize-SystemSettings
            
            Show-FinalReport -AllResults $allResults
            
            Write-ColorOutput -Message "`nO Explorer será reiniciado para aplicar as mudanças..." -Color $ColorScheme.Warning
            Start-Sleep -Seconds 3
            
            Stop-Process -Name explorer -Force -ErrorAction SilentlyContinue
            Start-Process explorer
            
            pause
            exit
        }
        "3" {
            # Apenas OneDrive
            $allResults["OneDrive"] = Remove-OneDriveCompletely
            Show-FinalReport -AllResults $allResults
            pause
        }
        "4" {
            # Apenas Bloatware
            $allResults["Bloatware"] = Remove-BloatwareApps
            Show-FinalReport -AllResults $allResults
            pause
        }
        "5" {
            # Apenas Privacidade
            $allResults["Privacidade"] = Optimize-Privacy
            Show-FinalReport -AllResults $allResults
            pause
        }
        "6" {
            # Apenas Serviços
            $allResults["Serviços"] = Optimize-Services
            Show-FinalReport -AllResults $allResults
            pause
        }
        "7" {
            # Apenas Efeitos Visuais
            $allResults["Efeitos Visuais"] = Optimize-VisualEffects
            Show-FinalReport -AllResults $allResults
            pause
        }
        "8" {
            Write-ColorOutput -Message "`nSaindo..." -Color $ColorScheme.Info
            exit
        }
        default {
            Write-ColorOutput -Message "`n✗ Opção inválida! Por favor, escolha entre 1 e 8.`n" -Color $ColorScheme.Error
            Start-Sleep -Seconds 2
        }
    }
} while ($true)
