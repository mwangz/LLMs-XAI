[CmdletBinding(ConfirmImpact = 'Low')]
param ()

begin
{
   Write-Output -InputObject 'Set the Windows Power Plan to Auto'

   $SCT = 'SilentlyContinue'

   $paramGetWmiObject = @{
      Namespace   = 'root\cimv2\power'
      Class       = 'Win32_PowerPlan'
      ErrorAction = $SCT
   }

   if (Get-Command -Name 'Set-MpPreference' -ErrorAction $SCT)
   {
      $null = (Set-MpPreference -EnableControlledFolderAccess Disabled -Force -ErrorAction $SCT)
   }

   function Get-ActiveWindowsPowerPlan
   {
      [CmdletBinding(ConfirmImpact = 'None')]
      [OutputType([string])]
      param
      (
         [Parameter(Mandatory,
            ValueFromPipeline,
            ValueFromPipelineByPropertyName,
            Position = 0,
            HelpMessage = 'Object with all Power Plans')]
         [ValidateNotNullOrEmpty()]
         [psobject]
         $AllPowerPlans
      )

      begin
      {
         $ActivePowerPlan = $null
      }

      process
      {
         $ActivePowerPlan = ($AllPowerPlans | Where-Object -FilterScript {
               $PSItem.IsActive -eq $true
            } | Select-Object -ExpandProperty ElementName)
      }

      end
      {
         $ActivePowerPlan
      }
   }
}

process
{
   $AllPowerPlans = (Get-WmiObject @paramGetWmiObject | Select-Object -Property ElementName, InstanceID, IsActive)

   $ActivePowerPlan = (Get-ActiveWindowsPowerPlan -AllPowerPlans $AllPowerPlans -ErrorAction $SCT)

   Write-Verbose -Message ('Active Power Plan: {0}' -f $ActivePowerPlan)

   if ((($AllPowerPlans).ElementName) -ccontains 'Parallels')
   {
      $RunOnParallels = ($AllPowerPlans | Where-Object {
            $PSItem.ElementName -ccontains 'Parallels'
         } | Select-Object -ExpandProperty InstanceID)

      $RunOnParallels = ([Regex]::Matches($RunOnParallels, '(?<={)(.*?)(?=})') | Select-Object -ExpandProperty Value)

      $null = (& "$env:windir\system32\powercfg.exe" /SETACTIVE $RunOnParallels)

      $null = (& "$env:windir\system32\powercfg.exe" /HIBERNATE OFF)
   }
   elseif ((Get-CimInstance -ClassName Win32_ComputerSystem -ErrorAction $SCT).PCSystemType -eq 2)
   {
      $null = (& "$env:windir\system32\powercfg.exe" /SETACTIVE SCHEME_BALANCED)
      $null = (& "$env:windir\system32\powercfg.exe" /HIBERNATE ON)
   }
   else
   {
      $null = (& "$env:windir\system32\powercfg.exe" /SETACTIVE SCHEME_MIN)
      $null = (& "$env:windir\system32\powercfg.exe" /HIBERNATE OFF)
   }

   $AllPowerPlans = (Get-WmiObject @paramGetWmiObject | Select-Object -Property ElementName, InstanceID, IsActive)

   $ActivePowerPlan = (Get-ActiveWindowsPowerPlan -AllPowerPlans $AllPowerPlans -ErrorAction $SCT)

   Write-Verbose -Message ('Active Power Plan: {0}' -f $ActivePowerPlan)
}

end
{
   if (Get-Command -Name 'Set-MpPreference' -ErrorAction $SCT)
   {
      $null = (Set-MpPreference -EnableControlledFolderAccess Enabled -Force -ErrorAction $SCT)
   }
}

