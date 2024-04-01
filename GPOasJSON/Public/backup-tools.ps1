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