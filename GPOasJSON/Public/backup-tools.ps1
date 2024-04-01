Function New-GPRegistyBackup {
    param (
        $gpoName,
        $backupPath = "$PSScriptRoot\..\Data"
    )
    $gpoData = @{}
    $gpo = [xml](Get-GPOReport -ReportType Xml -Name $gpoName)
    if ($null -ne $gpo.gpo.Computer.ExtensionData) {
        $gpoData += @{ComputerConfiguration = @()}
        foreach ($key in $gpo.gpo.Computer.ExtensionData.Extension.RegistrySettings.Registry.Properties) {
            $registryHashTable = [Ordered]@{
                Key = "$($key.hive)\\$($key.key)"
                ValueName = $key.name
                Value = $key.value
                Type = $key.type | ConvertTo-RegistryTypeString
                Action = $key.action
                Context = "Computer"
            }
            $gpoData.ComputerConfiguration += $registryHashTable
        }
    }
    if ($null -ne $gpo.gpo.User.ExtensionData) {
        $gpoData += @{UserConfiguration = @()}
        foreach ($key in $gpo.gpo.User.ExtensionData.Extension.RegistrySettings.Registry.Properties) {
            $registryHashTable = [Ordered]@{
                Key = "$($key.hive)\\$($key.key)"
                ValueName = $key.name
                Value = $key.value
                Type = $key.type | ConvertTo-RegistryTypeString
                Action = $key.action
                Context = "User"
            }
            $gpoData.UserConfiguration += $registryHashTable
        }
    }
    
    if (!(Test-Path $backupPath)) {
        New-Item -Path $backupPath -ItemType Directory
    }

    $gpoData | ConvertTo-Json -Depth 100 | Format-Json | Out-File "$backupPath\$gpoName.json"
}
# SIG # Begin signature block
# MIIFWwYJKoZIhvcNAQcCoIIFTDCCBUgCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQU1VisxGcpClJjVnylKDRE3uBj
# rFOgggL2MIIC8jCCAdqgAwIBAgIQYseIafgwqaZNeZ4d0CYhxTANBgkqhkiG9w0B
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
# BAGCNwIBFTAjBgkqhkiG9w0BCQQxFgQUN6aRJytBL5OT1kRuYADAtfCu7JowDQYJ
# KoZIhvcNAQEBBQAEggEAAWAFWgxFaXdhJ2fxgXqaGFNv3Gem/EqCz2k7aFCj9uDF
# XHTrUxoldE910JkXtN9FVo1bMPg037DvAXrnVdO9SEuw1Ss1Wqx1lHPXCTZjCxBm
# K0Z8hFFGvkYGsqfzwWkNA4l201HsHQxFhsppfaaBgKJ2ps5pnj0zVnFJyRPASF0i
# gqXJpFfDGwo1Iup95IZknymdNP55hIktOswSa8dpEAq5UHjMTewShFz3K8u26hBY
# HPmat+myIWj8C7/UdqHyHp1oxTP7a6tUyC5uQYI1oWoq0uct461Wu7cYN5KEaPCQ
# N9Ezfr+8KK3DUavqK6SYfLwB7lImSHhUY/TbF9JJ1A==
# SIG # End signature block
