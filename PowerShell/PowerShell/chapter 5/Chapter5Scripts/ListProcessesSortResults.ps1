$computers = "localhost","loopback","127.0.0.1"

foreach ($computer in $computers)
{
	$newfile = "~\desktop\"+ $computer +"_Processes.txt"
	Write-Host "The processes are being checked on computer" $computer "please wait ...";
	Get-WmiObject -computername $computer -class win32_process |
	Select-Object name, processID, Priority, ThreadCount, PageFaults, PageFileUsage | 
	Where-Object {!$_.processID -eq 0} | Sort-Object -property name | 
	Format-Table | Out-File $newfile
}