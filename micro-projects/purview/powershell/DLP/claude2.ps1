# Module de création de politiques DLP
# Auteur: Claude
# Date: 14/04/2025

function Get-PolicyBasicInfo {
    [CmdletBinding()]
    param()
    
    Write-Host "`n--- CRÉATION DE LA POLITIQUE DLP ---" -ForegroundColor Yellow
    $policyInfo = @{}
    $policyInfo.Name = Read-Host "Nom de la politique DLP"
    $policyInfo.Comment = Read-Host "Description de la politique"
    return $policyInfo
}

function Get-PolicyMode {
    [CmdletBinding()]
    param()
    
    $modeOptions = @("Enable", "TestWithNotifications", "TestWithoutNotifications", "Disable")
    $modeIndex = 0
    do {
        Write-Host "`nMode de la politique:"
        for ($i = 0; $i -lt $modeOptions.Count; $i++) {
            Write-Host "[$i] $($modeOptions[$i])"
        }
        $modeIndex = Read-Host "Choisissez le mode (0-3)"
    } while ($modeIndex -lt 0 -or $modeIndex -gt 3)
    
    return $modeOptions[$modeIndex]
}

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

function Get-RuleBasicInfo {
    [CmdletBinding()]
    param()
    
    Write-Host "`n--- CRÉATION DE LA RÈGLE DLP ---" -ForegroundColor Yellow
    return Read-Host "Nom de la règle DLP"
}

function Get-SensitiveInfoTypes {
    [CmdletBinding()]
    param()
    
    $sensInfoTypes = @(
        "Canada Bank Account Number",
        "Canada Driver's License Number",
        "Canada Health Service Number",
        "Canada Passport Number",
        "Canada Personal Health Identification Number (PHIN)",
        "Canada Social Insurance Number",
        "Autre (personnalisé)"
    )
    
    $selectedTypes = @()
    $customTypes = @()
    
    do {
        Write-Host "`nType d'information sensible à protéger:"
        for ($i = 0; $i -lt $sensInfoTypes.Count; $i++) {
            $selected = if ($selectedTypes -contains $i) { "[X]" } else { "[ ]" }
            Write-Host "$selected [$i] $($sensInfoTypes[$i])"
        }
        
        if ($selectedTypes.Count -gt 0) {
            Write-Host "`nVos sélections actuelles: "
            foreach ($index in $selectedTypes) {
                if ($index -eq 6) {
                    Write-Host "- $($sensInfoTypes[$index]): $($customTypes -join ', ')"
                } else {
                    Write-Host "- $($sensInfoTypes[$index])"
                }
            }
        }
        
        Write-Host "`nEntrez un numéro pour sélectionner/désélectionner une option,"
        Write-Host "ou entrez 'c' pour confirmer votre sélection actuelle."
        $input = Read-Host "Votre choix"
        
        if ($input -eq "c") {
            if ($selectedTypes.Count -eq 0) {
                Write-Host "Veuillez sélectionner au moins un type d'information"
            } else {
                break
            }
        } elseif ($input -match '^\d+$' -and $input -ge 0 -and $input -lt $sensInfoTypes.Count) {
            $index = [int]$input
            
            if ($selectedTypes -contains $index) {
                # Désélectionner l'option
                $selectedTypes = $selectedTypes | Where-Object { $_ -ne $index }
                if ($index -eq 6) {
                    $customTypes = @()
                }
            } else {
                # Sélectionner l'option
                $selectedTypes += $index
                
                # Si "Autre (personnalisé)" est sélectionné, demander les types personnalisés
                if ($index -eq 6) {
                    do {
                        $customType = Read-Host "Entrez un type personnalisé (ou 'fin' pour terminer)"
                        if ($customType -ne "fin" -and $customType.Trim() -ne "") {
                            $customTypes += $customType
                        }
                    } while ($customType -ne "fin")
                    
                    if ($customTypes.Count -eq 0) {
                        Write-Host "Aucun type personnalisé ajouté, l'option 'Autre' a été désélectionnée."
                        $selectedTypes = $selectedTypes | Where-Object { $_ -ne 6 }
                    }
                }
            }
        } else {
            Write-Host "Entrée invalide. Veuillez entrer un nombre entre 0 et $($sensInfoTypes.Count - 1) ou 'c' pour confirmer."
        }
    } while ($true)
    
    # Préparer le résultat
    $result = @{
        SelectedTypeIndices = $selectedTypes
        SelectedTypeNames = @()
        CustomTypes = $customTypes
    }
    
    foreach ($index in $selectedTypes) {
        if ($index -ne 6) {
            $result.SelectedTypeNames += $sensInfoTypes[$index]
        }
    }
    
    Write-Host "`nTypes d'information sensible sélectionnés:"
    foreach ($index in $selectedTypes) {
        if ($index -eq 6) {
            Write-Host "- $($sensInfoTypes[$index]): $($customTypes -join ', ')"
        } else {
            Write-Host "- $($sensInfoTypes[$index])"
        }
    }
    
    return $result
}

function Get-RuleMinimumCount {
    [CmdletBinding()]
    param()
    
    return Read-Host "Nombre minimum d'occurrences requises (ex: 1)"
}

function Get-RuleActions {
    [CmdletBinding()]
    param()
    
    $actions = @{}
    
    Write-Host "`nActions à configurer (Oui/Non):"
    $actions.BlockAccess = (Read-Host "Bloquer l'accès au contenu (O/N)").ToUpper() -eq "O"
    $actions.NotifyUser = (Read-Host "Notifier les utilisateurs (O/N)").ToUpper() -eq "O"
    
    return $actions
}

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

function Deploy-DlpPolicy {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [hashtable]$PolicyParameters,
        
        [Parameter(Mandatory=$true)]
        [hashtable]$RuleParameters
    )
    
    $confirmation = Read-Host "`nVoulez-vous déployer cette configuration? (O/N)"
    
    if ($confirmation.ToUpper() -eq "O") {
        Write-Host "`nCréation de la politique DLP..." -ForegroundColor Cyan
        try {
            New-DlpCompliancePolicy @PolicyParameters
            Write-Host "Politique DLP créée avec succès!" -ForegroundColor Green
            
            Write-Host "`nCréation de la règle DLP..." -ForegroundColor Cyan
            New-DlpComplianceRule @RuleParameters
            Write-Host "Règle DLP créée avec succès!" -ForegroundColor Green
            
            Write-Host "`nDéploiement terminé!" -ForegroundColor Green
            return $true
        }
        catch {
            Write-Host "Erreur lors du déploiement: $_" -ForegroundColor Red
            return $false
        }
    }
    else {
        Write-Host "`nDéploiement annulé par l'utilisateur." -ForegroundColor Yellow
        return $false
    }
}

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

# IMPORTANT: Appel de la fonction principale pour exécuter le script automatiquement
New-CompleteDlpPolicy
