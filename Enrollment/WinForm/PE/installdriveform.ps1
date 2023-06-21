#Load the System.windows.forms assembly to enable creating Windows Forms UI elements
[void] [System.Reflection.Assembly]::LoadWithPartialName("System.windows.forms")

#Initialize the environment variables to store the user's selections
$env:windowschoice = ""
$env:languagechoice = ""

#Define a function to get information about the disk drives and display them in a list view
Function get-drives
{
	# Clear the existing items and columns in the list view
	$listview_drives.Items.Clear()
	$listview_drives.Columns.Clear()
	# Get the disk drive information and select only the disk number, friendly name, and bus type properties
	$drives = get-disk | Select-Object -Property disknumber, FriendlyName, BusType
	
	# Get the properties of the first disk drive and use them as the column headers for the list view
	$driveProperties = $drives[0].psobject.properties
	$driveProperties | ForEach-Object {
	    $listview_drives.Columns.Add("$($_.Name)") | Out-Null
	}
	
	# Iterate through each disk drive, create a new list view item, and add its properties to the list view
	foreach ($drive in $drives){
	    $DriveListviewItem = New-Object System.Windows.Forms.ListViewItem($drive.disknumber)
	    $drive.psobject.properties | Where-Object {$_.Name -ne "disknumber"} | ForEach-Object {
	        $ColumnName = $_.name
	        $DriveListviewItem.SubItems.Add("$($drive.$ColumnName)") | Out-Null
	    }
	    $listview_drives.Items.Add($DriveListviewItem) | Out-Null
	}
	
	# Resize the columns to fit their contents
	$listview_drives.AutoResizeColumns("HeaderSize")
}

#Define a function to write the selected disk drive number to the drivechoice.txt file
Function select-drive
{
	# Get the index of the selected disk drive in the list view
	$SelectedDrive = @($listview_drives.SelectedIndices)
	$DiskNumberColumnIndex = ($listview_drives.Columns | Where-Object {$_.text -eq "DiskNumber"}).index
	# Write the disk number to the drivechoice.txt file in the %windir%\\temp folder
	$SelectedDrive | ForEach-Object {
	    $DriveDiskNumber = ($listview_drives.Items[$_].subitems[$DiskNumberColumnIndex]).text
	    New-Item $env:windir\\temp\\drivechoice.txt -Value $DriveDiskNumber -Confirm:$false -Force
	}
}

#Create the Windows Forms UI elements
$Form_DriveSelection = New-Object System.Windows.Forms.Form
$Form_DriveSelection.Text = "Drive Selection"
$Form_DriveSelection.Size = New-Object System.Drawing.Size(450,400)
$Form_DriveSelection.FormBorderStyle = "FixedDialog"
$Form_DriveSelection.Top = $true
$Form_DriveSelection.MaximizeBox = $true
$Form_DriveSelection.MinimizeBox = $true
$Form_DriveSelection.ControlBox = $true
$Form_DriveSelection.StartPosition = "CenterScreen"
$Form_DriveSelection.Font = "Segoe UI"

#Create a label for selecting the drive
$Label_DriveSelection1 = New-Object System.Windows.Forms.Label
$Label_DriveSelection1.Location = New-Object System.Drawing.Point(8,8)
$Label_DriveSelection1.Size = New-Object System.Drawing.Size(240,32)
$Label_DriveSelection1.Text = "Please select a drive to install windows on:"
$Label_DriveSelection1.TextAlign = "MiddleLeft"

#Create a label for indicating the selected drive
$Label_DriveSelection2 = New-Object System.Windows.Forms.Label
$Label_DriveSelection2.Location = New-Object System.Drawing.Point(10,10)
$Label_DriveSelection2.Size = New-Object System.Drawing.Size(240,32)
$Label_DriveSelection2.Text = "Windows will be installed on the selected drive."
$Label_DriveSelection2.TextAlign = "MiddleLeft"

