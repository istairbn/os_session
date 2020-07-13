$TeamsOutput = Get-Process | Where-Object Name -Match Team | Select *

$SumOutput = $TeamsOutput.Cpu | Measure-Object -Sum 

If($SumOutput.sum -ge 1000000){
    Write-output "TOO MUCH CPU!!!"
}
Else{
    Write-output "It's cool man!"
}

