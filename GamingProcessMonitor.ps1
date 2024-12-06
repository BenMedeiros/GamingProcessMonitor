Write-Output "Running GamingProcessMonitor.ps1 from: "
Write-Output "$PSScriptRoot"
Write-Output ""

if ($env:PSModulePath -notmatch [regex]::Escape("$PSScriptRoot\Modules")) {
    Write-Output "Adding module path to PSModulePath"
    Write-Output ""
    $env:PSModulePath += ";$PSScriptRoot\Modules"
}
else {
    Write-Output "Module path already in PSModulePath"
    Write-Output ""
}

Import-Module "$PSScriptRoot\Modules\MyModule"
Get-Command -Module MyModule

#Example 1: Monitor CPU usage aggregated across all cores
# Start-GPUMonitor -FilePath "$PSScriptRoot\Data" -MonitorTypes '\Processor(_Total)\% Processor Time'

# Example 2: Monitor all CPU performance metrics per core
# Start-CPUMonitorPerCore -FilePath "$PSScriptRoot\Data" -MonitorTypes '\Processor(*)\*'

# Main
Start-CPUMonitorPerCore -FilePath "$PSScriptRoot\Data" -MonitorTypes '\Processor(*)\*', '\Memory\*', '\GPU Engine(pid_35868*)\*'

