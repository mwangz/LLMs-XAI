[CmdletBinding(ConfirmImpact = 'Low')]
param
(
   [Parameter(ValueFromPipeline,
   ValueFromPipelineByPropertyName)]
   [ValidateSet('Soft', 'Hard', 'None', 'Delayed', IgnoreCase = $true)]
   [String]
   $Reboot = 'Soft',
   [Parameter(ValueFromPipeline,
   ValueFromPipelineByPropertyName)]
   [ValidateNotNullOrEmpty()]
   [int]
   $RebootTimeout = 120
)

begin
{
   $needReboot = $False
   $TimeStampFormat = 'yyyy/MM/dd hh:mm:ss tt'
   $WUSMServiceID = '7971f918-a847-4430-9279-4a52d1efe18d'

   if (!(Get-Module -ListAvailable -Name PSWindowsUpdate))
   {
      $TimeStamp = (Get-Date -Format $TimeStampFormat)
      Write-Host -Object ('{0} Start the installation of the required PSWindowsUpdate module' -f $TimeStamp)

      $paramInstallPackageProvider = @{
         Name        = 'NuGet'
         Force       = $true
         ErrorAction = 'Stop'
      }
      $null = (Install-PackageProvider @paramInstallPackageProvider)
      $paramInstallModule = @{
         Force              = $true
         Scope              = 'AllUsers'
         SkipPublisherCheck = $true
         AllowClobber       = $true
         Name               = 'PSWindowsUpdate'
         ErrorAction        = 'Stop'
      }
      $null = (Install-Module @paramInstallModule)
      $paramImportModule = @{
         Name        = 'PSWindowsUpdate'
         Force       = $true
         ErrorAction = 'Stop'
      }
      $null = (Import-Module @paramImportModule)

      $TimeStamp = (Get-Date -Format $TimeStampFormat)
      Write-Host -Object ('{0} Done with the installation of the required PSWindowsUpdate module' -f $TimeStamp)
   }

   if (!(Get-WUServiceManager -ServiceID $WUSMServiceID -ErrorAction SilentlyContinue | Where-Object -FilterScript {
            ($_.IsDefaultAUService -eq $true)
   }))
   {
      $TimeStamp = (Get-Date -Format $TimeStampFormat)
      Write-Host -Object ('{0} Start the WUServiceManager Setup' -f $TimeStamp)

      $paramAddWUServiceManager = @{
         ServiceID      = $WUSMServiceID
         AddServiceFlag = 7
         Confirm        = $False
         ErrorAction    = 'Stop'
         WarningAction  = 'SilentlyContinue'
      }
      $null = (Add-WUServiceManager @paramAddWUServiceManager)

      $TimeStamp = (Get-Date -Format $TimeStampFormat)
      Write-Host -Object ('{0} Done with the WUServiceManager Setup' -f $TimeStamp)


      $needReboot = (Get-WURebootStatus -Silent)
   }
}

process
{
   $TimeStamp = (Get-Date -Format $TimeStampFormat)
   Write-Host -Object ('{0} Start the Microsoft Update process' -f $TimeStamp)

   $paramGetWindowsUpdate = @{
      MicrosoftUpdate = $true
      AcceptAll       = $true
      IgnoreReboot    = $true
      Confirm         = $False
      ErrorAction     = 'Stop'
      WarningAction   = 'SilentlyContinue'
   }
   (Get-WindowsUpdate @paramGetWindowsUpdate | Select-Object -Property Title, KB, Result)

   $needReboot = (Get-WURebootStatus -Silent)

   $TimeStamp = (Get-Date -Format $TimeStampFormat)
   Write-Host -Object ('{0} Done with the Microsoft Update process' -f $TimeStamp)
}

end
{
   $TimeStamp = (Get-Date -Format $TimeStampFormat)

   if ($needReboot)
   {
      Write-Host -Object ('{0} PSWindowsUpdate indicated that a reboot is needed' -f $TimeStamp)

      if ($null -eq $Reboot)
      {
         if ($Reboot -eq 'None')
         {
            $Reboot = 'Soft'
         }
      }
   }
   else
   {
      Write-Host -Object ('{0} PSWindowsUpdate indicated that no reboot is required' -f $TimeStamp)

      $Reboot = 'None'
   }

   $TimeStamp = (Get-Date -Format $TimeStampFormat)

   if ($Reboot -eq 'Hard')
   {
      Write-Host -Object ('{0} Exiting with return code 1641 to indicate a hard reboot is needed' -f $TimeStamp)
      exit 1641
   }
   elseif ($Reboot -eq 'Soft')
   {
      Write-Host -Object ('{0} Exiting with return code 3010 to indicate a soft reboot is needed' -f $TimeStamp)
      exit 3010
   }
   elseif ($Reboot -eq 'Delayed')
   {
      Write-Host -Object ('{0} Rebooting with a {1} second delay' -f $TimeStamp, $RebootTimeout)
      & "$env:windir\system32\shutdown.exe" /r /t $RebootTimeout /c 'Rebooting to complete the installation of Microsoft updates'
      exit 0
   }
   else
   {
      Write-Host -Object ('{0} Skipping reboot based on Reboot parameter (None), or because no reboot is required' -f $TimeStamp)
      exit 0
   }
}
