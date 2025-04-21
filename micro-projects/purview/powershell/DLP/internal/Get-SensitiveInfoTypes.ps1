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


### REFACTOR