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
    
    function Update-ModuleVersion {
        param (
            [string]$filePath
        )

        Write-Host "Updating ModuleVersion to ModuleVersioning in file: $filePath"
        $content = Get-Content -Path $filePath
        $newContent = $content -replace 'ModuleVersion', 'ModuleVersioning'
        Set-Content -Path $filePath -Value $newContent
        Write-Host "Updated ModuleVersion to ModuleVersioning in the file."
    }

    $resolvedFilePath = (Resolve-Path -Path "$PSScriptRoot\..\Modules\MyModule\MyModule.psd1").Path
    Update-ModuleVersion -filePath $resolvedFilePath
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