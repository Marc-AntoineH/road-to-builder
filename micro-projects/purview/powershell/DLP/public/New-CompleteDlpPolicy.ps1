function New-CompleteDlpPolicy {
    [CmdletBinding()]
    param()
    
    # Collecter toutes les informations nécessaires
    $policyInfo = Get-PolicyBasicInfo
    $policyMode = Get-PolicyMode
    $locations = Get-PolicyLocations
    $ruleName = Get-RuleBasicInfo
    $sensitiveInfoTypes = Get-SensitiveInfoTypes
    $minCount = Get-RuleMinimumCount
    $actions = Get-RuleActions
    
    # Construire les paramètres
    $policyParams = Build-PolicyParameters -PolicyInfo $policyInfo -PolicyMode $policyMode -Locations $locations
    $ruleParams = Build-RuleParameters -RuleName $ruleName -PolicyName $policyInfo.Name -SensitiveInfoTypes $sensitiveInfoTypes -MinCount $minCount -Actions $actions
    
    # Afficher le résumé
    Show-ConfigurationSummary -PolicyInfo $policyInfo -PolicyMode $policyMode -Locations $locations `
                              -RuleName $ruleName -SensitiveInfoTypes $sensitiveInfoTypes `
                              -MinCount $minCount -Actions $actions
    
    # Déployer la politique
    Deploy-DlpPolicy -PolicyParameters $policyParams -RuleParameters $ruleParams
}