[CmdletBinding()]
param(
)

(Get-ChildItem . -Filter flights.*.json | Get-Content | ConvertFrom-Json).Items | Select-Object -Property Takeoff | ForEach-Object { $_.takeoff.name } | Group-Object | Format-Table -Property Count, Name