# Initialiser la variable d'état du module
$script:DlpModuleState = @{
    CachedPolicies = @{}
    SensitiveInfoTypes = $null
}

# Importer les scripts privés et publics
$privateScripts = @(Get-ChildItem -Path "$PSScriptRoot\internal" -Filter "*.ps1" -ErrorAction SilentlyContinue)
$publicScripts = @(Get-ChildItem -Path "$PSScriptRoot\public" -Filter "*.ps1" -ErrorAction SilentlyContinue)

foreach ($script in ($privateScripts + $publicScripts)) {
    try {
        . $script.FullName
    } catch {
        Write-Error -Message ("Échec de l'importation de la fonction {0}: {1}" -f $script, $_)
    }
}

# Importer les informations du manifeste si besoin
# $ModuleInfo = Import-PowerShellDataFile -Path "$PSScriptRoot/Purview.DLP.psd1"