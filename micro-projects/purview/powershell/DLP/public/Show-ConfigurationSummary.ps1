function Show-ConfigurationSummary {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [hashtable]$PolicyInfo,
        
        [Parameter(Mandatory=$true)]
        [string]$PolicyMode,
        
        [Parameter(Mandatory=$true)]
        [hashtable]$Locations,
        
        [Parameter(Mandatory=$true)]
        [string]$RuleName,
        
        [Parameter(Mandatory=$true)]
        [hashtable]$SensitiveInfoTypes,
        
        [Parameter(Mandatory=$true)]
        [string]$MinCount,
        
        [Parameter(Mandatory=$true)]
        [hashtable]$Actions
    )
    
    Write-Host "`n=== RÉSUMÉ DE LA CONFIGURATION ===" -ForegroundColor Green
    
    Write-Host "`nPOLITIQUE DLP :" -ForegroundColor Cyan
    Write-Host "- Nom: $($PolicyInfo.Name)"
    Write-Host "- Description: $($PolicyInfo.Comment)"
    Write-Host "- Mode: $PolicyMode"
    Write-Host "- Emplacements:"
    Write-Host "  - Exchange: $($Locations.Exchange)"
    Write-Host "  - SharePoint: $($Locations.SharePoint)"
    Write-Host "  - OneDrive: $($Locations.OneDrive)"
    Write-Host "  - Teams: $($Locations.Teams)"
    Write-Host "  - Endpoint: $($Locations.Endpoint)"
    
    Write-Host "`nRÈGLE DLP :" -ForegroundColor Cyan
    Write-Host "- Nom: $RuleName"
    Write-Host "- Types d'information sensible:"
    foreach ($typeName in $SensitiveInfoTypes.SelectedTypeNames) {
        Write-Host "  - $typeName"
    }
    foreach ($customType in $SensitiveInfoTypes.CustomTypes) {
        Write-Host "  - $customType (personnalisé)"
    }
    Write-Host "- Nombre minimum d'occurrences: $MinCount"
    Write-Host "- Bloquer l'accès: $($Actions.BlockAccess)"
    Write-Host "- Notifier les utilisateurs: $($Actions.NotifyUser)"
}


### REFACTOR