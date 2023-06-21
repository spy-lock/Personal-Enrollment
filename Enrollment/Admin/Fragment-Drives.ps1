$driveletter = Get-Partition | select -Property DriveLetter

Foreach ($D in $driveletter) {
Optimize-Volume -DriveLetter  $d.DriveLetter -Analyze -Verbose -Defrag
}