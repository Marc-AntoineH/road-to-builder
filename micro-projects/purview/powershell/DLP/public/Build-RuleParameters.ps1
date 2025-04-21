function Build-RuleParameters {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [string]$RuleName,
        
        [Parameter(Mandatory=$true)]
        [string]$PolicyName,
        
        [Parameter(Mandatory=$true)]
        [hashtable]$SensitiveInfoTypes,
        
        [Parameter(Mandatory=$true)]
        [string]$MinCount,
        
        [Parameter(Mandatory=$true)]
        [hashtable]$Actions
    )
    
    $ruleParams = @{
        Name = $RuleName
        Policy = $PolicyName
    }
    
    # Construire le ContentContainsSensitiveInformation
    $sensInfoRules = @()
    
    # Ajouter les types prédéfinis
    foreach ($typeName in $SensitiveInfoTypes.SelectedTypeNames) {
        $sensInfoRules += @{
            Name = $typeName
            MinCount = $MinCount
        }
    }
    
    # Ajouter les types personnalisés si présents
    if ($SensitiveInfoTypes.CustomTypes.Count -gt 0) {
        foreach ($customType in $SensitiveInfoTypes.CustomTypes) {
            $sensInfoRules += @{
                Name = $customType
                MinCount = $MinCount
            }
        }
    }
    
    # Ajouter les règles de contenu sensible au paramètre de règle
    if ($sensInfoRules.Count -gt 0) {
        $ruleParams.Add("ContentContainsSensitiveInformation", $sensInfoRules)
    }
    
    # Ajouter les actions
    if ($Actions.BlockAccess) { $ruleParams.Add("BlockAccess", $true) }
    if ($Actions.NotifyUser) { $ruleParams.Add("NotifyUser", "SiteAdmin") }
    
    return $ruleParams
}


### REFACTOR