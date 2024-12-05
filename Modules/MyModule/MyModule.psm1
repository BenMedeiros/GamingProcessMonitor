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

function Start-CPUMonitorPerCore {
    param (
        [string]$FilePath
    )

    # Ensure the file exists
    if (-not (Test-Path -Path $FilePath)) {
        New-Item -ItemType File -Path $FilePath -Force
    }

    $cpuMonitorActive = $true
    while($cpuMonitorActive) {
        if ([System.Console]::KeyAvailable) {
            $null = [System.Console]::ReadLine()
            break
        }

        $cpuCounters = Get-Counter '\Processor(*)\% Processor Time' -MaxSamples 1 -SampleInterval 1

        foreach ($counter in $cpuCounters.CounterSamples) {
            $core = $counter.Path.Split('\')[-2]
            $core = $core.Replace("processor(", "").Replace(")", "")
            $cpuUsage = [math]::Round($counter.CookedValue, 3)
            $timestamp = $counter.Timestamp
            $cpuLogString = "$timestamp, $core, $cpuUsage"
            $cpuLogString | Out-File -FilePath $FilePath -Append
            Write-Output $cpuLogString
        }

        # Start-Sleep -Milliseconds 10
    }
}

function Start-GPUMonitor {
    param (
        [string]$FilePath
    )

    # Ensure the file exists
    if (-not (Test-Path -Path $FilePath)) {
        New-Item -ItemType File -Path $FilePath -Force
    }

    $gpuMonitorActive = $true
    while($gpuMonitorActive) {
        if ([System.Console]::KeyAvailable) {
            $null = [System.Console]::ReadLine()
            break
        }

        $gpuCounters = Get-Counter '\GPU Engine(*)\Utilization Percentage' -MaxSamples 2 -SampleInterval 1
        foreach ($counter in $gpuCounters.CounterSamples) {
            $gpu = $counter.Path.Split('\')[-2]
            $gpu = $gpu.Replace("GPU Engine(", "").Replace(")", "")
            $gpuUsage = [math]::Round($counter.CookedValue, 3)
            $timestamp = $counter.Timestamp
            $gpuLogString = "$timestamp, $gpu, $gpuUsage"
            $gpuLogString | Out-File -FilePath $FilePath -Append
            Write-Output $gpuLogString
        }

        # Start-Sleep -Milliseconds 10
    }
}



Export-ModuleMember -Function Start-CPUMonitor, Start-CPUMonitorPerCore, Start-GPUMonitor