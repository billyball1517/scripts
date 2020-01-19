function project1_main {
    project1_menu
}
function project1_menu {
    do {
        Clear-Host
     
        Write-Host '================ Thomas Birchall A00122208 CET1014 Project 1 ================'
        Write-Host '1: Press "1" for "Problem 1".'
        Write-Host '2: Press "2" for "Problem 2".'
        Write-Host '3: Press "3" for "Problem 3".'
        Write-Host '4: Press "4" for "Problem 4".'
        Write-Host 'Q: Press "Q" to quit.'
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
    until ($project1_input -eq 'q')
    Clear-Host
}
function project1_problem1 {
    $project1_problem1_problem_user = Read-Host "Enter the name of the user to scan for permission errors"
    Write-Host 'Please select the destination to scan for permission errors'
    choose_folder
    $project1_problem1_problem_dest = $script:new_location
    Write-Host 'Please select the destination location for the report'
    choose_folder
    $project1_problem1_report_dest = $script:new_location
    Write-Output "All files and folders where $project1_problem1_problem_user does not have full control:" > "$project1_problem1_report_dest/problem1.txt"
    $ItemsWithNoFullAccess = @()
    $AllItems = Get-ChildItem $project1_problem1_problem_dest -Recurse -Force -ErrorAction 0
    foreach ($Item in $AllItems) {
        $ItemAcl = get-acl -Path $Item.FullName
        $ItemAccess = $ItemAcl.access
        [bool]$UserNoFullControl = $false
        foreach ($ItemAccessDetails in $ItemAccess) {
            if ($ItemAccessDetails.IdentityReference -match "$project1_problem1_problem_user" -and $ItemAccessDetails.FileSystemRights -match 'fullcontrol' -and $ItemAccessDetails.AccessControlType -match 'deny') {
                $UserNoFullControl = $true
            }
        }
        if ($UserNoFullControl) {
            $ItemsWithNoFullAccess += Get-Item -Path $Item.FullName
        }
    }
        
    $ItemsWithNoFullAccess |
    Select-Object -Property FullName, LastAccessTime, LastWriteTime |
    Format-Table >> "$project1_problem1_report_dest\problem1.txt"
    
    Write-Host "Report sent to: $project1_problem1_report_dest\problem1.txt"
}

function project1_problem2 {
    Write-Host 'Please select the source location of the text file'
    choose_folder
    $project1_problem2_list = $script:new_location
    Write-Host 'Please select the destination location for the shares'
    choose_folder
    $project1_problem2_shares_dest = $script:new_location
    Write-Host 'Please select the destination location for the report'
    choose_folder
    $project1_problem2_report_dest = $script:new_location
    Write-Output "User Shares:" > "$project1_problem2_report_dest\problem2.txt"
    [string]$path = $project1_problem2_shares_dest
    [string[]]$users = @()
    foreach ($line in Get-Content "$project1_problem2_list\NewHires.txt") {
        $users += $line
    }
    foreach ($user in $users) {
        $folder = $user -replace " ", ""
        $folder = $folder.ToLower()
        New-Item -Path "$path\$folder" -ItemType directory -ErrorAction 0 | Out-Null
        New-SmbShare -Name "$folder" -Path "$path\$folder" -FullAccess "Everyone" -ErrorAction 0 | Out-Null
        Write-Output "$user, $path\$folder, \\$env:COMPUTERNAME\$folder" >> "$project1_problem2_report_dest/problem2.txt"
    }
    Write-Host "Report sent to: $project1_problem2_report_dest\problem2.txt"
}

function project1_problem3 {

    Write-Host 'Please select the destination location of the text file'
    choose_folder
    $project1_problem3_list = $script:new_location
    Write-Host 'Please select the destination location for the report'
    choose_folder
    $project1_problem3_report_dest = $script:new_location
    Write-Output "Computers:" > "$project1_problem3_report_dest\problem3.txt"
    [string[]]$Computers = @()
    foreach ($line in Get-Content "$project1_problem3_list\Computers.txt") {
        $Computers += $line
    }
    foreach ($Computer in $Computers) {
        $ComputerDetails = Get-WMIObject -class "Win32_Computersystem" -namespace "root\CIMV2" -ComputerName $computer
        $IPv4Info = [System.Net.Dns]::GetHostAddresses($ComputerDetails.Name) | Where-Object { $_.AddressFamily -eq 'InterNetwork' } | Select-Object -Expand IPAddressToString
        
        $RamInfo = Get-WmiObject -ComputerName $Computer Win32_PhysicalMemory | Measure-Object -Property Capacity -Sum

        $properties = @(
            @{ Name = "Computer Name"; Expression = {$Computer}; Alignment = "left"; },
            @{ Name = "Hostname"; Expression = {$ComputerDetails.name}; Alignment = "left"; },
            @{ Name = "RAM (GB)"; Expression = {[math]::Round($RamInfo.Sum / 1GB, 2) }; Alignment = "left"; },
            @{ Name = "IPv4"; Expression = {$IPv4Info}; Alignment = "left"; },
            @{ Name = "Letter"; Expression = {"C:"}; Alignment = "left"; },
            @{ Name = "Size (GB)"; Expression = {[math]::Round($_.Size / 1GB, 2) }; Alignment = "left"; },
            @{ Name = "Free (%)"; Expression = {([math]::Round($_.FreeSpace / $_.Size, 2) * 100) }; Alignment = "left"; }
        )

        $DriveInfo = Get-WmiObject -ComputerName $Computer Win32_LogicalDisk -Filter "DeviceID='C:'" | Format-Table -Property $properties -AutoSize

        Write-Output $DriveInfo >> "$project1_problem3_report_dest\problem3.txt"
    }
    Write-Host "Report sent to: $project1_problem3_report_dest\problem3.txt"
}
function project1_problem4 {
    Write-Host 'Please select the destination to scan'
    choose_folder
    $project1_problem4_problem_dest = $script:new_location
    Write-Host 'Please select the destination location for the report'
    choose_folder
    $project1_problem4_report_dest = $script:new_location
    $ItemsToScan = @()
    $AllItems = Get-ChildItem $project1_problem4_problem_dest -Recurse -Force -File -ErrorAction 0
    foreach ($Item in $AllItems) {
        $ItemsToScan += Get-Item -Path $Item.FullName
    }
    
    Write-Output "25 Newest Files" > "$project1_problem4_report_dest\problem4.txt"
    $ItemsToScan |
    Select-Object -Property FullName,
    @{ Name = "SizeGB"; Expression = {[math]::Round($_.Length / 1GB, 2) }},
    @{ Name = "SizeMB"; Expression = {[math]::Round($_.Length / 1MB, 2) }},
    @{ Name = "SizeKB"; Expression = {[math]::Round($_.Length / 1KB, 2) }},
    CreationTime, LastAccessTime, LastWriteTime |
    Sort-Object { $_.CreationTime } -Descending |
    Select-Object -First 25 |
    Format-Table >> "$project1_problem4_report_dest\problem4.txt"
    
    Write-Output "20 Largest Files" >> "$project1_problem4_report_dest\problem4.txt"
    $ItemsToScan |
    Select-Object -Property FullName,
    @{ Name = "SizeGB"; Expression = {[math]::Round($_.Length / 1GB, 2) }},
    @{ Name = "SizeMB"; Expression = {[math]::Round($_.Length / 1MB, 2) }},
    @{ Name = "SizeKB"; Expression = {[math]::Round($_.Length / 1KB, 2) }},
    CreationTime, LastAccessTime, LastWriteTime |
    Sort-Object { $_.SizeKB } -Descending |
    Select-Object -First 20 |
    Format-Table >> "$project1_problem4_report_dest\problem4.txt"
    
    Write-Output "10 Most Recently Accessed Files" >> "$project1_problem4_report_dest\problem4.txt"
    $ItemsToScan |
    Select-Object -Property FullName,
    @{ Name = "SizeGB"; Expression = {[math]::Round($_.Length / 1GB, 2) }},
    @{ Name = "SizeMB"; Expression = {[math]::Round($_.Length / 1MB, 2) }},
    @{ Name = "SizeKB"; Expression = {[math]::Round($_.Length / 1KB, 2) }},
    CreationTime, LastAccessTime, LastWriteTime |
    Sort-Object { $_.LastAccessTime } -Descending |
    Select-Object -First 10 |
    Format-Table >> "$project1_problem4_report_dest\problem4.txt"
    Write-Host "Report sent to: $project1_problem4_report_dest\problem4.txt"

}
function choose_folder {
    Add-Type -AssemblyName System.Windows.Forms
    $FolderBrowser = New-Object System.Windows.Forms.FolderBrowserDialog
    $FolderBrowser.ShowDialog()
    $script:new_location = $FolderBrowser.SelectedPath
}

project1_main