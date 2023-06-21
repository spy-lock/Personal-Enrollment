# Load the System.Windows.Forms assembly to use Windows Forms
[void] [System.Reflection.Assembly]::LoadWithPartialName("System.windows.forms")

Clear-Host

# Define a function to save the computer name and other settings
Function save-computername
{
    # Get the computer name from the text box
    $computername = $TextBox_RCTZKB

    # Rename the computer with the given name and force the change
    Rename-Computer $computername.Text -Force -Verbose -ErrorAction SilentlyContinue
    
    # Set the time zone to W. Europe Standard Time
    Set-TimeZone -Id "W. Europe Standard Time" -Verbose

    # Set the user language list to nl-NL and force the change
    Set-WinUserLanguageList -LanguageList nl-NL -force -Verbose

    # Create a new file with the name RC-TZ-KB.txt and write 1 to it
    New-Item $env:windir\temp\RC-TZ-KB.txt -Value {1} -Force
}

# Define a function to save the choice of running Dism and SFC as yes
Function save-choiceYes
{
    # Create a new file with the name DismAndSFC.txt and write 1 to it
    New-Item -Path $env:windir\temp\DismAndSFC.txt -Value 1 -ErrorAction SilentlyContinue -Force
}

# Define a function to save the choice of running Dism and SFC as no
Function save-choiceNo
{
    # Create a new file with the name DismAndSFC.txt and write 0 to it
    New-Item -Path $env:windir\temp\DismAndSFC.txt -Value 0 -ErrorAction SilentlyContinue -Force
}


# Create a new Windows Form object with some properties
$Form_head                                                = [System.Windows.Forms.Form]::new()
    $Form_head.Text                                       = "PowerShell Enrollment" # Set the title of the form
    $Form_head.Size                                       = [System.Drawing.Size]::new(450,350) # Set the size of the form
    $Form_head.FormBorderStyle                            = "FixedDialog" # Set the border style of the form
    $Form_head.Top                                        = $true # Set the top property of the form
    $Form_head.MaximizeBox                                = $true # Set the maximize button property of the form
    $Form_head.MinimizeBox                                = $true # Set the minimize button property of the form
    $Form_head.ControlBox                                 = $true # Set the control box property of the form
    $Form_head.StartPosition                              = "CenterScreen" # Set the start position of the form
    $Form_head.Font                                       = "Segoe UI" # Set the font of the form



# Create a new TextBox object with some properties
$TextBox_RCTZKB                                           = [System.Windows.Forms.TextBox]::new()
    $TextBox_RCTZKB.Location                              = [System.Drawing.Point]::new(10,50) # Set the location of the text box
    $TextBox_RCTZKB.Size                                  = [System.Drawing.Size]::new(223,150) # Set the size of the text box



# Create a new Label object for connection type with some properties
$Label_Connection1                                        = [System.Windows.Forms.Label]::new()
    $Label_Connection1.Location                           = [System.Drawing.Point]::new(8,8) # Set the location of the label
    $Label_Connection1.Size                               = [System.Drawing.Size]::new(240,32)  # Set the size of the label
    $Label_Connection1.Text                               = "Select a Connection type:" # Set the text of the label
    $Label_Connection1.TextAlign                          = "MiddleLeft" # Set the text alignment of the label

# Create a new Label object for connection status with some properties
$Label_Connection2                                        = [System.Windows.Forms.Label]::new()
    $Label_Connection2.Location                           = [System.Drawing.Point]::new(8,8) # Set the location of the label
    $Label_Connection2.Size                               = [System.Drawing.Size]::new(280,32)  # Set the size of the label
    $Label_Connection2.Text                               = "Select continue when you have a internet connection." # Set the text of the label
    $Label_Connection2.TextAlign                          = "MiddleLeft" # Set the text alignment of the label

# Create a new Label object for network connection with some properties
$Label_Connection3                                        = [System.Windows.Forms.Label]::new()
    $Label_Connection3.Location                           = [System.Drawing.Point]::new(8,8) # Set the location of the label
    $Label_Connection3.Size                               = [System.Drawing.Size]::new(240,32)   # Set the size of the label
    $Label_Connection3.Text                               = "Please connect to a network and continue:" # Set the text of the label
    $Label_Connection3.TextAlign                          = "MiddleLeft" # Set the text alignment of the label

