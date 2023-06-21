Function Add-Driver {
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

    $Add1 = Start-Process powershell -ArgumentList {dism /Image:C:\Win10_en /Add-Driver /Driver:"C:\Users\MichaelFeenstraAgili\OneDrive - Agiliq B.V\Documenten\Drivers" /Recurse} -passthru
    $Add2 = Start-Process powershell -ArgumentList {dism /Image:C:\Win10_nl /Add-Driver /Driver:"C:\Users\MichaelFeenstraAgili\OneDrive - Agiliq B.V\Documenten\Drivers" /Recurse} -passthru
    $Add3 = Start-Process powershell -ArgumentList {dism /Image:C:\Win11_en /Add-Driver /Driver:"C:\Users\MichaelFeenstraAgili\OneDrive - Agiliq B.V\Documenten\Drivers" /Recurse} -passthru
    $Add4 = Start-Process powershell -ArgumentList {dism /Image:C:\Win11_nl /Add-Driver /Driver:"C:\Users\MichaelFeenstraAgili\OneDrive - Agiliq B.V\Documenten\Drivers" /Recurse} -passthru

    Wait-Process $Add1.id, $Add2.id, $Add3.id, $Add4.Id

    write-Output "`n Unmounting images..."
    WRITE-Output ""
    $unmount1 = Start-Process powershell -ArgumentList {dism /unmount-image /mountdir:C:/Win10_en /commit} -PassThru
    $unmount2 = Start-Process powershell -ArgumentList {dism /unmount-image /mountdir:C:/Win10_nl /commit} -PassThru
    $unmount3 = Start-Process powershell -ArgumentList {dism /unmount-image /mountdir:C:/Win11_en /commit} -PassThru
    $unmount4 = Start-Process powershell -ArgumentList {dism /unmount-image /mountdir:C:/Win11_nl /commit} -PassThru

    Wait-Process $unmount1.Id, $unmount2.id, $unmount3.id, $unmount4.id

    Remove-Item C:\WIN10_en, C:\WIN10_nl, C:\WIN11_en, C:\WIN11_nl -Force -Recurse -erroraction SilentlyContinue
}