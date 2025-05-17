function global:Get-NetSessionEnum {
[cmdletbinding()]
param (
    [string]$UserName = $null,
    [string[]]$ComputerName = $null,
    [switch]$UseCachedResults,
    [switch]$AllDomainComputers,
    [switch]$OpenAsGUI
)
if ($UseCachedResults -and ($Global:Results -eq $null)) {Write-Warning "No Cached Results found from previous run. Please run again without the -UserCachedResults switch."; break}
if (!($UseCachedResults)) {
write-host "Initiating..." -ForegroundColor cyan
$EXEStr='TVpQA...AAA=' #The omitted "TVpQA......AAA=" is actually a 459436-character long Base64 string.
[System.Convert]::FromBase64String($EXEStr) | Set-Content -Path $env:TEMP\ns.exe -Encoding Byte
$CurrentEAP = $ErrorActionPreference; $ErrorActionPreference = "SilentlyContinue";
if (($ComputerName -eq $null) -or $AllDomainComputers) {
    write-host "Getting domain computer names..." -ForegroundColor cyan
    if ($ComputerName -ne $null) {write-host "-AllDomainComputers was specified with -Computername. If you want to abort and re-specify, press CTRL+C, or wait while we get all domain computers." -ForegroundColor cyan}
    $s = New-Object System.DirectoryServices.DirectorySearcher
    if ($AllDomainComputers) {$s.Filter = '(objectCategory=computer)'}
        else { # Query all the DCs (Default)
        $s.Filter = '(&(objectCategory=computer)(userAccountControl:1.2.840.113556.1.4.803:=8192))'
        }
    [System.Collections.ArrayList]$ComputerName = ($s.FindAll().GetDirectoryEntry().name)
    if ($AllDomainComputers) {$ComputerName.Remove($env:COMPUTERNAME); $ComputerName.Add('LOCALHOST')}
    if (!($?)) {$Error[0].Exception.InnerException;
        If ($Error[0].Exception.HResult -eq -2146233087) {
            Write-Host "Failed to query for computer account names from Active Directory.`nOnly the localhost will be enumerated for Network Sessions." -ForegroundColor Yellow
            $ComputerName = 'LOCALHOST'
            }
        }
    }
$Global:Results = @(); [int]$i = 1;
foreach ($comp in $ComputerName) {
    if ($ComputerName -ne 'LOCALHOST'){cls; "Enumerating Net Sessions (host $i out of $($ComputerName.Count))..."}
    $temp = & $env:TEMP\ns.exe $comp 2>&1 # Peform the NetSessionEnum
    for ($c = 3; $c -le $($temp.Count-3);$c++) { # For each Net Session on that host -
        $res = $temp[$c].ToString().split()| where {$_}
        switch ($res[0].replace("\\\\",""))
        {
            '[::1]' {$hostname = 'IPv6 Loopback'}
            '127.0.0.1' {$hostname = 'IPv4 Loopback'}
            default {$hostname = [System.Net.Dns]::GetHostByAddress($res[0].replace("\\\\","")).HostName}
        }
        $Global:Results += [PSCustomObject]@{
            UserName = $res[1]
            ConnectedFromIP = $res[0].replace("\\\\","")
            ConnectedFromHostName = $hostname
            ConnctedTo = $comp
            Time = $res[2]
            IdleTime = $res[3]
            }
        Clear-Variable res, hostname
        }
    Clear-Variable temp; $i++
    }
}
if ($UseCachedResults -and $ComputerName -ne $null) {Write-Warning "-UseCachedResults was specified with -ComputerName; Displaying all cached Computer Names from previous run:"}
if ($UserName -ne "") {
    switch ($OpenAsGUI) {
    $true {$Global:Results | where UserName -eq $UserName | sort IdleTime, Time | Out-GridView -Title 'Network Sessions Enumeration'}
    $false {$Global:Results | where UserName -eq $UserName | sort IdleTime, Time | ft -AutoSize }
        }
     }
    else {
    switch ($OpenAsGUI) {
    $true {$global:Results | sort UserName, IdleTime, Time | Out-GridView -Title 'Network Sessions Enumeration'}
    $false {$global:Results | sort UserName, IdleTime, Time | ft -AutoSize}
        }
    }
write-host 'Optional: Type $Global:Results to see the full list of unfiltered data (Cached Results).' -ForegroundColor Cyan
if (Test-Path $env:TEMP\ns.exe) {del $env:TEMP\ns.exe}; $ErrorActionPreference = $CurrentEAP
}
