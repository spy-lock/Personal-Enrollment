Function Set-WinImage {

    Remove-Item $env:ProgramFiles\enrollment\mount\WIN11PRO_en -Force -Recurse -erroraction SilentlyContinue
    Remove-Item $env:ProgramFiles\enrollment\mount\WIN11HOME_en -Force -Recurse -erroraction SilentlyContinue

    #CREATES DIRECTORIES FOR WHERE THE MOUNTED IMAGES WILL BE MOUNTED
    Write-Output "`n Creating directories..."
    WRITE-Output ""
    New-Item -ItemType Directory $env:ProgramFiles\enrollment\mount\Win11PRO_en -Force -ErrorAction SilentlyContinue | Out-Null
    New-Item -ItemType Directory $env:ProgramFiles\enrollment\mount\Win11HOME_en -Force -ErrorAction SilentlyContinue | Out-Null
    Write-Output ""
    start-sleep -second 1
    #MOUNTS THE IMAGES TO THE CREATED DIRECTORIES
    write-Output "`n Mounting images..."
    WRITE-output ""
    dism /mount-image /imagefile:"C:\program files\enrollment\iso\images\WIN11_en-gb\sources\install.wim" /index:1 /mountdir:"C:\program files\enrollment\mount\win11PRO_en"
    dism /mount-image /imagefile:"C:\program files\enrollment\iso\images\WIN11_en-gb\sources\install.wim" /index:2 /mountdir:"C:\program files\enrollment\mount\win11HOME_en"

    write-Output "`n Removing files in images..."
    WRITE-Output ""

    Remove-Item $env:ProgramFiles\enrollment\mount\win11PRO_en\files -Force -Recurse
    Remove-Item $env:ProgramFiles\enrollment\mount\win11HOME_en\files -Force -Recurse

    #COPYING FILES INSIDE THE MOUNTED IMAGES
    write-host "`n Copying items now..."
    copy-files -Source $env:ProgramFiles\enrollment\files -Destination $env:ProgramFiles\enrollment\mount\win11PRO_en\files -Activity "Copying 'WIN11PRO_en\files'..."  -Verbose
    copy-files -Source $env:ProgramFiles\enrollment\files -Destination $env:ProgramFiles\enrollment\mount\win11HOME_en\files -Activity "Copying 'WIN11HOME_en\files'..."  -Verbose

    WRITE-Output ""


    #UNMOUNTING IMAGES AND SAVING CHANGES
    write-Output "`n Unmounting images..."
    WRITE-Output ""
    dism /unmount-image /mountdir:"C:\program files\enrollment\mount\win11PRO_en" /commit
    dism /unmount-image /mountdir:"C:\program files\enrollment\mount\win11HOME_en" /commit

    Remove-Item $env:ProgramFiles\enrollment\mount\WIN11PRO_en -Force -Recurse -erroraction SilentlyContinue
    Remove-Item $env:ProgramFiles\enrollment\mount\WIN11HOME_en -Force -Recurse -erroraction SilentlyContinue

    Read-Host -Prompt "press (ENTER) to exit"
}
