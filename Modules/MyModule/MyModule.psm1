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

    $timestamp = Get-Date -Format "yyyy-MM-dd_HHmmss"
    $fileName = "cpu_usage_per_core_log_$timestamp.txt"
    $FilePath = Join-Path -Path $FilePath -ChildPath $fileName
    Write-Output "Creating file: $FilePath"
# Create new file with timestamp in name
    New-Item -ItemType File -Path $FilePath -Force
    
    $cpuMonitorActive = $true
    while($cpuMonitorActive) {
        if ([System.Console]::KeyAvailable) {
            $null = [System.Console]::ReadLine()
            break
        }

        $cpuCounters = Get-Counter '\Processor(*)\*','\Memory\*','\GPU Engine(pid_35868*)\*' -MaxSamples 1 -SampleInterval 1

            if (-not $headers) {
                $headers = $cpuCounters.CounterSamples | ForEach-Object { $_.Path }
                $headersString = "Timestamp," + ($headers -join ",")
                # Remove commas from the headers for CSV
                $headersString = $headersString -replace ",", ""
                Write-Output $headersString
                $headersString | Out-File -FilePath $FilePath -Append -Encoding ascii
            }

            $timestamp = $cpuCounters.CounterSamples[0].Timestamp
            $values = $cpuCounters.CounterSamples | ForEach-Object { $_.CookedValue }
            $cpuLogString = "$timestamp," + ($values -join ",")
            $cpuLogString | Out-File -FilePath $FilePath -Append -Encoding ascii
            Write-Output $cpuLogString
        
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


function Start-MonitorFPS{

}


Export-ModuleMember -Function Start-CPUMonitor, Start-CPUMonitorPerCore, Start-GPUMonitor