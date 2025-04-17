
function Connect-ToExchangeOnline {
    [CmdletBinding()]
    param()
    
    Write-Host "Connexion à Exchange Online PowerShell..." -ForegroundColor Cyan
    try {
        Connect-IPPSSession
        Write-Host "Connexion réussie!" -ForegroundColor Green
    } 
    catch {
        Write-Host "Erreur de connexion: $_" -ForegroundColor Red
    }
}
Connect-ToExchangeOnline