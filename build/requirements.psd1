@{
    PSDependOptions = @{
        AddToPath = $true
        Parameters       = @{
            Import = $true
            Force = $true
        }
    }

    psake            = '4.7.4'
    pester           = '4.4.2'
    PSScriptAnalyzer = '1.17.1'
}