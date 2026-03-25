[CmdletBinding(ConfirmImpact = 'Medium',
   SupportsShouldProcess = $true)]
param ()

begin
{
   $STP = 'SilentlyContinue'

   $TransportAgentsToRemove = 'Content Filter Agent', 'Sender Id Agent', 'Protocol Analysis Agent'
}

process
{
   foreach ($TransportAgentToRemove in $TransportAgentsToRemove)
   {
      if (Get-TransportAgent -Identity $TransportAgentToRemove -ErrorAction $STP -WarningAction $STP)
      {
         Write-Verbose -Message "Try to remove $TransportAgentToRemove"

         try
         {
            if ($pscmdlet.ShouldProcess("$TransportAgentToRemove", 'Remove TransportAgent'))
            {
                $paramUninstallTransportAgent = @{
                  Identity      = $TransportAgentToRemove
                  ErrorAction   = $STP
                  WarningAction = $STP
                  Confirm       = $false
               }
               $null = (Uninstall-TransportAgent @paramUninstallTransportAgent)
            }
         }
         catch
         {
            Write-Warning -Message "Unable to remove $TransportAgentToRemove"
         }

         Write-Verbose -Message "$TransportAgentToRemove was removed"
      }
      else
      {
         Write-Verbose -Message "Sorry, $TransportAgentToRemove was not found..."
      }
   }

}


