function Build-PolicyParameters {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [hashtable]$PolicyInfo,
        
        [Parameter(Mandatory=$true)]
        [string]$PolicyMode,
        
        [Parameter(Mandatory=$true)]
        [hashtable]$Locations
    )
    
    $policyParams = @{
        Name = $PolicyInfo.Name
        Comment = $PolicyInfo.Comment
        Mode = $PolicyMode
    }
    
    if ($Locations.Exchange) { $policyParams.Add("ExchangeLocation", "All") }
    if ($Locations.SharePoint) { $policyParams.Add("SharePointLocation", "All") }
    if ($Locations.OneDrive) { $policyParams.Add("OneDriveLocation", "All") }
    if ($Locations.Teams) { $policyParams.Add("TeamsLocation", "All") }
    if ($Locations.Endpoint) { $policyParams.Add("EndpointDlpLocation", "All") }
    
    return $policyParams
}


### REFACTOR