foreach ($module in (Get-ChildItem -Path $PSScriptRoot\Private -Filter *.ps1 -Recurse)) {
    . $module.FullName
}