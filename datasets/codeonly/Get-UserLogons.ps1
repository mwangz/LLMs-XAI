function Get-UserLogons()
{
    [CmdletBinding()]
    Param
    (
            [string[]]$ExclusionList = $("SYSTEM", "NETWORK SERVICE", "DWM-1", "LOCAL SERVICE", "UMFD-0", "UMFD-1"),
            [int]$Newest = 200,
            [switch]$ServiceAccounts = $false,
            [string]$ComputerName = ""
    )
    Write-Output ""
    if($ComputerName)
    {
        $LogonEvents = Get-EventLog -newest $Newest -logname security -instanceid 4624 -ComputerName $ComputerName
    }
    else
    {
        $LogonEvents = Get-EventLog -newest $Newest -logname security -instanceid 4624
    }
    foreach($Events in $LogonEvents)
    {
        $LogonUsername = $Events.ReplacementStrings[5]
        $LogonHostname = $Events.ReplacementStrings[11]
        $LogonDomain = $Events.ReplacementStrings[6]
        if($ExclusionList -contains $LogonUsername)
        {
            continue
        }
        if($LogonHostname -eq "-")
        {
            continue
        }
        if($LogonUsername.Trim("`$") -eq $LogonHostname)
        {
            continue
        }
        if(!$ServiceAccounts)
        {
            if($LogonUsername.ToLower().StartsWith("svc_") -or $LogonUsername.ToLower().StartsWith("svc-"))
            {
                continue
            }
        }
        Write-Output "$($Events.TimeGenerated.ToString("yyyy-MM-dd HH:mm:ss")) : $LogonDomain\$LogonUsername -> $LogonHostname"
    }
}
