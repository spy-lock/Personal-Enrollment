powershell set-executionpolicy -scope currentuser bypass
powershell start-process powershell -argumentlist C:\files\scripts\headscript\check.ps1 -WindowStyle Maximized
