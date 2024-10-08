Function Set-WinImage {

    Remove-Item $env:ProgramFiles\enrollment\mount\WIN11PRO_en -Force -Recurse -erroraction SilentlyContinue
    Remove-Item $env:ProgramFiles\enrollment\mount\WIN11HOME_en -Force -Recurse -erroraction SilentlyContinue

    #CREATES DIRECTORIES FOR WHERE THE MOUNTED IMAGES WILL BE MOUNTED
    Write-Output "`n Creating directories..."
    WRITE-Output ""
    New-Item -ItemType Directory $env:ProgramFiles\enrollment\mount\Win11PRO_en -Force -ErrorAction SilentlyContinue | Out-Null
    New-Item -ItemType Directory $env:ProgramFiles\enrollment\mount\Win11HOME_en -Force -ErrorAction SilentlyContinue | Out-Null
    Write-Output ""
    start-sleep -second 1
    #MOUNTS THE IMAGES TO THE CREATED DIRECTORIES
    write-Output "`n Mounting images..."
    WRITE-output ""
    dism /mount-image /imagefile:"C:\program files\enrollment\iso\images\WIN11_en-gb\sources\install.wim" /index:1 /mountdir:"C:\program files\enrollment\mount\win11PRO_en"
    dism /mount-image /imagefile:"C:\program files\enrollment\iso\images\WIN11_en-gb\sources\install.wim" /index:2 /mountdir:"C:\program files\enrollment\mount\win11HOME_en"

    write-Output "`n Removing files in images..."
    WRITE-Output ""

    Remove-Item $env:ProgramFiles\enrollment\mount\win11PRO_en\files -Force -Recurse
    Remove-Item $env:ProgramFiles\enrollment\mount\win11HOME_en\files -Force -Recurse

    #COPYING FILES INSIDE THE MOUNTED IMAGES
    write-host "`n Copying items now..."
    copy-files -Source $env:ProgramFiles\enrollment\files -Destination $env:ProgramFiles\enrollment\mount\win11PRO_en\files -Activity "Copying 'WIN11PRO_en\files'..."  -Verbose
    copy-files -Source $env:ProgramFiles\enrollment\files -Destination $env:ProgramFiles\enrollment\mount\win11HOME_en\files -Activity "Copying 'WIN11HOME_en\files'..."  -Verbose

    WRITE-Output ""


    #UNMOUNTING IMAGES AND SAVING CHANGES
    write-Output "`n Unmounting images..."
    WRITE-Output ""
    dism /unmount-image /mountdir:"C:\program files\enrollment\mount\win11PRO_en" /commit
    dism /unmount-image /mountdir:"C:\program files\enrollment\mount\win11HOME_en" /commit

    Remove-Item $env:ProgramFiles\enrollment\mount\WIN11PRO_en -Force -Recurse -erroraction SilentlyContinue
    Remove-Item $env:ProgramFiles\enrollment\mount\WIN11HOME_en -Force -Recurse -erroraction SilentlyContinue

    Read-Host -Prompt "press (ENTER) to exit"
}

