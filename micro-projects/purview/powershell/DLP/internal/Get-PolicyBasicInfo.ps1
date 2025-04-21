# function Get-PolicyBasicInfo {
#     [CmdletBinding()]
#     param()
    
#     Write-Host "`n--- CRÉATION DE LA POLITIQUE DLP ---" -ForegroundColor Yellow
#     $policyInfo = @{}
#     $policyInfo.Name = Read-Host "Nom de la politique DLP"
#     $policyInfo.Comment = Read-Host "Description de la politique"
#     return $policyInfo
# }


### REFACTOR
function Get-PolicyBasicInfo {
    [CmdletBinding()]
    param()
    
    Write-Host "`n--- CRÉATION DE LA POLITIQUE DLP ---" -ForegroundColor Yellow
    $policyInfo = @{}
    
    # Boucle pour s'assurer que le nom de la politique est saisi
    do {
        $policyName = Read-Host "Nom de la politique DLP (obligatoire)"
        if ([string]::IsNullOrWhiteSpace($policyName)) {
            Write-Host "Le nom de la politique est obligatoire. Veuillez saisir un nom." -ForegroundColor Red
        }
    } while ([string]::IsNullOrWhiteSpace($policyName))
    
    $policyInfo.Name = $policyName
    $policyInfo.Comment = Read-Host "Description de la politique"
    return $policyInfo
}