#Create a label for continuing the installation process
$Label_DriveSelection3 = New-Object System.Windows.Forms.Label
$Label_DriveSelection3.Location = New-Object System.Drawing.Point(10,70)
$Label_DriveSelection3.Size = New-Object System.Drawing.Size(240,32)
$Label_DriveSelection3.Text = "Select 'Continue' to proceed."
$Label_DriveSelection3.TextAlign = "MiddleLeft"

#Create a label for selecting the Windows version
$Label_WindowsSelection1 = New-Object System.Windows.Forms.Label
$Label_WindowsSelection1.Location = New-Object System.Drawing.Point(8,8)
$Label_WindowsSelection1.Size = New-Object System.Drawing.Size(240,32)
$Label_WindowsSelection1.Text = "Please select a Windows version:"
$Label_WindowsSelection1.TextAlign = "MiddleLeft"

#Create a label for selecting the Windows language
$Label_WindowsSelection2 = New-Object System.Windows.Forms.Label
$Label_WindowsSelection2.Location = New-Object System.Drawing.Point(8,8)
$Label_WindowsSelection2.Size = New-Object System.Drawing.Size(240,32)
$Label_WindowsSelection2.Text = "Please select a Windows language:"
$Label_WindowsSelection2.TextAlign = "MiddleLeft"

#Create a label for starting the installation process
$Label_WindowsSelection3 = New-Object System.Windows.Forms.Label
$Label_WindowsSelection3.Location = New-Object System.Drawing.Point(8,8)
$Label_WindowsSelection3.Size = New-Object System.Drawing.Size(240,32)
$Label_WindowsSelection3.Text = "Click to start Install:"
$Label_WindowsSelection3.TextAlign = "MiddleLeft"

#Create a new ListView object for displaying drives
$listview_drives = New-Object System.Windows.Forms.ListView
$listview_drives.Location = New-Object System.Drawing.Size(8,40)
$listview_drives.Size = New-Object System.Drawing.Size(430,250)
$listview_drives.Anchor = [System.Windows.Forms.AnchorStyles]::Bottom -bor
[System.Windows.Forms.AnchorStyles]::Left -bor
[System.Windows.Forms.AnchorStyles]::Right -bor
[System.Windows.Forms.AnchorStyles]::Top
$listview_drives.View = "Details"
$listview_drives.FullRowSelect = $true
$listview_drives.MultiSelect = $true
$listview_drives.AllowColumnReorder = $true
$listview_drives.GridLines = $true

#Create a button for refreshing the list of drives
$button_DriveSelection1 = New-Object System.Windows.Forms.Button
$button_DriveSelection1.Location = New-Object System.Drawing.Point(10,310)
$button_DriveSelection1.Size = New-Object System.Drawing.Size(150,34)
$button_DriveSelection1.Text = "Refresh"
$button_DriveSelection1.Anchor = [System.Windows.Forms.AnchorStyles]::Bottom -bor
[System.Windows.Forms.AnchorStyles]::Left
$button_DriveSelection1.TextAlign = "MiddleCenter"

#Create a button for continuing with the selected drive(s)
$button_DriveSelection2 = New-Object System.Windows.Forms.Button
$button_DriveSelection2.Location = New-Object System.Drawing.Point(280,310)
$button_DriveSelection2.Size = New-Object System.Drawing.Size(150,34)
$button_DriveSelection2.Text = "Continue"
$button_DriveSelection2.Anchor = [System.Windows.Forms.AnchorStyles]::Bottom -bor
[System.Windows.Forms.AnchorStyles]::Right
$button_DriveSelection2.TextAlign = "MiddleCenter"

#Create another button for continuing with the selected drive(s)
$button_DriveSelection3 = New-Object System.Windows.Forms.Button
$button_DriveSelection3.Location = New-Object System.Drawing.Point(280,310)
$button_DriveSelection3.Size = New-Object System.Drawing.Size(150,34)
$button_DriveSelection3.Text = "Continue"
$button_DriveSelection3.Anchor = [System.Windows.Forms.AnchorStyles]::Bottom -bor
[System.Windows.Forms.AnchorStyles]::Right
$button_DriveSelection3.TextAlign = "MiddleCenter"