Function New-WinImageDrive {
     # Self-elevate the script if required
    if (-Not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator')) {
     if ([int](Get-CimInstance -Class Win32_OperatingSystem | Select-Object -ExpandProperty BuildNumber) -ge 6000) {
      $CommandLine = "-File `"" + $MyInvocation.MyCommand.Path + "`" " + $MyInvocation.UnboundArguments
      Start-Process -FilePath PowerShell.exe -Verb Runas -ArgumentList $CommandLine -WindowStyle Maximized
      Exit
     }
    }

############### ASSEMBLIES ###############
[void] [System.Reflection.Assembly]::LoadWithPartialName("System.windows.forms")


###############\\-FUNCTION-//###############

Function get-drives
{
    $listview_CreateDrive1.Items.Clear()
    $listview_CreateDrive1.Columns.Clear()

    $drives = get-disk | Select-Object -Property disknumber, FriendlyName, BusType  

    $driveProperties = $drives[0].psobject.properties

    $driveProperties | ForEach-Object {
        $listview_CreateDrive1.Columns.Add("$($_.Name)") | Out-Null
    }

    foreach ($drive in $drives){

        $DriveListviewItem = New-Object System.Windows.Forms.ListViewItem($drive.disknumber)

        $drive.psobject.properties | Where-Object {$_.Name -ne "disknumber"} | ForEach-Object {
            $ColumnName = $_.name
            $DriveListviewItem.SubItems.Add("$($drive.$ColumnName)") | Out-Null
        }

        $listview_CreateDrive1.Items.Add($DriveListviewItem) | Out-Null

    }

    $listview_CreateDrive1.AutoResizeColumns("HeaderSize")

}

Function select-drive
{
    $SelectedDrive = @($listview_CreateDrive1.SelectedIndices)

    $DiskNumberColumnIndex = ($listview_CreateDrive1.Columns | Where-Object {$_.text -eq "DiskNumber"}).index

    $SelectedDrive | ForEach-Object {

        $DriveDiskNumber = ($listview_CreateDrive1.Items[$_].subitems[$DiskNumberColumnIndex]).text

        New-Item $env:windir\temp\drivechoice.txt -Value $DriveDiskNumber -Confirm:$false -Force
        }
}

Function copy-files
{
    Param
    (
        [Parameter(Mandatory)]
        [string]$Source,

        [Parameter(Mandatory)]
        [string]$Destination,

        [Parameter()]
        [string]$Activity = "Default"
    )

        $ItemsToCopy = Get-ChildItem $Source -Recurse -Force
        
        $TotalItems = $ItemsToCopy.Count
        $CurrentItem = 0
        $PercentComplete = 0

        ForEach ($Item in $ItemsToCopy)
        {
            Write-Progress -Activity $Activity -Status "$PercentComplete% Complete" -PercentComplete $PercentComplete

            $Name = $Item.FullName
            $TrimmedName = $Name.Replace($Source, "").trim("\")
            $DestinationFull = $Destination + '\' + $TrimmedName

            Copy-Item -Path $Name -Destination $DestinationFull -Force

            $currentItem++
            $percentcomplete = [int](($currentItem / $totalitems) * 100)
        }
}

Function Remove-Files
{
    Param
    (
        [Parameter(Mandatory)]
        [string]$Path,

        [Parameter()]
        [string]$Activity = "Default"
    )

        $ItemsToDelete = Get-ChildItem $Path -Recurse -File -Force
        $TotalItems = $ItemsToDelete.Count
        $CurrentItem = 0
        $PercentComplete = 0

        ForEach ($Item in $ItemsToDelete)
        {
            Write-Progress -Activity $Activity -Status "$PercentComplete% Complete" -PercentComplete $PercentComplete

            Remove-Item $item.FullName -Force -Confirm:$false

            $currentItem++
            $percentcomplete = [int](($currentItem / $totalitems) * 100)
        }

    Write-Progress -Activity "Cleaning up directories..." -Status Waiting -PercentComplete $PercentComplete
    Start-Sleep -Seconds 2

    Get-ChildItem $Path -Directory -Recurse | Remove-Item -Recurse -Force -Confirm:$false -Verbose
}


###############\\-FORM-//###############

$Form_CreateDrive                             = [System.Windows.Forms.Form]::new()
    $Form_CreateDrive.StartPosition           = "CenterScreen"
    $Form_CreateDrive.Size                    = [System.Drawing.Size]::new(410,360)
    $Form_CreateDrive.Text                    = "Disk creation"
    $Form_CreateDrive.FormBorderStyle         = "FixedDialog"
    $Form_CreateDrive.top                     = $true


###############\\-LABELS-//###############

$Label_CreateDrive1                            = [System.Windows.Forms.Label]::new()
    $Label_CreateDrive1.Location               = [System.Drawing.Point]::new(8,8)
    $Label_CreateDrive1.Size                   = [System.Drawing.Size]::new(240,32)
    $Label_CreateDrive1.Text                   = "Please select a drive:"


###############\\-LISTVIEW-//###############

$listview_CreateDrive1                         = New-Object System.Windows.Forms.ListView
    $listview_CreateDrive1.Location            = New-Object System.Drawing.Size(8,40)
    $listview_CreateDrive1.Size                = New-Object System.Drawing.Size(380,250)
    $listview_CreateDrive1.Anchor              = [System.Windows.Forms.AnchorStyles]::Bottom -bor
                                                 [System.Windows.Forms.AnchorStyles]::Left -bor
                                                 [System.Windows.Forms.AnchorStyles]::Right -bor
                                                 [System.Windows.Forms.AnchorStyles]::Top
    $listview_CreateDrive1.View                = "Details"
    $listview_CreateDrive1.FullRowSelect       = $true
    $listview_CreateDrive1.MultiSelect         = $true
    $listview_CreateDrive1.AllowColumnReorder  = $true
    $listview_CreateDrive1.GridLines           = $true


###############\\-BUTTONS-//###############

$button_CreateDrive1                       = New-Object System.Windows.Forms.Button
    $button_CreateDrive1.Location          = New-Object System.Drawing.Point(6,291)
    $button_CreateDrive1.Size              = New-Object System.Drawing.Size(100,28)
    $button_CreateDrive1.Text              = "Refresh"
    $button_CreateDrive1.Anchor            = [System.Windows.Forms.AnchorStyles]::Bottom -bor
                                             [System.Windows.Forms.AnchorStyles]::Left
    $button_CreateDrive1.TextAlign         = "MiddleCenter"

$button_CreateDrive2                       = New-Object System.Windows.Forms.Button
    $button_CreateDrive2.Location          = New-Object System.Drawing.Point(290,291)
    $button_CreateDrive2.Size              = New-Object System.Drawing.Size(100,28)
    $button_CreateDrive2.Text              = "Continue"
    $button_CreateDrive2.Anchor            = [System.Windows.Forms.AnchorStyles]::Bottom -bor
                                             [System.Windows.Forms.AnchorStyles]::Right
    $button_CreateDrive2.TextAlign         = "MiddleCenter"


###############\\-EVENTS-//###############

$button_CreateDrive1.add_click({

    get-drives

})

$button_CreateDrive2.add_click({

    select-drive
    $Form_CreateDrive.close()
})

###############\\-CONTROLS-//###############

$Form_CreateDrive.controls.Add($Label_CreateDrive1)
$Form_CreateDrive.Controls.Add($listview_CreateDrive1)
$Form_CreateDrive.controls.Add($button_CreateDrive1)
$Form_CreateDrive.controls.Add($button_CreateDrive2)

###############\\-SHOW-//###############

$Form_CreateDrive.add_shown({

    get-drives

})
[void] $Form_CreateDrive.ShowDialog()

Get-Content $env:windir\temp\drivechoice.txt -ErrorAction SilentlyContinue -Force -OutVariable disknumber | Out-Null

Clear-Host
Write-Output "`n Drive $DiskNumber will be used for installation."
Write-Output ""
Start-Sleep -Seconds 2

winget install --id Microsoft.WindowsADK --force --accept-package-agreements --accept-source-agreements -h
winget install --id Microsoft.ADKPEAddon --force --accept-package-agreements --accept-source-agreements -h

Write-Output "`n Initializing disks..."
Write-Output ""
Start-Sleep -Seconds 2

$disknumber = Get-Content $env:windir\temp\drivechoice.txt

$diskpartCommands = @"
List disk
select disk $disknumber
clean
convert MBR
create partition primary size=2048
active
format fs=FAT32 quick label="WinPE"
assign letter=P
create partition primary
format fs=NTFS quick label="Images"
assign letter=E  
Exit
"@

$tempFile = [System.IO.Path]::GetTempFileName()
Set-Content -Path $tempFile -Value $diskpartCommands

Start-Process -FilePath "diskpart.exe" -ArgumentList "/s $tempFile" -Wait

Write-Output "`n Disk initialized."
Write-Output ""
Start-Sleep -Seconds 2

write-output "`n Getting files to copy, this may take a while..."
write-output ""
start-sleep -seconds 2

Dism /Mount-Image /ImageFile:"C:\program files\enrollment\PE\media\sources\boot.wim" /Index:1 /MountDir:"C:\program files\enrollment\PE\mount"

Dism /Add-Package /Image:"C:\program files\enrollment\PE\mount" /PackagePath:"C:\Program Files (x86)\Windows Kits\10\Assessment and Deployment Kit\Windows Preinstallation Environment\amd64\WinPE_OCs\WinPE-WMI.cab"
Dism /Add-Package /Image:"C:\program files\enrollment\PE\mount" /PackagePath:"C:\Program Files (x86)\Windows Kits\10\Assessment and Deployment Kit\Windows Preinstallation Environment\amd64\WinPE_OCs\en-us\WinPE-WMI_en-us.cab"
Dism /Add-Package /Image:"C:\program files\enrollment\PE\mount" /PackagePath:"C:\Program Files (x86)\Windows Kits\10\Assessment and Deployment Kit\Windows Preinstallation Environment\amd64\WinPE_OCs\WinPE-NetFX.cab"
Dism /Add-Package /Image:"C:\program files\enrollment\PE\mount" /PackagePath:"C:\Program Files (x86)\Windows Kits\10\Assessment and Deployment Kit\Windows Preinstallation Environment\amd64\WinPE_OCs\en-us\WinPE-NetFX_en-us.cab"
Dism /Add-Package /Image:"C:\program files\enrollment\PE\mount" /PackagePath:"C:\Program Files (x86)\Windows Kits\10\Assessment and Deployment Kit\Windows Preinstallation Environment\amd64\WinPE_OCs\WinPE-Scripting.cab"
Dism /Add-Package /Image:"C:\program files\enrollment\PE\mount" /PackagePath:"C:\Program Files (x86)\Windows Kits\10\Assessment and Deployment Kit\Windows Preinstallation Environment\amd64\WinPE_OCs\en-us\WinPE-Scripting_en-us.cab"
Dism /Add-Package /Image:"C:\program files\enrollment\PE\mount" /PackagePath:"C:\Program Files (x86)\Windows Kits\10\Assessment and Deployment Kit\Windows Preinstallation Environment\amd64\WinPE_OCs\WinPE-PowerShell.cab"
Dism /Add-Package /Image:"C:\program files\enrollment\PE\mount" /PackagePath:"C:\Program Files (x86)\Windows Kits\10\Assessment and Deployment Kit\Windows Preinstallation Environment\amd64\WinPE_OCs\en-us\WinPE-PowerShell_en-us.cab"
Dism /Add-Package /Image:"C:\program files\enrollment\PE\mount" /PackagePath:"C:\Program Files (x86)\Windows Kits\10\Assessment and Deployment Kit\Windows Preinstallation Environment\amd64\WinPE_OCs\WinPE-StorageWMI.cab"
Dism /Add-Package /Image:"C:\program files\enrollment\PE\mount" /PackagePath:"C:\Program Files (x86)\Windows Kits\10\Assessment and Deployment Kit\Windows Preinstallation Environment\amd64\WinPE_OCs\en-us\WinPE-StorageWMI_en-us.cab"
Dism /Add-Package /Image:"C:\program files\enrollment\PE\mount" /PackagePath:"C:\Program Files (x86)\Windows Kits\10\Assessment and Deployment Kit\Windows Preinstallation Environment\amd64\WinPE_OCs\WinPE-DismCmdlets.cab"
Dism /Add-Package /Image:"C:\program files\enrollment\PE\mount" /PackagePath:"C:\Program Files (x86)\Windows Kits\10\Assessment and Deployment Kit\Windows Preinstallation Environment\amd64\WinPE_OCs\en-us\WinPE-DismCmdlets_en-us.cab"

copy-item -path 'C:\Program Files\enrollment\Files\checkdrive.ps1','C:\Program Files\enrollment\Files\loading-screen.ps1','C:\Program Files\enrollment\Files\TPM_Fix.cmd'  -Destination "C:\program files\enrollment\PE\mount" -Force
Copy-Item -Path 'C:\Program Files\enrollment\Files\startnet.cmd' -Destination "C:\program files\enrollment\PE\mount\windows\system32" -Force -ErrorAction SilentlyContinue
Copy-Item -Path 'C:\Program Files\enrollment\Files\WinForm' -Destination "C:\program files\enrollment\PE\mount\windows" -Recurse -Force -ErrorAction SilentlyContinue

Dism /Unmount-Image /MountDir:"C:\program files\enrollment\PE\mount" /Commit

copy-files -Source 'C:\Program Files\enrollment\PE\media' -Destination P: -Activity "Creating boot drive..."

Write-Output "`n creating WinPE drive..."
Write-Output ""
Start-Sleep -Seconds 2


copy-files -Source $env:ProgramFiles\enrollment\ISO -Destination E: -Activity "Copying files from 'FILES'..."

Write-Output "`n Items have been copied."
Write-Output ""
Start-Sleep -Seconds 2

$drives = "D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"
FOREACH ($drive in $drives) {
    #\\-If it finds the right drive with the right file./-//#
    IF (Test-Path "$($drive):\checkofditdejuistedriveis.txt") {
        #\\-Saves the right drive in a variable.-//#
        $ImageDrive = $drive
    }
}

$drives = "D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"
FOREACH ($drive in $drives) {
    #\\-If it finds the right drive with the right file./-//#
    IF (Test-Path "$($drive):\checkdrive.ps1") {
        #\\-Saves the right drive in a variable.-//#
        $PEDrive = $drive
    }
}


$imageDriveL = $imageDrive + ":"
chkdsk $imageDriveL /f /x /r /c /i /b /scan /perf
Optimize-Volume $imageDrive -Analyze -Defrag -Verbose

$peDriveL = $peDrive + ":"
chkdsk $peDriveL /f /x /r




Write-Output "`n Script is done."
Read-Host -Prompt "Press enter to exit (ENTER)"
}

Function Start-Deployment {
    DO {
        Clear-Host

        $t = @"
  _____                       _____ _          _ _ 
 |  __ \                     / ____| |        | | |
 | |__) |____      _____ _ __ (___ | |__   ___| | |
 |  ___/ _ \ \ /\ / / _ \ '__\___ \| '_ \ / _ \ | |
 | |  | (_) \ V  V /  __/ |  ____) | | | |  __/ | |
 |_|   \___/ \_/\_/ \___|_| |_____/|_| |_|\___|_|_|
                                                   
"@

        for ($i=0;$i -lt $t.length;$i++) {
            if ($i%2) {
                 $c = "red"
            }
        elseif ($i%5) {
             $c = "yellow"
        }
        elseif ($i%7) {
             $c = "green"
        }
        else {
           $c = "white"
        }
        write-host $t[$i] -NoNewline -ForegroundColor $c
        }
        $title = "`n Welcome Michael Feenstra"

        $message = "`n Choose your desired function."

        $Mount = New-Object System.Management.Automation.Host.ChoiceDescription "&Mount","Images will be mounted and updates with items in C:/iso/files."
        $Create = New-Object System.Management.Automation.Host.ChoiceDescription "&Create","Installation media will be created."
        $ReplaceDrive = New-Object System.Management.Automation.Host.ChoiceDescription "Replace&Drive","Replaces the images on the external drive."
        $exit = New-Object System.Management.Automation.Host.ChoiceDescription "E&xit","Will close the menu."

        $options = [System.Management.Automation.Host.ChoiceDescription[]]($Mount, $Create, $ReplaceDrive, $exit)

        $result = $host.ui.PromptForChoice($title, $message, $options, 0) 

        $mountCode = 0
        $createCode = 0
        $ReplaceDriveCode = 0
        $exitCode = 0

        switch ($result)
            {
                0 {"Running mount process..." ; $mountCode = 1}
                1 {"Running Creation process..." ; $createCode = 1}
                2 {"Running replacement process..." ; $ReplaceDriveCode = 1}
                3 {"Exiting..." ; $exitCode = 1}
            }

        IF($mountCode -eq 1) {
            Set-WinImage
        }


        IF($createCode -eq 1) {
            New-WinImageDrive
        }


        IF($ReplaceDriveCode -eq 1){
            Set-DriveImage
        }


    }
    UNTIL($exitCode -eq 1)

    Clear-Host
    Write-Output "`n Have a nice day!"
    Start-Sleep -Seconds 2
}
Function Set-DriveImage {
    #\\-Puts all possible drives in a variable.-//#
    $drives = "D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"
    #\\-Does the statement for every item in $drives.-//#
    FOREACH ($drive in $drives) {
        #\\-If it finds the right drive with the right file./-//#
        IF (Test-Path "$($drive):\checkofditdejuistedriveis.txt") {
            #\\-Saves the right drive in a variable.-//#
            $IMAGESDRIVE =$drive
        }
    }
        IF(!$IMAGESDRIVE) {
            DO {
                Write-Output "Image drive not found on any of the possible drives."
                $RefreshOrExit = Read-Host -Prompt "Press (R) to Refresh OR Press (X) to Exit"
                IF($RefreshOrExit -eq "R") {
                    FOREACH ($drive in $drives) {
                        #\\-If it finds the right drive with the right file./-//#
                        IF (Test-Path "$($drive):\checkofditdejuistedriveis.txt") {
                            #\\-Saves the right drive in a variable.-//#
                            $IMAGESDRIVE =$drive
                        }
                    }
                }
                IF($RefreshOrExit -eq "X") {
                    Exit-PSHostProcess
                }
                
            }UNTIL($IMAGESDRIVE)
        }

    $FullDrivePath = "$IMAGESDRIVE" + ":\"

    Remove-Files -Path $FullDrivePath\images -Activity "Removing images from External drive..."
    copy-files -Source $env:ProgramFiles\enrollment\iso\images -Destination $FullDrivePath\images -activity "Replacing images..."

    Read-Host "`n Press (ENTER) to exit"
}

Function Remove-Files {

	# Define parameters
	Param (
		[Parameter(Mandatory)]
		[string]$Path,       # Path where files and directories need to be deleted
		
		[Parameter()]
		[string]$Activity = "Default"   # Activity being performed
	)
	
	# Get all files at the specified path (including subdirectories) and store them in $ItemsToDelete
	$ItemsToDelete = Get-ChildItem $Path -Recurse -File -Force
	
	# Calculate total number of items to be deleted and initialize variables for progress tracking
	$TotalItems = $ItemsToDelete.Count
	$CurrentItem = 0
	$PercentComplete = 0
	
	# Loop through each item in $ItemsToDelete and delete it
	ForEach ($Item in $ItemsToDelete) {
	    # Update progress bar
	    Write-Progress -Activity $Activity -Status "$PercentComplete% Complete" -PercentComplete $PercentComplete
	
	    # Delete current item
	    Remove-Item $item.FullName -Force -Confirm:$false
	
	    # Update progress variables
	    $currentItem++
	    $percentcomplete = [int](($currentItem / $totalitems) * 100)
	}
	
	# Clean up remaining directories (if any)
	Write-Progress -Activity "Cleaning up directories..." -Status Waiting -PercentComplete $PercentComplete
	Start-Sleep -Seconds 2
	Get-ChildItem $Path -Directory -Recurse | Remove-Item -Recurse -Force -Confirm:$false -Verbose
	
}

Function copy-files {
	Param (
		[Parameter(Mandatory)]
		[string]$Source,        # The path to the source directory
		[Parameter(Mandatory)]
		[string]$Destination,   # The path to the destination directory
		[Parameter()]
		[string]$Activity = "Default"  # An optional activity name to display during the copy operation
	)

	# Get all the items (files and folders) in the source directory and its subdirectories
	$ItemsToCopy = Get-ChildItem $Source -Recurse -Force
	
	# Initialize variables to track the progress of the copy operation
	$TotalItems = $ItemsToCopy.Count  # Total number of items to be copied
	$CurrentItem = 0  # Number of items copied so far
	$PercentComplete = 0  # Percentage of items copied so far
	
	# Loop through each item in the list of items to copy
	ForEach ($Item in $ItemsToCopy) {
	    # Display progress information for the current item
	    Write-Progress -Activity $Activity -Status "$PercentComplete% Complete" -PercentComplete $PercentComplete
	
	    # Get the full name of the item, trim the source directory path, and construct the destination path
	    $Name = $Item.FullName
	    $TrimmedName = $Name.Replace($Source, "").trim("\")
	    $DestinationFull = $Destination + '\' + $TrimmedName
	
	    # Copy the item from the source path to the destination path
	    Copy-Item -Path $Name -Destination $DestinationFull -Force -Verbose
	
	    # Update progress variables
	    $currentItem++
	    $percentcomplete = [int](($currentItem / $totalitems) * 100)
	}
	
}

function Write-Log {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory=$true)]
        [string]$Message,
        [string]$LogFilePath = "C:\logs\log.txt"
    )

    $Timestamp = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
    $LogMessage = "[$Timestamp]: ##\\-$Message-//##"
    Add-Content -Path $LogFilePath -Value $LogMessage
}


