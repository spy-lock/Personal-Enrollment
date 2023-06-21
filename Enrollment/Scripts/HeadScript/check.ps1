#  checks if the current user is an administrator and if not, it elevates the privileges by running the script again with the Runas verb
IF (-Not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator'))  {
    IF ([int](Get-CimInstance -Class Win32_OperatingSystem | Select-Object -ExpandProperty BuildNumber) -ge 6000) {
        $CommandLine = "-File `"" + $MyInvocation.MyCommand.Path + "`" " + $MyInvocation.UnboundArguments
        Start-Process -FilePath PowerShell.exe -Verb Runas -ArgumentList $CommandLine -WindowStyle Maximized
        Exit
    }
}

# defines a function named Write-Log that takes two parameters: a message and a log file path
function Write-Log  {
    [CmdletBinding()]
    Param 
    (
        [Parameter(Mandatory=$true)]
        [string]$Message,
        [string]$LogFilePath = "$env:windir\logs\HeadCheck.log"
    )

    $Timestamp = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
    $LogMessage = "[$Timestamp]: ##\\-$Message-//##"
    Add-Content -Path $LogFilePath -Value $LogMessage
}

#  calls the Write-Log function with the message "Start log"
Write-Log -Message "Start log"

#  calls the Write-Log function with the message "Head script started"
Write-Log -Message "Head script started"

#  starts a do-until loop that repeats until the variable $registry is equal to 1
DO {
    #  calls the Write-Log function with the message "[Registry]: Loop started"
    Write-Log -Message "[Registry]: Loop started"

    #  reads the content of the file registry.txt in the temp folder and assigns it to the variable $registry
    # If there is an error, it is ignored and the output is null
    Get-Content $env:windir\temp\registry.txt -ErrorAction SilentlyContinue -OutVariable registry | Out-Null
    Write-Log -Message "[Registry]: status $registry"

    #  checks if the variable $registry is null or empty
    IF(!$registry) {
        #  calls the Write-Log function with the message "[Registry]: change not detected"
        Write-Log -Message "[Registry]: change not detected"

        #  writes a message to the output saying "Changing registry key."
        Write-Output "Changing registry key."

        # Sets the value of InitialKeyboardIndicators to 2 using the Set-ItemPorperty cmdlet
        Set-ItemProperty -Path 'Registry::HKU\.DEFAULT\Control Panel\Keyboard' -Name "InitialKeyboardIndicators" -Value "2"
        Write-Log -Message "[Registry]: Changes InitialKeyboardIndicator to 2"

        #  sets the value of the registry key ConsentPromptBehaviorAdmin to 0 using the Set-ItemProperty cmdlet
        Set-ItemProperty -Path REGISTRY::HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Policies\System -Name ConsentPromptBehaviorAdmin -Value 0 -Force
        Write-Log -Message "[Registry]: ConcentBehavior turned to 0"

        #  gets the value of the registry key ConsentPromptBehaviorAdmin and assigns it to the variable ConcentValue using the Get-ItemProperty cmdlet
        Get-ItemProperty REGISTRY::HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Policies\System -Name ConsentPromptBehaviorAdmin -OutVariable ConcentValue | Out-Null

        #  checks if the value of ConcentValue.ConsentPromptBehaviorAdmin is equal to 0
        IF($ConcentValue.ConsentPromptBehaviorAdmin -eq 0) {
            #  calls the Write-Log function with the message "[Registry]: Concent behavior successfully changes to 0"
            Write-Log -Message "[Registry]: Concent behavior successfully changes to 0"
        }

        ELSE {
            #  calls the Write-Log function with the message "[Registry]: Something went wrong"
            Write-Log -Message "[Registry]: Something went wrong"
        }

        
        #  creates a new file named registry.txt in the temp folder with the value 1 using the New-Item cmdlet
        New-Item $env:windir/temp/registry.txt -Value {1} -ErrorAction SilentlyContinue -Force | Out-Null

        #  calls the Write-Log function with the message "[Registry]: Checksum file created"
        Write-Log -Message "[Registry]: Checksum file created"

        #  pauses the execution for 2 seconds using the Start-Sleep cmdlet
				Start-Sleep -Seconds 2
    }
}
#  ends the do-until loop
UNTIL($registry -eq 1)

#  calls the Write-Log function with the message "[Registry]: value has been set"
Write-Log -Message "[Registry]: value has been set"


#  starts a do-until loop that repeats until the variable $driveE is equal to 1
DO {
    #  calls the Write-Log function with the message "[Drive]: Loop started"
    Write-Log -Message "[Drive]: Loop started"

    #  reads the content of the file driveE.txt in the temp folder and assigns it to the variable $driveE
    # If there is an error, it is ignored and the output is null
    Get-Content $env:windir/temp/driveE.txt -ErrorAction SilentlyContinue -OutVariable driveE | Out-Null

    #  checks if the variable $driveE is null or empty
    IF(!$driveE) {
        #  calls the Write-Log function with the message "[Drive]: change not detected"
        Write-Log -Message "[Drive]: change not detected"

        #  creates an array of drive letters from C to Z and assigns it to the variable $drives
        $drives = "C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"

        #  starts a foreach loop that iterates over each drive letter in the $drives array
        FOREACH ($drive in $drives) {
            #  checks if there is a file named checkofditdejuistedriveis.txt on the current drive using the Test-Path cmdlet
            IF (Test-Path "$($drive):\checkofditdejuistedriveis.txt") {
                #  assigns the current drive letter to the variable $IMAGESDRIVE
                $IMAGESDRIVE = $drive
            }
        }

        #  checks if the variable $IMAGESDRIVE is not null or empty
        IF ($IMAGESDRIVE) {
            #  writes a message to the output saying "The Images folder is on drive: $IMAGESDRIVE"
            Write-Output "The Images folder is on drive: $IMAGESDRIVE"

            #  calls the Write-Log function with the message "[Drive]: Image folder found on $IMAGESDRIVE"
            Write-Log -Message "[Drive]: Image folder found on $IMAGESDRIVE"
        }
        
        ELSE {
            #  writes a message to the output saying "The Images folder could not be found on any of the drives: $drives"
            Write-Output "The Images folder could not be found on any of the drives: $drives"

            #  calls the Write-Log function with the message "[Drive]: Image drive could not be found"
            Write-Log -Message "[Drive]: Image drive could not be found"

            #  prompts the user to enter Y or N to skip drive configuration using the Read-Host cmdlet and assigns it to the variable $driveJN
            $driveJN = Read-Host -Prompt "Skip drive configuration? (Y/N)"

            #  checks if the user entered Y
            IF($driveJN -eq "y") {
                #  writes a message to the output saying "Drives will not be configured."
                Write-Output "`n Drives will not be configured."

                #  calls the Write-Log function with the message "[Drive]: User chose not to change drives"
                Write-Log -Message "[Drive]: User chose not to change drives"

                #  pauses the execution for 2 seconds using the Start-Sleep cmdlet
                Start-Sleep -Seconds 2

                #  creates a new file named driveE.txt in the temp folder with the value 1 using the New-Item cmdlet
                New-Item $env:windir/temp/driveE.txt -Value {1} -ErrorAction SilentlyContinue -Force | Out-Null

                #  calls the Write-Log function with the message "[Drive]: Checksum file created"
                Write-Log -Message "[Drive]: Checksum file created"

                #  breaks out of the foreach loop
                break
            }
        }

        #  gets the partition and disk information of the drive that contains the images folder using the Get-Partition and Get-Disk cmdlets and assigns them to the variables $partition and $disk
        $DISK = Get-Partition -DriveLetter $IMAGESDRIVE | get-disk

        $partition = Get-Partition -DriveLetter $IMAGESDRIVE

        #  writes a message to the output saying "Creating partitions..."
        Write-Output "` Creating partitions..."

        #  sets the found partition to drive letter X using the Set-Partition Cmdlet
        $disk | Get-Partition | Where-Object -Property PartitionNumber -eq $partition.PartitionNumber | Set-Partition -NewDriveLetter X -ErrorAction SilentlyContinue

        #  calls the Write-Log function with the message "[Drive]: Partitions have been set"
        Write-Log -Message "[Drive]: Partitions have been set"

        New-Item $env:windir/temp/driveE.txt -Value {1} -ErrorAction SilentlyContinue -Force  | Out-Null
    }
}
#  ends the do-until loop
UNTIL($driveE -eq 1)

