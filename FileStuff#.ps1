$FileStuff = Get-Childitem | Select Name, LastWriteTime, Length

$SortedStuff = $FileStuff | Sort -Property Length -Descending | Select -First 5 | ConvertTo-Csv

$FileDestination = "./MyOutput.csv"
$SortedStuff | Out-File -FilePath $FileDestination

$SortedStuff = $FileStuff | Sort -Property Length -Descending | Select -First 5 | ConvertTo-Json

$FileDestination2 = "./MyOutput.Json"

$SortedStuff | Out-File -FilePath $FileDestination2

Get-Content .\MyOutput.Json | ConvertFrom-Json 