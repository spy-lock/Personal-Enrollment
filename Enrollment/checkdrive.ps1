# Check if the current user is an administrator and elevate the privileges if not
IF (-Not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator')) {
    IF ([int](Get-CimInstance -Class Win32_OperatingSystem | Select-Object -ExpandProperty BuildNumber) -ge 6000) {
        $CommandLine = "-File `"" + $MyInvocation.MyCommand.Path + "`" " + $MyInvocation.UnboundArguments
        Start-Process -FilePath PowerShell.exe -Verb Runas -ArgumentList $CommandLine -WindowStyle Maximized
        Exit
    }
}

# Clear the console output
Clear-Host

# Display a message
Write-Output "`n Loading storage drivers..."

# Get the computer manufacturer information
$computerMANU = Get-ComputerInfo

# Load the appropriate storage driver based on the manufacturer
IF($computerMANU.CsManufacturer -like "LENOVO") {
    drvload C:/drivers/LENOVO-storage-drivers/iastorvd.inf
}

IF($computerMANU.CsManufacturer -like "HP") {
    drvload C:/drivers/HP-storage-drivers/iastorvd.inf
}

IF($computerMANU.CsManufacturer -like "Microsoft Corporation") {
    drvload C:/drivers/Microsoft-Corporation-storage-drivers/iastorvd.inf
}

Start-Sleep -Seconds 2

Start-Process powershell.exe -ArgumentList X:\windows\WinForm\PE\installdriveform.ps1 -Wait

# Get the disk number, windows choice, and language choice from temporary files
$disknumber = Get-Content $env:windir\temp\drivechoice.txt

$windowschoice = Get-Content $env:windir\temp\windowschoice.txt

$taalkeuze = Get-Content $env:windir\temp\languagechoice.txt

Write-Output "`n Windows $windowschoice $taalkeuze configuration is starting on disk $disknumber..."
Start-Sleep -Seconds 2

# Define an array of drive letters
$drives = "C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"

# Loop through each drive letter and check if it contains a file named checkofditdejuistedriveis.txt
FOREACH ($drive in $drives){
	IF (Test-Path "$($drive):\\checkofditdejuistedriveis.txt") {
		# If the file is found, assign the drive letter to a variable named IMAGESDRIVE
    $IMAGESDRIVE = $drive
  }
}

# If IMAGESDRIVE is not empty, display its value and list the contents of the images folder on that drive
IF ($IMAGESDRIVE) {
	Write-Output "The Images folder is on drive: $IMAGESDRIVE"
  $imagepath = "$IMAGESDRIVE" + ':\\' + 'images'
  Get-ChildItem $imagepath
}

# If IMAGESDRIVE is empty, display an error message and restart the computer after 60 seconds
ELSE {
	Write-Output "The Images folder could not be found on any of the drives: $drives"
  $tiny10 = read-host -Prompt "Install tiny 10? (Y/N)"

  IF($tiny10 -eq "N") {
    Restart-Computer -Force
  }

  IF($tiny10 -eq "Y"){
    Start-Process X:/local/setup.exe -Wait    
  }

}

# Copy the autounattend.xml file from the images folder to the appropriate subfolder based on the language and disk choices, overwriting any existing file
Copy-Item -Path "$imagepath\\autounattend\\$taalkeuze$disknumber-$windowschoice\\autounattend.xml" -Destination "$imagepath\\win11`_$taalkeuze" -Force

# Run a command to fix the TPM issue if it exists on any of the drives
cmd /q /c "FOR %i IN (C D E F G H I J K L N M O P Q R S T U V W X Y Z) DO IF EXIST %i:\TPM_Fix.cmd cmd /k %i:\TPM_Fix.cmd"

# Define the path to the unattend file
$unattendpath = "$imagepath\win11`_$taalkeuze\autounattend.xml"

# Start the setup.exe file with the unattend file as an argument
Start-Process "$imagepath\win11`_$taalkeuze\setup.exe" /unattend:$unattendpath

# Start another PowerShell process with a script to show a loading screen
Start-Process powershell -WindowStyle Maximized -ArgumentList X:/loading-screen.ps1