#  writes a message to the output saying "Partitions have been set."
Write-Output "`n Partitions have been set."
Write-Output ""
#  pauses the execution for 2 seconds using the Start-Sleep cmdlet
Start-Sleep -Seconds 2

#  calls the Write-Log function with the message "[Hibernate]: Changing hibernate settings"
Write-Log -Message "[Hibernate]: Changing hibernate settings"

# These lines use the powercfg.exe command to change various hibernate options for AC and DC power modes
powercfg.exe -x -monitor-timeout-ac 0
powercfg.exe -x -monitor-timeout-dc 0
powercfg.exe -x -disk-timeout-ac 0
powercfg.exe -x -disk-timeout-dc 0
powercfg.exe -x -standby-timeout-ac 0
powercfg.exe -x -standby-timeout-dc 0
powercfg.exe -x -hibernate-timeout-ac 0
powercfg.exe -x -hibernate-timeout-dc 0

#  writes a message to the output saying "Hibernate options have been applied."
Write-Output "` Hibernate options have been applied."

#  calls the Write-Log function with the message "[Hibernate]: Settings have been applied"
Write-Log -Message "[Hibernate]: Settings have been applied"
Write-Output ""
#  pauses the execution for 2 seconds using the Start-Sleep cmdlet
Start-Sleep -Seconds 2

