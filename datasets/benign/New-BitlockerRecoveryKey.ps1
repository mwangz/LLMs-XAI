[CmdletBinding(ConfirmImpact = 'Low')]
param ()

begin
{
   $LogName = 'Application'
   $STP = 'Stop'
   $SCT = 'SilentlyContinue'
   $LogSource = 'enAutomate'

   $null = (New-EventLog -LogName $LogName -Source $LogSource -ErrorAction $SCT)
}

process
{
   $BitLockerVolumeInfo = (Get-BitLockerVolume | Where-Object -FilterScript {
         $PSItem.VolumeType -eq 'OperatingSystem'
      })

   $BootDrive = $BitLockerVolumeInfo.MountPoint

   $KeyProtectors = $BitLockerVolumeInfo.KeyProtector

   if (($BitLockerVolumeInfo.VolumeStatus -eq 'FullyDecrypted') -or ($BitLockerVolumeInfo.ProtectionStatus -eq 'Off') -or (-not ($KeyProtectors)))
   {
      Write-Warning -Message ('Please Exceute: "Enable-BitLocker -MountPoint  {0}"' -f $BootDrive)
      break
   }
   else
   {
      foreach ($KeyProtector in $KeyProtectors)
      {
         if ($KeyProtector.KeyProtectorType -eq 'RecoveryPassword')
         {
            try
            {
               $null = (Remove-BitLockerKeyProtector -MountPoint $BootDrive -KeyProtectorId $KeyProtector.KeyProtectorId -ErrorAction $STP)

               $null = (Add-BitLockerKeyProtector -MountPoint $BootDrive -RecoveryPasswordProtector -WarningAction SilentlyContinue)

               $InfoText = 'Changed the BitLocker Recovery Password for ' + $BootDrive + ' successfully'
               Write-EventLog -LogName $LogName -Source $LogSource -EntryType Information -EventId 1000 -Message $InfoText
               Write-Output -InputObject $InfoText
            }
            catch
            {
               [Management.Automation.ErrorRecord]$e = $_

               $info = @{
                  Exception = $e.Exception.Message
                  Reason    = $e.CategoryInfo.Reason
                  Target    = $e.CategoryInfo.TargetName
                  Script    = $e.InvocationInfo.ScriptName
                  Line      = $e.InvocationInfo.ScriptLineNumber
                  Column    = $e.InvocationInfo.OffsetInLine
               }

               $info | Out-String | Write-Verbose

               $null = (Write-EventLog -LogName $LogName -Source $LogSource -EntryType Error -EventId 1001 -Message ($info.Exception) -ErrorAction $SCT)

               $paramWriteError = @{
                  Message       = ($info.Exception)
                  Exception     = $info.Exception
                  TargetObject  = $info.Target
                  ErrorAction   = $STP
                  WarningAction = 'Continue'
               }
               Write-Error @paramWriteError
            }
         }
      }
   }
}

