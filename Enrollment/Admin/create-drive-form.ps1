     # Self-elevate the script if required
    if (-Not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator')) {
     if ([int](Get-CimInstance -Class Win32_OperatingSystem | Select-Object -ExpandProperty BuildNumber) -ge 6000) {
      $CommandLine = "-File `"" + $MyInvocation.MyCommand.Path + "`" " + $MyInvocation.UnboundArguments
      Start-Process -FilePath PowerShell.exe -Verb Runas -ArgumentList $CommandLine -WindowStyle Maximized
      Exit
     }
    }

############### ASSEMBLIES ###############
[void] [System.Reflection.Assembly]::LoadWithPartialName("System.windows.forms")


###############\\-FUNCTION-//###############

Function get-drives
{
    $listview_CreateDrive1.Items.Clear()
    $listview_CreateDrive1.Columns.Clear()

    $drives = get-disk | Select-Object -Property disknumber, FriendlyName, BusType  

    $driveProperties = $drives[0].psobject.properties

    $driveProperties | ForEach-Object {
        $listview_CreateDrive1.Columns.Add("$($_.Name)") | Out-Null
    }

    foreach ($drive in $drives){

        $DriveListviewItem = New-Object System.Windows.Forms.ListViewItem($drive.disknumber)

        $drive.psobject.properties | Where-Object {$_.Name -ne "disknumber"} | ForEach-Object {
            $ColumnName = $_.name
            $DriveListviewItem.SubItems.Add("$($drive.$ColumnName)") | Out-Null
        }

        $listview_CreateDrive1.Items.Add($DriveListviewItem) | Out-Null

    }

    $listview_CreateDrive1.AutoResizeColumns("HeaderSize")

}

Function select-drive
{
    $SelectedDrive = @($listview_CreateDrive1.SelectedIndices)

    $DiskNumberColumnIndex = ($listview_CreateDrive1.Columns | Where-Object {$_.text -eq "DiskNumber"}).index

    $SelectedDrive | ForEach-Object {

        $DriveDiskNumber = ($listview_CreateDrive1.Items[$_].subitems[$DiskNumberColumnIndex]).text

        New-Item $env:windir\temp\drivechoice.txt -Value $DriveDiskNumber -Confirm:$false -Force
        }
}

Function copy-files
{
    Param
    (
        [Parameter(Mandatory)]
        [string]$Source,

        [Parameter(Mandatory)]
        [string]$Destination,

        [Parameter()]
        [string]$Activity = "Default"
    )

        $ItemsToCopy = Get-ChildItem $Source -Recurse -Force
        
        $TotalItems = $ItemsToCopy.Count
        $CurrentItem = 0
        $PercentComplete = 0

        ForEach ($Item in $ItemsToCopy)
        {
            Write-Progress -Activity $Activity -Status "$PercentComplete% Complete" -PercentComplete $PercentComplete

            $Name = $Item.FullName
            $TrimmedName = $Name.Replace($Source, "").trim("\")
            $DestinationFull = $Destination + '\' + $TrimmedName

            Copy-Item -Path $Name -Destination $DestinationFull -Force

            $currentItem++
            $percentcomplete = [int](($currentItem / $totalitems) * 100)
        }
}

Function Remove-Files
{
    Param
    (
        [Parameter(Mandatory)]
        [string]$Path,

        [Parameter()]
        [string]$Activity = "Default"
    )

        $ItemsToDelete = Get-ChildItem $Path -Recurse -File -Force
        $TotalItems = $ItemsToDelete.Count
        $CurrentItem = 0
        $PercentComplete = 0

        ForEach ($Item in $ItemsToDelete)
        {
            Write-Progress -Activity $Activity -Status "$PercentComplete% Complete" -PercentComplete $PercentComplete

            Remove-Item $item.FullName -Force -Confirm:$false

            $currentItem++
            $percentcomplete = [int](($currentItem / $totalitems) * 100)
        }

    Write-Progress -Activity "Cleaning up directories..." -Status Waiting -PercentComplete $PercentComplete
    Start-Sleep -Seconds 2

    Get-ChildItem $Path -Directory -Recurse | Remove-Item -Recurse -Force -Confirm:$false -Verbose
}


###############\\-FORM-//###############

$Form_CreateDrive                             = [System.Windows.Forms.Form]::new()
    $Form_CreateDrive.StartPosition           = "CenterScreen"
    $Form_CreateDrive.Size                    = [System.Drawing.Size]::new(410,360)
    $Form_CreateDrive.Text                    = "Disk creation"
    $Form_CreateDrive.FormBorderStyle         = "FixedDialog"
    $Form_CreateDrive.top                     = $true


###############\\-LABELS-//###############

$Label_CreateDrive1                            = [System.Windows.Forms.Label]::new()
    $Label_CreateDrive1.Location               = [System.Drawing.Point]::new(8,8)
    $Label_CreateDrive1.Size                   = [System.Drawing.Size]::new(240,32)
    $Label_CreateDrive1.Text                   = "Please select a drive:"


###############\\-LISTVIEW-//###############

$listview_CreateDrive1                         = New-Object System.Windows.Forms.ListView
    $listview_CreateDrive1.Location            = New-Object System.Drawing.Size(8,40)
    $listview_CreateDrive1.Size                = New-Object System.Drawing.Size(380,250)
    $listview_CreateDrive1.Anchor              = [System.Windows.Forms.AnchorStyles]::Bottom -bor
                                                 [System.Windows.Forms.AnchorStyles]::Left -bor
                                                 [System.Windows.Forms.AnchorStyles]::Right -bor
                                                 [System.Windows.Forms.AnchorStyles]::Top
    $listview_CreateDrive1.View                = "Details"
    $listview_CreateDrive1.FullRowSelect       = $true
    $listview_CreateDrive1.MultiSelect         = $true
    $listview_CreateDrive1.AllowColumnReorder  = $true
    $listview_CreateDrive1.GridLines           = $true


###############\\-BUTTONS-//###############

$button_CreateDrive1                       = New-Object System.Windows.Forms.Button
    $button_CreateDrive1.Location          = New-Object System.Drawing.Point(6,291)
    $button_CreateDrive1.Size              = New-Object System.Drawing.Size(100,28)
    $button_CreateDrive1.Text              = "Refresh"
    $button_CreateDrive1.Anchor            = [System.Windows.Forms.AnchorStyles]::Bottom -bor
                                             [System.Windows.Forms.AnchorStyles]::Left
    $button_CreateDrive1.TextAlign         = "MiddleCenter"

$button_CreateDrive2                       = New-Object System.Windows.Forms.Button
    $button_CreateDrive2.Location          = New-Object System.Drawing.Point(290,291)
    $button_CreateDrive2.Size              = New-Object System.Drawing.Size(100,28)
    $button_CreateDrive2.Text              = "Continue"
    $button_CreateDrive2.Anchor            = [System.Windows.Forms.AnchorStyles]::Bottom -bor
                                             [System.Windows.Forms.AnchorStyles]::Right
    $button_CreateDrive2.TextAlign         = "MiddleCenter"


###############\\-EVENTS-//###############

$button_CreateDrive1.add_click({

    get-drives

})

$button_CreateDrive2.add_click({

    select-drive
    $Form_CreateDrive.close()
})

###############\\-CONTROLS-//###############

$Form_CreateDrive.controls.Add($Label_CreateDrive1)
$Form_CreateDrive.Controls.Add($listview_CreateDrive1)
$Form_CreateDrive.controls.Add($button_CreateDrive1)
$Form_CreateDrive.controls.Add($button_CreateDrive2)

###############\\-SHOW-//###############

$Form_CreateDrive.add_shown({

    get-drives

})
[void] $Form_CreateDrive.ShowDialog()

Get-Content $env:windir\temp\drivechoice.txt -ErrorAction SilentlyContinue -Force -OutVariable disknumber | Out-Null

Clear-Host
Write-Output "`n Drive $DiskNumber will be used for installation."
Write-Output ""
Start-Sleep -Seconds 2

DO
{
    $adk = Test-Path "C:\Program Files (x86)\Windows Kits\10\Assessment and Deployment Kit\Deployment Tools\"

    IF($adk -like "false") {
        winget install --id Microsoft.WindowsADK --force --accept-package-agreements --accept-source-agreements -h
        winget install --id Microsoft.ADKPEAddon --force --accept-package-agreements --accept-source-agreements -h
    }

    ELSE
    {
        Write-Output "`n ADK has been found."
        Write-Output ""
        Start-Sleep -Seconds 2
    }
}
UNTIL($adk -like "true")

Write-Output "`n Initializing disks..."
Write-Output ""
Start-Sleep -Seconds 2

$disknumber = Get-Content $env:windir\temp\drivechoice.txt

Get-Disk | Where-Object -Property Number -eq $disknumber | Clear-Disk -RemoveData -Confirm:$false -Verbose

Set-Disk -PartitionStyle GPT -Number $disknumber -ErrorAction SilentlyContinue -Verbose

Initialize-Disk -Number $disknumber -erroraction silentlycontinue -Verbose

New-Partition -DiskNumber $disknumber -Size 10gb -DriveLetter P -Verbose
New-Partition -DiskNumber $disknumber -UseMaximumSize -DriveLetter E -Verbose

Format-Volume -DriveLetter p -FileSystem FAT32 -NewFileSystemLabel "Windows PE" -Verbose | out-null
Format-Volume -DriveLetter E -FileSystem NTFS -NewFileSystemLabel "Images" -Verbose | out-null

Write-Output "`n Disk initialized."
Write-Output ""
Start-Sleep -Seconds 2

write-output "`n Getting files to copy, this may take a while..."
write-output ""
start-sleep -seconds 2

Dism /Mount-Image /ImageFile:"C:\program files\enrollment\recources\PE\media\sources\boot.wim" /Index:1 /MountDir:"C:\program files\enrollment\Recources\PE\mount"

Dism /Add-Package /Image:"C:\program files\enrollment\Recources\PE\mount" /PackagePath:"C:\Program Files (x86)\Windows Kits\10\Assessment and Deployment Kit\Windows Preinstallation Environment\amd64\WinPE_OCs\WinPE-WMI.cab"
Dism /Add-Package /Image:"C:\program files\enrollment\Recources\PE\mount" /PackagePath:"C:\Program Files (x86)\Windows Kits\10\Assessment and Deployment Kit\Windows Preinstallation Environment\amd64\WinPE_OCs\en-us\WinPE-WMI_en-us.cab"
Dism /Add-Package /Image:"C:\program files\enrollment\Recources\PE\mount" /PackagePath:"C:\Program Files (x86)\Windows Kits\10\Assessment and Deployment Kit\Windows Preinstallation Environment\amd64\WinPE_OCs\WinPE-NetFX.cab"
Dism /Add-Package /Image:"C:\program files\enrollment\Recources\PE\mount" /PackagePath:"C:\Program Files (x86)\Windows Kits\10\Assessment and Deployment Kit\Windows Preinstallation Environment\amd64\WinPE_OCs\en-us\WinPE-NetFX_en-us.cab"
Dism /Add-Package /Image:"C:\program files\enrollment\Recources\PE\mount" /PackagePath:"C:\Program Files (x86)\Windows Kits\10\Assessment and Deployment Kit\Windows Preinstallation Environment\amd64\WinPE_OCs\WinPE-Scripting.cab"
Dism /Add-Package /Image:"C:\program files\enrollment\Recources\PE\mount" /PackagePath:"C:\Program Files (x86)\Windows Kits\10\Assessment and Deployment Kit\Windows Preinstallation Environment\amd64\WinPE_OCs\en-us\WinPE-Scripting_en-us.cab"
Dism /Add-Package /Image:"C:\program files\enrollment\Recources\PE\mount" /PackagePath:"C:\Program Files (x86)\Windows Kits\10\Assessment and Deployment Kit\Windows Preinstallation Environment\amd64\WinPE_OCs\WinPE-PowerShell.cab"
Dism /Add-Package /Image:"C:\program files\enrollment\Recources\PE\mount" /PackagePath:"C:\Program Files (x86)\Windows Kits\10\Assessment and Deployment Kit\Windows Preinstallation Environment\amd64\WinPE_OCs\en-us\WinPE-PowerShell_en-us.cab"
Dism /Add-Package /Image:"C:\program files\enrollment\Recources\PE\mount" /PackagePath:"C:\Program Files (x86)\Windows Kits\10\Assessment and Deployment Kit\Windows Preinstallation Environment\amd64\WinPE_OCs\WinPE-StorageWMI.cab"
Dism /Add-Package /Image:"C:\program files\enrollment\Recources\PE\mount" /PackagePath:"C:\Program Files (x86)\Windows Kits\10\Assessment and Deployment Kit\Windows Preinstallation Environment\amd64\WinPE_OCs\en-us\WinPE-StorageWMI_en-us.cab"
Dism /Add-Package /Image:"C:\program files\enrollment\Recources\PE\mount" /PackagePath:"C:\Program Files (x86)\Windows Kits\10\Assessment and Deployment Kit\Windows Preinstallation Environment\amd64\WinPE_OCs\WinPE-DismCmdlets.cab"
Dism /Add-Package /Image:"C:\program files\enrollment\Recources\PE\mount" /PackagePath:"C:\Program Files (x86)\Windows Kits\10\Assessment and Deployment Kit\Windows Preinstallation Environment\amd64\WinPE_OCs\en-us\WinPE-DismCmdlets_en-us.cab"

Dism /Unmount-Image /MountDir:C:\WinPE_amd64_PS\mount /Commit

dism /Apply-Image /ImageFile:"C:\program files\enrollment\recources\PE\media\sources\boot.wim" /Index:1 /ApplyDir:P:\

Start-Process powershell -ArgumentList {bcdboot P:\Windows /s P: /f ALL} -WorkingDirectory "C:\Program Files (x86)\Windows Kits\10\Assessment and Deployment Kit\Deployment Tools" -Wait

copy-files -Source $env:ProgramFiles\enrollment\ISO -Destination E: -Activity "Copying files from 'FILES'..."

Write-Output "`n Items have been copied."
Write-Output ""
Start-Sleep -Seconds 2

Write-Output "`n Adding boot files..."
Write-Output ""
Start-Sleep -Seconds 2

$drives = "D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"
FOREACH ($drive in $drives) {
    #\\-If it finds the right drive with the right file./-//#
    IF (Test-Path "$($drive):\checkofditdejuistedriveis.txt") {
        #\\-Saves the right drive in a variable.-//#
        $ImageDrive = $drive
    }
}

$drives = "D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"
FOREACH ($drive in $drives) {
    #\\-If it finds the right drive with the right file./-//#
    IF (Test-Path "$($drive):\checkdrive.ps1") {
        #\\-Saves the right drive in a variable.-//#
        $PEDrive = $drive
    }
}


$imageDriveL = $imageDrive + ":"
chkdsk $imageDriveL /f /x /r /c /i /b /scan /perf
Optimize-Volume $imageDrive -Analyze -Defrag -Verbose

$peDriveL = $peDrive + ":"
chkdsk $peDriveL /f /x /r




Write-Output "`n Script is done."
Read-Host -Prompt "Press enter to exit (ENTER)"