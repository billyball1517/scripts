$args = "localhost","loopback"

foreach ($i in $args)
    {Write-Host "Testing" $i "..."
    Get-WmiObject -ComputerName $args -Class win32_service |
    Select-Object -property name, state, startmode, startname | 
    Sort-Object -Property startmode, state, name |
    Format-Table *}