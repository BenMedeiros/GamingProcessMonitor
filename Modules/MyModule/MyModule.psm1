function Start-CPUMonitor {
    param (
        [string]$FilePath
    )

    # Ensure the file exists
    if (-not (Test-Path -Path $FilePath)) {
        New-Item -ItemType File -Path $FilePath -Force
    }

    for ($i = 0; $i -lt 3; $i++) {
        # You can only get one sample max per second with SampleInterval.  Pretty dumb.
        $cpuCounter = Get-Counter '\Processor(_Total)\% Processor Time' -MaxSamples 1 -SampleInterval 1
        $cpuUsage = $cpuCounter.CounterSamples.CookedValue
        $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
        "$timestamp - CPU Usage: $cpuUsage%" | Out-File -FilePath $FilePath -Append
        Write-Output "$timestamp - CPU Usage: $cpuUsage%"
        # Start-Sleep -Milliseconds 10
    }   
}

Export-ModuleMember -Function Start-CPUMonitor