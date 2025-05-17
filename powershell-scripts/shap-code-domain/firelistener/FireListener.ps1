function FireListener
{
    Param( 
        [Parameter(Position = 0, Mandatory = $True)]
        [String]
        $PortRange
    )
    $ErrorActionPreference = 'SilentlyContinue'
    $socketblock = { 
		param($port = $args[1])
		try
		{
			$EndPoint = New-Object System.Net.IPEndPoint([ipaddress]::any, $port)
			$ListenSocket = New-Object System.Net.Sockets.TCPListener $EndPoint
			$ListenSocket.Start()		
			$RecData = $ListenSocket.AcceptTCPClient()
			$clientip = $RecData.Client.RemoteEndPoint.Address.ToString()
            $clientport = $RecData.Client.LocalEndPoint.Port.ToString()
			Write-Host "$clientip connected through port $clientport" -ForegroundColor Green
		    $Stream.Close()
			$ListenSocket.Stop()		
			} catch
			{ Write-Error $Error[0]	}
    }
	[int] $lowport = $portrange.split("-")[0]
	[int] $highport = $portrange.split("-")[1]	
	[int] $ports = 0	   
	Get-Job | Remove-Job
	for($ports=$lowport; $ports -le $highport; $ports++)
	{
		"Listening on port $ports"	
        $job = start-job -ScriptBlock $socketblock -ArgumentList $ports -Name $ports
	}
	[console]::TreatControlCAsInput = $true
	while ($true)
	{
		if ($Host.UI.RawUI.KeyAvailable -and (3 -eq [int]$Host.UI.RawUI.ReadKey("AllowCtrlC,IncludeKeyUp,NoEcho").Character))
		{
			Write-Host "Stopping all jobs.....This can take many minutes." -Background DarkRed
			Sleep 2
            Get-Job | Stop-Job 
            Get-Job | Remove-Job
			break;
		}
		foreach ($job1 in (Get-Job))
		{ 
            Start-Sleep -Seconds 4
			Get-Job | Receive-Job
			if ($job1.State -eq "Completed")
			{
				$port = $job1.Name
                "Listening on port $port"
                $newjobs = start-job -ScriptBlock $socketblock -ArgumentList $port -Name $port
                Get-Job | Remove-Job
			}
		}
	}
}
