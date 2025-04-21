
function Disconnect-FromExchangeOnline {
    [CmdletBinding()]
    param()
    
    Write-Host "`nDéconnexion de Exchange Online PowerShell..." -ForegroundColor Cyan
    try {
        Disconnect-ExchangeOnline -Confirm:$false
        Write-Host "Déconnexion réussie!" -ForegroundColor Green
    } 
    catch {
        Write-Host "Erreur lors de la déconnexion: $_" -ForegroundColor Red
    }
}


### REFACTOR