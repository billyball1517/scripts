$args = "localhost"

foreach ($i in $args)
    {Write-Host "Connecting to" $i "pleas wait ...";
    Get-WmiObject -ComputerName $i -Class win32_UserAccount |
    Select-Object Name, Disabled, PasswordRequired, SID, SIDType | 
    Where-Object {$_.PasswordRequired -eq 0} |
    Sort-Object -property name | Write-Host}
