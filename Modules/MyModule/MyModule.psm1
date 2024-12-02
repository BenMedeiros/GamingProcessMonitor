

function Start-CPUMonitor {
    param (
        [string]$FilePath
    )

    # Ensure the file exists
    if (-not (Test-Path -Path $FilePath)) {
        New-Item -ItemType File -Path $FilePath -Force
    }

    $cpuCounter = Get-Counter '\Processor(_Total)\% Processor Time'

    for ($i = 0; $i -lt 30; $i++) {
        $cpuUsage = $cpuCounter.CounterSamples.CookedValue
        $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
        "$timestamp - CPU Usage: $cpuUsage%" | Out-File -FilePath $FilePath -Append
        Start-Sleep -Seconds 1
        $cpuCounter = Get-Counter '\Processor(_Total)\% Processor Time'
    }
}


Export-ModuleMember -Function Start-CPUMonitor