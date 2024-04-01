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
        [System.IO.DirectoryInfo]$path = "$PSScriptRoot\..\..\Data"
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
        foreach ($registry in $jsonGPO.ComputerConfiguration) {
            $jsonGPOs.ComputerConfiguration += [RegistryItem]$registry
        }
        foreach ($registry in $jsonGPO.UserConfiguration) {
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
        [System.IO.DirectoryInfo]$path = "$PSScriptRoot\..\..\Config\variableStrings.json"
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
        foreach ($changeString in ($variableStrings.psobject.Properties.name | Sort-object { $_.Length } -Descending)) {
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
# SIG # Begin signature block
# MIIFWwYJKoZIhvcNAQcCoIIFTDCCBUgCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUwHOqf0ONO5MUgiOOLhmKWlO6
# oHCgggL2MIIC8jCCAdqgAwIBAgIQYseIafgwqaZNeZ4d0CYhxTANBgkqhkiG9w0B
# AQsFADAaMRgwFgYDVQQDEw9LZXZpbiBLdmlzc2JlcmcwHhcNMjMxMjE4MjMxODA0
# WhcNMjQxMjE4MDUxODA0WjAaMRgwFgYDVQQDEw9LZXZpbiBLdmlzc2JlcmcwggEi
# MA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQDKlNjwOPiKcBJ86HgpMe6dojbh
# 8stpdYz+D9rLchQwSVRLJkay4McHeETdeUTRPgqVZfnt3ExwJpQoEwKw3mKcU+xe
# OQfODBAURPneH6AU774u2es3/qfIWITlW423s4DInw4X1LC4wblD59fnprfF1MpA
# ZvouL+NndDlDjf8JRvHL3XgaD9niT2g2+VeLTkZ3F1VYT5itH1S2a5jwmkesniOz
# CyEBwpF/J/UlTcID2Cgue7gnbxPaBPxphqvHGahufKGIwXutO7++6pgV0no7ZMFh
# wrXudFf2JUUGR2HhiB69RU+5FAlNngyDfzqRSVBQo0q8PX2nA0Er51yuuYepAgMB
# AAGjNDAyMAwGA1UdEwEB/wQCMAAwIgYDVR0lAQH/BBgwFgYIKwYBBQUHAwMGCisG
# AQQBgjdUAwEwDQYJKoZIhvcNAQELBQADggEBADcCLTlOYo8cRrcuhqDTvvc+7u7E
# +epENHrEXm3lNNgDZZDlYhgj3M5+Oewl6mSiE6RB9YoPwpZ4Xc7nmOQD2bZhELfP
# Zqy0NQ5yXHQ6frFeJ0FGr/XL3wTlvpaknfCxX7YcnLzw6e3I2psbSfOUA6+JL9T8
# tx7GZsWyKXmkncw8P7WzLHPEuVGnaOaUPs8HozzWlwNXoawXo5RwaCg/AGTsiiAH
# DreH/1myE+vbPFeAQyTlDhf8wVigXRuVWALn0YqaUG2yIoaOteqZdGc+vGL9JFpx
# nqgP7LwSgVnt9wNdO+9LwCgFyzvtVwSEojSaC0ymHB3rlL3X5tna3O4K1TMxggHP
# MIIBywIBATAuMBoxGDAWBgNVBAMTD0tldmluIEt2aXNzYmVyZwIQYseIafgwqaZN
# eZ4d0CYhxTAJBgUrDgMCGgUAoHgwGAYKKwYBBAGCNwIBDDEKMAigAoAAoQKAADAZ
# BgkqhkiG9w0BCQMxDAYKKwYBBAGCNwIBBDAcBgorBgEEAYI3AgELMQ4wDAYKKwYB
# BAGCNwIBFTAjBgkqhkiG9w0BCQQxFgQUmH3RlnYfnFiS5N5VdIIqiCbtb7cwDQYJ
# KoZIhvcNAQEBBQAEggEAQYUhfJnp75MuDy+VQrWzC8YjZZ3Rnz0sBDTZqijIgopC
# otp8sgSxyf9wPgXS27LrO5TYVpvDTrzRfESRvWWZvn6WvW4aNPxi1f5lDJwWmnUM
# 9Fj7mQSDBXA1hIB2pWZW/qGql1fP1kz3lwVrGircpNjTBqUZ8zse8k7CIPGoAAdM
# rqeTvMRwlxK2QgMo9AqqVxw0KfapEgyknNHkOPuVy8065HKXPslovMTF76rTxlPs
# 0QZL7CwQyL767ekwJd+FriB4FIp9qGo3kRTYTK/b/dRJC9yRPuAY8r8a8eJpR9p1
# Oz/30EAps3qZCgy96zVmcpr+Jdgd5T9Mx2oT6IzMXQ==
# SIG # End signature block
