[CmdletBinding(ConfirmImpact = 'Low',
               SupportsShouldProcess)]
[OutputType([string])]
param ()

begin
{
   $RegistryValue = 'https://teams.microsoft.com'

   $AllPolicies = @(
      'HKLM:\SOFTWARE\Policies\Microsoft\Edge\VideoCaptureAllowedUrls'
      'HKLM:\SOFTWARE\Policies\Microsoft\Edge\AudioCaptureAllowedUrls'
      'HKLM:\SOFTWARE\Policies\Google\Chrome\VideoCaptureAllowedUrls'
      'HKLM:\SOFTWARE\Policies\Google\Chrome\AudioCaptureAllowedUrls'
      'HKLM:\SOFTWARE\Policies\BraveSoftware\Brave\VideoCaptureAllowedUrls'
      'HKLM:\SOFTWARE\Policies\BraveSoftware\Brave\AudioCaptureAllowedUrls'
   )
}

process
{
   foreach ($RegistryPath in $AllPolicies)
   {
      $RegistryName = $null
      if (-not (Test-Path -Path $RegistryPath -ErrorAction SilentlyContinue))
      {
         if ($pscmdlet.ShouldProcess($RegistryPath, 'create'))
         {
            $paramNewItem = @{
               Path        = $RegistryPath
               Force       = $true
               Confirm     = $false
               ErrorAction = 'SilentlyContinue'
            }
            $null = (New-Item @paramNewItem)
         }

         $RegistryName = 1
      }
      else
      {
         (Get-Item -Path $RegistryPath).Property | ForEach-Object {
            if ((Get-ItemPropertyValue -Path $RegistryPath -Name $_) -contains $RegistryValue)
            {
               $SkipEntry = $true

               return
            }
            else
            {
               $SkipEntry = $null
            }
         }
      }

      if (-not $SkipEntry)
      {
         if (-not ($RegistryName))
         {
            1 .. 20 | ForEach-Object -Process {
               if ((-not $RegistryName) -and (-not (Get-ItemProperty -Path $RegistryPath -Name $_ -ErrorAction SilentlyContinue)))
               {
                  $RegistryName = $_
               }
            }
         }

         if ($pscmdlet.ShouldProcess(('{0} in {1} with value {2}' -f $RegistryName, $RegistryPath, $RegistryValue), 'create'))
         {
            $paramNewItemProperty = @{
               Path         = $RegistryPath
               Name         = $RegistryName
               Value        = $RegistryValue
               PropertyType = 'String'
               Force        = $true
               Confirm      = $false
               ErrorAction  = 'SilentlyContinue'
            }
            $null = (New-ItemProperty @paramNewItemProperty)
         }

         $SkipEntry = $null
      }
      else
      {
         $SkipEntry = $null
      }
   }
}
