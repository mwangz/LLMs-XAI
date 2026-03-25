[CmdletBinding(ConfirmImpact = 'Low')]
param ()

process
{
   $paramGetAzureADDevice = @{
      All           = $true
      ErrorAction   = 'SilentlyContinue'
      WarningAction = 'SilentlyContinue'
   }
   $null = ((Get-AzureADDevice @paramGetAzureADDevice) | ForEach-Object -Process {
         $paramGetAzureADDevice = @{
            ObjectId      = $PSItem.ObjectId
            ErrorAction   = 'SilentlyContinue'
            WarningAction = 'SilentlyContinue'
         }
         $paramGetAzureADDeviceRegisteredOwner = @{
            ErrorAction   = 'SilentlyContinue'
            WarningAction = 'SilentlyContinue'
         }
         if (-not (Get-AzureADDevice @paramGetAzureADDevice | Get-AzureADDeviceRegisteredOwner @paramGetAzureADDeviceRegisteredOwner))
         {
            try
            {
               $paramSetAzureADDevice = @{
                  ObjectId       = $PSItem.ObjectId
                  AccountEnabled = $false
                  IsCompliant    = $false
                  IsManaged      = $false
                  Verbose        = $true
                  ErrorAction    = 'SilentlyContinue'
                  WarningAction  = 'SilentlyContinue'
               }
               $null = (Set-AzureADDevice @paramSetAzureADDevice)
            }
            catch
            {
               Write-Verbose -Message 'OK'
            }

            try
            {
               $paramRemoveAzureADDevice = @{
                  ObjectId      = $PSItem.ObjectId
                  Verbose       = $true
                  ErrorAction   = 'SilentlyContinue'
                  WarningAction = 'SilentlyContinue'
               }
               $null = (Remove-AzureADDevice @paramRemoveAzureADDevice)
            }
            catch
            {
               Write-Verbose -Message 'OK'
            }
         }
      })
}
