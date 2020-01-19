function Main {
    Get-Menu
}
function Get-Menu {
    do {
        Clear-Host
     
        Write-Host '================ Menu ================'
        Write-Host '1: Press "1" for "Function 1".'
        Write-Host '2: Press "2" for "Function 2".'
        Write-Host '3: Press "3" for "Function 3".'
        Write-Host 'Q: Press "Q" to quit.'
        $project1_input = Read-Host 'Please make a selection'
        switch ($project1_input) {
            '1' {
                Clear-Host
                Get-Function1
            } '2' {
                Clear-Host
                Get-Function2
            } '3' {
                Clear-Host
                Get-Function3
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

function Get-Function1 {
    'You chose "Function 1"'
}

function Get-Function2 {
    'You chose "Function 2"'
}

function Get-Function3 {
    'You chose "Function 3"'
}
Main