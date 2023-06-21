Function Set-WinImage {
    Copy-Item -Path "C:\Users\MichaelFeenstraAgili\OneDrive - Agiliq B.V\Documenten\Powershell-Enrollment\Enrollment\Drivers" -Destination C:\Iso\Files\ -Force -Verbose -Recurse
    Copy-Item -Path "C:\Users\MichaelFeenstraAgili\OneDrive - Agiliq B.V\Documenten\Powershell-Enrollment\Enrollment\Econvert" -Destination C:\Iso\Files\ -Force -Verbose -Recurse
    Copy-Item -Path "C:\Users\MichaelFeenstraAgili\OneDrive - Agiliq B.V\Documenten\Powershell-Enrollment\Enrollment\Modules" -Destination C:\Iso\Files\ -Force -Verbose -Recurse
    Copy-Item -Path "C:\Users\MichaelFeenstraAgili\OneDrive - Agiliq B.V\Documenten\Powershell-Enrollment\Enrollment\Scripts" -Destination C:\Iso\Files\ -Force -Verbose -Recurse
    Copy-Item -Path "C:\Users\MichaelFeenstraAgili\OneDrive - Agiliq B.V\Documenten\Powershell-Enrollment\Enrollment\WinForm" -Destination C:\Iso\Files\ -Force -Verbose -Recurse

    dism /online /cleanup-wim

    Remove-Item C:\WIN10_en, C:\WIN10_nl, C:\WIN11_en, C:\WIN11_nl -Force -Recurse -erroraction SilentlyContinue

    #CREATES DIRECTORIES FOR WHERE THE MOUNTED IMAGES WILL BE MOUNTED
    Write-Output "`n Creating directories..."
    WRITE-Output ""
    mkdir C:\WIN10_en -ErrorAction SilentlyContinue | Out-Null
    mkdir C:\WIN10_nl -ErrorAction SilentlyContinue | Out-Null
    mkdir C:\WIN11_en -ErrorAction SilentlyContinue | Out-Null
    mkdir C:\WIN11_nl -ErrorAction SilentlyContinue | Out-Null
    Write-Output ""

    #MOUNTS THE IMAGES TO THE CREATED DIRECTORIES
    write-Output "`n Mounting images..."
    WRITE-output ""
    $mount1 = Start-Process powershell -ArgumentList {dism /mount-image /imagefile:"C:\iso\images\WIN10_en-gb\sources\install.wim" /index:1 /mountdir:C:/Win10_en} -passthru
    $mount2 = Start-Process powershell -ArgumentList {dism /mount-image /imagefile:"C:\iso\images\WIN10_nl-nl\sources\install.wim" /index:1 /mountdir:C:/Win10_nl} -passthru
    $mount3 = Start-Process powershell -ArgumentList {dism /mount-image /imagefile:"C:\iso\images\WIN11_en-gb\sources\install.wim" /index:1 /mountdir:C:/Win11_en} -passthru
    $mount4 = Start-Process powershell -ArgumentList {dism /mount-image /imagefile:"C:\iso\images\WIN11_nl-nl\sources\install.wim" /index:1 /mountdir:C:/Win11_nl} -passthru

    Wait-Process $mount1.Id, $mount2.id, $mount3.id, $mount4.id

    write-Output "`n Removing files in images..."
    WRITE-Output ""

    Remove-Item C:\WIN10_en\files -Force -Recurse
    Remove-item C:\WIN10_nl\files -Force -Recurse
    Remove-Item C:\WIN11_en\files -Force -Recurse
    Remove-Item C:\WIN11_nl\files -Force -Recurse

    #COPYING FILES INSIDE THE MOUNTED IMAGES
    write-host "`n Copying items now..."
    copy-files -Source C:\iso\Files -Destination C:\WIN10_en\files -Activity "Copying 'WIN10_en\files'..."  -Verbose
    copy-files -Source C:\iso\files -Destination C:\Win10_nl\files -Activity "Copying 'WIN10_nl\files'..." -Verbose
    copy-files -Source C:\iso\files -Destination C:\Win11_en\files -Activity "Copying 'WIN11_en\files'..."  -Verbose
    copy-files -Source C:\iso\files -Destination C:\Win11_nl\files -Activity "Copying 'WIN11_nl\files'..."  -Verbose
    WRITE-Output ""


    #UNMOUNTING IMAGES AND SAVING CHANGES
    write-Output "`n Unmounting images..."
    WRITE-Output ""
    $unmount1 = Start-Process powershell -ArgumentList {dism /unmount-image /mountdir:C:/Win10_en /commit} -PassThru
    $unmount2 = Start-Process powershell -ArgumentList {dism /unmount-image /mountdir:C:/Win10_nl /commit} -PassThru
    $unmount3 = Start-Process powershell -ArgumentList {dism /unmount-image /mountdir:C:/Win11_en /commit} -PassThru
    $unmount4 = Start-Process powershell -ArgumentList {dism /unmount-image /mountdir:C:/Win11_nl /commit} -PassThru

    Wait-Process $unmount1.Id, $unmount2.id, $unmount3.id, $unmount4.id

    Remove-Item C:\WIN10_en, C:\WIN10_nl, C:\WIN11_en, C:\WIN11_nl -Force -Recurse -erroraction SilentlyContinue
}

