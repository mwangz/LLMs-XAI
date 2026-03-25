
[CmdletBinding(SupportsShouldProcess = $true)]

param(
	[Parameter(Mandatory = $true, Position = 0)] [string] $InputPath,
	[Parameter(Position = 1)] [string] $OutputPath,
	[int] $Bitrate = 128,
	[string] $Extension = '.m4a',
	[switch] $FullQuality,
	[switch] $Info,
	[switch] $Recurse,
	[switch] $Clean,
	[switch] $Force
)

Begin
{
	function EnsureConverter
	{
		if ((Get-Command ffmpeg -ErrorAction:SilentlyContinue) -eq $null)
		{
			Write-Host '... installing ffmpeg'

			if (!$WhatIfPreference)
			{
				choco install -y ffmpeg
			}
		}
	}


	function Convert
	{
		param($name)

		$mp3 = [IO.Path]::ChangeExtension($name, 'mp3')

		if ($OutputPath)
		{
			$mp3 = Join-Path $OutputPath (Split-Path $mp3 -Leaf)
		}

		$loglevel = 'quiet'
		if ($Info) { $loglevel = 'info' }

		$over = ''
		if ($Force) { $over = '-y' }

		if ($FullQuality)
		{
			Write-Host "... converting $name with full quality" -ForegroundColor Cyan

			if (!$WhatIfPreference)
			{
				ffmpeg -i $name -q:a 0 -map a -vn -loglevel $loglevel $over $mp3
			}
		}
		else
		{
			Write-Host "... converting $name" -ForegroundColor Cyan

			if (!$WhatIfPreference)
			{
				ffmpeg -i $name -b:a $Bitrate`K -vn -loglevel $loglevel $over $mp3
			}
		}

		$mp3 = [WildcardPattern]::Escape($mp3)
		if ($Clean -and (Test-Path $mp3))
		{
			$name = [WildcardPattern]::Escape($name)
			$item4 = Get-Item $name
			$item3 = Get-Item $mp3
			if (($item3.Length -gt 0) -and ($item3.LastWriteTime -gt $item4.LastWriteTime))
			{
				Remove-Item $name -Force -Confirm:$False
			}
		}
	}
}
Process
{
	if (!(Test-Path $InputPath))
	{
		Write-Host "... $InputPath is not found" -ForegroundColor Red
		return
	}

	EnsureConverter

	if ($OutputPath -and !(Test-Path $OutputPath))
	{
		Write-Host "... creating $OutputPath" -ForegroundColor Cyan
		New-Item $OutputPath -ItemType Directory -Force -Confirm:$False | Out-Null
	}

	if ($Extension -and ($Extension[0] -ne '.'))
	{ 
		$Extension = ".$Extension"
	}

	if ($Recurse)
	{
		(Get-ChildItem .\ -Filter "*$Extension" -Recurse).DirectoryName | select -Unique | % `
		{
			Push-Location ([WildcardPattern]::Escape($_))
			ConvertTo-MP3 .\ -Clean:$Clean -Force:$Force
			Pop-Location
		}
	}
	elseif ((Get-Item $InputPath) -is [IO.DirectoryInfo])
	{
		Get-ChildItem $InputPath -Filter "*$Extension" | % { Convert $_.FullName }
	}
	else
	{
		Convert $InputPath
	}
}
