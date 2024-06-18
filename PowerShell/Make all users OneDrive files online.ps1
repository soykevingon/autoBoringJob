# Get all user profile directories from C:\Users
$userProfilesPath = "C:\Users"
$userProfiles = Get-ChildItem -Path $userProfilesPath -Directory

# Function to make a file online-only
function Set-OnlineOnly {
    param (
        [string]$path
    )
    if (Test-Path -Path $path) {
        # Set the attribute to make it online-only
        & attrib +U $path
        Write-Output "Set to online-only: $path"
    } else {
        Write-Output "Item not found: $path"
    }
}

# Loop through each user profile directory
foreach ($userProfile in $userProfiles) {
    # Get all directories that contain "OneDrive" in their name
    $oneDriveDirs = Get-ChildItem -Path $userProfile.FullName -Directory -Recurse | Where-Object { $_.Name -like "*OneDrive*" }

    # Loop through each directory containing "OneDrive" and process files
    foreach ($dir in $oneDriveDirs) {
        # Get all files within the directory and its subdirectories
        $files = Get-ChildItem -Path $dir.FullName -File -Recurse
        foreach ($file in $files) {
            # Set each file to be online-only
            Set-OnlineOnly -path $file.FullName
        }
    }
}