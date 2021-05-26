$location = Split-Path $PSCommandPath -Parent
$b = Get-Content -Path "${location}\users.txt"
@(ForEach ($a in $b) {$a.Replace(' ', '')}) > "${location}\users2.txt"