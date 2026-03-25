
param (
	[Parameter(Position=0)] [string] $folder,
	[switch] $all)

if ($all)
{
	$format = '{0,-30} {1}'

	Write-Host ($format -f 'Name', 'Value')
	Write-Host ($format -f '----', '-----')

	$folders = @{}
	[Enum]::GetValues('System.Environment+SpecialFolder') | % `
	{
		if (!($folders.ContainsKey($_.ToString())))
		{
			$folders.Add($_.ToString(), [Environment]::GetFolderPath($_))
		}
	}

	$folders.GetEnumerator() | sort name | % `
	{
		$name = $_.Name.ToString()
		if ($name.Length -gt 30) { $name = $name.Substring(0,27) + '...' }

		$value = $_.Value.ToString()
		$max = $host.UI.RawUI.WindowSize.Width - 32
		if ($value.Length -gt $max) { $value = $value.Substring(0, $max - 3) + '...' }


		if ($folder -and ($_.Name -match $folder))
		{
			Write-Host ($format -f $name, $value) -ForegroundColor Green
		}
		elseif ([String]::IsNullOrEmpty($folder))
		{
			if ($_.Name -eq 'CommonApplicationData')
			{
				Write-Host ($format -f $name, $value) -ForegroundColor Blue				
			}
			elseif ($_.Name -match 'ApplicationData')
			{
				Write-Host ($format -f $name, $value) -ForegroundColor Magenta
			}
			elseif ($value -match "$env:USERNAME(?:\\\w+){0,1}$")
			{
				Write-Host ($format -f $name, $value) -ForegroundColor DarkGreen
			}
			else
			{
				Write-Host ($format -f $name, $value)
			}
		}
		else
		{
			Write-Host ($format -f $name, $value)
		}
	}
}
else
{
	if ([String]::IsNullOrEmpty($folder))
	{
		Write-Host "Specify a SpecialFolder name or -all" -ForegroundColor Yellow
		exit 1
	}
	if (-not [bool]($folder -as [Environment+SpecialFolder] -is [Environment+SpecialFolder]))
	{
		Write-Host "$folder is not a valid SpecialFolder name" -ForegroundColor Red
		exit 1
	}

	[Environment]::GetFolderPath($folder -as [Environment+SpecialFolder])
}
