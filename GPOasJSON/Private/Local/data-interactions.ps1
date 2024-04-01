<#
.SYNOPSIS
Get all JSON files in a directory and convert them to PowerShell objects.

.PARAMETER path
The path to the directory containing the JSON files.

.EXAMPLE
Get-JSONRegistrykeys -path "C:\Data"
#>
function Get-JSONRegistrykeys {
    param (
        [Parameter()]
        [System.IO.DirectoryInfo]$path = "$PSScriptRoot\Data"
    )
    
    # Check if the path exists
    Write-Verbose "Checking if the path exists: $path"
    if (!(Test-Path $path)) {
        throw "Path does not exist: $path"
    }
    # Check if the path contains any JSON files
    elseif (!(Get-ChildItem -Path $path -Filter "*.json")) {
        throw "No JSON files found in path: $path"
    }

    $allGPOs = @()

    # Get all JSON files in the path
    Get-ChildItem -Path $path -Filter "*.json" | ForEach-Object {
        # Create a new GPOList object
        $jsonGPOs = [GPOList]::New()
        Write-Verbose "Readiong JSON file: $_ as a [RegistryItem] object"
        # Add the name of the GPO to the object
        $jsonGPOs.Name = $_.BaseName

        # Convert the JSON file to a PowerShell object
        $jsonGPO = Get-Content -Path $_.FullName | ConvertFrom-Json
        # Add the registry values to the GPOList object
        foreach ($registry in $jsonGPO.ComputerConfiguration.Registry) {
            $jsonGPOs.ComputerConfiguration += [RegistryItem]$registry
        }
        foreach ($registry in $jsonGPO.UserConfiguration.Registry) {
            $jsonGPOs.UserConfiguration += [RegistryItem]$registry
        }

        $allGPOs += $jsonGPOs
    }
    
    return $allGPOs
}

<#
.SYNOPSIS
Get all strings from a JSON file and replace them with the result of the string.

.PARAMETER path
The path to the JSON config file.

.NOTES
The values of the properties in the JSON file will be executed as PowerShell commands.
All the properties in the JSON file that are not strings will be excluded. The README property will also be excluded.
#>
function Get-VariableStrings {
    param (
        [Parameter()]
        [System.IO.DirectoryInfo]$path = "$PSScriptRoot\Config\variableStrings.json"
    )
    # Check if the path exists
    Write-Verbose "Checking if the path exists: $path"
    if (!(Test-Path $path -PathType Leaf)) {
        throw "Path does not exist: $path"
    }
    # Get the JSON file
    $variableStrings = Get-Content -Path $path | ConvertFrom-Json

    # Remove README property
    $variableStrings = $variableStrings | Select-Object * -ExcludeProperty README
    
    # Execlude all properties that are not strings
    foreach ($command in $variableStrings.PSObject.Properties) {
        # $command.Value
        if ($command.Value -is [string]) {
            Write-Verbose "Executing command for ($($command.Name)): $($command.Value)"
            $result = Invoke-Expression $command.Value
            $command.Value = $result
            Write-Verbose "Result: $result"
        }
        else {
            Write-Verbose "Excluding property: $($command.Name) because it is not a string."
        }
    }

    return $variableStrings
}

function Set-VariableStrings {
    param (
        $variableStrings,
        [RegistryItem]$registryItem
    )
    Write-Verbose "Checking for string replacements in registry value: $($registryItem.Key)\$($registryItem.ValueName) in GPO: $($gpo.name)"

    $replacedStringCount = 0

    # Replace all strings in the GPOList with the variableStrings
    $iterationNames = @("Key", "ValueName", "Value")
    foreach ($iterationName in $iterationNames) {
        # Iterate over all the available change strings
        foreach ($changeString in $variableStrings.psobject.Properties.name) {
            if ($registryItem.$iterationName -match $changeString) {
                # Replace the string
                Write-Verbose "Replacing string: $changeString with $($variableStrings.$changeString) in registry value: $($registryItem.Key)\$($registryItem.ValueName)"
                $registryItem.$iterationName = $registryItem.$iterationName -ireplace $changeString, $variableStrings.$changeString
                $replacedStringCount++
            }
        }
    }

    if ($replacedStringCount -gt 0) {
        Write-Verbose "Replaced $replacedStringCount strings in registry value: $($registryItem.Key)\$($registryItem.ValueName) in GPO: $($gpo.name)"
    }
    else {
        Write-Verbose "No strings replaced in registry value: $($registryItem.Key)\$($registryItem.ValueName) in GPO: $($gpo.name)"
    }
}