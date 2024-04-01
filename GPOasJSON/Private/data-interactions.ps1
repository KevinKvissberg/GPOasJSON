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
    if (!(Test-Path $path)) {
        throw "Path does not exist: $path"
    }
    # Check if the path contains any JSON files
    elseif (!(Get-ChildItem -Path $path -Filter "*.json")) {
        throw "No JSON files found in path: $path"
    }

    # Create a new GPOList object
    $jsonGPOs = [GPOList]::New()
    # Get all JSON files in the path
    Get-ChildItem -Path $path -Filter "*.json" | ForEach-Object {
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
    }
    
    return $jsonGPOs
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
            $result = Invoke-Expression $command.Value
            $command.Value = $result
        }
    }

    return $variableStrings
}