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
    Get-ChildItem -Path $env:ProgramFiles\enrollment -Force -Recurse -ErrorAction SilentlyContinue| Where-Object -Property Name -like profile.ps1 | Select-Object -Property FullName -OutVariable ProfileLocation -ErrorAction SilentlyContinue| out-null -ErrorAction SilentlyContinue

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

    $profileversionEX = Test-Path "C:\Windows\System32\WindowsPowerShell\v1.0\ProfileVersion.txt" -ErrorAction SilentlyContinue

    IF($profileversionEX -like "false") {
        new-item -ItemType File -Path "C:\Windows\System32\WindowsPowerShell\v1.0" -Name profileversion.txt -ErrorAction SilentlyContinue -Force
    }

    [int]$Version = Get-Content "C:\windows\system32\windowspowershell\v1.0\ProfileVersion.txt" -Force
    $version++
    Set-Content "C:\windows\system32\windowspowershell\v1.0\ProfileVersion.txt" -Value $Version -Force
    Read-Host -Prompt "press enter to exit"
}