#Create a button for selecting Windows 11
$Button_WindowsOption1 = New-Object System.Windows.Forms.Button
$Button_WindowsOption1.Location = New-Object System.Drawing.Point(90,60)
$Button_WindowsOption1.Size = New-Object System.Drawing.Size(240,34)
$Button_WindowsOption1.TextAlign = "MiddleCenter"
$Button_WindowsOption1.Text = "Windows 11"
$Button_WindowsOption1.Anchor = [System.Windows.Forms.AnchorStyles]::Top

#Create a button for selecting Windows 10
$Button_WindowsOption2 = New-Object System.Windows.Forms.Button
$Button_WindowsOption2.Location = New-Object System.Drawing.Point(90,100)
$Button_WindowsOption2.Size = New-Object System.Drawing.Size(240,34)
$Button_WindowsOption2.TextAlign = "MiddleCenter"
$Button_WindowsOption2.Text = "Windows 10"
$Button_WindowsOption2.Anchor = [System.Windows.Forms.AnchorStyles]::Top

#Creates a button for NL language option
$Button_WindowsOption3 = New-Object System.Windows.Forms.Button
$Button_WindowsOption3.Location = New-Object System.Drawing.Point(90,60)
$Button_WindowsOption3.Size = New-Object System.Drawing.Size(240,34)
$Button_WindowsOption3.TextAlign = "MiddleCenter"
$Button_WindowsOption3.Text = "NL"
$Button_WindowsOption3.Anchor = [System.Windows.Forms.AnchorStyles]::top

#Creates a button for EN language option
$Button_WindowsOption4 = New-Object System.Windows.Forms.Button
$Button_WindowsOption4.Location = New-Object System.Drawing.Point(90,100)
$Button_WindowsOption4.Size = New-Object System.Drawing.Size(240,34)
$Button_WindowsOption4.TextAlign = "MiddleCenter"
$Button_WindowsOption4.Text = "EN"
$Button_WindowsOption4.Anchor = [System.Windows.Forms.AnchorStyles]::top

#Creates a button for INSTALL option
$Button_WindowsOption5 = New-Object System.Windows.Forms.Button
$Button_WindowsOption5.Location = New-Object System.Drawing.Point(90,60)
$Button_WindowsOption5.Size = New-Object System.Drawing.Size(240,34)
$Button_WindowsOption5.TextAlign = "MiddleCenter"
$Button_WindowsOption5.Text = "INSTALL"
$Button_WindowsOption5.Anchor = [System.Windows.Forms.AnchorStyles]::top

#Creates a button for "Back" option for Drive Selection screen
$BackButton_DriveSelection1 = New-Object System.Windows.Forms.Button
$BackButton_DriveSelection1.Location = New-Object System.Drawing.Point(10,310)
$BackButton_DriveSelection1.Size = New-Object System.Drawing.Size(150,34)
$BackButton_DriveSelection1.Text = "Back"
$BackButton_DriveSelection1.Anchor = [System.Windows.Forms.AnchorStyles]::Bottom -bor [System.Windows.Forms.AnchorStyles]::Left
$BackButton_DriveSelection1.TextAlign = "MiddleCenter"

#Creates a button for "Back" option for Drive Selection screen
$BackButton_DriveSelection2 = New-Object System.Windows.Forms.Button
$BackButton_DriveSelection2.Location = New-Object System.Drawing.Point(10,310)
$BackButton_DriveSelection2.Size = New-Object System.Drawing.Size(150,34)
$BackButton_DriveSelection2.Text = "Back"
$BackButton_DriveSelection2.Anchor = [System.Windows.Forms.AnchorStyles]::Bottom -bor [System.Windows.Forms.AnchorStyles]::Left
$BackButton_DriveSelection2.TextAlign = "MiddleCenter"

