Function Set-NasImage {
    Write-Output "`n Starting NAS replacement process..."
    Start-Sleep -Seconds 2
    DO {
        $NAS = Test-Path L:/enrollment -ErrorAction SilentlyContinue
        IF($NAS -like "false") {
            Write-Output "`n Network share not found, mapping now..."
            Start-Sleep -Seconds 2

            net use L: \\192.168.227.250\Enrollment /user:Enrollment 3Ul9T0Ay!
        }
    }
    UNTIL($NAS -like "true")

    Remove-Files -Path L:\ENROLLMENT\FILES\images -Activity "Removing images from 'NAS'..." 

    copy-files -Source C:\iso\images -Destination L:\ENROLLMENT\FILES\images -Activity "Copying images to 'NAS'..."

    Write-output "`n Remove temp folders..."
    Write-Output ""
    Remove-Item C:\WIN10_en, C:\WIN10_nl, C:\WIN11_en, C:\WIN11_nl -ErrorAction SilentlyContinue

    Write-output "`n Operation completed succesfully."
    Read-Host -Prompt "`n Press (ENTER) to exit"
}
