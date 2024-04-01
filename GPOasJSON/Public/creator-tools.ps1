function Set-GPRegistyValuesPlus {
    param (
        [Parameter()]
        [System.IO.DirectoryInfo]$DataPath = "$PSScriptRoot\Data",
        [Parameter()]
        [System.IO.DirectoryInfo]$ConfigPath = "$PSScriptRoot\Config"
    )
    
    $targetGPOs = Get-JSONRegistrykeys -path $DataPath
    
    # Create GPOs if they don't exist
    Write-Verbose "Creating GPOs if they don't exist."
    $targetGPOs.name | Where-Object {$_ -notin (Get-GPO -All).DisplayName} | ForEach-Object {
        Write-Output "Creating GPO: $_"
        # Create GPO
        New-GPO -Name $_ | Out-Null
    }
    
    # Create hashtable for string replacement
    $variableStrings = Get-VariableStrings -path $ConfigPath
    
    Write-Output "Starting to update GPOs with registry values."
    
    # Update GPOs
    foreach ($jsonGPO in $jsonGPOs) {
        Write-Verbose "Starting to update GPO: $($jsonGPO.name)"
        # Get all registry values
        Write-Verbose "Getting registry values for GPO: $($jsonGPO.name)"
        $gpoInfo = Get-RecursePolicyKeys $jsonGPO.name
    
        # Remove all registry values, this is becouse it is a easy way to make sure that the registry values are up to date
        $gpoInfo | ForEach-Object {
            Write-Verbose "Removing registry value: $($_.hive)\$($_.key)\$($_.name) in GPO: $($jsonGPO.name)"
            Remove-GPPrefRegistryValue -Name $jsonGPO.name -Key "$($_.hive)\$($_.key)" -ValueName $_.name -Context $_.Context -ErrorAction SilentlyContinue | Out-Null
        }
        Write-Verbose "Completed removing all registry values for GPO: $($jsonGPO.name)"
    
        # Update registry values
        $allRegistryValues = $jsonGPO.UserConfiguration.Registry + $jsonGPO.ComputerConfiguration.Registry
        Write-Verbose "Iterating over $($allRegistryValues.Count) registry values for GPO: $($jsonGPO.name)"
        foreach ($registryValue in $allRegistryValues) {
            # Replace strings
            Write-Verbose "Checking for string replacements in registry value: $($registryValue.Key)\$($registryValue.ValueName) in GPO: $($jsonGPO.name)"
            
            # Iterate over all these properties of the registry value
            $iterationNames = @("Key", "ValueName", "Value")
            foreach ($iterationName in $iterationNames) {
                # Iterate over all the available change strings
                foreach ($changeString in $changeStrings.Keys) {
                    if ($registryValue.$iterationName -match $changeString) {
                        # Replace the string
                        Write-Verbose "Replacing string: $changeString with $($changeStrings[$changeString]) in registry value: $($registryValue.Key)\$($registryValue.ValueName) in GPO: $($jsonGPO.name)"
                        $registryValue.$iterationName = $registryValue.$iterationName -ireplace $changeString, $changeStrings[$changeString]
                    }
                }
            }
    
            $gpoSettings = @{
                Name = $jsonGPO.name
                Key = $registryValue.Key
                ValueName = $registryValue.ValueName
                Value = $registryValue.Value
                Type = $typeAsString.($registryValue.Type)
                Action = $registryValue.Action
                Context = $registryValue.Context
            }
            Write-Output "Setting registry value: $($registryValue.Key)\$($registryValue.ValueName) in GPO: $($jsonGPO.name)"
            Write-Verbose ("KeyValues: " + ($gpoSettings | ConvertTo-Json))
            Set-GPPrefRegistryValue @gpoSettings | Out-Null
        }
        Write-Verbose "Completed updating registry values for GPO: $($jsonGPO.name)"
    }
    Write-Output "Completed updating GPOs with registry values."
}