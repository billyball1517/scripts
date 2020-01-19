#Main function, calls the Menu function
function project1_main {
    project1_menu
}
#Menu function, provides access to the 4 problem functions, or option to quit.
function project1_menu {
    #Prints options for user
    do {
        Clear-Host
        Write-Host '================ Thomas Birchall A00122208 CET1014 Project 1 ================'
        Write-Host '1: Press "1" for "Problem 1".'
        Write-Host '2: Press "2" for "Problem 2".'
        Write-Host '3: Press "3" for "Problem 3".'
        Write-Host '4: Press "4" for "Problem 4".'
        Write-Host 'Q: Press "Q" to quit.'
        #Allows user to imput value, selects problem function based on input 
        $project1_input = Read-Host 'Please make a selection'
        switch ($project1_input) {
            '1' {
                Clear-Host
                'You chose "Problem 1"'
                project1_problem1
            } '2' {
                Clear-Host
                'You chose "Problem 2"'
                project1_problem2
            } '3' {
                Clear-Host
                'You chose "Problem 3"'
                project1_problem3
            } '4' {
                Clear-Host
                'You chose "Problem 4"'
                project1_problem4
            } 'q' {
                Clear-Host 
                'Goodbye!'
            }
        }
        pause
    }
    #When user inputs "Q", the function quits
    until ($project1_input -eq 'q')
    Clear-Host
}
#Defines problem 1 function (Roy Trenneman - Scanning for permission errors)
function project1_problem1 {
    #Allows user to type username to scan for permission errors
    $project1_problem1_problem_user = Read-Host "Enter the name of the user to scan for permission errors"
    Write-Host 'Please select the destination to scan for permission errors'
    choose_folder
    #Allows user to select directory to scan for permissions eroors
    $project1_problem1_problem_dest = $script:new_location
    Write-Host 'Please select the destination location for the report'
    choose_folder
    $project1_problem1_report_dest = $script:new_location
    #Writes header for output file
    Write-Output "All files and folders where user: $project1_problem1_problem_user does not have full control:" > "$project1_problem1_report_dest/problem1.txt"
    #Empty variable for items where the selected user does not have full access
    $ItemsWithNoFullAccess = @()
    #Recursivly gets all items (Files and Directories) within the selected directory
    $AllItems = Get-ChildItem $project1_problem1_problem_dest -Recurse -Force -ErrorAction 0
    #"Get-Acl" for each item
    foreach ($Item in $AllItems) {
        $ItemAcl = get-acl -Path $Item.FullName
        $ItemAccess = $ItemAcl.access
        #Defines a boolean variable
        [bool]$UserNoFullControl = $false
        #If the user has full control, change the boolean variable to "true"
        foreach ($ItemAccessDetails in $ItemAccess) {
            if ($ItemAccessDetails.IdentityReference -match "$project1_problem1_problem_user" -and $ItemAccessDetails.FileSystemRights -match 'fullcontrol' -and $ItemAccessDetails.AccessControlType -match 'deny') {
                $UserNoFullControl = $true
            }
        }
        #If the boolean variable is true, add the given item to the variable
        if ($UserNoFullControl) {
            $ItemsWithNoFullAccess += Get-Item -Path $Item.FullName
        }
    }
    #For all the items where the user dosn't have full access, select the desired properties, and append them to file
    $ItemsWithNoFullAccess |
        Select-Object -Property FullName, LastAccessTime, LastWriteTime |
        Format-Table >> "$project1_problem1_report_dest\problem1.txt"
    #Write each line of report to host
    foreach ($line in Get-Content "$project1_problem1_report_dest\problem1.txt") {
        Write-Host $line
    }
    #Notify the user of the destination of the report
    Write-Host "Report sent to: $project1_problem1_report_dest\problem1.txt"
}
#Defines problem 2 function (Jen Barber - Creating file shares from a text document)
function project1_problem2 {
    #Allows user to select directory containing "NewHires.txt"
    Write-Host 'Please select the source location of the NewHires.txt file'
    choose_folder
    $project1_problem2_list = $script:new_location
    #Allows user to select destination location for the new file shares
    Write-Host 'Please select the destination location for the shares'
    choose_folder
    $project1_problem2_shares_dest = $script:new_location
    #Allows user to select destination location for the report
    Write-Host 'Please select the destination location for the report'
    choose_folder
    $project1_problem2_report_dest = $script:new_location
    #Writes header for output file
    Write-Output "User Shares:" > "$project1_problem2_report_dest\problem2.txt"
    #create two variables to be used later
    [string]$path = $project1_problem2_shares_dest
    [string[]]$users = @()
    #Add each user from the text file to the variable
    foreach ($line in Get-Content "$project1_problem2_list\NewHires.txt") {
        $users += $line
    }
    #For each user, create directory and create file share
    foreach ($user in $users) {
        $folder = $user -replace " ", ""
        $folder = $folder.ToLower()
        New-Item -Path "$path\$folder" -ItemType directory -ErrorAction 0 | Out-Null
        New-SmbShare -Name "$folder" -Path "$path\$folder" -FullAccess "Everyone" -ErrorAction 0 | Out-Null
        #Get information about newly created fileshares, and append them to file
        Write-Output "$user, $path\$folder, \\$env:COMPUTERNAME\$folder" >> "$project1_problem2_report_dest\problem2.txt"
    }
    #Write each line of report to host
    foreach ($line in Get-Content "$project1_problem2_report_dest\problem2.txt") {
        Write-Host $line
    }
    #Notify the user of the destination of the report
    Write-Host "Report sent to: $project1_problem2_report_dest\problem2.txt"
}
#Defines problem 3 function (Douglas Reynholm - Finding hardware information of computers)
function project1_problem3 {
    #Allows user to select directory containing "Computers.txt"
    Write-Host 'Please select the location of the Computers.txt file'
    choose_folder
    $project1_problem3_list = $script:new_location
    #Allows user to select destination location for the report
    Write-Host 'Please select the destination location for the report'
    choose_folder
    $project1_problem3_report_dest = $script:new_location
    #Writes header for output file
    Write-Output "Computers:" > "$project1_problem3_report_dest\problem3.txt"
    #Creates empty variable
    [string[]]$Computers = @()
    #Add each computer from the file to the variable
    foreach ($line in Get-Content "$project1_problem3_list\Computers.txt") {
        $Computers += $line
    }
    #For each computer in the variable, get requested info
    foreach ($Computer in $Computers) {
        #Get IPv4 address for given computer
        $ComputerDetails = Get-WMIObject -class "Win32_Computersystem" -namespace "root\CIMV2" -ComputerName $computer
        $IPv4Info = [System.Net.Dns]::GetHostAddresses($ComputerDetails.Name) | Where-Object { $_.AddressFamily -eq 'InterNetwork' } | Select-Object -Expand IPAddressToString
        #Get RAM info for given computer
        $RamInfo = Get-WmiObject -ComputerName $Computer Win32_PhysicalMemory | Measure-Object -Property Capacity -Sum
        #Defines format to display properties
        $properties = @(
            @{ Name = "Computer Name"; Expression = {$Computer}; Alignment = "left"; },
            @{ Name = "Hostname"; Expression = {$ComputerDetails.name}; Alignment = "left"; },
            @{ Name = "RAM (GB)"; Expression = {[math]::Round($RamInfo.Sum / 1GB, 2) }; Alignment = "left"; },
            @{ Name = "IPv4"; Expression = {$IPv4Info}; Alignment = "left"; },
            @{ Name = "Letter"; Expression = {"C:"}; Alignment = "left"; },
            @{ Name = "Size (GB)"; Expression = {[math]::Round($_.Size / 1GB, 2) }; Alignment = "left"; },
            @{ Name = "Free (%)"; Expression = {([math]::Round($_.FreeSpace / $_.Size, 2) * 100) }; Alignment = "left"; }
        )
        #Filter info to only include the C: drive
        $ComputerInfo = Get-WmiObject -ComputerName $Computer Win32_LogicalDisk -Filter "DeviceID='C:'" | Format-Table -Property $properties -AutoSize
        #Append info to file
        Write-Output $ComputerInfo >> "$project1_problem3_report_dest\problem3.txt"
    }
    #Write each line of report to host
    foreach ($line in Get-Content "$project1_problem3_report_dest\problem3.txt") {
        Write-Host $line
    }
    #Notify the user of the destination of the report
    Write-Host "Report sent to: $project1_problem3_report_dest\problem3.txt"
}
#Defines problem 4 function (Maurice Moss - Finding details about files)
function project1_problem4 {
    #Allows user to select directory to recursivly scan for file details
    Write-Host 'Please select the destination to scan'
    choose_folder
    $project1_problem4_problem_dest = $script:new_location
    #Allows user to select destination for report
    Write-Host 'Please select the destination location for the report'
    choose_folder
    $project1_problem4_report_dest = $script:new_location
    #Defines empty variable
    $ItemsToScan = @()
    #Recursivly gets all files within a given directory
    $AllItems = Get-ChildItem $project1_problem4_problem_dest -Recurse -Force -File -ErrorAction 0
    foreach ($Item in $AllItems) {
        #Adds name of item to variable
        $ItemsToScan += Get-Item -Path $Item.FullName
    }
    #Writes header for output file
    Write-Output "25 Newest Files" > "$project1_problem4_report_dest\problem4.txt"
    #Selects properties to output
    $ItemsToScan |
        Select-Object -Property FullName,
    @{ Name = "SizeGB"; Expression = {[math]::Round($_.Length / 1GB, 2) }},
    @{ Name = "SizeMB"; Expression = {[math]::Round($_.Length / 1MB, 2) }},
    @{ Name = "SizeKB"; Expression = {[math]::Round($_.Length / 1KB, 2) }},
    CreationTime, LastAccessTime, LastWriteTime |
        #Sort items based off "CreationTime"
    Sort-Object { $_.CreationTime } -Descending |
        #Selects only the first 25 items
    Select-Object -First 25 |
        #Append sorted items to file
    Format-Table >> "$project1_problem4_report_dest\problem4.txt"
    #Append header to file
    Write-Output "20 Largest Files" >> "$project1_problem4_report_dest\problem4.txt"
    #Selects properties to output
    $ItemsToScan |
        Select-Object -Property FullName,
    @{ Name = "SizeGB"; Expression = {[math]::Round($_.Length / 1GB, 2) }},
    @{ Name = "SizeMB"; Expression = {[math]::Round($_.Length / 1MB, 2) }},
    @{ Name = "SizeKB"; Expression = {[math]::Round($_.Length / 1KB, 2) }},
    CreationTime, LastAccessTime, LastWriteTime |
        #Sort items based off "$_.SizeKB"
    Sort-Object { $_.SizeKB } -Descending |
        #Selects only the first 20 items
    Select-Object -First 20 |
        #Append sorted items to file
    Format-Table >> "$project1_problem4_report_dest\problem4.txt"
    #Append header to file
    Write-Output "10 Most Recently Accessed Files" >> "$project1_problem4_report_dest\problem4.txt"
    #Selects properties to output
    $ItemsToScan |
        Select-Object -Property FullName,
    @{ Name = "SizeGB"; Expression = {[math]::Round($_.Length / 1GB, 2) }},
    @{ Name = "SizeMB"; Expression = {[math]::Round($_.Length / 1MB, 2) }},
    @{ Name = "SizeKB"; Expression = {[math]::Round($_.Length / 1KB, 2) }},
    CreationTime, LastAccessTime, LastWriteTime |
        #Sort items based off "$_.LastAccessTime"
    Sort-Object { $_.LastAccessTime } -Descending |
        #Selects only the first 10 items
    Select-Object -First 10 |
        #Append sorted items to file
    Format-Table >> "$project1_problem4_report_dest\problem4.txt"
    #Write each line of report to host
    foreach ($line in Get-Content "$project1_problem4_report_dest\problem4.txt") {
        Write-Host $line
    }
    #Notify the user of the destination of the report
    Write-Host "Report sent to: $project1_problem4_report_dest\problem4.txt"
}
#Defines function that allows selection of directories based on the GUI
function choose_folder {
    Add-Type -AssemblyName System.Windows.Forms
    $FolderBrowser = New-Object System.Windows.Forms.FolderBrowserDialog
    $FolderBrowser.ShowDialog()
    #Creats script-wide variable and adds directory path to it
    $script:new_location = $FolderBrowser.SelectedPath
}
#Calls the main function
project1_main