
$script:new_location = 'c:\'

function choose_folders
{
    Add-Type -AssemblyName System.Windows.Forms
    $FolderBrowser = New-Object System.Windows.Forms.FolderBrowserDialog
    $FolderBrowser.ShowDialog()
    $script:new_location = $FolderBrowser.SelectedPath
}

choose_folders

Set-Location $script:new_location