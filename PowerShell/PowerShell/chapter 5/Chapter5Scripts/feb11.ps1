<#
Start-Job -ScriptBlock {Get-Process}

Get-Job -Name Job1

Receive-Job -Name Job1

$JobResult = Receive-Job -Name Job2
$JobResult
#>

<#
$ImportantScriptBlock = {Get-ChildItem C:/}

$ImportantJob = Start-Job -Name "ImportantJob" -ScriptBlock $ImportantScriptBlock

Write-Host "`n Example of Get-Job Command:" -ForegroundColor Green
#Get-Job -Name "ImportantJob"

Write-Host "`n Contents of the `$ImportantJob variable:" -ForegroundColor Blue
$ImportantJob.State

Write-Host "`n Contents of the  `$ImportantResult Variable:" -ForegroundColor 

#>

