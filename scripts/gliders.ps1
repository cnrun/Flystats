[CmdletBinding()]
param(
)

$FlightsByGliders = (Get-ChildItem . -Filter flights.*.json | Get-Content | ConvertFrom-Json).Items | Select-Object -Property Glider | ForEach-Object { $_.glider.nameCompact } | Group-Object

foreach ($GliderStat in $FlightsByGliders) {
    $MeasureSeconds = (Get-ChildItem . -Filter flights.*.json `
    | Get-Content `
    | ConvertFrom-Json).Items `
    | Select-Object -Property Glider,routeFreeFlight `
    | ForEach-Object { if ($_.glider.nameCompact -eq $GliderStat.Name) { [TimeSpan]::ParseExact($_.routeFreeFlight.duration,"\P\T%h\H%m\M%s\S",$null).TotalSeconds} } `
    # | Measure-Object -Sum | ForEach-Object { (New-TimeSpan -Seconds $_.Sum).ToString() }
    | Measure-Object -Sum
    $ts = New-TimeSpan -Seconds $MeasureSeconds.sum
    $tsString = "$($ts.Days * 24 + $ts.Hours):$($ts.Minutes):$($ts.Seconds)S"
    Write-Host "Name:$($GliderStat.Name) Count: $($GliderStat.Count) Time:$tsString"
}
