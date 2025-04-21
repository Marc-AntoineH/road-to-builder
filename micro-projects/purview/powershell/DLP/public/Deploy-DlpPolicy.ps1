function Deploy-DlpPolicy {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [hashtable]$PolicyParameters,
        
        [Parameter(Mandatory=$true)]
        [hashtable]$RuleParameters
    )
    
    $confirmation = Read-Host "`nVoulez-vous déployer cette configuration? (O/N)"
    
    if ($confirmation.ToUpper() -eq "O") {
        Write-Host "`nCréation de la politique DLP..." -ForegroundColor Cyan
        try {
            New-DlpCompliancePolicy @PolicyParameters
            Write-Host "Politique DLP créée avec succès!" -ForegroundColor Green
            
            Write-Host "`nCréation de la règle DLP..." -ForegroundColor Cyan
            New-DlpComplianceRule @RuleParameters
            Write-Host "Règle DLP créée avec succès!" -ForegroundColor Green
            
            Write-Host "`nDéploiement terminé!" -ForegroundColor Green
            return $true
        }
        catch {
            Write-Host "Erreur lors du déploiement: $_" -ForegroundColor Red
            return $false
        }
    }
    else {
        Write-Host "`nDéploiement annulé par l'utilisateur." -ForegroundColor Yellow
        return $false
    }
}


### REFACTOR