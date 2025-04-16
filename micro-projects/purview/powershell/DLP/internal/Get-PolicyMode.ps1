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