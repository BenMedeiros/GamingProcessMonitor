"root:"
"$PSScriptRoot"

$env:PSModulePath += ";$PSScriptRoot\Modules"
"`n"
Write-Output "PSModulePath: $env:PSModulePath"

Remove-Module MyModule
Import-Module "$PSScriptRoot\Modules\MyModule" -Force

Import-Module "$PSScriptRoot\Modules\MyModule"
Get-Command -Module MyModule

# "`n"
# Get-Greeting182346 -Name "Ben"
# "`n"
# "Greeting has been displayed."

# # Start-CPUMonitor -FilePath "C:\path\to\cpu_usage_log.txt"

# Start-CPUMonitor -FilePath "$PSScriptRoot\Data\cpu_usage_log.txt"