# Create a new Label object for LAN driver installation with some properties
$Label_Connection4                                        = [System.Windows.Forms.Label]::new()
    $Label_Connection4.Location                           = [System.Drawing.Point]::new(8,8) # Set the location of the label
    $Label_Connection4.Size                               = [System.Drawing.Size]::new(240,32)  # Set the size of the label
    $Label_Connection4.Text                               = "Install LAN driver and continue:" # Set the text of the label
    $Label_Connection4.TextAlign                          = "MiddleLeft" # Set the text alignment of the label



# Create a new Label object for computer name with some properties
$Label_RCTZKB1                                            = [System.Windows.Forms.Label]::new()
    $Label_RCTZKB1.Location                               = [System.Drawing.Point]::new(8,8) # Set the location of the label
    $Label_RCTZKB1.Size                                   = [System.Drawing.Size]::new(240,32)  # Set the size of the label
    $Label_RCTZKB1.Text                                   = "Enter new computername here:" # Set the text of the label
    $Label_RCTZKB1.TextAlign                              = "MiddleLeft" # Set the text


# Create a new Label object for Dism and SFC option with some properties
$Label_DismAndSFC                                         = [System.Windows.Forms.Label]::new()
    $Label_DismAndSFC.Location                            = [System.Drawing.Point]::new(8,8) # Set the location of the label
    $Label_DismAndSFC.Size                                = [System.Drawing.Size]::new(240,32)  # Set the size of the label
    $Label_DismAndSFC.Text                                = "Run Dism and SFC at the end?" # Set the text of the label
    $Label_DismAndSFC.TextAlign                           = "MiddleLeft" # Set the text alignment of the label





# Create a new Button object for WLAN connection with some properties
$Button_Connection2                                       = [System.Windows.Forms.Button]::new()
    $Button_Connection2.Location                          = [System.Drawing.Point]::new(100,90) # Set the location of the button
    $Button_Connection2.Size                              = [System.Drawing.Size]::new(240,32) # Set the size of the button
    $Button_Connection2.Anchor                            = [System.Windows.Forms.AnchorStyles]::Top # Set the anchor property of the button
    $Button_Connection2.TextAlign                         = "MiddleCenter" # Set the text alignment of the button
    $Button_Connection2.Text                              = "WLAN" # Set the text of the button

# Create a new Button object for LAN connection with some properties
$Button_Connection3                                       = [System.Windows.Forms.Button]::new()
    $Button_Connection3.Location                          = [System.Drawing.Point]::new(100,130) # Set the location of the button
    $Button_Connection3.Size                              = [System.Drawing.Size]::new(240,32) # Set the size of the button
    $Button_Connection3.Anchor                            = [System.Windows.Forms.AnchorStyles]::Top # Set the anchor property of the button
    $Button_Connection3.TextAlign                         = "MiddleCenter" # Set the text alignment of the button
    $Button_Connection3.Text                              = "LAN" # Set the text of the button

# Create a new Button object for continue with some properties
$Button_Connection4                                       = [System.Windows.Forms.Button]::new()
    $Button_Connection4.Location                          = [System.Drawing.Point]::new(300,270) # Set the location of the button
    $Button_Connection4.Size                              = [System.Drawing.Size]::new(120,32) # Set the size of the button
    $Button_Connection4.Anchor                            = [System.Windows.Forms.AnchorStyles]::Bottom -bor
                                                            [System.Windows.Forms.AnchorStyles]::Right # Set the anchor property of the button
    $Button_Connection4.TextAlign                         = "MiddleCenter" # Set the text alignment of the button
    $Button_Connection4.Text                              = "Continue" # Set the text of the button