#Creates a button for "Back" option for other screens
$button_back1 = New-Object System.Windows.Forms.Button
$button_back1.Location = New-Object System.Drawing.Point(10,310)
$button_back1.Size = New-Object System.Drawing.Size(150,34)
$button_back1.TextAlign = "MiddleCenter"
$button_back1.Text = "Back"
$button_back1.Anchor = [System.Windows.Forms.AnchorStyles]::Bottom -bor [System.Windows.Forms.AnchorStyles]::Left

#Creates a button for "Back" option for other screens
$button_back2 = New-Object System.Windows.Forms.Button
$button_back2.Location = New-Object System.Drawing.Point(10,310)
$button_back2.Size = New-Object System.Drawing.Size(150,34)
$button_back2.Text = "Back"
$button_back2.TextAlign = "MiddleCenter"
$button_back2.Anchor = [System.Windows.Forms.AnchorStyles]::Bottom -bor [System.Windows.Forms.AnchorStyles]::left

$button_DriveSelection1.add_click({
	# When button_DriveSelection1 is clicked, execute the get-drives command and write a verbose message.
	get-drives
	Write-Verbose -Message "Refreshing drives..." -Verbose
})

$button_DriveSelection2.add_click({
	# When button_DriveSelection2 is clicked, execute the select-drive command, get the current chosen drive from a text file, and write a verbose message.
	select-drive
	Get-Content $env:windir\temp\drivechoice.txt -OutVariable currentchosendrive | Out-Null
	Write-Verbose -Message "Disk $currentchosendrive chosen" -Verbose
	# Show or hide certain UI elements.
	$Label_DriveSelection2.Visible = $true
	$Label_DriveSelection3.Visible = $true
	$button_DriveSelection3.Visible = $true
	$BackButton_DriveSelection1.Visible = $true
	
	$Label_DriveSelection1.Visible = $false
	$listview_drives.Visible = $false
	$button_DriveSelection1.Visible = $false
	$button_DriveSelection2.Visible = $false
})

$button_DriveSelection3.add_click({
	# When button_DriveSelection3 is clicked, show or hide certain UI elements.
	$BackButton_DriveSelection2.Visible = $true
	$Label_WindowsSelection1.Visible = $true
	$Button_WindowsOption1.Visible = $true
	$Button_WindowsOption2.Visible = $true
	$Label_DriveSelection2.Visible = $false
	$Label_DriveSelection3.Visible = $false
	$button_DriveSelection3.Visible = $false
	$BackButton_DriveSelection1.Visible = $false
})

$BackButton_DriveSelection1.add_click({
	# When BackButton_DriveSelection1 is clicked, show or hide certain UI elements.
	$Label_DriveSelection1.Visible = $true
	$listview_drives.Visible = $true
	$button_DriveSelection1.Visible = $true
	$button_DriveSelection2.Visible = $true
	$Label_DriveSelection2.Visible = $false
	$Label_DriveSelection3.Visible = $false
	$button_DriveSelection3.Visible = $false
	$BackButton_DriveSelection1.Visible = $false
	$Label_DriveSelection2.Visible = $false
})

$BackButton_DriveSelection2.add_click({
	# When BackButton_DriveSelection2 is clicked, show or hide certain UI elements.
	$Label_DriveSelection2.Visible = $true
	$Label_DriveSelection3.Visible = $true
	$button_DriveSelection3.Visible = $true
	$BackButton_DriveSelection1.Visible = $true
	$BackButton_DriveSelection2.Visible = $false
	$Label_WindowsSelection1.Visible = $false
	$Button_WindowsOption1.Visible = $false
	$Button_WindowsOption2.Visible = $false
})

