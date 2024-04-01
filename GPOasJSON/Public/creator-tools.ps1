<#
.SYNOPSIS
Using JSON files, update GPOs with static and dynamic registry values. 

.DESCRIPTION
This function reads JSON files containing registry values and updates/creates GPOs with these values.
Using this function the targeted GPOs will also be cleared of all registry values before the new values are set.

.PARAMETER DataPath
Folder or specific JSON file

.PARAMETER ConfigPath
Exact path to configuration file

.NOTES
This function will clear all registry values in the targeted GPOs before setting the new values!!!
#>
function Set-GPRegistyValuesPlus {
    param (
        [Parameter()]
        [System.IO.DirectoryInfo]$DataPath = "$PSScriptRoot\..\Data",
        [Parameter()]
        [System.IO.DirectoryInfo]$ConfigPath = "$PSScriptRoot\..\Config\variableStrings.json"
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
# SIG # Begin signature block
# MIIFWwYJKoZIhvcNAQcCoIIFTDCCBUgCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUlMERA2UyuTroLLL9uj6iG1Lr
# WYWgggL2MIIC8jCCAdqgAwIBAgIQYseIafgwqaZNeZ4d0CYhxTANBgkqhkiG9w0B
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
# BAGCNwIBFTAjBgkqhkiG9w0BCQQxFgQUU97cjW4hcVGO+adeYKRJUNj0qGkwDQYJ
# KoZIhvcNAQEBBQAEggEAO2rugX3C5SaNtwR+qwqwcM+pGLWN1vaRkpDbordywEpX
# MD2hNCwKwp81JecXr/fNvCx8FYbrgFxeCeO8oIgSr11jdoMj0tsdehNllQaYBUDr
# P6PlTOAyUmrZbbphxESf/V1emUr//Y6h9WcelgQZpBkm12ajxgAFNhGNHRoFxSfF
# KAusSjEr+8WfGF2gfcW+A2A6eZKMspV6me81kAFush8cxRRaEf7aetJNYscZ3Qvb
# RZNokB7Zl3LLqQrPk5jYMDRtHIvglfsox837hiwqUHbSMmoWa+4p2UItfpEAKWob
# lg/ajtV0NXK2VO3b8phDYO7s/2Sc6/35leKbZTw2/Q==
# SIG # End signature block
