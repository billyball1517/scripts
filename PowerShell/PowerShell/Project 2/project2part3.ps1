#Run all of the commands on your Hyper-V machine in the order below...

#Getting Started - Step 1 - Set a Static IP
Get-NetAdapter | Get-NetIPAddress | Remove-NetIPAddress -ErrorAction 0 | Out-Null
Get-NetAdapter | Remove-NetRoute -ErrorAction 0 | Out-Null
Get-NetAdapter | New-NetIPAddress -IPAddress '192.168.4.5' -PrefixLength '24' -DefaultGateway '192.168.4.1'
Get-NetAdapter | Set-DnsClientServerAddress -ServerAddresses ('127.0.0.1')

#Getting Started - Step 2 - Set Your Computer Name
Rename-Computer -NewName 'east-a00122208-dc1' -force

Restart-Computer

#Getting Started - Step 3 - Installing Windows Roles and Features
New-Item -Path 'C:\Logs' -ItemType Directory
Add-WindowsFeature -Name 'AD-Domain-Services' -IncludeAllSubFeature -IncludeManagementTools -LogPath 'C:\Logs\ad-domain-services.txt'
Add-WindowsFeature -Name 'DNS' -IncludeAllSubFeature -IncludeManagementTools -LogPath 'C:\Logs\dns.txt'
Add-WindowsFeature -Name 'gpmc' -IncludeAllSubFeature -IncludeManagementTools -LogPath 'C:\Logs\gpmc.txt'
Add-WindowsFeature -Name 'RSAT-AD-Tools' -LogPath 'C:\Logs\RSAT-AD-Tools.txt'

Restart-Computer

#Getting Started - Step 4 - Create a New Active Directory Forest
Import-Module ADDSDeployment

#Use the Install-ADDSForest cmdlet to complete the setup. Type your working Install-ADDSForest command line below...
Install-ADDSForest -CreateDnsDelegation: $false -DatabasePath 'C:\Windows\NTDS' -DomainMode 'Win2012' -DomainName 'a00122208.anecdote.local' -DomainNetbiosName 'a00122208' -ForestMode 'Win2012' -InstallDns -LogPath 'C:\Windows\NTDS' -SysvolPath 'C:\Windows\SYSVOL' -SafeModeAdministratorPassword (ConvertTo-SecureString -AsPlainText "Pa$$w0rd" -Force) -Force

Restart-Computer


Get-ADDomain
sconfig

option : 15

Get-ADComputer -Filter * | Format-Table - Autosize