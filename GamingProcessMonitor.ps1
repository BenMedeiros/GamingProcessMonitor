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

Import-Module "$PSScriptRoot\Modules\MyModule" -Force
Get-Command -Module MyModule


while ($true) {
    # KeyLogger will run and wait until the user types [help], allowing the rest of the script to continue. Then the monitoring will start.
    ./Scripts/KeyLogger.ps1

    # Example 1: Monitor CPU usage aggregated across all cores
    # Start-MonitorTypes -FilePath "$PSScriptRoot\Data" -MonitorTypes '\Processor(_Total)\% Processor Time'

    # Example 2: Monitor all CPU performance metrics per core
    # Start-MonitorTypes -FilePath "$PSScriptRoot\Data" -MonitorTypes '\Processor(*)\*'

    # Main
    # Start-MonitorTypes -FilePath "$PSScriptRoot\Data" -MonitorTypes '\Processor(*)\*', '\Memory\*', '\GPU Engine(pid_35868*)\*'
    # Start-CPUMonitor -FilePath "$PSScriptRoot\Data"
    Start-MonitorTypes -FilePath "$PSScriptRoot\Data" -MonitorTypes '\Processor(*)\*', '\Memory\*'
}