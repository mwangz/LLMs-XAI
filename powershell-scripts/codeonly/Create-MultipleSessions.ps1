function Create-MultipleSessions
{
    [CmdletBinding()] Param ( 
        [Parameter(Position = 0, Mandatory = $True)]
        [String]
        $filename,
        [Parameter(Mandatory = $False)]
        [Switch]
        $Creds,
        [Parameter(Mandatory = $False)]
        [Switch]
        $CreateSessions,
        [Parameter(Mandatory = $False)]
        [Switch]
        $VerboseErrors
    )
    $ErrorActionPreference = "SilentlyContinue"
    if ($VerboseErrors)
    {
        $ErrorActionPreference = "Continue"
    }
    $servers = Get-Content $filename
    if ($Creds)
    {
        $Credentials = Get-Credential
        $CheckCommand = 'gwmi -query "Select IPAddress From Win32_NetworkAdapterConfiguration Where IPEnabled = True" -ComputerName $server -Credential $Credentials'
        $SessionCommand = 'New-PSSession -ComputerName $server -Credential $Credentials'
    }
    else
    {
        $CheckCommand = 'gwmi -query "Select IPAddress From Win32_NetworkAdapterConfiguration Where IPEnabled = True" -ComputerName $server'
        $SessionCommand = 'New-PSSession -ComputerName $server'
    }
    foreach ($server in $servers)
    {
       $check = Invoke-Expression $CheckCommand
       if($check -ne $null)
       {
           Write-Host "Credentials worked on $server !!" -ForegroundColor Green
           if ($CreateSessions -eq $True)
           {
                "`nCreating Session for $server"
                Invoke-Expression $SessionCommand
           }
        }
        else
        {
           "Could not connect or credentials didn't work on $server"
        }
    }
    if ($CreateSessions -eq $True)
    {
        Write-Host "`nFollowing Sessions have been created: " -ForegroundColor Green
        Get-PSSession
    }
}
