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