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
    Write-Host 'Please select the directory you wish to check for permission errors'
    choose_folder
    $project1_problem1_permission_source = $script:new_location
    Write-Host 'Please select the destination location for the report'
    choose_folder
    $project1_problem1_permission_dest = $script:new_location
    Write-Host '(this may take a minute)'
     
    Set-Location $project1_problem1_permission_source
    Get-ChildItem -Path my_path -Recurse -ErrorAction SilentlyContinue -ErrorVariable error_var_1
     
    Write-output $error_var_1.TargetObject | Format-List | Out-File $project1_problem1_permission_dest'\problem1.txt'
    Write-Host 'Report sent to ' $project1_problem1_permission_dest'\problem1.txt'
}

function project1_problem2 {
    Write-Host 'Please select the path to the file share'
    choose_folder
    $project1_problem2_fileshare_dest = $script:new_location
    $project1_problem2_fileshare_name = Read-Host 'Please write the name for the file share'
    Write-Host 'Please select the destination location for the report'
    choose_folder
    $project1_problem2_report_dest = $script:new_location
    New-SmbShare -Name $project1_problem2_fileshare_name -Path $project1_problem2_fileshare_dest -FullAccess Everyone
}

function project1_problem3 {
    Write-Host 'Please select the destination location for the report'
    choose_folder
    $project1_problem3_permission_dest = $script:new_location
    Get-WmiObject win32_logicaldisk | 
        Format-Table @{n = "Letter"; e = {$_.DeviceId}},
    @{n = "Name"; e = {$_.VolumeName}}, 
    @{n = "Size (GB)"; e = {[math]::Round($_.Size / 1GB, 2)}}, 
    @{n = "Size (TB)"; e = {[math]::Round($_.Size / 1TB, 2)}}, 
    @{n = "Free (GB)"; e = {[math]::Round($_.FreeSpace / 1GB, 2)}}, 
    @{n = "Free (TB)"; e = {[math]::Round($_.FreeSpace / 1TB, 2)}},
    @{n = "Free (%)"; e = {[math]::Round($_.FreeSpace / $_.Size * 100, 2)}} |
        Out-File $project1_problem3_permission_dest'\problem3.txt'
    Write-Host 'Report sent to ' $project1_problem3_permission_dest'\problem3.txt'
}

function project1_problem4 {

}

function choose_folder {
    Add-Type -AssemblyName System.Windows.Forms
    $FolderBrowser = New-Object System.Windows.Forms.FolderBrowserDialog
    $FolderBrowser.ShowDialog()
    $script:new_location = $FolderBrowser.SelectedPath
}

project1_main