Write-Output "Copying item..."
Write-Output ""
Start-Sleep -Seconds 2
New-Item -Type Directory -Path C:/ -Name files -Force -ErrorAction SilentlyContinue | Out-Null
copy-item ./enrollment/drivers, ./enrollment/scripts, ./enrollment/winform -Destination C:/files -Recurse -ErrorAction SilentlyContinue -Force | Out-Null

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

Write-Output "Creating run key..."
Write-Output ""
Start-Sleep -Seconds 1
Set-ItemProperty Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Run -Name Scriptrun -Value {cmd /k "C:\files\Scripts\CLICK ME.bat" -verb runas} -Force 
Unblock-File 'C:/files/scripts/click me.bat'

Write-Output "Key created."
Write-Output ""

$restartYN = Read-Host -Prompt "For this script to function you need to restart your computer. Restart now? (Y/N)"

IF($restartYN -eq "Y"){
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
}

Else {
    exit
}