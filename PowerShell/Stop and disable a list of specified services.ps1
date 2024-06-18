# PowerShell script to stop and disable a list of specified services

# Define an array of service names to be stopped and disabled
$servicesToDisable = @('diagtrack', 'mapsbroker', 'wpcmonsvc', 'wisvc', 'icssvc', 'fax', 'wscsvc', 'certpropsvc', 'assignedaccessmanager', 'xboxgipsvc', 'xboxnetapisvc', 'xblgamesave', 'xtu3service', 'walletservice', 'ZoomCptService')

# Loop through each service in the array
foreach ($service in $servicesToDisable) {
    # Check if the service exists
    $serviceExists = Get-Service -Name $service -ErrorAction SilentlyContinue
    if ($serviceExists) {
        # Attempt to stop the service if it is running
        try {
            Stop-Service -Name $service -Force -ErrorAction Stop
            Write-Host "Successfully stopped service: $service"
        } catch {
            Write-Warning "Failed to stop service: $service. Error: $_"
        }

        # Attempt to disable the service
        try {
            Set-Service -Name $service -StartupType Disabled -ErrorAction Stop
            Write-Host "Successfully disabled service: $service"
        } catch {
            Write-Warning "Failed to disable service: $service. Error: $_"
        }
    } else {
        Write-Warning "Service $service does not exist or cannot be found."
    }
}

# Note: This script requires administrative privileges to stop and disable services.
# Warning: Disabling services can affect system functionality. Ensure you understand the impact of disabling each service.
# Suggestion: Test this script in a non-production environment before applying it to critical systems.