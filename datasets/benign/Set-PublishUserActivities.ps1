function Set-PublishUserActivities
{
   [CmdletBinding(ConfirmImpact = 'None',
      SupportsShouldProcess)]
   param
   (
      [Parameter(ValueFromPipeline,
         ValueFromPipelineByPropertyName,
         Position = 1)]
      [switch]
      $enable = $false
   )

   begin
   {
      $RegistryPath = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\System'
      $RegistryName = 'PublishUserActivities'

      if ($enable)
      {
         $RegistryValue = '1'
         $SetAction = 'Enable'
         Write-Verbose -Message 'Enable the collection of Activity History'
      }
      else
      {
         $RegistryValue = '0'
         $SetAction = 'Disable'
         Write-Verbose -Message 'Disable the collection of Activity History'
      }
   }

   process
   {
      if ($pscmdlet.ShouldProcess('Collection of Activity History', $SetAction))
      {
         try
         {
            $SetPublishUserActivitiesParams = @{
               Path          = $RegistryPath
               Name          = $RegistryName
               Value         = $RegistryValue
               PropertyType  = 'DWORD'
               Force         = $true
               Confirm       = $false
               ErrorAction   = 'Stop'
               WarningAction = 'SilentlyContinue'
            }
            $null = (New-ItemProperty @SetPublishUserActivitiesParams)
            Write-Verbose -Message 'Collection of Activity History value modified.'
         }
         catch
         {
            Write-Warning -Message 'Unable to modify the collection of Activity History value!'
         }
      }
   }
}

