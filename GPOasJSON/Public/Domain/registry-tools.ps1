function Get-ADRecursePolicyKeys {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$GPOName
    )
    Write-Verbose "Getting registry values for GPO: $($GPOName)"
    $gpo = [xml](Get-GPOReport -ReportType Xml -Name $GPOName)
    $result = @()
    if ($null -ne $gpo.gpo.Computer.ExtensionData) {
        $key = $gpo.gpo.Computer.ExtensionData.Extension.RegistrySettings.Registry.Properties
        if ($null -ne $key) {
            $key | Add-Member -MemberType NoteProperty -Name Context -Value "Computer"
            $result += $key
        }
    }
    if ($null -ne $gpo.gpo.User.ExtensionData) {
        $key = $gpo.gpo.User.ExtensionData.Extension.RegistrySettings.Registry.Properties
        if ($null -ne $key) {
            $key | Add-Member -MemberType NoteProperty -Name Context -Value "User"
            $result += $key
        }
    }
    return $result
}
# SIG # Begin signature block
# MIIFWwYJKoZIhvcNAQcCoIIFTDCCBUgCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUG0hrYf/ElDAGQHFYLnCCyjb0
# 9GOgggL2MIIC8jCCAdqgAwIBAgIQYseIafgwqaZNeZ4d0CYhxTANBgkqhkiG9w0B
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
# BAGCNwIBFTAjBgkqhkiG9w0BCQQxFgQU++sZSVPWLaqIo6oJxh7LdUzDiMkwDQYJ
# KoZIhvcNAQEBBQAEggEAn3mPgePgzUsedibZTiDUC4jaxwMqbc4S6SiOBez8q+WS
# qWQrkxhnGk/5/t0Jj+FQSNFJVsKttiuIYLfLlI/J6i3azYHDKtmlYO7KX0srhFxx
# U+8evOzbgQ0HeRjUgAX9qUQ4bji4yHTCFui3OEr3VADHDMV2ywp6DePt1QNw7R9n
# lZhrf/2Ev8vF77PBXIpRMOpkxZhIna5VvLBahGY6Tc2wvEYhTDty+PGtbwKilmxv
# 0o26NA2xa8ItAw/kX7NpqlGaVoKY25ONdwYoNnal4jHGSwK3NF3mtdV2T4wNBYy0
# NZVdwyJ5GZbYI/b7NoN/exLYOBvlueDSIaGv3XE0UQ==
# SIG # End signature block
