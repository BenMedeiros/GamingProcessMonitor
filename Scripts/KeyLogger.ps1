function Start-KeyLogger {
    $csFilePath = "c:/Users/benme/source/repos/Powershell/GamingProcessMonitor/Scripts/KeyLogger.cs"
    Write-Output "Loading C# code from $csFilePath..."
    
    try {
        Add-Type -Path $csFilePath -ReferencedAssemblies "System.Windows.Forms", "System.Drawing"
        Write-Output "C# code loaded successfully."
    } catch {
        Write-Output "Failed to load C# code: $_"
        return
    }

    Write-Output "Starting KeyLogger..."
    [KeyLogger]::Start() 
}

function Stop-KeyLogger {
    Write-Output "Stopping KeyLogger..."
    [KeyLogger]::Stop()
}

function Get-KeyPresses {
    return [KeyLogger]::GetKeyPresses()
}

# Call the function to start the keylogger
Start-KeyLogger

# Example usage: Get the key presses after some time
Write-Output "Keylogger started. Sleeping for 10 seconds..."
Start-Sleep -Seconds 10
$keyPresses = Get-KeyPresses
Write-Output "Captured Key Presses: $($keyPresses -join ', ')"

# Stop the keylogger
Stop-KeyLogger

# ...existing code...
