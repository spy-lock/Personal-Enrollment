Function Set-DriveImage {
    #\\-Puts all possible drives in a variable.-//#
    $drives = "D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"
    #\\-Does the statement for every item in $drives.-//#
    FOREACH ($drive in $drives) {
        #\\-If it finds the right drive with the right file./-//#
        IF (Test-Path "$($drive):\checkofditdejuistedriveis.txt") {
            #\\-Saves the right drive in a variable.-//#
            $IMAGESDRIVE =$drive
        }
    }
        IF(!$IMAGESDRIVE) {
            DO {
                Write-Output "Image drive not found on any of the possible drives."
                $RefreshOrExit = Read-Host -Prompt "Press (R) to Refresh OR Press (X) to Exit"
                IF($RefreshOrExit -eq "R") {
                    FOREACH ($drive in $drives) {
                        #\\-If it finds the right drive with the right file./-//#
                        IF (Test-Path "$($drive):\checkofditdejuistedriveis.txt") {
                            #\\-Saves the right drive in a variable.-//#
                            $IMAGESDRIVE =$drive
                        }
                    }
                }
                IF($RefreshOrExit -eq "X") {
                    Exit-PSHostProcess
                }
                
            }UNTIL($IMAGESDRIVE)
        }

    $FullDrivePath = "$IMAGESDRIVE" + ":\"

    Remove-Files -Path $FullDrivePath\images -Activity "Removing images from External drive..."
    copy-files -Source C:\iso\images -Destination $FullDrivePath\images -activity "Replacing images..."

    Read-Host "`n Press (ENTER) to exit"
}
