function Get-RuleBasicInfo {
    [CmdletBinding()]
    param()
    
    Write-Host "`n--- CRÉATION DE LA RÈGLE DLP ---" -ForegroundColor Yellow
    return Read-Host "Nom de la règle DLP"
}


### REFACTOR