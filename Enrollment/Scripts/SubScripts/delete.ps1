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

Write-Output "`n Removing files..."
Start-Sleep -Seconds 2

# Remove any files or folders that start with C:\Windows\temp\
Remove-Item C:\Windows\temp\* -Recurse -Force -ErrorAction SilentlyContinue

# Remove any files or folders that start with C:\Users\Administrator\AppData\Local\Temp\
Remove-Item C:\Users\Administrator\AppData\Local\Temp\* -Recurse -Force -ErrorAction SilentlyContinue

# Remove any files or folders that start with C:\Users\Administrator\AppData\LocalLow\Temp\
Remove-Item C:\Users\Administrator\AppData\LocalLow\Temp\* -Recurse -Force -ErrorAction SilentlyContinue

# Remove any files or folders that start with C:\Users\Administrator\AppData\Roaming\Temp\
Remove-Item C:\Users\Administrator\AppData\Roaming\Temp\* -Recurse -Force -ErrorAction SilentlyContinue

Clear-Host
Write-Output "`n Starting file deletion..."

# Remove the files folder from C:\
Remove-Item -Path C:/files -Force -ErrorAction SilentlyContinue -Recurse

# Wait for the user to press enter before exiting
Read-Host -Prompt "Press enter to exit"