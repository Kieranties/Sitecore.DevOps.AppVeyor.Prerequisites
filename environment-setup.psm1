Function CheckAdmin() {
    $elevated = [bool](([System.Security.Principal.WindowsIdentity]::GetCurrent()).groups -match "S-1-5-32-544")
    if ($elevated -eq $false)
    {
        throw "Please run this script as an administrator"
    }
}

Function CheckLicense(
  [Parameter(Mandatory=$true)] [string]$LicenseFileUrl,
  [Parameter(Mandatory=$true)] [string]$LicenseFile
) {
    Write-Host "CheckLicense $LicenseFile"
    (New-Object System.Net.WebClient).DownloadFile($LicenseFileUrl, $LicenseFile)
    if (!(Test-Path $LicenseFile)) {
        throw "LicenseFile did not download successfully"
    }
}

Function RegisterSitecoreGallery() {
    Get-PackageProvider -Name Nuget -ForceBootstrap
    Register-PSRepository -Name "SitecoreGallery" `
                          -SourceLocation "https://sitecore.myget.org/F/sc-powershell/api/v2" `
                          -InstallationPolicy Trusted | Out-Null

    Write-Host ("PowerShell repository `"SitecoreGallery`" has been registered.") -ForegroundColor Green
}

Function InstallLatestSqlServerModule() {
    $localSqlServerModule = Get-InstalledModule | Where-Object { $_.Name -eq "SqlServer" }
    if(!($localSqlServerModule))
    {
        Install-module -Name "SqlServer" -Scope AllUsers -Force -SkipPublisherCheck -AllowClobber | Out-Null
        Write-Host ("SqlServer module installed") -ForegroundColor Green
    }
    else
    {
        $latestSqlServerModule = Find-Module -Name "SqlServer"
        $localSqlServerModuleByVersion = Get-InstalledModule | Where-Object {($_.Name -eq "SqlServer") -and ($_.Version -eq $latestSqlServerModule.Version)}
        if($localSqlServerModuleByVersion -eq $null)
        {
            Install-module -Name "SqlServer" -Scope AllUsers -RequiredVersion $latestSqlServerModule.Version -Force -SkipPublisherCheck -AllowClobber | Out-Null
            Write-Host ("SqlServer module updated") -ForegroundColor Green
        }
    }
}

Function InstallLatestSitecoreInstallationFramework() {
    if(!(Get-InstalledModule | Where-Object { $_.Name -eq "SitecoreInstallFramework" })) {
        Install-Module -Name "SitecoreInstallFramework" -Repository "SitecoreGallery" -Force -Scope AllUsers -SkipPublisherCheck -AllowClobber | Out-Null
        Write-Host ("Module `"SitecoreInstallFramework`" has been installed.") -ForegroundColor Green
    } else {
        [array] $sifModules = Find-Module -Name "SitecoreInstallFramework" -Repository "SitecoreGallery"
        $latestSIFModule = $sifModules[-1]
        $localSIFModuleByVersion = Get-InstalledModule | Where-Object { ($_.Name -eq "SitecoreInstallFramework") -and ($_.Version -eq $latestSIFModule.Version) }
        if($localSIFModuleByVersion -eq $null) {
            Install-module -Name "SitecoreInstallFramework" -Repository "SitecoreGallery" -Scope AllUsers -RequiredVersion $latestSIFModule.Version -Force -SkipPublisherCheck -AllowClobber | Out-Null
            Write-Host ("Module `"SitecoreInstallFramework`" has been updated.") -ForegroundColor Green
        }
    }
}

Function EnableModernSecurityProtocols() {
    Write-Host "Enabling modern security protocols..." -foregroundcolor "green"
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]'Ssl3,Tls,Tls11,Tls12'
}

Function InstallUrlRewriteModule() {
    choco install -y urlrewrite
}

Function RefreshEnvironmentVariables() {
    refreshenv
    $env:PSModulePath = [Environment]::GetEnvironmentVariable('PSModulePath', 'Machine')
}