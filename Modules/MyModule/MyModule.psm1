function Start-CPUMonitor {
    param (
        [string]$FilePath 
    )

    Start-MonitorTypes -FilePath $FilePath -MonitorTypes '\Processor(_Total)\% Processor Time'
}

function Start-MonitorTypes {
    param (
        [string]$FilePath,
        # [ValidateSet('\Processor(*)\*', '\Memory\*', '\GPU Engine(pid_35868*)\*')]
        [ValidateScript({
            $_ -like '\Processor(*)\*' -or
            $_ -like '\Memory\*' -or
            $_ -like '\GPU Engine(pid_*)\*'
        })]
        [string[]]$MonitorTypes
    )

    $timestamp = Get-Date -Format "yyyy-MM-dd_HHmmss"
    $fileName = "performance_monitor_$timestamp.txt"
    $FilePath = Join-Path -Path $FilePath -ChildPath $fileName
    Write-Output "Creating file: $FilePath"
    Write-Output "Monitoring: $MonitorTypes"
    # Create new file with timestamp in name
    New-Item -ItemType File -Path $FilePath -Force
    
    $sampleInterval = 1
    Write-Output "Sample Interval: $sampleInterval"
    $dataPointsCollected = 0
    $cpuMonitorActive = $true
    while ($cpuMonitorActive) {
        if ([System.Console]::KeyAvailable) {
            $null = [System.Console]::ReadLine()
            break   
        }

        $cpuCounters = Get-Counter $MonitorTypes -MaxSamples 1 -SampleInterval $sampleInterval

        if (-not $headers) {
            $headers = $cpuCounters.CounterSamples | ForEach-Object { $_.Path }
            $headersString = "Timestamp," + ($headers -replace ",", "" -join ",")
            # Write-Output $headersString
            $headersString | Out-File -FilePath $FilePath -Append -Encoding ascii
        }

        $timestamp = $cpuCounters.CounterSamples[0].Timestamp
        $values = $cpuCounters.CounterSamples | ForEach-Object { $_.CookedValue }
        $cpuLogString = "$timestamp," + ($values -join ",")
        $cpuLogString | Out-File -FilePath $FilePath -Append -Encoding ascii
        # Write-Output $cpuLogString
        $dataPointsCollected++
        Write-Output "Data Points Collected: $dataPointsCollected"
        Write-Output "Press [enter] to stop monitoring..."
        # Start-Sleep -Milliseconds 10
    }
}


function Start-GPUMonitor {
    param (
        [string]$FilePath
    )
   # This function is deprecated and will be removed in a future release. Please use Start-MonitorTypes instead.
   Write-Warning "The function 'Start-GPUMonitor' is deprecated and will be removed in a future release. Please use 'Start-MonitorTypes' instead."

    # Ensure the file exists
    if (-not (Test-Path -Path $FilePath)) {
        New-Item -ItemType File -Path $FilePath -Force
    }

    $gpuMonitorActive = $true
    while ($gpuMonitorActive) {
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

Export-ModuleMember -Function Start-CPUMonitor, Start-MonitorTypes, Start-GPUMonitor