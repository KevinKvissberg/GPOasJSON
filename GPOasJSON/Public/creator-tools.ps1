function Set-GPRegistyValuesPlus {
    param (
        [Parameter()]
        [System.IO.DirectoryInfo]$DataPath = "$PSScriptRoot\Data",
        [Parameter()]
        [System.IO.DirectoryInfo]$ConfigPath = "$PSScriptRoot\Config"
    )
    Write-Information "Starting to update GPOs with registry values." -InformationAction Continue
    $targetGPOs = Get-JSONRegistrykeys -path $DataPath
    
    # Create GPOs if they don't exist
    Write-Verbose "Creating GPOs if they don't exist."
    $currentDomainGPOs = Get-GPO -All
    foreach ($gpo in $targetGPOs) {
        if ($gpo.name -notin $currentDomainGPOs.DisplayName) {
            Write-Information "Creating GPO: $($gpo.name)" -InformationAction Continue
            New-GPO -Name $gpo.name | Out-Null
        }
        else {
            Write-Verbose "GPO '$($gpo.name)' already exists, skipping..."
        }
    }
    
    # Create hashtable for string replacement
    $variableStrings = Get-VariableStrings -path $ConfigPath
    
    # Update GPOs
    foreach ($gpo in $targetGPOs) {
        Write-Verbose "Starting to update GPO: $($gpo.name)"
        
        # Clear all registry values
        Clear-ADGPORegistryValues -GPOName $gpo.name
    
        # Update registry values
        $allRegistryItems = $gpo.UserConfiguration + $gpo.ComputerConfiguration
        Write-Verbose "Iterating over $($allRegistryItems.Count) registry values for GPO: $($gpo.name)"
        foreach ($registryItem in $allRegistryItems) {
            # Iterate over all these properties of the registry value
            Set-VariableStrings -variableStrings $variableStrings -registryItem $registryItem
    
            # Set the registry value
            Set-ADGPORegistryKeys -GPOName $gpo.name -registryItem $registryItem
        }
        Write-Verbose "Completed updating registry values for GPO: $($gpo.name)"
    }
    Write-Output "Completed updating GPOs with registry values."
}