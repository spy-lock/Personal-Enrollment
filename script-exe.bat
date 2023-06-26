powershell start-process powershell.exe -argumentlist {set-executionpolicy -scope currentuser bypass -force} -verb runas
powershell start-process powershell -argumentlist ./start-deployment.ps1 -WindowStyle Maximized
