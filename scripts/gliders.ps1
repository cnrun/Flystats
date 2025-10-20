[CmdletBinding()]
param(
)

$FlightsByGliders = (Get-ChildItem . -Filter flights.*.json | Get-Content | ConvertFrom-Json).Items | Select-Object -Property Glider | ForEach-Object { $_.glider.nameCompact } | Group-Object

foreach ($GliderStat in $FlightsByGliders) {
    $MeasureSeconds = (Get-ChildItem . -Filter flights.*.json `
    | Get-Content | ConvertFrom-Json).Items `
    | Select-Object -Property Glider,routeFreeFlight `
    | ForEach-Object { if ($_.glider.nameCompact -eq $GliderStat.Name) 
        { [TimeSpan]::ParseExact($_.routeFreeFlight.duration,"\P\T%h\H%m\M%s\S",$null).TotalSeconds} } `
    | Measure-Object -Sum
    $ts = New-TimeSpan -Seconds $MeasureSeconds.sum
    $tsString = "{0:D2}:{1:D2}:{2:D2}" -f $($ts.Days * 24 + $ts.Hours),$($ts.Minutes),$($ts.Seconds)
    Write-Host "$($GliderStat.Name) ($($GliderStat.Count)) $tsString"
}
