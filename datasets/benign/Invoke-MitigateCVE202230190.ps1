[CmdletBinding(ConfirmImpact = 'Low')]
param ()

begin
{
   $RegistryRoot = $null

   $paramGetPSDrive = @{
      ErrorAction   = 'SilentlyContinue'
      WarningAction = 'SilentlyContinue'
   }
   $RegistryRoot = ((Get-PSDrive @paramGetPSDrive | Where-Object {
            $PSItem.Root -eq 'HKEY_CLASSES_ROOT'
         }).Name)
   $paramGetPSDrive = $null

   if (-not ($RegistryRoot))
   {
      $paramNewPSDrive = @{
         PSProvider  = 'registry'
         Root        = 'HKEY_CLASSES_ROOT'
         Name        = 'HKCR'
         ErrorAction = 'Stop'
      }
      $RegistryRoot = ((New-PSDrive @paramNewPSDrive).Name)
      $paramNewPSDrive = $null
   }
}

process
{
   try
   {
      $paramRemoveItem = @{
         Path        = ('{0}:\ms-msdt' -f $RegistryRoot)
         Force       = $true
         Recurse     = $true
         ErrorAction = 'Stop'
      }
      $null = (Remove-Item @paramRemoveItem)
      $paramRemoveItem = $null
   }
   catch
   {
      [Management.Automation.ErrorRecord]$e = $_

      $info = [PSCustomObject]@{
         Exception = $e.Exception.Message
         Reason    = $e.CategoryInfo.Reason
         Target    = $e.CategoryInfo.TargetName
         Script    = $e.InvocationInfo.ScriptName
         Line      = $e.InvocationInfo.ScriptLineNumber
         Column    = $e.InvocationInfo.OffsetInLine
      }

      Write-Warning -Message $info -WarningAction Stop

      exit 1
   }
}

end
{
   Write-Output -InputObject 'CVE-2022-30190 workaround was applied!'

   exit 0
}
