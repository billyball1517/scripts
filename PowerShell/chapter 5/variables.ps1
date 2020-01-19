#This is a comment
<#
$Count = 0
while ($Count -lt 5)
{
    Write-Host "`$Count equals $Count"
    $Count++
}
#>

<#
$Count = 0
do {
    Write-Host "`$Count equals $Count"
    $Count++
} while ($Count -lt 5)
#>

<#
$Count = 0
$ListLines = Get-Content -Path ~\desktop\testing.txt
while ($Count -lt $ListLines.Length)
{
    Write-Host $ListLines[$Count]
    $Count++
}
#>

<#
Clear-Host
$Password = "cety"
$QuitNow = "Not Yet"

do {
    $guess  = Read-Host"`n Guess The Password"

    if($guess -eq $Password)
    {
        Write-Host "Correct!"
    }
    else {
        Read-Host "Wrong! Do you wnat ot try again? (y/n)"
    }
} until ($QuitNow -eq "n")
#>

<#
Get-WmiObject  Win32_LogicalDisk

ForEach-Object {
    Write-Host "$($_.DeviceID) Has $($_.FreeSpace / 1073741824)GB Free"
}
#>

$disks = Get-WmiObject  Win32_LogicalDisk
$currentdisk = 0
while ($currentdisk -lt $disks.Length) {
    $freespacegb = $([math]::Round($disks[$currentdisk].FreeSpace / 1073741824))
   
    Write-Host "$($disks[$currentdisk].deviceid) Has $freespacegb GB Free"
    
    if ($freespacegb -gt 5000) {
        Write-Host "Wow, that is a lot!"
        break; #just exit also works
    }
    
    $currentdisk++;
}
Write-Host "All done!!"