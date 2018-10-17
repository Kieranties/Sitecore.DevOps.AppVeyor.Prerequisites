Properties {
    [string]$projectName = 'Stroben.SitecoreDevOps.AppVeyor.Prerequisites'
    [string]$srcPath = ([Path]::Combine($PSScriptRoot, '..', $projectName))
    [string]$artifactsPath = ([Path]::Combine($PSScriptRoot, '..', 'artifacts'))
    [string]$version = '0.1.2'
    [string]$releaseLabel = 'alpha'
}

Task UpdateManifest {
    $manifestPath = Join-Path $srcPath "${projectName}.psd1"
    Update-ModuleManifest -Path $manifestPath -ModuleVersion $build -Prerelease $releaseLabel
}

Task Test -depends UpdateManifest {
    Write-Host "TODO" -ForegroundColor Yellow
}

Task PublishLocal -depends Test {
    $repoName = [Guid]::NewGuid()
    $repoPath = Join-Path $artifactsPath 'output'
    New-Item $repoPath -itemType Directory -ErrorAction Ignore | Out-Null
    Get-ChildItem $repoPath | Remove-Item -Recurse -Force

    try {
        Register-PSRepository -Name $repoName -PublishLocation $repoPath -SourceLocation $repoPath -PackageManagementProvider NuGet
        Publish-Module -Path (Resolve-Path $srcPath) -Repository $repoName -Force
    } finally {
        Unregister-PSRepository -Name $repoName -ErrorAction Ignore
    }
}

Task Default -depends PublishLocal