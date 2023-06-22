Function Set-WinImage {
    Copy-Item -Path "C:\Users\MichaelFeenstraAgili\OneDrive - Agiliq B.V\Documenten\Powershell-Enrollment\Enrollment\Drivers" -Destination C:\Iso\Files\ -Force -Verbose -Recurse
    Copy-Item -Path "C:\Users\MichaelFeenstraAgili\OneDrive - Agiliq B.V\Documenten\Powershell-Enrollment\Enrollment\Econvert" -Destination C:\Iso\Files\ -Force -Verbose -Recurse
    Copy-Item -Path "C:\Users\MichaelFeenstraAgili\OneDrive - Agiliq B.V\Documenten\Powershell-Enrollment\Enrollment\Modules" -Destination C:\Iso\Files\ -Force -Verbose -Recurse
    Copy-Item -Path "C:\Users\MichaelFeenstraAgili\OneDrive - Agiliq B.V\Documenten\Powershell-Enrollment\Enrollment\Scripts" -Destination C:\Iso\Files\ -Force -Verbose -Recurse
    Copy-Item -Path "C:\Users\MichaelFeenstraAgili\OneDrive - Agiliq B.V\Documenten\Powershell-Enrollment\Enrollment\WinForm" -Destination C:\Iso\Files\ -Force -Verbose -Recurse

    Remove-Item C:\WIN10_en, C:\WIN10_nl, C:\WIN11_en, C:\WIN11_nl -Force -Recurse -erroraction SilentlyContinue

    #CREATES DIRECTORIES FOR WHERE THE MOUNTED IMAGES WILL BE MOUNTED
    Write-Output "`n Creating directories..."
    WRITE-Output ""
    mkdir C:\WIN10_en -ErrorAction SilentlyContinue | Out-Null
    mkdir C:\WIN10_nl -ErrorAction SilentlyContinue | Out-Null
    mkdir C:\WIN11_en -ErrorAction SilentlyContinue | Out-Null
    mkdir C:\WIN11_nl -ErrorAction SilentlyContinue | Out-Null
    Write-Output ""

    #MOUNTS THE IMAGES TO THE CREATED DIRECTORIES
    write-Output "`n Mounting images..."
    WRITE-output ""
    $mount1 = Start-Process powershell -ArgumentList {dism /mount-image /imagefile:"C:\iso\images\WIN10_en-gb\sources\install.wim" /index:1 /mountdir:C:/Win10_en} -passthru
    $mount2 = Start-Process powershell -ArgumentList {dism /mount-image /imagefile:"C:\iso\images\WIN10_nl-nl\sources\install.wim" /index:1 /mountdir:C:/Win10_nl} -passthru
    $mount3 = Start-Process powershell -ArgumentList {dism /mount-image /imagefile:"C:\iso\images\WIN11_en-gb\sources\install.wim" /index:1 /mountdir:C:/Win11_en} -passthru
    $mount4 = Start-Process powershell -ArgumentList {dism /mount-image /imagefile:"C:\iso\images\WIN11_nl-nl\sources\install.wim" /index:1 /mountdir:C:/Win11_nl} -passthru

    Wait-Process $mount1.Id, $mount2.id, $mount3.id, $mount4.id

    write-Output "`n Removing files in images..."
    WRITE-Output ""

    Remove-Item C:\WIN10_en\files -Force -Recurse
    Remove-item C:\WIN10_nl\files -Force -Recurse
    Remove-Item C:\WIN11_en\files -Force -Recurse
    Remove-Item C:\WIN11_nl\files -Force -Recurse

    #COPYING FILES INSIDE THE MOUNTED IMAGES
    write-host "`n Copying items now..."
    copy-files -Source C:\iso\Files -Destination C:\WIN10_en\files -Activity "Copying 'WIN10_en\files'..."  -Verbose
    copy-files -Source C:\iso\files -Destination C:\Win10_nl\files -Activity "Copying 'WIN10_nl\files'..." -Verbose
    copy-files -Source C:\iso\files -Destination C:\Win11_en\files -Activity "Copying 'WIN11_en\files'..."  -Verbose
    copy-files -Source C:\iso\files -Destination C:\Win11_nl\files -Activity "Copying 'WIN11_nl\files'..."  -Verbose
    WRITE-Output ""


    #UNMOUNTING IMAGES AND SAVING CHANGES
    write-Output "`n Unmounting images..."
    WRITE-Output ""
    $unmount1 = Start-Process powershell -ArgumentList {dism /unmount-image /mountdir:C:/Win10_en /commit} -PassThru
    $unmount2 = Start-Process powershell -ArgumentList {dism /unmount-image /mountdir:C:/Win10_nl /commit} -PassThru
    $unmount3 = Start-Process powershell -ArgumentList {dism /unmount-image /mountdir:C:/Win11_en /commit} -PassThru
    $unmount4 = Start-Process powershell -ArgumentList {dism /unmount-image /mountdir:C:/Win11_nl /commit} -PassThru

    Wait-Process $unmount1.Id, $unmount2.id, $unmount3.id, $unmount4.id

    Remove-Item C:\WIN10_en, C:\WIN10_nl, C:\WIN11_en, C:\WIN11_nl -Force -Recurse -erroraction SilentlyContinue
}