function Write-Log 
{
    [CmdletBinding()]
    Param 
    (
        [Parameter(Mandatory=$true)]
        [string]$Message,
        [string]$LogFilePath = "C:\logs\log.txt"
    )

    $Timestamp = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
    $LogMessage = "[$Timestamp]: ##\\-$Message-//##"
    Add-Content -Path $LogFilePath -Value $LogMessage
}

