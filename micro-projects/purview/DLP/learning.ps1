# Se connecter avec User UPN
Connect-IPPSSession -UserPrincipalName mhebert@klabmtl.ca 

# TARGET =>
#   DLP Policy:
#       Canada PII (EXO, SPO, ODB & Teams dans une policy)
#           DLP Rule:
#               - ExternalShare
Get-DlpCompliancePolicy
Get-DlpCompliancePolicy -Identity "Canada PII"

Get-DlpComplianceRule -Policy "Canada PII"
Get-DlpComplianceRule -Identity "ExternalShare"


# Aller chercher AdvancedRule dans la Rule et sauvegarder en JSON
$Rule = Get-DlpComplianceRule -Identity "ExternalShare"
$AdvancedRule = $Rule.AdvancedRule
$AdvancedRule > AdvancedRule.json


# Lister les SITs, filtrer sur ceux creer par l'organisation
Get-DlpSensitiveInformationType
Get-DlpSensitiveInformationType | Where-Object { $_.Publisher -eq "K-laboratory" }
Get-DlpSensitiveInformationType -Identity "NAS by DataShieldDivine"


# Update DLP rule
$Data = Get-Content `
    -Path "C:\Users\marc-antoinehebert\Downloads\road-to-builder\micro-projects\purview\DLP\Rule\AdvancedRule\Canada PII\ExternalShare.json" `
    -ReadCount 0
$String = $Data | Out-string
Set-DLPComplianceRule -Identity "ExternalShare" `
    -AdvancedRule $String





# Creer une nouvelle DLP policy
New-DlpCompliancePolicy -Name "Canada PII" `
    -Mode TestWithoutNotifications `
    -ExchangeLocation All `
    -SharePointLocation All `
    -OneDriveLocation All `
    -TeamsLocation All


# Creer une nouvelle DLP rule
$Data = Get-Content `
    -Path "C:\Users\marc-antoinehebert\Downloads\road-to-builder\micro-projects\purview\DLP\Rule\AdvancedRule\Canada PII\ExternalShare.json" `
    -ReadCount 0
$String = $Data | Out-string
New-DLPComplianceRule -Name "ExternalShare" `
    -Policy "Canada PII" `
    -AdvancedRule $String