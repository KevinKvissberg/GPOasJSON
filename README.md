# GPOasJSON
This module is aimed at deploying GPO objects from a JSON database. 
As limitations between powershell and ActiveDirectory GPO objects this module is focused on only registry settings in GPOs. 

This module is also aimed at working better with git as normal GPO backups can be a pain to keep track of in git. 

## Deployment from JSON
Using json files stored in a Data directory we can deploy the GPOs from the JSON files like following.

**gpoDemostration.json**
```
{
    "ComputerConfiguration" :
    [
        {
            "Key" : "HKEY_LOCAL_MACHINE\\RegisteredApplications",
            "ValueName" : "ExampleKeyName",
            "Value" : "ValueGoesHere",
            "Type" : "String",
            "Action" : "R",
            "Context" : "Computer"
        }
    ]
}
```

Then we can use the Function: **Set-GPRegistyValuesPlus -DataPath "C:\\Example\\GPOs\\"** \
This will create the GPO if needed, then add all the corresponding GPO registry values. 

## Variables in the Registry
Using customizable keywords like _CHANGE_DOMAIN_ or _CHANGE_Domain_DistinguishedName_ we can replace the values before registry deployment to accomodate for the current domain. \
This is useful when you want to store a set of generic GPO objects but customize the GPO objects before deployment. 

## Backups
Using **New-GPRegistyBackup -GPOName "gpoDemostration" -BackupPath ".\backups\"** you can backup gpos to this modules JSON format.
