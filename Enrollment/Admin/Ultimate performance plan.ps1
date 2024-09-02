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
powercfg -duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61