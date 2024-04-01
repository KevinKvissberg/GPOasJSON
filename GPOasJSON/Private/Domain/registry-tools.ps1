function Clear-ADGPORegistryValues {
    param (
        [Parameter(Mandatory = $true)]
        [string]$GPOName
    )
    # Get all registry values
    $gpoInfo = Get-ADRecursePolicyKeys $GPOName

    if ($null -eq $gpoInfo) {
        Write-Verbose "No registry values found for GPO: $($GPOName)"
        return
    }

    # Remove all registry values, this is becouse it is a easy way to make sure that the registry values are up to date
    $gpoInfo | ForEach-Object {
        Write-Verbose "Removing registry value: $($_.hive)\$($_.key)\$($_.name) in GPO: $($GPOName)"
        Remove-GPPrefRegistryValue -Name $GPOName -Key "$($_.hive)\$($_.key)" -ValueName $_.name -Context $_.Context -ErrorAction SilentlyContinue | Out-Null
    }
    Write-Verbose "Completed removing all registry values for GPO: $($GPOName)"
}

function Set-ADGPORegistryKeys {
    param (
        [Parameter(Mandatory = $true)]
        [string]$GPOName,
        [Parameter(Mandatory = $true)]
        [RegistryItem]$registryItem
    )
    $gpoSettings = @{
        Name = $GPOName
        Key = $registryItem.Key
        ValueName = $registryItem.ValueName
        Value = $registryItem.Value
        Type = $registryItem.Type
        Action = $registryItem.Action
        Context = $registryItem.Context
    }
    Write-Output "Setting registry values: $($registryItem.Key)\$($registryItem.ValueName) in GPO: $($GPOName)"
    Write-Verbose ("KeyValues: " + ($gpoSettings | ConvertTo-Json))
    Set-GPPrefRegistryValue @gpoSettings | Out-Null
}
# SIG # Begin signature block
# MIIFWwYJKoZIhvcNAQcCoIIFTDCCBUgCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUIRAGDjrG4yWIWHdmekwIDV5b
# EgmgggL2MIIC8jCCAdqgAwIBAgIQYseIafgwqaZNeZ4d0CYhxTANBgkqhkiG9w0B
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
# BAGCNwIBFTAjBgkqhkiG9w0BCQQxFgQUo++Ihm/x24roXbVSqN9wKbNmTgowDQYJ
# KoZIhvcNAQEBBQAEggEAIoi/mqUBRvXEZNAqcvqw8y0FU85zpQJdb8N/Tjq2UKgH
# 1+X1eM/JcN9/xSuDxThCcgt34hgmZ4xiKfGv6gQulMQ4OR1d7AMZy1+h05TzVTuA
# GVyvVfOTp2LsvcOrFt0WTAL4TKG+2VvqItQZ4hWU+EkcSj8tRokg9I9yxHeO37U9
# lpCZJfnTyAXtct1ewZ43Xg1OJjgyvDlLg5f2b/PGkXUkYWEHElQJklBUmRMVMJVi
# 6nh0ai7edPN8fBaD9crwhRurPmNI/puHxzbzueG3IcDG+Vx4zKRg1lMOLwf9dSQx
# NWcPskgY33KHlw/POt9wpKk/FA2L672MQjntlj/84g==
# SIG # End signature block
