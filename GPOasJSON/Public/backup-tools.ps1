Function New-GPRegistyBackup {
    param (
        $gpoName,
        $backupPath = "$PSScriptRoot\Data"
    )
    $gpo = [xml](Get-GPOReport -ReportType Xml -Name $gpoName)
    $gpoData = @{
        Name = $gpoName
    }
    if ($null -ne $gpo.gpo.Computer.ExtensionData) {
        $gpoData += @{ComputerConfiguration = @{Registry = @()}}
        foreach ($key in $gpo.gpo.Computer.ExtensionData.Extension.RegistrySettings.Registry.Properties) {
            $registryHashTable = @{
                Key = "$($key.hive)\\$($key.key)"
                ValueName = $key.name
                Value = $key.value
                Type = $key.type
                Action = $key.action
                Context = "Computer"
            }
            $gpoData.ComputerConfiguration.Registry += $registryHashTable
        }
    }
    if ($null -ne $gpo.gpo.User.ExtensionData) {
        $gpoData += @{UserConfiguration = @{Registry = @()}}
        foreach ($key in $gpo.gpo.User.ExtensionData.Extension.RegistrySettings.Registry.Properties) {
            $registryHashTable = @{
                Key = "$($key.hive)\\$($key.key)"
                ValueName = $key.name
                Value = $key.value
                Type = $key.type
                Action = $key.action
                Context = "User"
            }
            $gpoData.UserConfiguration.Registry += $registryHashTable
        }
    }
    
    if (!(Test-Path $backupPath)) {
        New-Item -Path $backupPath -ItemType Directory
    }

    $gpoData | ConvertTo-Json -Depth 100 | Format-Json | Out-File "$backupPath\$gpoName.json"
}
new-GPRegistyBackup "anotherGPO"