Start-Process powershell.exe -ArgumentList {DISM /Online /Cleanup-Image /RestoreHealth} -Wait
Start-Process powershell.exe -ArgumentList {net stop bits} -Wait
Start-Process powershell.exe -ArgumentList {net stop cryptsvc} -Wait
Start-Process powershell.exe -ArgumentList {net stop wuauserv} -Wait
Start-Process powershell.exe -ArgumentList {Rename-Item C:\Windows\SoftwareDistribution SoftwareDistribution.old} -Wait
Start-Process powershell.exe -ArgumentList {Rename-Item C:\Windows\System32\catroot2 Catroot2.old} -Wait
Start-Process powershell.exe -ArgumentList {net start bits} -Wait
Start-Process powershell.exe -ArgumentList {net start cryptsvc} -Wait
Start-Process powershell.exe -ArgumentList {net start wuauserv} -Wait
Start-Process powershell.exe -ArgumentList {net start msiserver} -Wait