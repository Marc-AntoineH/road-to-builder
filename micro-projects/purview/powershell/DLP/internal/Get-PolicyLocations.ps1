function Get-PolicyLocations {
    [CmdletBinding()]
    param()
    
    $locations = @{}
    
    Write-Host "`nEmplacements à inclure (Oui/Non):"
    $locations.Exchange = (Read-Host "Exchange Online (O/N)").ToUpper() -eq "O"
    $locations.SharePoint = (Read-Host "SharePoint (O/N)").ToUpper() -eq "O"
    $locations.OneDrive = (Read-Host "OneDrive (O/N)").ToUpper() -eq "O"
    $locations.Teams = (Read-Host "Teams (O/N)").ToUpper() -eq "O"
    $locations.Endpoint = (Read-Host "Endpoint (O/N)").ToUpper() -eq "O"
    
    return $locations
}