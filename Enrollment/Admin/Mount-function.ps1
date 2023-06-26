Function Set-WinImage {

    Remove-Item $env:ProgramFiles\enrollment\mount\WIN11_en -Force -Recurse -erroraction SilentlyContinue

    #CREATES DIRECTORIES FOR WHERE THE MOUNTED IMAGES WILL BE MOUNTED
    Write-Output "`n Creating directories..."
    WRITE-Output ""
    New-Item -ItemType Directory $env:ProgramFiles\enrollment\mount\Win11_en -Force -ErrorAction SilentlyContinue | Out-Null
    Write-Output ""
    start-sleep -second 1
    #MOUNTS THE IMAGES TO THE CREATED DIRECTORIES
    write-Output "`n Mounting images..."
    WRITE-output ""
    dism /mount-image /imagefile:"C:\program files\enrollment\iso\images\WIN11_en-gb\sources\install.wim" /index:1 /mountdir:"C:\program files\enrollment\mount\win11_en"

    write-Output "`n Removing files in images..."
    WRITE-Output ""

    Remove-Item $env:ProgramFiles\enrollment\mount\win11_en\files -Force -Recurse

    #COPYING FILES INSIDE THE MOUNTED IMAGES
    write-host "`n Copying items now..."
    copy-files -Source $env:ProgramFiles\enrollment\files -Destination $env:ProgramFiles\enrollment\mount\win11_en\files -Activity "Copying 'WIN11_en\files'..."  -Verbose
    WRITE-Output ""


    #UNMOUNTING IMAGES AND SAVING CHANGES
    write-Output "`n Unmounting images..."
    WRITE-Output ""
    dism /unmount-image /mountdir:"C:\program files\enrollment\mount\win11_en" /commit

    Remove-Item $env:ProgramFiles\enrollment\mount\WIN11_en -Force -Recurse -erroraction SilentlyContinue
}
