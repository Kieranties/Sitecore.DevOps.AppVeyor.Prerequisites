using namespace System.IO

param(
    [string]$PSDependVersion = '0.3.0',
    [string]$modulesPath = (Join-Path $PSScriptRoot 'modules')
)

# Bootstrap dependencies
New-Item $modulesPath -ItemType Directory -ErrorAction Ignore | Out-Null
$PSDependPath = Join-Path $modulesPath 'PSDepend'
if(!(Test-Path $PSDependPath)) {
    Save-Module -Name PSDepend -RequiredVersion $PSDependVersion -Path $modulesPath
}

Import-Module $PSDependPath -Force
Invoke-PSDepend -Path (Join-Path $PSScriptRoot 'requirements.psd1') -Target $modulesPath -Force

#TODO: Pass additional parameters/properties
Invoke-Psake (Join-Path $PSScriptRoot 'build.psake.ps1')