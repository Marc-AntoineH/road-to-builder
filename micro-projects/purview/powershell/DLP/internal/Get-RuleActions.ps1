function Get-RuleActions {
    [CmdletBinding()]
    param()
    
    $actions = @{}
    
    Write-Host "`nActions à configurer (Oui/Non):"
    $actions.BlockAccess = (Read-Host "Bloquer l'accès au contenu (O/N)").ToUpper() -eq "O"
    $actions.NotifyUser = (Read-Host "Notifier les utilisateurs (O/N)").ToUpper() -eq "O"
    
    return $actions
}


### REFACTOR