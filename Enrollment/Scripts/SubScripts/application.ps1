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

#  defines a function named Write-Log that takes two parameters: a message and a log file path
# The function writes the message to the log file with a timestamp and a format
function Write-Log {
    [CmdletBinding()]
    Param (
        #  declares a mandatory parameter of type string named Message
        [Parameter(Mandatory=$true)]
        [string]$Message,
        #  declares an optional parameter of type string named LogFilePath with a default value of "$env:windir\logs\Application.log"
        [string]$LogFilePath = "$env:windir\logs\Application.log"
    )

    #  gets the current date and time and converts it to a string format of "yyyy-MM-dd HH:mm:ss"
    $Timestamp = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
    #  constructs the log message by enclosing the timestamp and the message in brackets and dashes
    $LogMessage = "[$Timestamp]: ##\\-$Message-//##"
    #  appends the log message to the log file using the Add-Content cmdlet
    Add-Content -Path $LogFilePath -Value $LogMessage
}

#  calls the Write-Log function with the message "start log"
Write-Log -Message "start log"
#  calls the Write-Log function with the message "Starting application log."
Write-Log -Message "Starting application log."
#  clears the host screen using the Clear-Host cmdlet
Clear-Host
#  writes a message to the output saying "Installation of winget is starting..."
Write-Output "`n Installation of winget is starting..."
#  calls the Write-Log function with the message "Starting Winget installation."
Write-Log -Message "Starting Winget installation."


#  creates a new directory named C:\temp using the New-Item cmdlet
mkdir C:\temp
#  calls the Write-Log function with the message "[Winget]: Temp folder created"
Write-Log -Message "[Winget]: Temp folder created"

#  sets the progress preference to silently continue to suppress any progress bars
$ProgressPreference = 'silentlycontinue'

#  calls the Write-Log function with the message "[Winget]: starting web request for required files"
Write-Log -Message "[Winget]: starting web request for required files"

#  use the Invoke-WebRequest cmdlet to download two files from different URLs and save them in C:\temp folder with different names
Invoke-WebRequest -Uri "https://aka.ms/Microsoft.VCLibs.x64.14.00.Desktop.appx" -OutFile "C:\temp\Microsoft.VCLibs.x64.14.00.Desktop.appx"
Invoke-WebRequest -Uri "https://github.com/microsoft/winget-cli/releases/download/v1.1.12653/Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle" -OutFile "C:\temp\WinGet.msixbundle"

#  use the Test-Path cmdlet to check if the downloaded files exist in C:\temp folder and assign the results to two variables: VClib and Winget
Test-Path "C:\temp\Microsoft.VCLibs.x64.14.00.Desktop.appx" -OutVariable VClib | Out-Null
Test-Path "C:\temp\WinGet.msixbundle" -OutVariable Winget | Out-Null

#  call the Write-Log function with the messages "[Winget]: VClibs returned = $VClib" and "[Winget]: Winget returned = $Winget"
Write-Log -Message "VClibs returned = $VClib"
Write-Log -Message "Winget returned = $Winget"


#  calls the Write-Log function with the message "[Winget]: Trying to add appxpackage"
Write-Log -Message "[Winget]: Trying to add appxpackage"
#  use the Add-AppxPackage cmdlet to install the downloaded files as app packages
Add-AppxPackage "C:\temp\Microsoft.VCLibs.x64.14.00.Desktop.appx"
Add-AppxPackage "C:\temp\WinGet.msixbundle" -ForceUpdateFromAnyVersion

#  calls the Write-Log function with the message "[Winget]: removing temp folder"
Write-Log -Message "[Winget]: removing temp folder"
#  uses the Remove-Item cmdlet to delete the C:\temp folder and its contents without confirmation
Remove-Item C:\temp -Confirm:$false -Recurse


#  clears the host screen using the Clear-Host cmdlet
Clear-Host
#  writes a message to the output saying "Winget is starting"
Write-Output "`n Winget is starting"
#  calls the Write-Log function with the message "[App]: winget is starting"
write-log -Message "[App]: winget is starting"

$DiscordEX = Test-Path $env:LOCALAPPDATA\discord -ErrorAction SilentlyContinue
$7ZipEX = Test-Path $Env:ProgramFiles\7-Zip -ErrorAction SilentlyContinue
$JavaEX = Test-Path $Env:ProgramFiles\Java -ErrorAction SilentlyContinue
$DotNetEX = Test-Path $Env:ProgramFiles\dotnet -ErrorAction SilentlyContinue
$FirefoxEX = Test-Path "$Env:ProgramFiles\Mozilla Firefox" -ErrorAction SilentlyContinue

#  gets the version of winget using the winget -v command and assigns it to the variable $wingetversion
$wingetversion = winget -v
#  calls the Write-Log function with the message "[Winget]: version $wingetversion"
Write-Log "[Winget]: version $wingetversion"
#  pauses the execution for 1 second using the Start-Sleep cmdlet
Start-Sleep -Seconds 1

#  use the winget install command with various options to install different applications using winget
IF($7ZipEX -like "False")  {
    winget install -e --accept-source-agreements -h --force --id 7zip.7zip
    Write-Log -Message "[App]: installed 7zip"
}

IF($JavaEX -like "false") {
    winget install -e --accept-source-agreements -h --force --id Oracle.JavaRuntimeEnvironment
    Write-Log -Message "[App]: installed java"
}

IF($DiscordEX -like "false") {
    winget install -e --accept-source-agreements -h --force --id Discord.Discord
    Write-Log -Message "[App]: installed Discord"
}

IF($DotNetEX -like "false") {
    winget install -e --accept-source-agreements -h --force --id Microsoft.DotNet.Runtime.7
    Write-Log -Message "[App]: installed .net 7"
}

IF($FirefoxEX -like "false") {
    winget install -e --accept-source-agreements -h --force --id Mozilla.Firefox
    Write-Log -Message "[App]: installed .net 7"
}


New-Item $env:windir\temp\application.txt -ErrorAction SilentlyContinue -Value {1} -Force
Write-Log -Message "created checksum file"
write-log -Message "end log"