Function Add-Profile {
    #  checks if the current user is an administrator and if not, it elevates the privileges by running the script again with the Runas verb
    IF (-Not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator')) {
        #  checks if the operating system build number is greater than or equal to 6000
        IF ([int](Get-CimInstance -Class Win32_OperatingSystem | Select-Object -ExpandProperty BuildNumber) -ge 6000) {
            #  constructs the command line arguments for running the script with the same path and parameters as the current invocation
            $CommandLine = "-File `"" + $MyInvocation.MyCommand.Path + "`" " + $MyInvocation.UnboundArguments
            #  starts a new process of PowerShell.exe with the Runas verb and the command line arguments and maximizes the window
            Start-Process -FilePath PowerShell.exe -Verb Runas -ArgumentList $CommandLine -WindowStyle Maximized
            #  exits the current script
            Exit
        }
    }


    Clear-Host
    Write-Output "Searching for Profiles..."
    Get-ChildItem -Path $env:ProgramFiles\enrollment -Force -Recurse -ErrorAction SilentlyContinue| Where-Object -Property Name -like profile.ps1 | Select-Object -Property FullName -OutVariable ProfileLocation -ErrorAction SilentlyContinue| out-null -ErrorAction SilentlyContinue

    $number = 0
    Write-Output "`n Please select the script you want to copy"
    Write-Output ""
    foreach ($p in $ProfileLocation) {
        [int]$number++ | Out-Null
        Write-Output "$number - $($p.FullName)"
        New-Variable -Name Script$number -Value $p.FullName -Force
    }
    Write-Output ""
    Read-Host -Prompt "enter choice" -OutVariable ScriptChoice | Out-Null

    Get-Variable | Where-Object -Property name -Like "Script$SCriptchoice" | Select-Object -Property Value -OutVariable Thescript | Out-Null

    Write-Output ""
    Write-Output "copying item..."
    Start-Sleep -Seconds 2

    Remove-item "C:\windows\system32\windowspowershell\v1.0\Profile.ps1" -Force -ErrorAction SilentlyContinue
    Copy-Item  $thescript.value -Destination "C:\windows\system32\windowspowershell\v1.0" -Force
    Get-Item "C:\windows\system32\windowspowershell\v1.0\profile.ps1" | Select-Object -Property LastWriteTime, name

    [int]$Version = Get-Content "C:\windows\system32\windowspowershell\v1.0\ProfileVersion.txt" -Force
    $version++
    Set-Content "C:\windows\system32\windowspowershell\v1.0\ProfileVersion.txt" -Value $Version -Force
}

Get-Content "C:\windows\system32\windowspowershell\v1.0\ProfileVersion.txt" -OutVariable version | Out-Null
Write-Output "Version: $version"