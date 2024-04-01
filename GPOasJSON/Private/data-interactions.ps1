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
    if (!(Test-Path $path)) {
        throw "Path does not exist: $path"
    }
    elseif (!(Get-ChildItem -Path $path -Filter "*.json")) {
        throw "No JSON files found in path: $path"
    }
    $jsonGPOs = [GPOList]::New()
    Get-ChildItem -Path $path -Filter "*.json" | ForEach-Object {
        $jsonGPOs.Name = $_.BaseName
        $jsonGPO = Get-Content -Path $_.FullName | ConvertFrom-Json
        foreach ($registry in $jsonGPO.ComputerConfiguration.Registry) {
            $jsonGPOs.ComputerConfiguration += [RegistryItem]$registry
        }
        foreach ($registry in $jsonGPO.UserConfiguration.Registry) {
            $jsonGPOs.UserConfiguration += [RegistryItem]$registry
        }
    }
    return $jsonGPOs
}