function Get-SystemDNSServer
{
    $DNSServerAddresses = @()
    $interfaces = [System.Net.NetworkInformation.NetworkInterface]::GetAllNetworkInterfaces()
    foreach($interface in $interfaces)
    {
        if($interface.OperationalStatus -eq "Up")
        {
            $DNSConfig = $interface.GetIPProperties().DnsAddresses
            if (!$DNSConfig.IsIPv6SiteLocal)
            {
                $DNSServerAddresses += $DNSConfig
            }
        }
    }
    $DNSServerAddresses
}