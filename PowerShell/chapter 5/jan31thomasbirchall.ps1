<# This gets details about disks on a system
$diskspacedata = Get-WmiObject win32_logicaldisk | 
Format-Table @{n = "Letter"; e = {$_.DeviceId}},
@{n = "Name"; e = {$_.VolumeName}}, 
@{n = "Size (GB)"; e = {[math]::Round($_.Size / 1GB, 2)}}, 
@{n = "Size (TB)"; e = {[math]::Round($_.Size / 1TB, 2)}}, 
@{n = "Free (GB)"; e = {[math]::Round($_.FreeSpace / 1GB, 2)}}, 
@{n = "Free (TB)"; e = {[math]::Round($_.FreeSpace / 1TB, 2)}},
@{n = "Free (%)"; e = {[math]::Round($_.FreeSpace / $_.Size * 100, 2)}}
#>

