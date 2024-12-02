Import-Module -Name "$PSScriptRoot/../Modules/MyModule" -Verbose

# List available commands in the module to verify the function is exported
Get-Command -Module MyModule
