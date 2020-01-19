
<#
Function Get-Greeting
{
    return "Hello, sunshine!"
}

Write-Host "Your greeting is: $(Get-Greeting)"
#>

Function Get-RandomGreeting {
    $greetings = @(
        "Hi!",
        "Howdy, partner!",
        "G'day mate!",
        "Salutations, Good Sir!",
        "What's up!"
        "Peek-a-boo!"
    )
    
    return $greetings | Get-Random
}

Write-Host "Your random greeting is: $(Get-RandomGreeting)"