#This block adds a click event handler to the button named $Button_WindowsOption1
	$Button_WindowsOption1.add_click({
	# This block makes some UI elements visible when the button is clicked
	$button_back1.Visible = $true
	$Button_WindowsOption3.Visible = $true
	$Button_WindowsOption4.Visible = $true
	$Label_WindowsSelection2.Visible = $true
	
	# This block makes some UI elements invisible when the button is clicked
	$Button_WindowsOption1.Visible = $false
	$Button_WindowsOption2.Visible = $false
	$Label_WindowsSelection1.Visible = $false
	$BackButton_DriveSelection2.Visible = $false
	
	# This block sets the environment variable windowschoice to 11 and writes a verbose message
	$env:windowschoice = 11
	Write-Verbose -Message "Windows $env:windowschoice chosen" -Verbose
})

#This block adds a click event handler to the button named $Button_WindowsOption2
$Button_WindowsOption2.add_click({
	# This block makes some UI elements visible when the button is clicked
	$button_back1.Visible = $true
	$Button_WindowsOption3.Visible = $true
	$Button_WindowsOption4.Visible = $true
	$Label_WindowsSelection2.Visible = $true
	
	# This block makes some UI elements invisible when the button is clicked
	$Button_WindowsOption1.Visible = $false
	$Button_WindowsOption2.Visible = $false
	$Label_WindowsSelection1.Visible = $false
	$BackButton_DriveSelection2.Visible = $false
	
	# This block sets the environment variable windowschoice to 10 and writes a verbose message
	$env:windowschoice = 10
	Write-Verbose -Message "Windows $env:windowschoice chosen" -Verbose
})

#This block adds a click event handler to the button named $Button_WindowsOption3
$Button_WindowsOption3.add_click({
	# This block makes some UI elements visible when the button is clicked
	$Button_WindowsOption5.Visible = $true
	$Label_WindowsSelection3.Visible = $true
	$button_back2.Visible = $true
	
	# This block makes some UI elements invisible when the button is clicked
	$Label_WindowsSelection2.Visible = $false
	$Button_WindowsOption3.Visible = $false
	$Button_WindowsOption4.Visible = $false
	$button_back1.Visible = $false
	
	# This block sets the environment variable languagechoice to "NL-nl" and writes a verbose message
	# NL-nl stands for Dutch language in Netherlands locale
	$env:languagechoice = "NL-nl"
	Write-Verbose -Message "language $env:languagechoice chosen" -Verbose
})

#This block adds a click event handler to the button named $Button_WindowsOption4
$Button_WindowsOption4.add_click({
	# This block makes some UI elements visible when the button is clicked
	$Button_WindowsOption5.Visible = $true
	$Label_WindowsSelection3.Visible = $true
	$button_back2.Visible = $true
	
	# This block makes some UI elements invisible when the button is clicked
	$Label_WindowsSelection2.Visible = $false
	$Button_WindowsOption3.Visible = $false
	$Button_WindowsOption4.Visible = $false
	$button_back1.Visible = $false
	
	# This block sets the environment variable languagechoice to "EN-gb" and writes a verbose message
	# EN-gb stands for English language in United Kingdom locale
	$env:languagechoice = "EN-gb"
	Write-Verbose -Message "language $env:languagechoice chosen" -Verbose
})

#This block adds a click event handler to the button named $Button_WindowsOption5
$Button_WindowsOption5.add_click({
	# This block closes the form named $Form_DriveSelection when the button is clicked
	$Form_DriveSelection.Close()
})

#This block adds a click event handler to the button named $button_back1
$button_back1.add_click({
	# This block makes some UI elements visible when the button is clicked
	$Button_WindowsOption1.Visible = $true
	$Button_WindowsOption2.Visible = $true
	$Label_WindowsSelection1.Visible = $true
	$BackButton_DriveSelection2.Visible = $true
	
	# This block makes some UI elements invisible when the button is clicked
	$Button_WindowsOption3.Visible = $false
	$Button_WindowsOption4.Visible = $false
	$Label_WindowsSelection2.Visible = $false
	$button_back1.Visible = $false
})

