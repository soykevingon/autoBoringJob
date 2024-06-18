# PowerShell Script to Empty Recycle Bin Silently

# Assumption: User has administrative privileges to run this script.
# Warning: This script will permanently delete all items in the Recycle Bin without any prompt for confirmation.
# Suggestion: Ensure you do not have any items in the Recycle Bin that you may want to recover.

# Import necessary namespace for using Shell object
Add-Type -AssemblyName Microsoft.VisualBasic
Add-Type -AssemblyName System.Windows.Forms

# Create a Shell object
$shell = New-Object -ComObject Shell.Application

# Get the Recycle Bin folder using its Shell special folder value, which is 10
$recycleBin = $shell.Namespace(0xA)

# Check if Recycle Bin is not empty
if ($recycleBin.Items().Count -gt 0) {
    # Empty the Recycle Bin silently
    $recycleBin.Items() | ForEach-Object { $_.InvokeVerb("Delete") }
    Write-Output "Recycle Bin has been emptied."
} else {
    Write-Output "Recycle Bin is already empty."
}

# Release COM object to avoid memory leaks
[System.Runtime.Interopservices.Marshal]::ReleaseComObject($shell) | Out-Null
Remove-Variable shell

# Note: This script does not provide a confirmation prompt before emptying the Recycle Bin.
# It is recommended to double-check the contents of your Recycle Bin before running this script.
