param
(
 [Parameter(Mandatory=$false)] [string] $LicenseFileUrl = $Env:LicenseFileUrl,
 [Parameter(Mandatory=$false)] [string] $LicenseFile = $PSScriptRoot + "\license.xml", 
 [Parameter(Mandatory=$false)] [string] $SolrVersion = "6.6.2"
)

$ErrorActionPreference = "Stop"
$elapsed = [System.Diagnostics.Stopwatch]::StartNew()

$Env:APPVEYOR_SAVE_CACHE_ON_ERROR = "true"
Import-Module $PSScriptRoot\environment-setup.psm1 -DisableNameChecking -Force
$SolrServerConfig = Resolve-Path "$PSScriptRoot\SolrServer.json"

CheckAdmin
CheckLicense $LicenseFileUrl $LicenseFile
RegisterSitecoreGallery
InstallLatestSitecoreInstallationFramework
InstallLatestSqlServerModule

Write-Host "================= Installing Solr =================" -foregroundcolor "green"
Install-SitecoreConfiguration $SolrServerConfig -SolrVersion $SolrVersion

Write-Host "Successfully setup dev environment (time: $($elapsed.Elapsed.ToString()))"