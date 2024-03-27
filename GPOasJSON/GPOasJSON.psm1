foreach ($module in (Get-ChildItem -Path $PSScriptRoot\Private -Filter *.ps1)) {
    . $module.FullName
}