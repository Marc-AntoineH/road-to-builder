function Get-RuleMinimumCount {
    [CmdletBinding()]
    param()
    
    return Read-Host "Nombre minimum d'occurrences requises (ex: 1)"
}


### REFACTOR