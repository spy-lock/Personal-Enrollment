Write-Output ""
Write-Output "Checking Administrator rights"
Start-Sleep -Seconds 1

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
Write-Output ""
Write-Output "Renaming the old hostfile to: 'hosts.old'"
Get-Item $env:windir\system32\drivers\etc\hosts | Rename-Item -NewName Hosts.old -Force -Verbose -ErrorAction SilentlyContinue
Start-Sleep -Seconds 1
Write-Output ""
$HostContent = "
# Copyright (c) 1993-2009 Microsoft Corp.
#
# This is a sample HOSTS file used by Microsoft TCP/IP for Windows.
#
# This file contains the mappings of IP addresses to host names. Each
# entry should be kept on an individual line. The IP address should
# be placed in the first column followed by the corresponding host name.
# The IP address and the host name should be separated by at least one
# space.
#
# Additionally, comments (such as these) may be inserted on individual
# lines or following the machine name denoted by a '#' symbol.
#
# For example:
#
# localhost name resolution is handled within DNS itself.
# 102.54.94.97 rhino.acme.com # source server
# 38.25.63.10 x.acme.com # x client host
# 127.0.0.1 localhost
# ::1 localhost
"

Write-Output "Creating new hostfile with default content"
Write-Output ""
Start-Sleep -Seconds 1
New-Item $env:windir\system32\drivers\etc\hosts -Force -Value $HostContent -Verbose
Write-Output ""
Write-Output "Changed the %windir%\System32\drivers\etc\hosts to hosts.old and created a new one with default content."
Write-Output "If you wish to revert the changes you need to delete the 'hosts' file and rename 'hosts.old' back to 'hosts'"
write-output ""
Read-Host -Prompt "press (ENTER) to exit"