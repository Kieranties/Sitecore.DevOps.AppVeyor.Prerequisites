# Sitecore Prerequisites on AppVeyor

This script prepares [AppVeyor](https://www.appveyor.com) to install Sitecore 9.

* Downloads the Sitecore license file
* Registers the Sitecore PowerShell Gallery
* Installs the latest version of the Sitecore Installation Framework
* Installs the latest version of the SqlServer PowerShell module
* Installs Solr 6.6.2

## How to consume this package

Look to [Sitecore.DevOps.AppVeyor.V902XP0](https://github.com/steviemcg/Sitecore.DevOps.AppVeyor.V902XP0/blob/master/install-xp0.ps1) for an example. Example code is:

    nuget sources add -name Prerequisites -source https://ci.appveyor.com/nuget/sitecore-devops-appveyor-prere-qeyv6do3n8b9
    nuget install "Stroben.SitecoreDevOps.AppVeyor.Prerequisites" -ExcludeVersion -OutputDirectory $PSScriptRoot

    Try {
        Push-Location .\Stroben.SitecoreDevOps.AppVeyor.Prerequisites
        & .\environment-setup.ps1
    } Finally {
        Pop-Location
    }

## Authors
[@steviemcgill](https://twitter.com/steviemcgill), [@jermdavis](https://twitter.com/jermdavis), [@Kieranties](https://twitter.com/Kieranties)

## Contributing

Pull Requests are **very** welcome.