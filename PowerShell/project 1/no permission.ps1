$result = Get-ChildItem -Path path2scan -Recurse -ErrorAction SilentlyContinue -ErrorVariable myError
Echo $myError.TargetObject