# Create a new Button object for skip with some properties
$Button_Connection5                                       = [System.Windows.Forms.Button]::new()
    $Button_Connection5.Location                          = [System.Drawing.Point]::new(300,270) # Set the location of the button
    $Button_Connection5.Size                              = [System.Drawing.Size]::new(120,32) # Set the size of the button
    $Button_Connection5.Anchor                            = [System.Windows.Forms.AnchorStyles]::Bottom -bor
                                                            [System.Windows.Forms.AnchorStyles]::Right # Set the anchor property of the button
    $Button_Connection5.TextAlign                         = "MiddleCenter" # Set the text alignment of the button
    $Button_Connection5.Text                              = "Skip" # Set the text of the button


# Create a new Button object for back with some properties
$Backbutton_Connection1                                   = [System.Windows.Forms.Button]::new()
    $Backbutton_Connection1.Location                      = [System.Drawing.Point]::new(20,270) # Set the location of the button
    $Backbutton_Connection1.Size                          = [System.Drawing.Size]::new(120,32) # Set the size of the button
    $Backbutton_Connection1.Anchor                        = [System.Windows.Forms.AnchorStyles]::Bottom -bor
                                                            [System.Windows.Forms.AnchorStyles]::Left # Set the anchor property of the button
    $Backbutton_Connection1.TextAlign                     = "MiddleCenter" # Set the text alignment of the button
    $Backbutton_Connection1.Text                          = "Back" # Set the text of the button

# Create a new Button object for back with some properties
$Backbutton_Connection2                                   = [System.Windows.Forms.Button]::new()
    $Backbutton_Connection2.Location                      = [System.Drawing.Point]::new(20,270) # Set the location of the button
    $Backbutton_Connection2.Size                          = [System.Drawing.Size]::new(120,32) # Set the size of the button
    $Backbutton_Connection2.Anchor                        = [System.Windows.Forms.AnchorStyles]::Bottom -bor
                                                            [System.Windows.Forms.AnchorStyles]::Left # Set the anchor property of the button
    $Backbutton_Connection2.TextAlign                     = "MiddleCenter" # Set the text alignment of the button
    $Backbutton_Connection2.Text                          = "Back" # Set the text of the button



# Create a new Button object for OK with some properties
$button_RCTZKB1                                           = [System.Windows.Forms.Button]::new()
    $button_RCTZKB1.Location                              = [System.Drawing.Point]::new(300,270) # Set the location of the button
    $button_RCTZKB1.Size                                  = [System.Drawing.Size]::new(120,32) # Set the size of the button
    $button_RCTZKB1.Anchor                                = [System.Windows.Forms.AnchorStyles]::Bottom -bor
                                                            [System.Windows.Forms.AnchorStyles]::Right # Set the anchor property of the button
    $button_RCTZKB1.Text                                  = "OK" # Set the text of the button

# Create a new Button object for back with some properties
$Backbutton_RCTZKB1                                       = [System.Windows.Forms.Button]::new()
    $Backbutton_RCTZKB1.Location                          = [System.Drawing.Point]::new(20,270) # Set the location of the button
    $Backbutton_RCTZKB1.Size                              = [System.Drawing.Size]::new(120,32) # Set the size of the button
    $Backbutton_RCTZKB1.Anchor                            = [System.Windows.Forms.AnchorStyles]::Bottom -bor
                                                            [System.Windows.Forms.AnchorStyles]::Left # Set the anchor property of the button
    $Backbutton_RCTZKB1.TextAlign                         = "MiddleCenter" # Set the text alignment of the button
    $Backbutton_RCTZKB1.Text                              = "Back" # Set the text of the button


# Create a new Button object for Dism and SFC yes option with some properties
$Button_DismAndSFC1                                       = [System.Windows.Forms.Button]::new()
    $Button_DismAndSFC1.Location                          = [System.Drawing.Point]::new(100,90) # Set the location of the button
    $Button_DismAndSFC1.Size                              = [System.Drawing.Size]::new(240,32) # Set the size of the button
    $Button_DismAndSFC1.Anchor                            = [System.Windows.Forms.AnchorStyles]::Top # Set the anchor property of the button
    $Button_DismAndSFC1.TextAlign                         = "MiddleCenter" # Set the text alignment of the button
    $Button_DismAndSFC1.Text                              = "Yes" # Set the text of the button

