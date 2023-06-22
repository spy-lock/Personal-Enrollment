Function Set-WinImage {

    Remove-Item $env:ProgramFiles\enrollment\mount\WIN10_en, $env:ProgramFiles\enrollment\mount\WIN10_nl, $env:ProgramFiles\enrollment\mount\WIN11_en, $env:ProgramFiles\enrollment\mount\WIN11_nl -Force -Recurse -erroraction SilentlyContinue

    #CREATES DIRECTORIES FOR WHERE THE MOUNTED IMAGES WILL BE MOUNTED
    Write-Output "`n Creating directories..."
    WRITE-Output ""
    New-Item -ItemType Directory $env:ProgramFiles\enrollment\mount\win10_en -Force -ErrorAction SilentlyContinue | Out-Null
    New-Item -ItemType Directory $env:ProgramFiles\enrollment\mount\Win10_nl -Force -ErrorAction SilentlyContinue | Out-Null
    New-Item -ItemType Directory $env:ProgramFiles\enrollment\mount\Win11_en -Force -ErrorAction SilentlyContinue | Out-Null
    New-Item -ItemType Directory $env:ProgramFiles\enrollment\mount\Win11_nl -Force -ErrorAction SilentlyContinue | Out-Null
    Write-Output ""

    #MOUNTS THE IMAGES TO THE CREATED DIRECTORIES
    write-Output "`n Mounting images..."
    WRITE-output ""
    $mount1 = Start-Process powershell -ArgumentList {dism /mount-image /imagefile:"C:\programfiles\enrollment\iso\images\WIN10_en-gb\sources\install.wim" /index:1 /mountdir:C:\programfiles\enrollment\mount\win10_en} -passthru
    $mount2 = Start-Process powershell -ArgumentList {dism /mount-image /imagefile:"C:\programfiles\enrollment\iso\images\WIN10_nl-nl\sources\install.wim" /index:1 /mountdir:C:\programfiles\enrollment\mount\win10_nl} -passthru
    $mount3 = Start-Process powershell -ArgumentList {dism /mount-image /imagefile:"C:\programfiles\enrollment\iso\images\WIN11_en-gb\sources\install.wim" /index:1 /mountdir:C:\programfiles\enrollment\mount\win11_en} -passthru
    $mount4 = Start-Process powershell -ArgumentList {dism /mount-image /imagefile:"C:\programfiles\enrollment\iso\images\WIN11_nl-nl\sources\install.wim" /index:1 /mountdir:C:\programfiles\enrollment\mount\win11_nl} -passthru

    Wait-Process $mount1.Id, $mount2.id, $mount3.id, $mount4.id

    write-Output "`n Removing files in images..."
    WRITE-Output ""

    Remove-Item C:\programfiles\enrollment\mount\win10_en\files -Force -Recurse
    Remove-item C:\programfiles\enrollment\mount\win10_nl\files -Force -Recurse
    Remove-Item C:\programfiles\enrollment\mount\win11_en\files -Force -Recurse
    Remove-Item C:\programfiles\enrollment\mount\win11_nl\files -Force -Recurse

    #COPYING FILES INSIDE THE MOUNTED IMAGES
    write-host "`n Copying items now..."
    copy-files -Source $env:ProgramFiles\enrollment\files -Destination C:\programfiles\enrollment\mount\win10_en\files -Activity "Copying 'WIN10_en\files'..."  -Verbose
    copy-files -Source $env:ProgramFiles\enrollment\files -Destination C:\programfiles\enrollment\mount\win10_nl\files -Activity "Copying 'WIN10_nl\files'..." -Verbose
    copy-files -Source $env:ProgramFiles\enrollment\files -Destination C:\programfiles\enrollment\mount\win11_en\files -Activity "Copying 'WIN11_en\files'..."  -Verbose
    copy-files -Source $env:ProgramFiles\enrollment\files -Destination C:\programfiles\enrollment\mount\win11_nl\files -Activity "Copying 'WIN11_nl\files'..."  -Verbose
    WRITE-Output ""


    #UNMOUNTING IMAGES AND SAVING CHANGES
    write-Output "`n Unmounting images..."
    WRITE-Output ""
    $unmount1 = Start-Process powershell -ArgumentList {dism /unmount-image /mountdir:C:\programfiles\enrollment\mount\win10_en /commit} -PassThru
    $unmount2 = Start-Process powershell -ArgumentList {dism /unmount-image /mountdir:C:\programfiles\enrollment\mount\win10_nl /commit} -PassThru
    $unmount3 = Start-Process powershell -ArgumentList {dism /unmount-image /mountdir:C:\programfiles\enrollment\mount\win11_en /commit} -PassThru
    $unmount4 = Start-Process powershell -ArgumentList {dism /unmount-image /mountdir:C:\programfiles\enrollment\mount\win11_nl /commit} -PassThru

    Wait-Process $unmount1.Id, $unmount2.id, $unmount3.id, $unmount4.id

    Remove-Item $env:ProgramFiles\enrollment\mount\WIN10_en, $env:ProgramFiles\enrollment\mount\WIN10_nl, $env:ProgramFiles\enrollment\mount\WIN11_en, $env:ProgramFiles\enrollment\mount\WIN11_nl -Force -Recurse -erroraction SilentlyContinue
}
