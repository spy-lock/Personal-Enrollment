# Check if the script is running as administrator
IF (-Not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator'))
{
    # If not, check if the OS version is 6000 or higher
    IF ([int](Get-CimInstance -Class Win32_OperatingSystem | Select-Object -ExpandProperty BuildNumber) -ge 6000)
    {
        # If yes, restart the script with elevated privileges
        $CommandLine = "-File `"" + $MyInvocation.MyCommand.Path + "`" " + $MyInvocation.UnboundArguments
        Start-Process -FilePath PowerShell.exe -Verb Runas -ArgumentList $CommandLine -WindowStyle Maximized
        Exit
    }
}

# Define a function to write logs to a file
function Write-Log
{
    [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory=$true)]
        [string]$Message,
        # The default log file path is C:\Windows\logs\windowsupdate.log
        [string]$LogFilePath = "$env:windir\logs\windowsupdate.log"
    )

    # Format the timestamp and the log message
    $Timestamp = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
    $LogMessage = "[$Timestamp]: ##\\-$Message-//##"
    # Append the log message to the log file
    Add-Content -Path $LogFilePath -Value $LogMessage
}

# Write the start log message
Write-Log -Message "start log"
Write-Log -Message "Windows Update Logging started."

# Import the PSWindowsUpdate module and ignore any errors
Import-Module PSWindowsUpdate -ErrorAction Ignore
Write-Log -Message "[Module]: trying to import PSWindowsUpdate"

# Get the PSWindowsUpdate module and store it in a variable called pswindowsupdate
$pswindowsupdate = Get-Module -Name PSWindowsUpdate

# If the module is not found, install it using NuGet and force it for the current user
IF (!$pswindowsupdate)
{
    Write-Log -Message "[Module]: PSWindowsUpdate not found"
    Write-Output "`n Detected that the PSWindowsUpdate module is not installed."
    Start-Sleep -Seconds 1
    Write-Output "`n Starting installation now..."

    Write-Log -Message "[Module]: Installing NuGet"
    Install-PackageProvider -name NuGet -Force

    Write-Log -Message "[Module]: Installing PSWindowsUpdate"
    Install-Module PSWindowsUpdate -Force -Scope CurrentUser
    Write-Log -Message "[Module]: PSWindowsUpdate installed."
}

# If the module is found, import it and force it for the current session
ELSE
{
    Write-Log -Message "[Module]: PSWindowsUpdate found"
    Import-Module -Name PSWindowsUpdate -Force
    Write-Output "`n Starting windows update process..."
    Write-Log -Message "Module successfully found at: '$($pswindowsupdate.ModuleBase)'"
}



# Get the reboot status and store it in a variable called reboot
$reboot = Get-WURebootStatus -Silent
Write-Log -Message "[Reboot]: Status: $reboot"

# If reboot is true, restart the computer and wait for 60 seconds
IF($reboot -like "true")
{
    Write-Log -Message "[Reboot]: Restarting device"
    Write-Output "`n Detected that windows needs to reboot."
    Write-Output ""
    Write-Output "Reboot in 5..."
    Start-Sleep -Seconds 1
    Write-Output "Reboot in 4..."
    Start-Sleep -Seconds 1
    Write-Output "Reboot in 3..."
    Start-Sleep -Seconds 1
    Write-Output "Reboot in 2..."
    Start-Sleep -Seconds 1
    Write-Output "Reboot in 1..."
    Start-Sleep -Seconds 1

    Restart-Computer -Force
    start-sleep -seconds 60
}



# Initialize a loop counter variable called count
$count = 0

# Start a loop to check for windows updates until there are none or the loop count reaches 6
DO
{
    # Get the available windows updates and store them in a variable called updates
		$updates = Get-WindowsUpdate -Verbose
    # Loop through each update and write its name to the log file
    foreach ($u in $updates)
    {
        Write-Log -Message "[Update]: found: $u"
    }
    # Increment the loop counter by 1
    $count += 1
    Write-Log -Message "[Update]: Current loop: $($count)"

    # If the loop count reaches 6, restart the windows update service and the computer
    IF($count -eq 6)
    {
        Write-Log -Message "[Update]: looped 5 times"
        New-Item $env:windir\temp\update.txt -ErrorAction SilentlyContinue -Value {1} -Force
        Write-Log -Message "Creating checksum file"
        write-log -Message "End log"
        break
    }

    # If there are any updates available, accept them all and force download and install them and ignore reboot
    IF($updates.count -gt 0)
    {
        Write-Log -Message "[Update]: Starting installation process"
        start-process powershell -verb runas -argumentlist {Get-WindowsUpdate -AcceptAll -ForceDownload -ForceInstall -IgnoreReboot -Install} -Wait
        # Get the reboot status again and store it in a variable called reboot
        $reboot = Get-WURebootStatus -Silent
        Write-Log -Message "[Reboot]: Status: $reboot"

        # If reboot is true, restart the computer and wait for 60 seconds
        IF($reboot -like "true")
        {
            Write-Log -Message "[Reboot]: Restarting device"
            Write-Output "`n Detected that windows needs to reboot." 
            Write-Output ""
            Write-Output "Reboot in 5..."
            Start-Sleep -Seconds 1
            Write-Output "Reboot in 4..." 
            Start-Sleep -Seconds 1
            Write-Output "Reboot in 3..." 
            Start-Sleep -Seconds 1
            Write-Output "Reboot in 2..." 
            Start-Sleep -Seconds 1
            Write-Output "Reboot in 1..."
            Start-Sleep -Seconds 1

            Restart-Computer -Force
            start-sleep -seconds 60
        }

        # If reboot is false, write to the output that reboot is not required
        ELSE
        {
            Write-Log -Message "[Reboot]: No reboot required"
            Write-Output "`n Reboot not required"
        }
    }

    # If there are no updates available, write to the output that all updates have been installed
    ELSE
    {
        Write-Log -Message "[Update]: all updates have been installed"
        Write-Output "`n All updates have been installed"
    }
}
# Repeat the loop until there are no updates available or the loop count reaches 6
UNTIL($updates.count -eq 0)

# Create a text file to indicate that the update script ran successfully
New-Item $env:windir\temp\update.txt -ErrorAction SilentlyContinue -Value {1} -Force
Write-Log -Message "Creating checksum file"
write-log -Message "End log"