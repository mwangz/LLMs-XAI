function Get-DsRegStatusInfo
{
   [CmdletBinding(ConfirmImpact = 'None')]
   [OutputType([psobject])]
   param ()

   begin
   {
      $DsRegCmdPlain = (& "$env:windir\system32\dsregcmd.exe" /status)
      $DsRegStatusInfo = (New-Object -TypeName PSObject)
   }

   process
   {
      $DsRegCmdPlain | Select-String -Pattern ' *[A-z]+ : [A-z]+ *' | ForEach-Object -Process {
         $null = (Add-Member -InputObject $DsRegStatusInfo -MemberType NoteProperty -Name (([String]$_).Trim() -split ' : ')[0] -Value (([String]$_).Trim() -split ' : ')[1] -ErrorAction SilentlyContinue)
      }
   }

   end
   {
      $DsRegStatusInfo
   }
}

