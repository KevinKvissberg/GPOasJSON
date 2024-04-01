class RegistryItem {
    [string]$Key

    [string]$ValueName

    [string]$Value
    [ValidateSet(
        'Binary',
        'String',
        'DWord',
        'QWord',
        'MultiString',
        'ExpandString'
    )]
    [string]$Type

    [ValidateSet('C', 'R', 'U', 'D')]
    [string]$Action

    [ValidateSet('Computer', 'User')]
    $Context
}

Class GPOList {
    [string]$Name

    [RegistryItem[]]$ComputerConfiguration

    [RegistryItem[]]$UserConfiguration
}
# SIG # Begin signature block
# MIIFWwYJKoZIhvcNAQcCoIIFTDCCBUgCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUpXhWGcJm8ErejfUjuI/W2kBO
# TiygggL2MIIC8jCCAdqgAwIBAgIQYseIafgwqaZNeZ4d0CYhxTANBgkqhkiG9w0B
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
# BAGCNwIBFTAjBgkqhkiG9w0BCQQxFgQUYc4CLZgL3h+3t4NRjVs8xRropngwDQYJ
# KoZIhvcNAQEBBQAEggEATfO/oOm56khhSBT7sjCXV29MhL53tMPwN/Q5QpjZfCi3
# xqKmlydeE1XBPw/VLiG2gMup56PHwAf5nOyiRAfEerBr/Gzz75NANcBzsZLz3qN6
# V9keZOzOrClfp8AR1PkH1jkX7iKHbENWXl1b7qwd4zMntKaG6BBRlRnb02fjBoyz
# 5/tsseQ5vFHpKNUq9rJ4SZj6ZHWRWFWH9SDPpmAgySkyinoqNkKasXdmrao32+Pr
# IVtJjx+vWr0Zj8kPWYC4ceo6QBE1t6G/x/XP8AuML7VX7DwVoBb2g+tb7ZBlWOpl
# I81W5h55rCXQaekXmuuY3Xo3i1eoaWhhaz8Q9pfp8Q==
# SIG # End signature block
