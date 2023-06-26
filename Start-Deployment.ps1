Write-Output "Copying item..."
Write-Output ""
Start-Sleep -Seconds 2
New-Item -Type Directory -Path C:/ -Name files -Force -ErrorAction SilentlyContinue | Out-Null
copy-item ./enrollment/drivers, ./enrollment/scripts, ./enrollment/winform -Destination C:/files -Recurse -ErrorAction SilentlyContinue -Force | Out-Null

Write-Output "Items coppied."
Write-Output ""
Start-Sleep -Seconds 1

Write-Output "Creating run key..."
Write-Output ""
Start-Sleep -Seconds 1
start-process powershell.exe -verb runas -wait -argumentlist {Set-ItemProperty Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Run -Name Scriptrun -Value {"C:/files/scripts/click me.bat"} -Force -ErrorAction SilentlyContinue ; Unblock-File "C:/files/scripts/click me.bat" -force}

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