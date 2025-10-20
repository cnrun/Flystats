[CmdletBinding()]
param(
)

(Get-ChildItem . -Filter flights.*.json | Get-Content | ConvertFrom-Json).Items | Select-Object -Property Glider | ForEach-Object { $_.glider.nameCompact } | Group-Object | Format-Table -Property Count, Name