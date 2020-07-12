#Permissions
icacls .\untouchable /deny bob:F

#Processes
Get-Process

Get-Process | Where Name -match Task

get-process | select * -First 1

Get-Process | Measure -Average CPU

#Users
Add-LocalUser
New-LocalGroup
Add-LocalGroupMember

#Packages
#Ripped directly from https://chocolatey.org/install 
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))