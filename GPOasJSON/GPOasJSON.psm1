foreach ($module in (Get-ChildItem -Path $PSScriptRoot\Public -Filter *.ps1)) {
    . $module.FullName
}