Function Start-Deployment {
    DO {
        Clear-Host

        $t = @"
  _____                       _____ _          _ _ 
 |  __ \                     / ____| |        | | |
 | |__) |____      _____ _ __ (___ | |__   ___| | |
 |  ___/ _ \ \ /\ / / _ \ '__\___ \| '_ \ / _ \ | |
 | |  | (_) \ V  V /  __/ |  ____) | | | |  __/ | |
 |_|   \___/ \_/\_/ \___|_| |_____/|_| |_|\___|_|_|
                                                   
"@

        for ($i=0;$i -lt $t.length;$i++) {
            if ($i%2) {
                 $c = "red"
            }
        elseif ($i%5) {
             $c = "yellow"
        }
        elseif ($i%7) {
             $c = "green"
        }
        else {
           $c = "white"
        }
        write-host $t[$i] -NoNewline -ForegroundColor $c
        }
        $title = "`n Welcome Michael Feenstra"

        $message = "`n Choose your desired function."

        $Mount = New-Object System.Management.Automation.Host.ChoiceDescription "&Mount","Images will be mounted and updates with items in C:/iso/files."
        $Create = New-Object System.Management.Automation.Host.ChoiceDescription "&Create","Installation media will be created."
        $ReplaceDrive = New-Object System.Management.Automation.Host.ChoiceDescription "Replace&Drive","Replaces the images on the external drive."
        $ReplaceNas = New-Object System.Management.Automation.Host.ChoiceDescription "Replace&Nas","Replaces the iamges on the NAS."
        $exit = New-Object System.Management.Automation.Host.ChoiceDescription "E&xit","Will close the menu."

        $options = [System.Management.Automation.Host.ChoiceDescription[]]($Mount, $Create, $ReplaceDrive, $ReplaceNas, $exit)

        $result = $host.ui.PromptForChoice($title, $message, $options, 0) 

        $mountCode = 0
        $createCode = 0
        $ReplaceDriveCode = 0
        $ReplaceNasCode = 0
        $exitCode = 0

        switch ($result)
            {
                0 {"Running mount process..." ; $mountCode = 1}
                1 {"Running Creation process..." ; $createCode = 1}
                2 {"Running replacement process..." ; $ReplaceDriveCode = 1}
                3 {"Running replacement process..." ; $ReplaceNasCode = 1}
                4 {"Exiting..." ; $exitCode = 1}
            }

        IF($mountCode -eq 1) {
            Set-WinImage
        }


        IF($createCode -eq 1) {
            New-WinImageDrive
        }


        IF($ReplaceDriveCode -eq 1){
            Set-DriveImage
        }


        IF($ReplaceNasCode -eq 1){
            Set-NasImage
        }
    }
    UNTIL($exitCode -eq 1)

    Clear-Host
    Write-Output "`n Have a nice day!"
    Start-Sleep -Seconds 2

}