# Create a new Button object for Dism and SFC no option with some properties
$Button_DismAndSFC2                                       = [System.Windows.Forms.Button]::new()
    $Button_DismAndSFC2.Location                          = [System.Drawing.Point]::new(100,130) # Set the location of the button
    $Button_DismAndSFC2.Size                              = [System.Drawing.Size]::new(240,32) # Set the size of the button
    $Button_DismAndSFC2.Anchor                            = [System.Windows.Forms.AnchorStyles]::Top # Set the anchor property of the button
    $Button_DismAndSFC2.TextAlign                         = "MiddleCenter" # Set the text alignment of the button
    $Button_DismAndSFC2.Text                              = "No" # Set the text of the button

# Create a new Button object for back with some properties
$Backbutton_DISM1                                         = [System.Windows.Forms.Button]::new()
    $Backbutton_DISM1.Location                            = [System.Drawing.Point]::new(20,270) # Set the location of the button
    $Backbutton_DISM1.Size                                = [System.Drawing.Size]::new(120,32) # Set the size of the button
    $Backbutton_DISM1.Anchor                              = [System.Windows.Forms.AnchorStyles]::Bottom -bor
                                                            [System.Windows.Forms.AnchorStyles]::Left # Set the anchor property of the button
    $Backbutton_DISM1.Text                                = "Back" # Set the text of the button



# Add a click event handler for the WLAN connection button
$Button_Connection2.add_click({

    # Make some controls visible
    $Label_Connection3.Visible = $true
    $Backbutton_Connection1.Visible = $true
    $Button_Connection4.Visible = $true

    # Make some controls invisible
    $Button_Connection2.Visible = $false
    $Button_Connection3.Visible = $false
    $Button_Connection5.Visible = $false
    $Label_Connection1.Visible = $false

    # Start the wifi settings applet
    Start-Process ms-settings:network-wifi
})

# Add a click event handler for the LAN connection button
$Button_Connection3.add_click({

    # Make some controls visible
    $Label_Connection4.Visible = $true
    $Backbutton_Connection1.Visible = $true
    $Button_Connection4.Visible = $true

    # Make some controls invisible
    $Button_Connection2.Visible = $false
    $Button_Connection3.Visible = $false
    $Button_Connection5.Visible = $false
    $Label_Connection1.Visible = $false

    # Start the drivers folder in explorer
    Start-Process C:/files/drivers
})

# Add a click event handler for the button named Button_Connection4
$Button_Connection4.add_click({

    # Create a new file named Connection.txt in the temp folder with the value 1 and overwrite any existing file
    New-Item $env:windir\temp\Connection.txt -Value {1} -Force

    # Make the label, textbox and buttons named Label_RCTZKB1, TextBox_RCTZKB, button_RCTZKB1 and Backbutton_Connection2 visible
    $Label_RCTZKB1.Visible = $true
    $TextBox_RCTZKB.Visible = $true
    $button_RCTZKB1.Visible = $true
    $Backbutton_Connection2.Visible = $true

    # Make the labels and buttons named Label_Connection2, Label_Connection3, Label_Connection4, Backbutton_Connection1 and Button_Connection4 invisible
    $Label_Connection2.Visible = $false
    $Label_Connection3.Visible = $false
    $Label_Connection4.Visible = $false
    $Backbutton_Connection1.Visible = $false
    $Button_Connection4.Visible = $false

})

# Add a click event handler for the button named Button_Connection5
$Button_Connection5.add_click({

    # Create a new file named Connection.txt in the temp folder with the value 1 and overwrite any existing file
    New-Item $env:windir\temp\Connection.txt -Value {1} -Force

    # Make the label, textbox and buttons named Label_RCTZKB1, TextBox_RCTZKB, button_RCTZKB1 and Backbutton_Connection2 visible
    $Label_RCTZKB1.Visible = $true
    $TextBox_RCTZKB.Visible = $true
    $button_RCTZKB1.Visible = $true
    $Backbutton_Connection2.Visible = $true

    # Make the buttons named button_Connection1, button_Connection2, button_Connection3 and button_Connection5 invisible
    # Make the label named Label_Connection1 invisible
    $button_Connection2.Visible = $false
    $button_Connection3.Visible = $false
    $button_Connection5.Visible = $false
    $Button_Connection4.Visible = $false
    $Label_Connection1.Visible = $false

})

