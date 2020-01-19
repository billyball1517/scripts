<#
.SYNOPSIS
Waiting for a Job to Complete
.DESCRIPTION
An example of how to start a background job that takes a while and then wait for it to complete.
.NOTES  
File Name  : WaitingforaJobToComplete.ps1
Author     : Nathan Abourbih - nathan@abourbih.com 
#>

#Step 1: Create a script block to run.
$NewJob1 = {
    Start-Sleep -s 10 #We use this command to simulate a command that takes a while to run. Wait for 10 seconds.
    Get-ChildItem C:\
}

$NewJob2 = {
    Start-Sleep -s 5
    Get-Process -Name notepad
}

#Step 2: Start the job and store it in a variable.
$LongJob1 = Start-Job -Name "LongJob1" -ScriptBlock $NewJob1  #Store the script block in a variable instead of writing it in-line.
$LongJob2 = Start-Job -Name "LongJob2" -ScriptBlock $NewJob2

#Step 3: Run a loop every second and check if the job is complete.
do {
    Write-Host "`n [$(Get-Date -Format 'hh:mm:ss tt')] Long Job 1 State is... $($LongJob1.State)" -ForegroundColor Blue
    Write-Host "`n [$(Get-Date -Format 'hh:mm:ss tt')] Long Job 2 State is... $($LongJob2.State)" -ForegroundColor Cyan
    Start-Sleep -s 1

} while (($LongJob1.State -ne "Completed") -And ($LongJob1.State -ne "Completed") )

Write-Host "`n The Long Jobs are completed!" -ForegroundColor Green

#Step 4: Capture the result of the job to a new variable.
$LongJob1Result = Receive-Job -Name "LongJob1"
$LongJob2Result = Receive-Job -Name "LongJob2"

Write-Host "`n Press enter to see the results of the Long Jobs.`n " -ForegroundColor Yellow
pause
$LongJob1Result
$LongJob2Result