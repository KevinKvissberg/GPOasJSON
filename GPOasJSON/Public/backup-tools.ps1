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

Function New-OUBackup {
    param (
        $backupPath = "$PSScriptRoot\..\Data"
    )
    $allOUs = Get-ADObject -LDAPFilter "(objectClass=organizationalUnit)" -Properties CanonicalName,DistinguishedName,Name | Sort-Object CanonicalName | Select-Object CanonicalName,DistinguishedName,Name

    $domainName = (Get-ADDomain).Name
    $domainRoot = (Get-ADDomain).DNSRoot

    $tree = @{}
    foreach ($ou in $allOUs) {
        $plainName = $ou.CanonicalName -replace "^$domainRoot/",""
        $plainName = $plainName -replace $domainName, "DomainOU"
        
        $currentNode = $tree
        foreach ($part in $plainName -split "/") {
            if (-Not $currentNode.ContainsKey($part)) {
                $currentNode[$part] = @{}
                $gpos = (Get-GPInheritance -Target $ou.DistinguishedName).GpoLinks
                if ($gpos) {
                    $gpoLinks = @()
                    foreach ($gpo in $gpos) {
                        if ($gpo.DisplayName -eq "Local Group Policy" -or $gpo.DisplayName -eq "Default Domain Policy" -or $gpo.DisplayName -eq "Default Domain Controllers Policy") {
                            continue
                        }

                        if (($gpo.Enabled -eq $false) -or ($gpo.Enforced -eq $true)) {
                            $gpoObj = @{
                                DisplayName = $gpo.DisplayName
                                Enabled = $gpo.Enabled
                                Enforced = $gpo.Enforced
                            }
                            $gpoLinks += $gpoObj
                        }
                        else {
                            $gpoLinks += $gpo.DisplayName
                        }
                    }
                    if ($gpoLinks) {
                        $currentNode[$part]._GPOs = $gpoLinks
                    }
                }
            }
            $currentNode = $currentNode[$part]
        }
    }
    $tree | ConvertTo-Json -Depth 100 | format-json | Out-File "$backupPath\ou.json" -Force
}