# Add a click event handler for the back button named Backbutton_Connection1
$Backbutton_Connection1.add_click({

    # Make the buttons named Button_Connection1, Button_Connection2, Button_Connection3 and button_Connection5 visible
    # Make the label named Label_Connection1 visible
    $Button_Connection2.Visible = $true
    $Button_Connection3.Visible = $true
    $button_Connection5.Visible = $true
    $Label_Connection1.Visible = $true

    # Make the labels and buttons named Label_Connection2, Label_Connection3, Label_Connection4, Backbutton_Connection1 and Button_Connection4 invisible
    $Label_Connection2.Visible = $false
    $Label_Connection3.Visible = $false
    $Label_Connection4.Visible = $false
    $Backbutton_Connection1.Visible = $false
    $Button_Connection4.Visible = $false
})

# Add a click event handler for the back button named Backbutton_Connection2
$Backbutton_Connection2.add_click({

    # Make the label and buttons named Label_Connection1, Button_Connection1, Button_Connection2, Button_Connection3 and Button_Connection5 visible
    $Label_Connection1.Visible = $true
    $Button_Connection2.Visible = $true
    $Button_Connection3.Visible = $true
    $Button_Connection5.Visible = $true

    # Make the label, textbox and button named Label_RCTZKB1, TextBox_RCTZKB and button_RCTZKB1 invisible
    # Make the back button named Backbutton_Connection2 invisible
    $Label_RCTZKB1.Visible = $false
    $TextBox_RCTZKB.Visible = $false
    $button_RCTZKB1.Visible = $false
    $Backbutton_Connection2.Visible = $false

})

# Add a click event handler for the button named button_RCTZKB1
$button_RCTZKB1.add_click({

    # Save the computer name to a file 
    save-computername

    # Make the label and buttons named Label_Company1, button_Company1, button_Company2 and button_Company4 visible
    # Make the back button named Backbutton_RCTZKB1 visible
    $Backbutton_RCTZKB1.Visible = $true
    $Button_DismAndSFC1.Visible = $true
    $Button_DismAndSFC2.Visible = $true
    $Label_DismAndSFC.Visible = $true

    # Make the back button named Backbutton_Connection2 invisible
    # Make the textbox and label named TextBox_RCTZKB and Label_RCTZKB1 invisible
    # Make the button named button_RCTZKB1 invisible
    $Backbutton_Connection2.Visible = $false
    $TextBox_RCTZKB.Visible = $false
    $Label_RCTZKB1.Visible = $false
    $button_RCTZKB1.Visible = $false

})

# Add a click event handler for the back button named Backbutton_RCTZKB1
$Backbutton_RCTZKB1.add_click({

    # Make the back button named Backbutton_Connection2 visible
    # Make the textbox and label named TextBox_RCTZKB and Label_RCTZKB1 visible
    # Make the button named button_RCTZKB1 visible
    $Backbutton_Connection2.Visible = $true
    $TextBox_RCTZKB.Visible = $true
    $Label_RCTZKB1.Visible = $true
    $button_RCTZKB1.Visible = $true

    # Make the label and buttons named Label_Company1, button_Company1, button_Company2 and button_Company4 invisible
    # Make the back button named Backbutton_RCTZKB1 invisible
    $Backbutton_RCTZKB1.Visible = $false
    $Button_DismAndSFC1.Visible = $false
    $Button_DismAndSFC2.Visible = $false
    $Label_DismAndSFC.Visible = $false


})

# Event handler for Button_DismAndSFC1 click event
$Button_DismAndSFC1.add_click({

    # Call save-choiceYes function and close the form
    save-choiceYes 
    $Form_head.Close()

})

# Event handler for Button_DismAndSFC2 click event
$Button_DismAndSFC2.add_click({

    # Call save-choiceNo function and close the form
    save-choiceNo    
    $Form_head.close()

})

