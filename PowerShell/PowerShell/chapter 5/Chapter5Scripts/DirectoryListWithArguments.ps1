foreach ($directory in $args)
{
    Get-ChildItem $directory | Where-Object length -gt 1000 | Sort-Object -property name
}
