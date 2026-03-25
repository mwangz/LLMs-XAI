[CmdletBinding(ConfirmImpact = 'Low',
   SupportsShouldProcess)]
param
(
   [Parameter(ValueFromPipeline,
      ValueFromPipelineByPropertyName)]
   [Alias('AppName')]
   [string]
   $AppPathNameMatchCondition = $null
)

begin
{
   $AppSharingPolicy = 'MTR AppSharing'
   $VideoPolicy = 'MTR Video'
   $AudioPoliy = 'MTR Audio'
}

process
{
   if ($pscmdlet.ShouldProcess('QoS-Settings', 'Apply'))
   {
      $paramGetNetQosPolicy = @{
         Name          = $AudioPoliy
         ErrorAction   = $SCT
         WarningAction = $SCT
      }
      if (-not (Get-NetQosPolicy @paramGetNetQosPolicy))
      {
         try
         {
            $paramNewNetQosPolicy = @{
               NetworkProfile               = 'All'
               IPSrcPortStartMatchCondition = 50000
               IPSrcPortEndMatchCondition   = 50019
               DSCPAction                   = 46
               IPProtocolMatchCondition     = 'Both'
               Name                         = $AudioPoliy
               Confirm                      = $false
               WarningAction                = $CNT
               ErrorAction                  = $STP
            }

            if ($AppPathNameMatchCondition)
            {
               $paramNewNetQosPolicy.Add('AppPathNameMatchCondition', $AppPathNameMatchCondition)
            }

            $null = (New-NetQosPolicy @paramNewNetQosPolicy)
         }
         catch
         {
            Write-Warning -Message ('Unable to apply {0} QoS Poliy' -f $AudioPoliy)
         }
      }

      $paramGetNetQosPolicy = @{
         Name          = $VideoPolicy
         ErrorAction   = $SCT
         WarningAction = $SCT
      }
      if (-not (Get-NetQosPolicy @paramGetNetQosPolicy))
      {
         try
         {
            $paramNewNetQosPolicy = @{
               NetworkProfile               = 'All'
               IPSrcPortStartMatchCondition = 50020
               IPSrcPortEndMatchCondition   = 50039
               DSCPAction                   = 34
               IPProtocolMatchCondition     = 'Both'
               Name                         = $VideoPolicy
               Confirm                      = $false
               WarningAction                = $CNT
               ErrorAction                  = $STP
            }

            if ($AppPathNameMatchCondition)
            {
               $paramNewNetQosPolicy.Add('AppPathNameMatchCondition', $AppPathNameMatchCondition)
            }

            $null = (New-NetQosPolicy @paramNewNetQosPolicy)
         }
         catch
         {
            Write-Warning -Message ('Unable to apply {0} QoS Poliy' -f $VideoPolicy)
         }
      }

      $paramGetNetQosPolicy = @{
         Name          = $AppSharingPolicy
         ErrorAction   = $SCT
         WarningAction = $SCT
      }
      if (-not (Get-NetQosPolicy @paramGetNetQosPolicy))
      {
         try
         {
            $paramNewNetQosPolicy = @{
               NetworkProfile               = 'All'
               IPSrcPortStartMatchCondition = 50040
               IPSrcPortEndMatchCondition   = 50059
               DSCPAction                   = 28
               IPProtocolMatchCondition     = 'Both'
               Name                         = $AppSharingPolicy
               Confirm                      = $false
               WarningAction                = $CNT
               ErrorAction                  = $STP
            }

            if ($AppPathNameMatchCondition)
            {
               $paramNewNetQosPolicy.Add('AppPathNameMatchCondition', $AppPathNameMatchCondition)
            }

            $null = (New-NetQosPolicy @paramNewNetQosPolicy)
         }
         catch
         {
            Write-Warning -Message ('Unable to apply {0} QoS Poliy' -f $AppSharingPolicy)
         }
      }
   }
}

