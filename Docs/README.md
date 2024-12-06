# Gaming Process Monitor

## Overview
The Gaming Process Monitor is a PowerShell module designed to monitor CPU usage on a per-core basis. It logs the data to text files for further analysis.

## Features
- **CPU Monitoring**: Monitor overall CPU usage and per-core usage.
- **Automatic Logging**: Logs data to timestamped text files.

## Functions
### Start-CPUMonitor
Monitors overall CPU usage and logs the data to a specified file.

**Usage:**
```ps1
Start-CPUMonitor -FilePath "$PSScriptRoot\Data"
```

### Start-CPUMonitorPerCore
Monitors CPU usage per core and logs the data to a specified directory with timestamped filenames.

**Usage:**
```ps1
Start-MonitorTypes -FilePath "path\to\log\directory"
```

## Installation
1. Clone the repository.
2. Import the module:
```ps1
Import-Module "path\to\MyModule.psm1"
```

## Examples

### Example 1: Monitor CPU usage aggregated across all cores
```ps1
Start-MonitorTypes -FilePath "$PSScriptRoot\Data" -MonitorTypes '\Processor(_Total)\% Processor Time'
```

### Example 2: Monitor all CPU performance metrics per core
```ps1
Start-MonitorTypes -FilePath "$PSScriptRoot\Data" -MonitorTypes '\Processor(*)\*'
```

### Example 3: Monitor tons of stuff, and GPU for PID (otherwise it's too many)
```ps1
Start-MonitorTypes -FilePath "$PSScriptRoot\Data" -MonitorTypes '\Processor(*)\*', '\Memory\*', '\GPU Engine(pid_35868*)\*'
```

## Contributing
Contributions are welcome! Please fork the repository and submit a pull request.

## License
This project is licensed under the MIT License.