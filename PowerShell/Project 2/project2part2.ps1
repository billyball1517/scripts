#Project 2 - Part 2

#Question 1
#Use the New-ADGroup command to add a group inside your department OU for staff workstations.
New-ADGroup -Name "MENT_StaffWorkstations" -SamAccountName MENT_StaffWorkstations -GroupCategory Security -GroupScope Global -DisplayName "MENT_StaffWorkstations" -Path "OU=MentalHealth,DC=anecdote,DC=local" -Description "Members of this group are Mental Health Staff Workstations"

#Question 2
#Use the New-ADComputer command to add a staff computer. 
#This computer will be used by staff.
#Add the computer you created to the department OU you created in Project 2 - Part 1.
#Be sure to communicate with the rest of your team members to coordinate naming conventions.
#Note: Create the computer and add it to the OU in one step.
New-ADComputer -Name "MENT_StaffComp1" -SamAccountName "MENT_StaffComp1" -Path "OU=MentalHealth,DC=anecdote,DC=local"

#Question 3
#Use the Set-ADComputer to set the following properties on your staff computer:
#1. Description - Type a one sentence description for your computer.
#2. Operating System - Choose the operating system your computer will use.
#3. Enabled: True
#4. Location - Set the location of your computer.
#Note: For the properties above, make up values but be creative and choose something professional and amusing. No profanity please.
Set-ADComputer -Identity "MENT_StaffComp1"  -DisplayName "MENT_StaffComp1" -Description "Mental Health Staff Computer 1" -OperatingSystem "TempleOS 5.03" -Enabled $true -Location "Mental Health Staff Office"

#Question 4
#Use the Add-AdGroupMember command to add your staff computer to the Staff Workstations group that is inside your department OU.
Add-ADGroupMember -Identity "MENT_StaffWorkstations" -Members "CN=MENT_StaffComp1,OU=MentalHealth,DC=anecdote,DC=local"

#Question 5
#Use the New-ADGroup command to add a group inside your department OU for lab equipment.
New-ADGroup -Name "MENT_LabEquipment" -SamAccountName MENT_LabEquipment -GroupCategory Security -GroupScope Global -DisplayName "MENT_LabEquipment" -Path "OU=MentalHealth,DC=anecdote,DC=local" -Description "Members of this group are Mental Health Lab Equipment"

#Question 6
#Use the New-ADComputer command to add a lab computer. 
#This computer will be connected to lab analysis equipment. 
#Add the computer you created to the department OU you created in Project 2 - Part 1. 
#Be sure to communicate with the rest of your team members to coordinate naming conventions.
#Note: Create the computer and add it to the OU in one step.
New-ADComputer -Name "MENT_LabComp1" -SamAccountName "MENT_LabComp1" -Path "OU=MentalHealth,DC=anecdote,DC=local"

#Question 7
#Use the Set-ADComputer to set the following properties on your lab computer:
#1. Description - Type a one sentence description for your computer.
#2. Operating System - Choose the operating system your computer will use.
#3. Enabled: True
#4. Location - Set the location of your computer.
Set-ADComputer -Identity "MENT_LabComp1"  -DisplayName "MENT_LabComp1" -Description "Mental Health Lab Computer 1" -OperatingSystem "TempleOS 5.03" -Enabled $true -Location "Mental Health Lab Office"

#Question 8
#Use the Add-AdGroupMember command to add your lab computer to the Lab Equipment group that is inside your department OU.
Add-ADGroupMember -Identity "MENT_LabEquipment" -Members "CN=MENT_LabComp1,OU=MentalHealth,DC=anecdote,DC=local"

#Question 9
#Grant your account Domain Admin permissions for anecdote.local and try logging into Putty with your new account.
Add-ADGroupMember -Identity "Domain Admins" -Members "CN=A00122208,OU=MentalHealth,DC=anecdote,DC=local"

#Question 10
#Use the Disable-ADAccount to disable a team member's account and double check with them that they can no longer login with putty.
Disable-ADAccount -Identity "A00122208"

#Question 11
#Use the Search-ADAccount command to write a line that will return the Name and SamAccountName of all disabled USER accounts.
Search-ADAccount -AccountDisabled | Format-Table -AutoSize

#Question 12
#Use the Enable-ADAccount command to re-enable your team member's account and double check with them that they can login with putty again.
Enable-ADAccount -Identity "A00122208"

#Question 13
#Use the Set-ADAccountPassword to reset the password of a team member's account. Set the password to Pa$$w0rd1.
Set-ADAccountPassword -Identity A00122208 -NewPassword (ConvertTo-SecureString -AsPlainText "Pa$$w0rd1" -Force)