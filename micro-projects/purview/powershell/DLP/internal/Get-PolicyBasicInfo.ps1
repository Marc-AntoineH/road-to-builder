function Get-PolicyBasicInfo {
    [CmdletBinding()]
    param()
    
    Write-Host "`n--- CRÉATION DE LA POLITIQUE DLP ---" -ForegroundColor Yellow
    $policyInfo = @{}
    $policyInfo.Name = Read-Host "Nom de la politique DLP"
    $policyInfo.Comment = Read-Host "Description de la politique"
    return $policyInfo
}