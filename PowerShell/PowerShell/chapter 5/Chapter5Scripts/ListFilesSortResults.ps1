$folders = "c:\","C:\Users","~\desktop"

foreach ($folder in $folders)
{
	$newfile = "~\desktop\"+ ($folder -replace ":", "" -replace "\\", "") +"_Folders.txt"
	Write-Host "The folder contents are being checked inside the folder" $folder "please wait ...";
    
    Get-ChildItem $folder | Select-Object name | Sort-Object -property name | Format-Table | Out-File $newfile
}