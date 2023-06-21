# Define an array of loading tips
$loadingTips = @(
    "`n Loading..."
    "`n Cleanup the '%temp%' folder so now and then..."
    "`n Don't forget to keep Windows up-to-date!"
    "`n PowerShell is an scripting language..."
    "`n For any questions you can contact Michael Feenstra..."
    "`n Microsoft stands for 'microcomputers and software'..."
    "`n Microsoft used Mac to test things like Office because the OS was more flexible..."
    "`n Check your RAM speeds, it may not be performing at its maximum..."
    "`n Please don't get angry i know this is taking long..."
    "`n The iconic 'Windows' name was derived from the fact that early versions of the operating system featured graphical user interfaces with multiple 'windows' on the screen."
    "`n The default desktop wallpaper of Windows XP, known as 'Bliss,' is one of the most recognizable images in the world. It features rolling green hills and a blue sky and was photographed in Sonoma County, California."
    "`n A blue button is usually not that hard to find..."
)

# Loop through each tip in the array, display it, wait 7 seconds, and clear the console
Write-Output ""
foreach ($tip in $loadingTips) {
    Write-Output $tip
    Start-Sleep -Seconds 7
    Clear-Host
}

# Display a message indicating how long the setup has taken so far
Write-Output ""
Write-Output "`n The setup has already taken $($loadingTips.Count * 7) seconds..."

# Display an error message in case something goes wrong with the setup
Write-Output "`n If you see this message it means the setup is broken... contact Michael Feenstra..."