#  gets the process information of CMD using the Get-Process cmdlet and assigns it to the variable $cmd
# If there is an error, it is ignored and the output is null
$cmd = Get-Process -Name cmd -ErrorAction SilentlyContinue

#  calls the Write-Log function with the message "[CMD]: Trying to close CMD"
Write-Log -Message "[CMD]: Trying to close CMD"


#  checks if the variable $cmd is null or empty
IF(!$cmd) {
    #  calls the Write-Log function with the message "[CMD]: has already been closed"
    Write-Log -Message "[CMD]: has already been closed"

    #  writes a message to the output saying "'CMD' is already closed."
    Write-output "`n 'CMD' is already closed."
    Write-Output ""
    #  pauses the execution for 2 seconds using the Start-Sleep cmdlet
    Start-Sleep -Seconds 2
}

ELSE {
    #  calls the Write-Log function with the message "[CMD]: Detected that $($cmd.name) is still open, closing now" 
    Write-Log -Message "[CMD]: Detected that $($cmd.name) is still open, closing now" 

    #  writes a message to the output saying "Closing 'CMD'..."
    Write-Output "`n Closing 'CMD'..."
    Write-Output ""
    #  pauses the execution for 2 seconds using the Start-Sleep cmdlet
    Start-Sleep -Seconds 2

    #  stops the CMD process using the Stop-Process cmdlet
    $cmd | Stop-Process
}

#  changes the current location to C:/files/WinForm/Design using the Set-Location cmdlet
Set-Location C:/files/WinForm/Design

#  starts a do-until loop that repeats until the variable $head is equal to 1
DO {
    #  calls the Write-Log function with the message "[HeadForm]: loop started" 
    Write-Log -Message "[HeadForm]: loop started" 

    #  reads the content of the file head.txt in the temp folder and assigns it to the variable $head
    # If there is an error, it is ignored and the output is null
    Get-Content $env:windir\temp\head.txt -ErrorAction SilentlyContinue -OutVariable head | Out-Null

    #  calls the Write-Log function with the message "[HeadForm]: Getting checksum file"
    Write-Log -Message "[HeadForm]: Getting checksum file"

    #  checks if the variable $head is null or empty
    IF(!$head) {
        #  calls the Write-Log function with the message "[HeadForm]: checksum not detected, starting now"
        Write-Log -Message "[HeadForm]: checksum not detected, starting now"

        #  writes a message to the output saying "Running Form..."
        Write-Output "`n Running Form..."

        #  starts a new process of PowerShell.exe with the argument ./headForm.ps1 and waits for it to finish using the Start-Process cmdlet
        Start-Process powershell.exe -ArgumentList ./headForm.ps1 -Wait

        #  pauses the execution for 2 seconds using the Start-Sleep cmdlet
        Start-Sleep -Seconds 2
		}
    #  calls the Write-Log function with the message "[HeadForm]: Checksum Detected"
    Write-Log -Message "[HeadForm]: Checksum Detected"
}
#  ends the do-until loop
UNTIL($head -eq 1) 

