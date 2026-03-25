
param([switch] $quiet)

$count = 0
$size = 0
$skip = 0


(Get-WinEvent -Listlog * -Force -ErrorAction SilentlyContinue) | % `
{
	if ($_.RecordCount -gt 0)
	{
		if (!$quiet) { Write-Host '.' -NoNewline }
		$name = $_.LogName
		try
		{

			$size += $_.FileSize
			[System.Diagnostics.Eventing.Reader.EventLogSession]::GlobalSession.ClearLog($name)
			$count++
		}
		catch
		{
			$skip++
		}
	}
}

if (!$quiet)
{
	[double] $kb = $size / 1024
	Write-Host "`n"
	Write-Host("Cleared {0} logs saving {1} KB" -f $count, $kb) -Foreground DarkYellow

	if ($skip -gt 0)
	{
		Write-Host("Skipped {0} logs" -f $skip) -Foreground DarkYellow
	}
}
