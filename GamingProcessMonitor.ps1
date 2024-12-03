Write-Output "Running GamingProcessMonitor.ps1 from: "
Write-Output "$PSScriptRoot"
Write-Output ""

if ($env:PSModulePath -notmatch [regex]::Escape("$PSScriptRoot\Modules")) {
    Write-Output "Adding module path to PSModulePath"
    Write-Output ""
    $env:PSModulePath += ";$PSScriptRoot\Modules"
}else{
    Write-Output "Module path already in PSModulePath"
    Write-Output ""
}


Write-Output "PSModulePath: "
Write-Output "$env:PSModulePath"
Write-Output ""

# -Force seems to handle this, however I thought I saw different behavior
# if (Get-Module -Name MyModule) {
#     Write-Output "Removing existing MyModule"
#     Remove-Module MyModule
# }
Import-Module "$PSScriptRoot\Modules\MyModule" -Force

Import-Module "$PSScriptRoot\Modules\MyModule"
Get-Command -Module MyModule

Start-CPUMonitor -FilePath "$PSScriptRoot\Data\cpu_usage_log.txt"
Start-CPUMonitor-PerCore -FilePath "$PSScriptRoot\Data\cpu_usage_per_core_log.txt"