#  writes a message to the output saying "HeadForm has completed."
Write-Output "`n HeadForm has completed."
Start-Sleep -Seconds 2

#  starts a do-until loop that repeats until the variable $bloatware is equal to 1
DO {
    #  calls the Write-Log function with the message "[Bloatware]: loop started." 
    Write-Log -Message "[Bloatware]: loop started." 

    #  reads the content of the file bloatware.txt in the temp folder and assigns it to the variable $bloatware
    # If there is an error, it is ignored and the output is null
    Get-Content $env:windir\temp\bloatware.txt -ErrorAction SilentlyContinue -OutVariable bloatware | Out-Null

    #  calls the Write-Log function with the message "[Bloatware]: Getting checksum file"
    Write-Log -Message "[Bloatware]: Getting checksum file"

    #  checks if the variable $bloatware is null or empty
    IF(!$bloatware) {
        #  calls the Write-Log function with the message "[Bloatware]: checksum not detected, starting now"
        Write-Log -Message "[Bloatware]: checksum not detected, starting now"

        #  writes a message to the output saying "Bloatware script is running..."
        Write-Output "`n Bloatware script is running..."

        #  starts a new process of PowerShell with elevated privileges and the argument C:\files\Scripts\SubScripts\bloatware.ps1 and waits for it to finish using the Start-Process cmdlet
        start-process powershell -verb runas -argumentlist C:\files\Scripts\SubScripts\bloatware.ps1 -Wait
    }
    #  calls the Write-Log function with the message "[Bloatware]: Checksum Detected"
    Write-Log -Message "[Bloatware]: Checksum Detected"
}
#  ends the do-until loop
until ($bloatware -eq 1)

#  writes a message to the output saying "Bloatware has been removed."
Write-Output "`n Bloatware has been removed."
Start-Sleep -Seconds 2

#  starts a do-until loop that repeats until the variable $application is equal to 1
DO {
    #  calls the Write-Log function with the message "[Application]: loop started."
    Write-Log -Message "[Application]: loop started."

    #  reads the content of the file application.txt in the temp folder and assigns it to the variable $application
    # If there is an error, it is ignored and the output is null
    Get-Content $env:windir\temp\application.txt -ErrorAction SilentlyContinue -OutVariable application | Out-Null

    #  calls the Write-Log function with the message "[Application]: Getting checksum file"
    Write-Log -Message "[Application]: Getting checksum file"

		#  checks if the variable $application is null or empty
    IF(!$application) {
        #  calls the Write-Log function with the message "[Application]: checksum not detected, starting now"
        Write-Log -Message "[Application]: checksum not detected, starting now"

        #  writes a message to the output saying "Installing applications..."
        Write-Output "`n Installing applications..." 

        #  starts a new process of PowerShell with elevated privileges and the argument C:\files\Scripts\SubScripts\application.ps1 and waits for it to finish using the Start-Process cmdlet
        Start-Process powershell -Verb runas -argumentlist C:\files\Scripts\SubScripts\application.ps1 -Wait
    }
    #  calls the Write-Log function with the message "[Update]: Checksum Detected"
    Write-Log -Message "[Update]: Checksum Detected"
}
#  ends the do-until loop
until ($application -eq 1)

#  writes a message to the output saying "Applications have been installed."
Write-Output "`n Applications have been installed."
Start-Sleep -Seconds 2

