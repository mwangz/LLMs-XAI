[CmdletBinding(ConfirmImpact = 'Medium',
   SupportsShouldProcess)]
param
(
   [Parameter(ValueFromPipeline)]
   [switch]
   $RDPGroup
)

begin
{
   $paramSetItemProperty = @{
      Path        = 'HKLM:\System\CurrentControlSet\Control\Terminal Server'
      Name        = 'fDenyTSConnections'
      Value       = 0
      ErrorAction = 'Continue'
   }

   $paramEnableNetFirewallRule = @{
      Confirm     = $false
      ErrorAction = 'Continue'
   }
}

process
{
   if ($pscmdlet.ShouldProcess('Registry Terminal Server', 'Modify'))
   {
      $null = (Set-ItemProperty @paramSetItemProperty)
   }

   if ($PSBoundParameters.ContainsKey('RDPGroup'))
   {
      if ($pscmdlet.ShouldProcess('Firewall Group for Remote Desktop', 'Enable'))
      {
         $null = (Get-NetFirewallRule -DisplayGroup 'Remote Desktop' -ErrorAction SilentlyContinue | Where-Object {
               $PSItem.Enabled -ne $true
            } | Enable-NetFirewallRule @paramEnableNetFirewallRule)
      }
   }
   else
   {
      if ($pscmdlet.ShouldProcess('Firewall Rules for Remote Desktop', 'Enable'))
      {
         Get-NetFirewallRule -Name 'RemoteDesktop-UserMode-In-TCP' -ErrorAction SilentlyContinue | Where-Object {
            $PSItem.Enabled -ne $true
         } | Enable-NetFirewallRule @paramEnableNetFirewallRule

         Get-NetFirewallRule -DisplayName 'Remote Desktop - User Mode (TCP-In)' -ErrorAction SilentlyContinue | Where-Object {
            $PSItem.Enabled -ne $true
         } | Enable-NetFirewallRule @paramEnableNetFirewallRule
      }
   }

   if ($pscmdlet.ShouldProcess('Ping', 'Enable'))
   {
      Get-NetFirewallRule -DisplayName 'File and Printer Sharing (Echo Request - ICMPv?-In)' -ErrorAction SilentlyContinue | Where-Object {
         $PSItem.Enabled -ne $true
      } | Enable-NetFirewallRule @paramEnableNetFirewallRule
   }
}

