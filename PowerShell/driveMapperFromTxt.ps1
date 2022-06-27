echo "Before we begin you need to put the drive path on a file called list.txt(each path a line)."
echo "You need to put it where the script is or know the exact location. Each path should be like this:"
echo "X: \\SERVER\FOLDER (with the space between : and \"
pause
cls
echo "Now let's create map drive"
pause
cls
$req = 0
while ($req -ne 1){
               echo "Where's the list.txt file?"
               echo "A) In script folder"
               echo "B) Elsewhere"
               $answer = Read-Host -Prompt "Select"
               if ($answer -eq "A" -or $answer -eq "a"){
                              $path = $PSScriptRoot
                              echo "We got it"
                              pause
                              $req = 1
               }
               elseif ($answer -eq "B" -or $answer -eq "b"){
                              $path = Read-Host -Prompt "Enter the list.txt path: "
                              echo "Thanks"
                              pause
                              $req = 1
               }
               else {
                              echo "Not the answer, try again: "
                              #$req = 0
                              cls
               }
}
[array] $drivePathList = Get-Content -Path $path\list.txt
echo $drivePathList
pause
foreach ($drivePath in $drivePathList){
               $driveLetter = $drivePath.substring(0,2)
               $pathExist = Test-Path -Path $drivePath.substring(0,2)
               if ($pathExist){
                              echo "The drive $driveLetter already exist"
                              echo " "
               }
               else{
                              net use $driveLetter $drivePath.substring(3) /persistent:yes
               }
               pause
}
cls
echo "Script finished. Check Mapped Drives"
pause
