
[CmdletBinding(SupportsShouldProcess = $true)]

param(
	[parameter(Position = 0)] [string] $Project,
	[parameter(Position = 1)] [string] $Branch,
	[string] $After,
	[string] $Since,
	[int] $Last = 14,
	[switch] $Raw,
	[switch] $Graph
)

Begin
{
	class IssueTicket
	{
		[string] $status
		[string] $type
	}
	
	$script:MergeCommit = 'merge-commit'
	$script:curlcmd = "$($env:windir)\System32\curl.exe"

	$script:Tickets = @{}


	function Report
	{
		param (
			[Parameter(Mandatory = $true, Position = 0, ValueFromPipeline = $true)]
			[string] $Project
		)

		Push-Location $Project

		if (!$Branch)
		{
			$Branch = (git branch -a | ? { $_ -match 'origin/HEAD -> (.*)' } | % { $Matches[1] })
		}

		Write-Host
		Write-Host "$Project commits to $Branch since $Since" -ForegroundColor Blue
		Write-Host

		if ($raw -or $graph)
		{
			ReportRaw
		}
		else
		{
			SetupRemoteAccess
			ReportCommits
		}

		Pop-Location
	}


	function SetupRemoteAccess
	{
		if (!(Test-Path $curlcmd))
		{
			Write-Host "$0 does not exist" -ForegroundColor Red
			Write-Host 'Install curl from chocolatey.org with the command choco install curl' -ForegroundColor Yellow
			exit
		}

		if ($env:JIRA_URL -eq $null -or $env:JIRA_TOKEN -eq $null)
		{
			Write-Verbose 'could not determine remote access; set the JIRA_URL and JIRA_TOKEN env variables'
			$script:remote = $null
			return
		}


		$script:remote = "$($env:JIRA_URL)/rest/api/3/issue/"
		$script:token = $env:JIRA_TOKEN

		Write-Verbose "using remote $remote"
	}



	function ReportRaw
	{
		if ($graph)
		{
			Write-Host "git log --all --graph  --abbrev-commit --date=relative " -NoNewline -ForegroundColor DarkGray
			Write-Host "--pretty=format:'%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset'" -ForegroundColor DarkGray
			Write-Host

			git log --all --graph --abbrev-commit --date=relative `
				--pretty=format:'%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset'
		}
		else
		{
			Write-Host "git log --first-parent $Branch --after $Since " -NoNewline -ForegroundColor DarkGray
			Write-Host "--date=format-local:'%b %d %H:%M:%S' --pretty=format:""%h %<(15,trunc)%aN %ad %s %GK""" -ForegroundColor DarkGray
			Write-Host

			git log --first-parent $Branch --after $Since `
				--date=format-local:'%b %d %H:%M:%S' `--pretty=format:"%h %<(15,trunc)%aN %ad %s %GK"
		}
	}


	function ReportCommits
	{
		$lines = git log --first-parent $Branch --after $Since `
			--date=format-local:'%b %d %H:%M:%S' `--pretty=format:"%h~%<(15,trunc)%aN~%ad~%s~%GK"

		foreach ($line in $lines)
		{
			Write-Verbose $line
			$parts = $line.Split('~')

			$a = $parts[3] | Select-String -Pattern "Merge pull request (#[0-9]+) from (?:[\w/]+/)?([A-Z]+-[0-9]+)[-_ ]?"
			if ($a.Matches.Success)
			{
				$groups = $a.Matches.Groups
				ReportCommit $parts[1] $parts[2] $groups[1] $groups[2] $MergeCommit $parts[4]
				continue
			}

			$a = $parts[3] | Select-String -Pattern "(?:fix|feat|[Ff]eature)?[/(]?([A-Z]+[- ][0-9]+)\)?[:-]?\s?(.+)?\s?\((#[0-9]+)\)$"
			if ($a.Matches.Success)
			{
				$groups = $a.Matches.Groups
				ReportCommit $parts[1] $parts[2] $groups[3] $groups[1] $groups[2] $parts[4]
				continue
			}

			$a = $parts[3] | Select-String -Pattern "build\(deps\): (.+)? \((#[0-9]+)\)$"
			if ($a.Matches.Success)
			{
				$groups = $a.Matches.Groups
				ReportCommit $parts[1] $parts[2] $groups[2] '-' $groups[1] $parts[4]
				continue
			}

			$b = (git name-rev --name-only --exclude=tags/* $parts[0])
			if ($b -match '/([A-Za-z]+\-[0-9]+)')
			{
				$key = $matches[1]
				$a = $parts[3] | Select-String -Pattern "(.+)? \((#[0-9]+)\)$"
				if ($a.Matches.Success)
				{
					$desc = $a.Matches.Groups[1]
					$pr = $a.Matches.Groups[2]
					ReportCommit $parts[1] $parts[2] $pr $key $desc $parts[4] -ForegroundColor Magenta
					continue
				}
			}

			Write-Verbose "fallback... from $b"
			Write-Host $line.Replace('~', ' ') -ForegroundColor Magenta
		}
	}


	function ReportCommit
	{
		param(
			[string] $author,
			[string] $ago,
			[string] $pr,
			[string] $key,
			[string] $desc,
			[string] $sig
		)

		if ($ago.Length -lt 15) { $ago = $ago.PadRight(15) }

		if ($desc.Length -gt $sumax) { $desc = $desc.Substring(0, $sumax) + '..' }

		if (-not $key)
		{
			Write-Host "$author  $ago  PR $pr $desc"
			return
		}

		$key = $key.ToUpper().Replace(' ', '-')
		$pkey = $key.PadRight(12)

		if (-not $remote.StartsWith('http'))
		{
			Write-Host "$author  $ago  $pkey  PR $pr $desc" -ForegroundColor DarkMagenta
			return
		}

		$color = 'Gray'
		if ($desc -eq $MergeCommit) { $color = 'DarkGray' }
		if ($author.StartsWith('dependabot')) { $color = 'Magenta' }

		$ticket = $tickets[$key]
		if ($ticket -eq $null)
		{

			$response = . $curlcmd -s -u $token -X GET -H 'Content-Type: application/json' "$remote$key" | ConvertFrom-Json
			if (-not ($response -and $response.fields))
			{
				Write-Host "$author  $ago  $pkey " -NoNewLine
				Write-Host 'unknown    ' -NoNewline -ForegroundColor DarkGray
				Write-Host "  PR $pr $desc" -ForegroundColor $color
				return
			}

			$ticket = [IssueTicket]::new();
			$ticket.status = $response.fields.status.name
			$ticket.type = $response.fields.issueType.name
			$script:tickets += @{ $key = $ticket }
		}

		if ($ticket.type -ne 'Story')
		{
			$desc = "($($ticket.type)) $desc"
			if ($ticket.type -eq 'Defect') { $color = 'DarkRed' } else { $color = 'DarkCyan' }
		}

		Write-Host "$author  $ago  $pkey " -NoNewline

		$storyStatus = $ticket.status.PadRight(11)
		switch ($ticket.status)
		{
			'Verified' { Write-Host $storyStatus -NoNewline -ForegroundColor Green }
			'Passed' { Write-Host $storyStatus -NoNewline -ForegroundColor Yellow }
			default { Write-Host $storyStatus -NoNewline -ForegroundColor Cyan }
		}

		if ($sig -eq $null -or $sig -eq '') { $sig = ' SIG-MISSING' } else { $sig = '' }

		$desc = $desc.Trim()
		$descSig = "$desc$sig"
		if ($descSig.Length -gt $sumax) { $descSig = $descSig.Substring(0, $sumax) + '..' }

		Write-Host "  PR $pr $desc$sig" -ForegroundColor $color
	}
}
Process
{
	if (!$Since) { $Since = $After }
	if (!$Since) { $Since = [DateTime]::Now.AddDays(-$Last).ToString('yyyy-MM-dd') }

	if (!$Project -and (Test-Path '.git')) { $Project = '.' }

	if (!$Project)
	{
		Get-ChildItem | ? { Test-Path (Join-Path $_.FullName '.git') } | Select -ExpandProperty Name | % { Report $_ }
		return
	}

	if (!(Test-Path (Join-Path $Project '.git')))
	{
		Write-Host "*** $Project is not the path to a local repo" -ForegroundColor Yellow
		return
	}

	$script:sumax = $host.UI.RawUI.WindowSize.Width - 70

	Report $Project
}
