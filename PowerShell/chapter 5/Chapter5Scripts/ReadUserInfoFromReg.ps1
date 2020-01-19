$strUserPath ="\Software\Microsoft\Windows\CurrentVersion\" `
            + "Explorer"
$strUserName = "Logon User Name"
$strPath = "\Volatile Environment"
$strName = "LOGONSERVER","HOMEPATH","APPDATA","HOMEDRIVE"

Set-Location HKCU:\
    Get-ItemProperty -Path $strUserPath -Name $strUserName |
    Format-List $strUserName
foreach ($i in $strName)
    {Get-ItemProperty -Path $strPath -Name $i |
    Format-List $i}