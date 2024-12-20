# Specify the directory to watch
$directoryToWatch = "$PSScriptRoot\..\Modules\MyModule"
$fileToWatch = "MyModule.psm1"

Write-Host $directoryToWatch
Write-Host $fileToWatch
# Resolve the directory path
$resolvedDirectoryToWatch = (Resolve-Path -Path $directoryToWatch).Path
Write-Host "Resolved directory to watch: "
Write-Host $resolvedDirectoryToWatch

# Create a new FileSystemWatcher instance
$watcher = New-Object System.IO.FileSystemWatcher $resolvedDirectoryToWatch

# Set the filter to monitor the specific file
$watcher.Filter = $fileToWatch
$watcher.NotifyFilter = [System.IO.NotifyFilters]::LastWrite

# Register event handler for file changed event
$sourceIdentifier = "FileChangedEvent"
Write-Host "Registering event with SourceIdentifier: $sourceIdentifier"

# Unfortunatly, this event gets called twice by Powershell
$changedEventHandler = Register-ObjectEvent $watcher "Changed" -SourceIdentifier $sourceIdentifier -Action {
    Write-Host "File Changed: "
    
    # Update the ModuleVersion in the MyModule.psd1 file
    function Update-ModuleVersion {
        param (
            [string]$filePath
        )

        Write-Host "Updating ModuleVersion to ModuleVersioning in file: "
        Write-Host $filePath
        $content = Get-Content -Path $filePath

        $contentLines = $content -split "`r`n"
        foreach ($line in $contentLines) {
            if ($line.Trim().StartsWith('ModuleVersion')) {
                $lineSplit1 = $line.Split("'")
                $lineSplit2 = $lineSplit1[1].Split(".")
                
                $patchVersion = $lineSplit2[2]
                $patchVersion = [int]$patchVersion + 1
                $lineSplit2[2] = $patchVersion
                $lineSplit1[1] = $lineSplit2 -join "."
                $rebuiltLine = $lineSplit1 -join "'"
                
                Write-Host "patchVersion: $patchVersion"
                Write-Host "rebuiltLine: $rebuiltLine"
                $content = $content -replace $line, $rebuiltLine
            }
        }
        
        Set-Content -Path $filePath -Value $content
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