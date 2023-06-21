Function New-WinImageDrive {
    Write-Output ""
    Write-Output "`n searching for script..."
    Write-Output ""

    Get-ChildItem -Path C:\Users -Force -Recurse | Where-Object -Property Name -like create-drive-form.ps1 | Select-Object -Property FullName -OutVariable createlocation | out-null
    $count = 0
    foreach ($location in $createlocation)
    {
        $count++

        $name = "option" + "$count"

        New-Variable -Name $name -Value $location -Force -ErrorAction SilentlyContinue
    } 

    Get-Variable -Exclude options | Where-Object -Property Name -like option* -OutVariable numberoption | Out-Null
    $coun = 0
    foreach ($opt in $numberoption)
    {
        $coun++
        $name = $opt.Value.fullname
        Write-Output "$coun - $name"
    }
    Write-Output ""
    $chosennumber = Read-Host -Prompt "please select the right script to run"

    Get-Variable | Where-Object -Property Name -like option$chosennumber -OutVariable chosenscript
    $chosenscript.Value

    $fullchosenscript = $chosenscript.Value.FullName.Replace("\create-drive-form.ps1", "")
    Set-Location $fullchosenscript
    .\create-drive-form.ps1
}