Function New-WinImageDrive {
    Write-Output ""
    Write-Output "`n searching for script..."
    Write-Output ""

    Get-ChildItem -Path C:\Users -Force -Recurse | Where-Object -Property Name -like create-drive-form.ps1 | Select-Object -Property FullName -OutVariable createlocation | out-null
    $count = 0
    foreach ($location in $createlocation)
    {
        $count++

        $name = "option" + "$count"

        New-Variable -Name $name -Value $location -Force -ErrorAction SilentlyContinue
    } 

    Get-Variable -Exclude options | Where-Object -Property Name -like option* -OutVariable numberoption | Out-Null
    $coun = 0
    foreach ($opt in $numberoption)
    {
        $coun++
        $name = $opt.Value.fullname
        Write-Output "$coun - $name"
    }
    Write-Output ""
    $chosennumber = Read-Host -Prompt "please select the right script to run"

    Get-Variable | Where-Object -Property Name -like option$chosennumber -OutVariable chosenscript
    $chosenscript.Value

    $fullchosenscript = $chosenscript.Value.FullName.Replace("\create-drive-form.ps1", "")
    Set-Location $fullchosenscript
    .\create-drive-form.ps1
}

Function Set-NasImage {
    Write-Output "`n Starting NAS replacement process..."
    Start-Sleep -Seconds 2
    DO {
        $NAS = Test-Path L:/enrollment -ErrorAction SilentlyContinue
        IF($NAS -like "false") {
            Write-Output "`n Network share not found, mapping now..."
            Start-Sleep -Seconds 2

            net use L: \\192.168.227.250\Enrollment /user:Enrollment 3Ul9T0Ay!
        }
    }
    UNTIL($NAS -like "true")

    Remove-Files -Path L:\ENROLLMENT\FILES\images -Activity "Removing images from 'NAS'..." 

    copy-files -Source C:\iso\images -Destination L:\ENROLLMENT\FILES\images -Activity "Copying images to 'NAS'..."

    Write-output "`n Remove temp folders..."
    Write-Output ""
    Remove-Item C:\WIN10_en, C:\WIN10_nl, C:\WIN11_en, C:\WIN11_nl -ErrorAction SilentlyContinue

    Write-output "`n Operation completed succesfully."
    Read-Host -Prompt "`n Press (ENTER) to exit"
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
        $ReplaceNas = New-Object System.Management.Automation.Host.ChoiceDescription "Replace&Nas","Replaces the iamges on the NAS."
        $exit = New-Object System.Management.Automation.Host.ChoiceDescription "E&xit","Will close the menu."

        $options = [System.Management.Automation.Host.ChoiceDescription[]]($Mount, $Create, $ReplaceDrive, $ReplaceNas, $exit)

        $result = $host.ui.PromptForChoice($title, $message, $options, 0) 

        $mountCode = 0
        $createCode = 0
        $ReplaceDriveCode = 0
        $ReplaceNasCode = 0
        $exitCode = 0

        switch ($result)
            {
                0 {"Running mount process..." ; $mountCode = 1}
                1 {"Running Creation process..." ; $createCode = 1}
                2 {"Running replacement process..." ; $ReplaceDriveCode = 1}
                3 {"Running replacement process..." ; $ReplaceNasCode = 1}
                4 {"Exiting..." ; $exitCode = 1}
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


        IF($ReplaceNasCode -eq 1){
            Set-NasImage
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
    copy-files -Source C:\iso\images -Destination $FullDrivePath\images -activity "Replacing images..."

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

Function Add-Driver {
    Remove-Item C:\WIN10_en, C:\WIN10_nl, C:\WIN11_en, C:\WIN11_nl -Force -Recurse -erroraction SilentlyContinue

    #CREATES DIRECTORIES FOR WHERE THE MOUNTED IMAGES WILL BE MOUNTED
    Write-Output "`n Creating directories..."
    WRITE-Output ""
    mkdir C:\WIN10_en -ErrorAction SilentlyContinue | Out-Null
    mkdir C:\WIN10_nl -ErrorAction SilentlyContinue | Out-Null
    mkdir C:\WIN11_en -ErrorAction SilentlyContinue | Out-Null
    mkdir C:\WIN11_nl -ErrorAction SilentlyContinue | Out-Null
    Write-Output ""

    #MOUNTS THE IMAGES TO THE CREATED DIRECTORIES
    write-Output "`n Mounting images..."
    WRITE-output ""
    $mount1 = Start-Process powershell -ArgumentList {dism /mount-image /imagefile:"C:\iso\images\WIN10_en-gb\sources\install.wim" /index:1 /mountdir:C:/Win10_en} -passthru
    $mount2 = Start-Process powershell -ArgumentList {dism /mount-image /imagefile:"C:\iso\images\WIN10_nl-nl\sources\install.wim" /index:1 /mountdir:C:/Win10_nl} -passthru
    $mount3 = Start-Process powershell -ArgumentList {dism /mount-image /imagefile:"C:\iso\images\WIN11_en-gb\sources\install.wim" /index:1 /mountdir:C:/Win11_en} -passthru
    $mount4 = Start-Process powershell -ArgumentList {dism /mount-image /imagefile:"C:\iso\images\WIN11_nl-nl\sources\install.wim" /index:1 /mountdir:C:/Win11_nl} -passthru

    Wait-Process $mount1.Id, $mount2.id, $mount3.id, $mount4.id

    $Add1 = Start-Process powershell -ArgumentList {dism /Image:C:\Win10_en /Add-Driver /Driver:"C:\Users\MichaelFeenstraAgili\OneDrive - Agiliq B.V\Documenten\Drivers" /Recurse} -passthru
    $Add2 = Start-Process powershell -ArgumentList {dism /Image:C:\Win10_nl /Add-Driver /Driver:"C:\Users\MichaelFeenstraAgili\OneDrive - Agiliq B.V\Documenten\Drivers" /Recurse} -passthru
    $Add3 = Start-Process powershell -ArgumentList {dism /Image:C:\Win11_en /Add-Driver /Driver:"C:\Users\MichaelFeenstraAgili\OneDrive - Agiliq B.V\Documenten\Drivers" /Recurse} -passthru
    $Add4 = Start-Process powershell -ArgumentList {dism /Image:C:\Win11_nl /Add-Driver /Driver:"C:\Users\MichaelFeenstraAgili\OneDrive - Agiliq B.V\Documenten\Drivers" /Recurse} -passthru

    Wait-Process $Add1.id, $Add2.id, $Add3.id, $Add4.Id

    write-Output "`n Unmounting images..."
    WRITE-Output ""
    $unmount1 = Start-Process powershell -ArgumentList {dism /unmount-image /mountdir:C:/Win10_en /commit} -PassThru
    $unmount2 = Start-Process powershell -ArgumentList {dism /unmount-image /mountdir:C:/Win10_nl /commit} -PassThru
    $unmount3 = Start-Process powershell -ArgumentList {dism /unmount-image /mountdir:C:/Win11_en /commit} -PassThru
    $unmount4 = Start-Process powershell -ArgumentList {dism /unmount-image /mountdir:C:/Win11_nl /commit} -PassThru

    Wait-Process $unmount1.Id, $unmount2.id, $unmount3.id, $unmount4.id

    Remove-Item C:\WIN10_en, C:\WIN10_nl, C:\WIN11_en, C:\WIN11_nl -Force -Recurse -erroraction SilentlyContinue
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
    Get-ChildItem -Path C:\users -Force -Recurse -ErrorAction SilentlyContinue| Where-Object -Property Name -like profile.ps1 | Select-Object -Property FullName -OutVariable ProfileLocation -ErrorAction SilentlyContinue| out-null -ErrorAction SilentlyContinue

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