#This block adds a click event handler to the button named $button_back2
$button_back2.add_click({
	# This block makes some UI elements visible when the button is clicked
	$Button_WindowsOption3.Visible = $true
	$Button_WindowsOption4.Visible = $true
	$Label_WindowsSelection2.Visible = $true
	$button_back1.Visible = $true
	
	# This block makes some UI elements invisible when the button is clicked
	$Button_WindowsOption5.Visible = $false
	$Label_WindowsSelection3.Visible = $false
	$button_back2.Visible = $false
})

#This block adds a label named $Label_DriveSelection1 to the form named $Form_DriveSelection and makes it visible
$Form_DriveSelection.Controls.Add($Label_DriveSelection1)
$Label_DriveSelection1.Visible = $true
#This block adds a listview named $listview_drives to the form and makes it visible
$Form_DriveSelection.Controls.Add($listview_drives)
$listview_drives.Visible = $true
#This block adds a button named $button_DriveSelection1 to the form and makes it visible
$Form_DriveSelection.Controls.Add($button_DriveSelection1)
$button_DriveSelection1.Visible = $true
#This block adds a button named $button_DriveSelection2 to the form and makes it visible
$Form_DriveSelection.Controls.add($button_DriveSelection2)
$button_DriveSelection2.Visible = $true

#This block adds several UI elements to the form but makes them invisible by default
#These elements are used in other parts of the code to handle user input and display information
$Form_DriveSelection.Controls.Add($BackButton_DriveSelection1)
$Form_DriveSelection.Controls.Add($BackButton_DriveSelection2)
$Form_DriveSelection.Controls.Add($button_back1)
$Form_DriveSelection.Controls.Add($button_back2)
$Form_DriveSelection.Controls.Add($button_DriveSelection3)
$Form_DriveSelection.Controls.Add($Button_WindowsOption1)
$Form_DriveSelection.Controls.Add($Button_WindowsOption2)
$Form_DriveSelection.Controls.Add($Button_WindowsOption3)
$Form_DriveSelection.Controls.Add($Button_WindowsOption4)
$Form_DriveSelection.Controls.Add($Button_WindowsOption5)
$Form_DriveSelection.Controls.Add($Label_DriveSelection2)
$Form_DriveSelection.Controls.Add($Label_DriveSelection3)
$Form_DriveSelection.Controls.Add($Label_WindowsSelection1)
$Form_DriveSelection.Controls.Add($Label_WindowsSelection2)
$Form_DriveSelection.Controls.Add($Label_WindowsSelection3)

$BackButton_DriveSelection1.Visible = $false
$BackButton_DriveSelection2.Visible = $false
$button_back1.Visible = $false
$button_back2.Visible = $false
$button_DriveSelection3.Visible = $false
$Button_WindowsOption1.Visible = $false
$Button_WindowsOption2.Visible = $false
$Button_WindowsOption3.Visible = $false
$Button_WindowsOption4.Visible = $false
$Button_WindowsOption5.Visible = $false
$Label_DriveSelection2.Visible = $false
$Label_DriveSelection3.Visible = $false
$Label_WindowsSelection1.Visible = $false
$Label_WindowsSelection2.Visible = $false
$Label_WindowsSelection3.Visible = $false

#This block adds a shown event handler to the form named $Form_DriveSelection
$Form_DriveSelection.add_shown({
	# This block calls a function named get-drives that is defined elsewhere in the code
	# This function gets the available drives on the system and displays them in the listview
	get-drives
})

#This block shows the form as a modal dialog box and waits for user input
[void] $Form_DriveSelection.ShowDialog()

#This block creates two text files in the temp folder with the values of the environment variables windowschoice and languagechoice
#These files are used to store the user's preferences for later use
New-Item -ItemType File -Path $env:windir\temp\windowschoice.txt -Value $env:windowschoice -Force | Out-Null
New-Item -ItemType File -Path $env:windir\temp\languagechoice.txt -Value $env:languagechoice -Force | Out-Null

#This block pauses the execution for 3 seconds
Start-Sleep -Seconds 3
