$process = "notepad","calculator"
# Get-Process -Name $Process
Get-Process -Name $Process -ErrorAction SilentlyContinue |
Stop-Process -PassThru |
forEach-Object { $_.name + ' with Process ID: ' + $_.Id + ' was stopped.'}