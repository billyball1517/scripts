#Create an Active Directory User
New-ADUser -Name "A00122208" -GivenName "Thomas" -Surname "Birchall" -DisplayName "Thomas Birchall" -PasswordNeverExpires $true -AccountPassword (ConvertTo-SecureString -AsPlainText "Pa$$w0rd" -Force) -Enabled $true

#Create an Active Directory OU
New-ADOrganizationalUnit -Name "MentalHealth" -Path "DC=anecdote,DC=local"

#Add Your User to Your OU
Move-ADObject -Identity "CN=A00122208,CN=Users,DC=anecdote,DC=local" -TargetPath "OU=MentalHealth,DC=anecdote,DC=local"

#Create a Share
mkdir "d:\Shares\Users\A00122208"
New-SmbShare -Name "A00122208" -Path "d:\Shares\Users\A00122208" -FullAccess "A00122208"

#Set the NTFS permissions
$acl = Get-Acl "d:\Shares\Users\A00122208";$AccessRule = New-Object System.Security.AccessControl.FileSystemAccessRule("anecdote\A00122208","FullControl","Allow");$acl.SetAccessRule($AccessRule);$acl | Set-Acl "d:\Shares\Users\A00122208"

#Set Your Home Directory (With Bonus)
set-aduser "A00122208" -HomeDrive "H:" -homedirectory "\\$env:COMPUTERNAME\A00122208"

Get-ADUser -Identity "A00122208"
Get-ADOrganizationalUnit  -LDAPFilter "(name=MentalHealth)"
(Get-Acl d:\Shares\Users\A00122208).Access