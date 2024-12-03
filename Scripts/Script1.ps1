# Specify the directory to watch
$directoryToWatch = "$PSScriptRoot\..\Data"
$fileToWatch = "cpu_usage_per_core_log.txt"

# Resolve the directory path
$resolvedDirectoryToWatch = (Resolve-Path -Path $directoryToWatch).Path
Write-Host "Resolved directory to watch: $resolvedDirectoryToWatch"

# Create a new FileSystemWatcher instance
$watcher = New-Object System.IO.FileSystemWatcher $resolvedDirectoryToWatch

# Set the filter to monitor the specific file
$watcher.Filter = $fileToWatch
$watcher.NotifyFilter = [System.IO.NotifyFilters]::LastWrite

# Register event handler for file changed event
$sourceIdentifier = "FileChangedEvent"
Write-Host "Registering event with SourceIdentifier: $sourceIdentifier"
$changedEventHandler = Register-ObjectEvent $watcher "Changed" -SourceIdentifier $sourceIdentifier -Action {
    Write-Host "File Changed: "
    
    function Increment-ModuleVersion {
        param (
            [string]$filePath
        )

        Write-Host "Incrementing ModuleVersion in file: $filePath"
        $content = Get-Content -Path $filePath
        $moduleVersionLine = $content | Select-String -Pattern 'ModuleVersion'
        if ($moduleVersionLine) {
            Write-Host "ModuleVersion found in the file."
            $version = $moduleVersionLine -replace '.*?(\d+\.\d+\.\d+\.\d+).*', '$1'
            $versionParts = $version -split '\.'
            
            Write-Host "Current ModuleVersion: $version Parts: $versionParts[0] $versionParts[1] $versionParts[2] $versionParts[3]"
            $versionPartMinorNum = $versionParts[2] -split ''''
            $versionPartMinorNum = [int]$versionPartMinorNum[0] + 1
            $versionParts[2] = $versionPartMinorNum -join ''''
            $newVersion = $versionParts -join '.'
            Write-Host "New ModuleVersion: $newVersion"
            $newContent = $content -replace $version, $newVersion
            Set-Content -Path $filePath -Value $newContent
            Write-Host "ModuleVersion incremented to $newVersion"
        } else {
            Write-Host "ModuleVersion not found in the file."
        }
    }

    $resolvedFilePath = (Resolve-Path -Path "$PSScriptRoot\..\Modules\MyModule\MyModule.psd1").Path
    Increment-ModuleVersion -filePath $resolvedFilePath
}

# Begin monitoring the directory
$watcher.EnableRaisingEvents = $true
Write-Host "Started monitoring file changes for: $resolvedDirectoryToWatch\$fileToWatch"

# Keep the script running
Write-Host "Monitoring file changes. Press [Enter] to exit."
while ($true) {
    if ([System.Console]::KeyAvailable) {
        $null = [System.Console]::ReadLine()
        break
    }
    Start-Sleep -Seconds 1
}

# Unregister the event and dispose the watcher when done
Write-Host "Unregistering event with SourceIdentifier: $sourceIdentifier"
Unregister-Event -SourceIdentifier $sourceIdentifier
$changedEventHandler.Dispose()
$watcher.Dispose()
Write-Host "Stopped monitoring file changes."