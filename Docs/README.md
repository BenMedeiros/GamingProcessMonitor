# Gaming Process Monitor

## Overview
The Gaming Process Monitor is a PowerShell module designed to monitor CPU and GPU usage on a per-core basis. It logs the data to text files for further analysis.

## Features
- **CPU Monitoring**: Monitor overall CPU usage and per-core usage.
- **GPU Monitoring**: Monitor GPU usage.
- **Automatic Logging**: Logs data to timestamped text files.

## Functions
### Start-CPUMonitor
Monitors overall CPU usage and logs the data to a specified file.

**Usage:**
```ps1
Start-CPUMonitor -FilePath "path\to\logfile.txt"
```

### Start-CPUMonitorPerCore
Monitors CPU usage per core and logs the data to a specified directory with timestamped filenames.

**Usage:**
```ps1
Start-CPUMonitorPerCore -FilePath "path\to\log\directory"
```

### Start-GPUMonitor
Monitors GPU usage and logs the data to a specified file.

**Usage:**
```ps1
Start-GPUMonitor -FilePath "path\to\logfile.txt"
```

## Installation
1. Clone the repository.
2. Import the module:
```ps1
Import-Module "path\to\MyModule.psm1"
```

## Usage
1. Start monitoring CPU usage:
```ps1
Start-CPUMonitor -FilePath "path\to\cpu_log.txt"
```
2. Start monitoring per-core CPU usage:
```ps1
Start-CPUMonitorPerCore -FilePath "path\to\log\directory"
```
3. Start monitoring GPU usage:
```ps1
Start-GPUMonitor -FilePath "path\to\gpu_log.txt"
```

## Contributing
Contributions are welcome! Please fork the repository and submit a pull request.

## License
This project is licensed under the MIT License.