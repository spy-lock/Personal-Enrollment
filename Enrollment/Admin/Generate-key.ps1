    $licenseKeys = @(
    )

DO {
$excludedLetters = 'z', 'a', 'l', 'e', 'u', 'i', 'o'
$characters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789'
$random = New-Object System.Random
$keys = @()

for ($i = 0; $i -lt 5; $i++) {
    $key = ""
    for ($j = 0; $j -lt 5; $j++) {
        do {
            $char = $characters[$random.Next(0, $characters.Length)]
        } until (-not $excludedLetters.Contains($char))
        $key += $char
    }
    $keys += $key
}

$finalKey = $keys -join '-'
Write-Host $finalKey

$licenseKeys += $finalKey

}
UNTIL($JNIFS -eq 1)

# Iterate through each license key
foreach ($key in $licenseKeys) {
    # Activate the license key using slmgr.vbs
    $output = & cscript.exe //Nologo //B "%windir%\system32\slmgr.vbs" /ipk $key

    # Check the output for success or failure
    if ($output -like "*successfully*") {
        Write-Host "License key '$key' activated successfully."
        $succevolKey += $key
    } else {
        Write-Host "Failed to activate license key '$key'."
    }
}