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

function Clear-ADGPORegistryValues {
    param (
        [Parameter(Mandatory = $true)]
        [string]$GPOName
    )
    # Get all registry values
    $gpoInfo = Get-ADRecursePolicyKeys $GPOName

    if ($null -eq $gpoInfo) {
        Write-Verbose "No registry values found for GPO: $($GPOName)"
        return
    }

    # Remove all registry values, this is becouse it is a easy way to make sure that the registry values are up to date
    $gpoInfo | ForEach-Object {
        Write-Verbose "Removing registry value: $($_.hive)\$($_.key)\$($_.name) in GPO: $($GPOName)"
        Remove-GPPrefRegistryValue -Name $GPOName -Key "$($_.hive)\$($_.key)" -ValueName $_.name -Context $_.Context -ErrorAction SilentlyContinue | Out-Null
    }
    Write-Verbose "Completed removing all registry values for GPO: $($GPOName)"
}

function Set-ADGPORegistryKeys {
    param (
        [Parameter(Mandatory = $true)]
        [string]$GPOName,
        [Parameter(Mandatory = $true)]
        [RegistryItem]$registryItem
    )
    $gpoSettings = @{
        Name = $GPOName
        Key = $registryItem.Key
        ValueName = $registryItem.ValueName
        Value = $registryItem.Value
        Type = $registryItem.Type
        Action = $registryItem.Action
        Context = $registryItem.Context
    }
    Write-Output "Setting registry values: $($registryItem.Key)\$($registryItem.ValueName) in GPO: $($GPOName)"
    Write-Verbose ("KeyValues: " + ($gpoSettings | ConvertTo-Json))
    Set-GPPrefRegistryValue @gpoSettings | Out-Null
}