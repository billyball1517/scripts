Echo "All files and folders where user does not have full control:" > ~/desktop/problem1test/problem1.txt
$ItemsWithNoFullAccess = @()
$AllItems = Get-ChildItem ~\desktop\problem1test -Recurse
foreach ($Item in $AllItems) {
    $ItemAcl = get-acl -Path $Item.FullName
    $ItemAccess = $ItemAcl.access
    [bool]$UserNoFullControl = $false
    foreach ($ItemAccessDetails in $ItemAccess) {
        if ($ItemAccessDetails.IdentityReference -match 'user' -and $ItemAccessDetails.FileSystemRights -match 'fullcontrol' -and $ItemAccessDetails.AccessControlType -match 'deny') {
            $UserNoFullControl = $true
        }
    }
    if ($UserNoFullControl) {
        $ItemsWithNoFullAccess += Get-Item -Path $Item.FullName
    }
}
$ItemsWithNoFullAccess | Select-Object -Property FullName, Mode, LastAccessTime, LastWriteTime | Format-Table >> ~/desktop/problem1test/problem1.txt