Set-Location HKCU:\Software\Classes\CLSID\ -Verbose | Out-Null
New-Item "{86CA1AA0-34AA-4E8B-A509-50C905BAE2A2}" -Verbose -Force -ErrorAction SilentlyContinue | Out-Null
Write-Output "Creating main key..."
Start-Sleep -Seconds 2
Set-Location '.\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\' -Verbose | Out-Null
New-Item -Name "InprocServer32" -Verbose -Force -ErrorAction SilentlyContinue | Out-Null
Write-Output "Creating sub key..."
Start-Sleep -Seconds 2
set-item .\InprocServer32 -Value {} -Verbose -Force -ErrorAction SilentlyContinue | Out-Null
Write-Output "changing value to blank..."
Start-Sleep -Seconds 1
Write-Output "Restarting explorer..."
stop-Process -Name explorer -ErrorAction SilentlyContinue
Start-Sleep -Seconds 1
Start-Process explorer.exe -Wait -ErrorAction SilentlyContinue
Read-Host "Press (ENTER) to exit"
