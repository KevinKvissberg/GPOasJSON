function Format-Json([Parameter(Mandatory, ValueFromPipeline)][String] $json) {
    $indent = 0;
    ($json -Split '\n' |
    ForEach-Object {
        if ($_ -match '[\}\]]') {
            # This line contains  ] or }, decrement the indentation level
            $indent--
        }
        $line = ('  ' * $indent * 2) + $_.TrimStart().Replace(':  ', ': ')
        if ($_ -match '[\{\[]') {
            # This line contains [ or {, increment the indentation level
            $indent++
        }
        $line
    }) -Join "`n"
}

<#
.SYNOPSIS
Converts a registry type string to a human readable string.

.PARAMETER type
The registry type string to convert.
#>
function ConvertTo-RegistryTypeString {
    param (
        [Parameter(Mandatory, ValueFromPipeline)][String] $type
    )
    switch ($type) {
        "Reg_SZ" {
            return "String"
        }
        "Reg_DWORD" {
            return "DWord"
        }
        "Reg_QWORD" {
            return "QWord"
        }
        "Reg_EXPAND_SZ" {
            return "ExpandString"
        }
        "Reg_MULTI_SZ" {
            return "MultiString"
        }
        "Reg_BINARY" {
            return "Binary"
        }
        default {
            return "Unknown"
        }
    }
}
# SIG # Begin signature block
# MIIFWwYJKoZIhvcNAQcCoIIFTDCCBUgCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUEOhjTcpPtLqngYN87ZMOpr1j
# XpigggL2MIIC8jCCAdqgAwIBAgIQYseIafgwqaZNeZ4d0CYhxTANBgkqhkiG9w0B
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
# BAGCNwIBFTAjBgkqhkiG9w0BCQQxFgQUkBjaIxjJiwztwMiRhg4bEgsv7NswDQYJ
# KoZIhvcNAQEBBQAEggEApTUCglgoMcxHUbg4mliJbOZoS1Lj4a372beaQHK/AZYc
# CKZrVHqT8bf5eIFWD194tSfLtZiFJJAnkeUepZ5SmxUpXYkmBRkNDZv4vCBWcAGi
# I2L961jbwc44SPD3HhbaRvq2kaD7vO4kYbBjOs6HU0db3I/+TaKcl9G2IUraV/86
# Opo52Se4CHd+jldWo4qehwmXDWV5BXlteljkeVeRc8HPYneb5ecynNEA6FmBOJ4X
# Xv6U0utHNvjXMvmB/ELkEM7Dzl1ztY2sdZ7yS5bYRX+Q+wjq4jhGfxaU9AA1FYEt
# db3BF0oTDoxMEJayTMgXRmY3p29ZFh9X2RSWkAHo9g==
# SIG # End signature block
