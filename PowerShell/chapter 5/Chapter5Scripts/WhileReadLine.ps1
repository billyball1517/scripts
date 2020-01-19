$i = 0
$fileContents = Get-Content -path C:\fso\testfile.txt
While ( $i -ls $fileContents.Length )
{
    $fileContents[$i]
    $i++
}