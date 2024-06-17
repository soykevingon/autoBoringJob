# PowerShell Script to check the current time and date and if the time and date is off hours it will scan on SentinelOne
# The script stops if the current time is between 8:00 AM and 5:30 PM on a weekday
# Note: This script assumes that the system's timezone is correctly set and matches the intended timezone for these restrictions.
# Assuming the task is to navigate into a folder within C:\Program Files\SentinelOne that contains "Sentinel Agent" in its name
# This script will change the current directory to the first matching folder found.
# Warning: If there are multiple folders matching the criteria, this script will only navigate into the first one found.

# Get the current date and time
$currentDateTime = Get-Date

# Extract the day of the week and the time from the current date and time
$dayOfWeek = $currentDateTime.DayOfWeek
$timeOfDay = $currentDateTime.TimeOfDay

# Define the start and end times for the restricted period
$startTime = New-TimeSpan -Hours 8 -Minutes 0
$endTime = New-TimeSpan -Hours 17 -Minutes 30

# Check if today is a weekday (Monday to Friday)
if ($dayOfWeek -ge [System.DayOfWeek]::Monday -and $dayOfWeek -le [System.DayOfWeek]::Friday) {
    # It's a weekday, now check if the current time is within the restricted period
    if ($timeOfDay -ge $startTime -and $timeOfDay -lt $endTime) {
        # Current time is within the restricted period, stop the script
        Write-Host "It's between 8:00 AM and 5:30 PM on a weekday. Stopping the script."
        exit
    }
}

# If the script hasn't exited by now, it means it's either not a weekday or not within the restricted hours
# Place any additional script actions below this line


# Define the base path where to search for the folder
$basePath = "C:\Program Files\SentinelOne"

# Use Get-ChildItem to find directories within the base path that match the name criteria
$targetFolder = Get-ChildItem -Path $basePath -Directory | Where-Object { $_.Name -like "*Sentinel Agent*" } | Select-Object -First 1

# Check if a matching folder was found
if ($targetFolder -ne $null) {
    # Change directory to the found folder
    Set-Location $targetFolder.FullName
    Write-Output "Navigated to: $($targetFolder.FullName)"
    .\SentinelCtl.exe status
    Start-Sleep -Seconds 5
    .\SentinelCtl.exe scan_folder -i path
    Start-Sleep -Seconds 5
    .\SentinelCtl.exe is_scan_in_progress
} else {
    # If no matching folder was found, output a warning message
    Write-Warning "No folder containing 'Sentinel Agent' in its name was found in $basePath"
}

# Note: This script assumes administrative privileges are available if required for accessing the target directory.
# Suggestion: For scripts running in environments with strict security policies, consider handling permissions explicitly.