#  starts a do-until loop that repeats until the variable $update is equal to 1
DO {
    #  calls the Write-Log function with the message "[Update]: loop started."
    Write-Log -Message "[Update]: loop started."

    #  reads the content of the file update.txt in the temp folder and assigns it to the variable $update
    # If there is an error, it is ignored and the output is null
    Get-Content $env:windir\temp\update.txt -ErrorAction SilentlyContinue -OutVariable update | Out-Null

    #  calls the Write-Log function with the message "[Update]: Getting checksum file"
    Write-Log -Message "[Update]: Getting checksum file"

    #  checks if the variable $update is null or empty
    IF(!$update) {
        #  calls the Write-Log function with the message "[Update]: checksum not detected, starting now"
        Write-Log -Message "[Update]: checksum not detected, starting now"

        #  writes a message to the output saying "Installing updates..."
        Write-Output "`n Installing updates..."

        #  starts a new process of PowerShell with elevated privileges and the argument C:\files\Scripts\SubScripts\windowsupdate.ps1 and waits for it to finish using the Start-Process cmdlet
        start-process powershell -verb runas -argumentlist C:\files\Scripts\SubScripts\windowsupdate.ps1 -Wait 
    }
    #  calls the Write-Log function with the message "[Update]: Checksum Detected"
    Write-Log -Message "[Update]: Checksum Detected"
}
#  ends the do-until loop
UNTIL($update -eq 1)

#  writes a message to the output saying "All updates have been installed."
Write-Output "`n All updates have been installed."
Start-Sleep -Seconds 2


#  starts a do-until loop that repeats until the variable $cleanup is equal to 1
DO {
    #  calls the Write-Log function with the message "[Cleanup]: loop started"
    Write-Log -Message "[Cleanup]: loop started"

    #  reads the content of the file cleanup.txt in the temp folder and assigns it to the variable $cleanup
    # If there is an error, it is ignored and the output is null
    Get-Content $env:windir\temp\cleanup.txt -ErrorAction SilentlyContinue -OutVariable cleanup | Out-Null

    #  calls the Write-Log function with the message "[Cleanup]: Getting checksum file"
    Write-Log -Message "[Cleanup]: Getting checksum file"

    #  checks if the variable $cleanup is null or empty
    IF(!$cleanup) {
        #  calls the Write-Log function with the message "[Cleanup]: checksum not detected"
        Write-Log -Message "[Cleanup]: checksum not detected"

        #  calls the Write-Log function with the message "[Cleanup]: Starting script"
        Write-Log -Message "[Cleanup]: Starting script"

        #  writes a message to the output saying "Starting cleanup process..."
        Write-Output "`n Starting cleanup process..."

        #  starts a new process of PowerShell with elevated privileges and the argument C:\files\Scripts\SubScripts\cleanup.ps1 and waits for it to finish using the Start-Process cmdlet
        start-process powershell -verb runas -argumentlist C:\files\Scripts\SubScripts\cleanup.ps1 -Wait
    }
    #  calls the Write-Log function with the message "[Cleanup]: Checksum Detected"
    Write-Log -Message "[Cleanup]: Checksum Detected"
}
#  ends the do-until loop
UNTIL($cleanup -eq 1)


#  calls the Write-Log function with the message "All task loops have been completed"
Write-Log -Message "All task loops have been completed"

#  clears the host screen using the Clear-Host cmdlet
Clear-Host

#  writes a message to the output saying "All tasks have been completed." 
Write-Output "`n All tasks have been completed." 

#  calls the Write-Log function with the message "Starting deletion script"
Write-Log "Copying deletion script"

#  copies the file delete.ps1 from C:\files\scripts\subscripts to the temp folder using the Copy-Item cmdlet
Copy-Item C:\files\scripts\subscripts\delete.ps1 -Destination C:\ -Force

Write-Log "Creating RunOnce key for file deletion."
# adds a run key to delete files
New-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce\ -Name Delete -Force -Value {powershell Start-Process "powershell.exe" -argumentlist C:/delete.ps1}

#  calls the Write-Log function with the message "End log"
Write-Log -Message "End log"

#  restarts the computer
Write-Output "Restarting in 5..."
Start-Sleep -Seconds 1
Write-Output "Restarting in 4..."
Start-Sleep -Seconds 1
Write-Output "Restarting in 3..."
Start-Sleep -Seconds 1
Write-Output "Restarting in 2..."
Start-Sleep -Seconds 1
Write-Output "Restarting in 1..."
Start-Sleep -Seconds 1
Restart-Computer -Force