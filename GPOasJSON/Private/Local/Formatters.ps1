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