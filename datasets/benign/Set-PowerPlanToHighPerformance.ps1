[CmdletBinding(ConfirmImpact = 'Low')]
param ()

process
{
   $ActivePowerPlan = $null
   $PowerPlanHighPowerState = $null
   $paramGetWmiObject = @{
      Namespace = 'root\cimv2\power'
      Class     = 'Win32_PowerPlan'
   }

   $ActivePowerPlan = (Get-WmiObject @paramGetWmiObject | Select-Object -Property ElementName, IsActive)

   $PowerPlanHighPowerState = $ActivePowerPlan | Where-Object -FilterScript {
      $PSItem.ElementName -eq 'High Performance'
   }

   if ($PowerPlanHighPowerState.IsActive -ne $true)
   {
      $paramGetWmiObject.Filter = "ElementName = 'High Performance'"
      $powerPlan = (Get-WmiObject @paramGetWmiObject)

      $null = (Invoke-Command -ScriptBlock {
            $powerPlan.Activate()
         } -ErrorAction SilentlyContinue)

   }

   $PowerPlanHighPowerState = $null

   $PowerPlanHighPowerState = $ActivePowerPlan | Where-Object -FilterScript {
      $PSItem.ElementName -eq 'High Performance'
   }

   if ($PowerPlanHighPowerState.IsActive -ne $true)
   {
      Write-Warning -Message "Unable to set the PowerPlan to 'High Performance'"
   }

   & "$env:windir\system32\powercfg.cpl" -change -standby-timeout-ac 0
   & "$env:windir\system32\powercfg.cpl" -change -hibernate-timeout-ac 0

}

