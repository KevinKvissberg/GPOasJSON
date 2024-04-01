class RegistryItem {
    [string]$Key

    [string]$ValueName

    [string]$Value
    [ValidateSet(
        'Reg_BINARY',
        'Reg_SZ',
        'Reg_DWORD',
        'Reg_QWORD',
        'Reg_MULTI_SZ',
        'Reg_EXPAND_SZ'
    )]
    [string]$Type

    [ValidateSet('C', 'R', 'U', 'D')]
    [char]$Action

    [ValidateSet('Computer', 'User')]
    $Context
}

Class GPOList {
    [string]$Name

    [RegistryItem[]]$ComputerConfiguration

    [RegistryItem[]]$UserConfiguration
}