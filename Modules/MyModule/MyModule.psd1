@{
    # Script module or binary module file associated with this manifest.
    RootModule = 'MyModule.psm1'

    # Version number of this module.
    ModuleVersion = '1.0.584'

    # ID used to uniquely identify this module
    GUID = '12345678-1234-1234-1234-123456789012'

    # Author of this module
    Author = 'Benjamin Medeiros'

    # Company or vendor of this module
    CompanyName = 'Benjamin Medeiros'

    # Description of the functionality provided by this module
    Description = 'Description of MyModule'

    # Functions to export from this module
    FunctionsToExport = @('Start-CPUMonitor', 'Start-CPUMonitorPerCore', 'Start-GPUMonitor')

    # Cmdlets to export from this module
    CmdletsToExport = @()

    # Variables to export from this module
    VariablesToExport = @()

    # Aliases to export from this module
    AliasesToExport = @()

    # Private data to pass to the module specified in RootModule/ModuleToProcess
    PrivateData = @{

    }
}
