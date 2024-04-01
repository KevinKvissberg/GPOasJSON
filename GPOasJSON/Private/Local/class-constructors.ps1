class RegistryItem {
    [string]$Key

    [string]$ValueName

    [string]$Value
    [ValidateSet(
        'Binary',
        'String',
        'DWord',
        'QWord',
        'MultiString',
        'ExpandString'
    )]
    [string]$Type

    [ValidateSet('C', 'R', 'U', 'D')]
    [string]$Action

    [ValidateSet('Computer', 'User')]
    $Context
}

Class GPOList {
    [string]$Name

    [RegistryItem[]]$ComputerConfiguration

    [RegistryItem[]]$UserConfiguration
}