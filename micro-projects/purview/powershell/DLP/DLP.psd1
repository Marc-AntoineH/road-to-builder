# Se placer dans le dossier du module
New-ModuleManifest -Path .\DLP.psd1 -RootModule DLP.psm1 -Author "Votre nom" -Description "Module pour la création et gestion de politiques DLP" -FunctionsToExport @(
    'Get-PolicyBasicInfo',
    'Get-PolicyMode',
    'Get-PolicyLocations',
    'Get-RuleBasicInfo',
    'Get-SensitiveInfoTypes',
    'Get-RuleMinimumCount',
    'Get-RuleActions',
    'Build-PolicyParameters',
    'Build-RuleParameters',
    'Show-ConfigurationSummary',
    'Deploy-DlpPolicy',
    'New-CompleteDlpPolicy'
)