# Event handler for Backbutton_DISM1 click event
$Backbutton_DISM1.add_click({

    # Show Company1 label and buttons, and hide current label and buttons
    $Backbutton_RCTZKB1.Visible = $true

    $Label_DismAndSFC.Visible = $false
    $Button_DismAndSFC1.Visible = $false
    $Button_DismAndSFC2.Visible = $false
    $Backbutton_DISM1.Visible = $false
})

# This event handler is triggered when the "No" button is clicked on the DismAndSFC form
$Button_DismAndSFC2.add_click({
    
    # Call the function "save-choiceNo" to save the user's choice
    save-choiceNo
    
    # Close the DismAndSFC form
    $Form_head.close()
})

# This event handler is triggered when the "Back" button is clicked on the DISM form
$Backbutton_DISM1.add_click({
    
    # Show the necessary controls on the Company form
    $Backbutton_RCTZKB1.Visible = $true

    # Hide the unnecessary controls on the DISM form
    $Label_DismAndSFC.Visible = $false
    $Button_DismAndSFC1.Visible = $false
    $Button_DismAndSFC2.Visible = $false
    $Backbutton_DISM1.Visible = $false
})


# Add Connection1 label to Form_head controls and set it to visible
$Form_head.Controls.Add($Label_Connection1)
$Label_Connection1.Visible = $true

# Add Connection2 button to Form_head controls and set it to visible
$Form_head.Controls.Add($Button_Connection2)
$Button_Connection2.Visible = $true

# Add Connection3 button to Form_head controls and set it to visible
$Form_head.Controls.Add($Button_Connection3)
$Button_Connection3.Visible = $true

# Add Connection5 button to Form_head controls and set it to visible
$Form_head.Controls.Add($Button_Connection5)
$Button_Connection5.Visible = $true

# Add Connection1 Back button to Form_head controls and set it to invisible
$Form_head.Controls.Add($Backbutton_Connection1)
$Backbutton_Connection1.Visible = $false

# Add Connection2 Back button to Form_head controls and set it to invisible
$Form_head.Controls.Add($Backbutton_Connection2)
$Backbutton_Connection2.Visible = $false

# Add DISM1 Back button to Form_head controls and set it to invisible
$Form_head.Controls.Add($Backbutton_DISM1)
$Backbutton_DISM1.Visible = $false

# Add RCTZKB1 Back button to Form_head controls and set it to invisible
$Form_head.Controls.Add($Backbutton_RCTZKB1)
$Backbutton_RCTZKB1.Visible = $false
# Add Connection4 button to Form_head controls and set it to invisible
$Form_head.Controls.Add($Button_Connection4)
$Button_Connection4.Visible = $false

# Add DismAndSFC1 button to Form_head controls and set it to invisible
$Form_head.Controls.Add($Button_DismAndSFC1)
$Button_DismAndSFC1.Visible = $false
              
# Add a button control to the form and hide it
$Form_head.Controls.Add($Button_DismAndSFC2)
$Button_DismAndSFC2.Visible = $false
              
# Add another button control to the form and hide it
$Form_head.Controls.Add($button_RCTZKB1)
$button_RCTZKB1.Visible = $false                  
                 
# Add another label control to the form and hide it
$Form_head.Controls.Add($Label_Connection2)  
$Label_Connection2.Visible = $false
             
# Add another label control to the form and hide it
$Form_head.Controls.Add($Label_Connection3)  
$Label_Connection3.Visible = $false
             
# Add another label control to the form and hide it
$Form_head.Controls.Add($Label_Connection4)  
$Label_Connection4.Visible = $false
             
# Add a label control to the form and hide it
$Form_head.Controls.Add($Label_DismAndSFC)
$Label_DismAndSFC.Visible = $false
                
# Add a label control to the form and hide it
$Form_head.Controls.Add($Label_RCTZKB1)
$Label_RCTZKB1.Visible = $false                   

# Add a text box control to the form and hide it
$Form_head.Controls.Add($TextBox_RCTZKB)    
$TextBox_RCTZKB.Visible = $false              

# Show the form as a dialog box
[void] $Form_head.ShowDialog()

# Create a new file at the specified path with a value of "1" and hide any errors that occur
New-Item $env:windir\temp\head.txt -Value {1} -Force -ErrorAction SilentlyContinue | Out-Null
