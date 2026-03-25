
[CmdletBinding(SupportsShouldProcess=$true)]

param (
	[switch] $Yes
)

Begin
{
	$script:MaxLength = [Int16]::MaxValue

	function RemoveInvalidPaths
	{
		param (
			[string[]] $paths,
			[string[]] $expos,
			[string] $target
		)

		Write-Host "... cleaning $target" -ForegroundColor DarkYellow

		$list = @()
		foreach ($path in $paths)
		{
			if ($path -eq '')
			{
				Write-Host "... removing empty $target path"
			}
			elseif ($list -contains $path) # -contains is case-insensitive
			{
				Write-Host "... removing duplicate $target path: $path"
			}
			elseif ($expos -contains $path)
			{
				Write-Host "... removing expanded $target path: $path"
			}
			elseif (Test-Path (ExpandPath $path))
			{
				$list += $path
			}
			else
			{
				Write-Host "... removing invalid $target path: $path"
			}
		}

		$list
	}

	function ExpandPath ($path)
	{
		$match = [Regex]::Match($path, '\%(.+)\%')
		if ($match.Success)
		{
			$evar = [Environment]::GetEnvironmentVariable( `
				$match.Value.Substring(1, $match.Value.Length -2))

			if ($evar -and ($evar.Length -gt 0))
			{
				return $path -replace $match.value, $evar
			}
		}

		return $path
	}


	function BalancePaths
	{
		param (
			[string[]] $highpaths,		# preferred collection
			[string[]] $highExpos,		# entries that contain variables
			[string] $highprefix,		# prefix that should be moved to preferred collection
			[string] $highname,			# name of the preferred collection (User or System)
			[string[]] $lowpaths,		# other collection
			[string] $lowprefix,		# prefix that should remain in other collection
			[string] $lowname			# name of the other collection (System or User)
		)

		Write-Host "... balancing $lowname to $highname" -ForegroundColor DarkYellow

		$lpaths = @()

		foreach ($path in $lowpaths)
		{
			$expo = ExpandPath $path

			if ($expo.StartsWith($highprefix, 'CurrentCultureIgnoreCase'))
			{
				if (($highpaths -contains $expo) -or `
					($highExpos -contains $path) -or `
					($highpaths -contains $path))
				{
					Write-Host ... ignoring duplicate $lowname path`: "$path"
				}
				else
				{
					$highpaths += $path
					Write-Host ... moving from $lowname to $highname`: "$path"
				}
			}
			elseif (!$path.StartsWith($lowprefix, 'CurrentCultureIgnoreCase') -and ($highpaths -contains $path))
			{
				Write-Host ... ignoring duplicate $lowname path`: "$path"
			}
			else
			{
				$lpaths += $path
			}
		}

		return $highpaths, $lpaths
	}

	function InjectVariables ($paths, $name)
	{
		$value = [System.Environment]::GetEnvironmentVariable($name)
		$subst = "%$name%"

		$result = @()
		$paths | % `
		{
			if ($_.StartsWith($value, 'CurrentCultureIgnoreCase'))
			{
				$path = $_.Replace($value, $subst)
				Write-Host "... injecting $name`: $path"
				$result += $path
			}
			else
			{
				$result += $_
			}
		}

		$result
	}

	function RebuildSessionPath ($sysPaths, $usrPaths)
	{
		$spaths = $sysPaths | % { ExpandPath $_ }
		$upaths = $usrPaths | % { ExpandPath $_ }

		$ppaths = @()

		$shell = 'PowerShell'
		if ($PSVersionTable.PSVersion.Major -lt 6) { $shell = 'WindowsPowerShell' }
		
		$psroot = Join-Path $env:USERPROFILE "Documents\$shell\Modules\Scripts"

		$env:Path -split ';' | % `
		{
			if (!(($spaths -contains $_) -or ($upaths -contains $_) -or `
				$_.StartsWith($psroot, 'CurrentCultureIgnoreCase')))
			{
				$ppaths += ExpandPath $_
			}
		}

		$paths = $ppaths + $spaths + $upaths

		if (!($paths -contains $psroot)) { $paths += $psroot }

		if ($WhatIfPreference)
		{
			Write-Host ([String]::New('-',80)) -ForegroundColor DarkYellow
			Write-Host 'Original $env:Path' -ForegroundColor DarkYellow
			Write-Host (($env:Path -split ';') -join [Environment]::NewLine) -ForegroundColor DarkGray
			Write-Host 'Updated env:PATH' -ForegroundColor DarkYellow
			Write-Host ($paths -join [Environment]::NewLine) -ForegroundColor DarkGray
		}
		else
		{
			$env:Path = $paths -join ';'
		}
	}
}
Process
{

	$0 = 'SYSTEM\CurrentControlSet\Control\Session Manager\Environment'
	$sysKey = [Microsoft.Win32.Registry]::LocalMachine.OpenSubKey($0, $true)
	$sysPath = $sysKey.GetValue('Path', $null, 'DoNotExpandEnvironmentNames')
	$sysPaths = $sysPath -split ';'
	$sysExpos = $sysPaths | ? { $_ -match '\%.+\%' } | % { (ExpandPath $_).ToLower() }

	$usrKey = [Microsoft.Win32.Registry]::CurrentUser.OpenSubKey('Environment', $true)
	$usrPath = $usrKey.GetValue('Path', $null, 'DoNotExpandEnvironmentNames')
	$usrPaths = $usrPath -split ';'
	$usrExpos = $usrPaths | ? { $_ -match '\%.+\%' } | % { (ExpandPath $_).ToLower() }

	if ($VerbosePreference -eq 'Continue')
	{
		Write-Host 'Original System Paths' -ForegroundColor DarkYellow
		Write-Host ($sysPaths -join [Environment]::NewLine) -ForegroundColor DarkGray
		Write-Host 'Original User Paths' -ForegroundColor DarkYellow
		Write-Host ($usrPaths -join [Environment]::NewLine) -ForegroundColor DarkGray
		Write-Host
	}

	$sysPaths = RemoveInvalidPaths $sysPaths $sysExpos 'System'
	$usrPaths = RemoveInvalidPaths $usrPaths $usrExpos 'User'

	$usrPaths, $sysPaths = BalancePaths $usrPaths $usrExpos $env:USERPROFILE 'User' $sysPaths $env:SystemRoot 'System'
	$sysPaths, $usrPaths = BalancePaths $sysPaths $sysExpos $env:SystemRoot 'System' $usrPaths $env:USERPROFILE 'User'

	$sysPaths = InjectVariables $sysPaths 'SystemRoot'
	$usrPaths = InjectVariables $usrPaths 'USERPROFILE'

	$newSysPath = $sysPaths -join ';'
	$newUsrPath = $usrPaths -join ';'
	
	if ($VerbosePreference -eq 'Continue')
	{
		if ($newSysPath -ne $sysPath)
		{
			Write-Host 'New System Paths' -ForegroundColor DarkYellow
			Write-Host ($sysPaths -join [Environment]::NewLine) -ForegroundColor DarkGray
		}

		if ($newUsrPath -ne $usrPath)
		{
			Write-Host 'New User Paths' -ForegroundColor DarkYellow
			Write-Host ($usrPaths -join [Environment]::NewLine) -ForegroundColor DarkGray
		}
	}

	if (($newSysPath -ne $sysPath) -or ($newUsrPath -ne $usrPath))
	{
		if ($WhatIfPreference)
		{
			RebuildSessionPath $sysPaths $usrPaths
		}
		else
		{
			if ($Yes) { $ans = 'y' } else { $ans = Read-Host 'Apply changes? (Y/N) [Y]' }
			if (($ans -eq 'y') -or ($ans -eq 'Y') -or ($ans -eq ''))
			{
				if ($newSysPath -ne $sysPath) { $sysKey.SetValue('Path', $newSysPath, 'ExpandString') }
				if ($newUsrPath -ne $usrPath) { $usrKey.SetValue('Path', $newUsrPath, 'ExpandString') }

				RebuildSessionPath $sysPaths $usrPaths
			}
		}
	}
	else
	{
		Write-Host
		Write-Host 'NO changes needed'
	}

	$sysKey.Dispose()
	$usrKey.Dispose()
}
