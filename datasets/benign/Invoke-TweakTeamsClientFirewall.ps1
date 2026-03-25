[CmdletBinding(ConfirmImpact = 'Low',
   SupportsShouldProcess)]
param ()

begin
{
   Write-Output -InputObject 'Tweak the Firewall Rules for Microsoft Teams clients for all users that have it installed'

   $SCT = 'SilentlyContinue'
}

process
{
   $AllUsers = $null

   $paramJoinPath = @{
      Path        = $env:SystemDrive
      ChildPath   = 'Users'
      ErrorAction = $SCT
   }
   $paramGetChildItem = @{
      Path        = (Join-Path @paramJoinPath)
      ErrorAction = $SCT
      Exclude     = 'Public', 'ADMINI~*'
   }
   $AllUsers = (Get-ChildItem @paramGetChildItem)

   if ($null -ne $AllUsers)
   {
      foreach ($SingleUser in $AllUsers)
      {
         $FullTeamsPath = $null

         $paramJoinPath = @{
            Path        = $SingleUser.FullName
            ChildPath   = 'AppData\Local\Microsoft\Teams\Current\Teams.exe'
            ErrorAction = $SCT
         }
         $FullTeamsPath = (Join-Path @paramJoinPath)

         $paramTestPath = @{
            Path        = $FullTeamsPath
            ErrorAction = $SCT
         }
         if (Test-Path @paramTestPath)
         {
            $paramGetNetFirewallApplicationFilter = @{
               Program     = $FullTeamsPath
               ErrorAction = $SCT
            }
            if (-not (Get-NetFirewallApplicationFilter @paramGetNetFirewallApplicationFilter))
            {
               $NetFirewallRuleName = $null

               $NetFirewallRuleName = ('Teams.exe for user {0}' -f $SingleUser.Name)

               'UDP', 'TCP' | ForEach-Object -Process {
                  $paramNewNetFirewallRule = @{
                     DisplayName = $NetFirewallRuleName
                     Direction   = 'Inbound'
                     Profile     = 'Any'
                     Program     = $FullTeamsPath
                     Action      = 'Allow'
                     Protocol    = $_
                     Enabled     = 'True'
                     Confirm     = $false
                     ErrorAction = $SCT
                  }
                  $null = (New-NetFirewallRule @paramNewNetFirewallRule)
               }

               $NetFirewallRuleName = $null
            }
         }

         $FullTeamsPath = $null
      }
   }
}

