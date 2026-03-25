[CmdletBinding(DefaultParameterSetName = 'Default',
   ConfirmImpact = 'Low')]
[OutputType([bool])]
param
(
   [Parameter(ParameterSetName = 'Report',
      ValueFromPipeline,
      ValueFromPipelineByPropertyName)]
   [Alias('ReportOnly')]
   [switch]
   $Report,
   [Parameter(ParameterSetName = 'Mitigate',
      ValueFromPipeline,
      ValueFromPipelineByPropertyName)]
   [Alias('MitigateCVE')]
   [switch]
   $Mitigate,
   [Parameter(ParameterSetName = 'Default',
      ValueFromPipeline,
      ValueFromPipelineByPropertyName)]
   [Alias('Revert', 'RevertToDefault')]
   [switch]
   $Default
)

begin
{
   $RegistryValue = 'EnableTrailerSupport'
   $RegistryPath = 'HKLM:\System\CurrentControlSet\Services\HTTP\Parameters\'

   $IsEffected = $false
}

process
{
   $paramGetItemProperty = @{
      Path        = $RegistryPath
      Name        = $RegistryValue
      ErrorAction = 'SilentlyContinue'
   }
   if (((Get-ItemProperty @paramGetItemProperty ).EnableTrailerSupport) -eq 1)
   {
      $IsEffected = $true
   }
   $paramGetItemProperty = $null

   if ($IsEffected -eq $true)
   {
      Write-Warning -Message ('{0} might be vulnerable to CVE-2022-21907!!!' -f $env:COMPUTERNAME)

      try
      {
         if ($PSBoundParameters.ContainsKey('Mitigate'))
         {
            $paramSetItemProperty = @{
               Path        = $RegistryPath
               Name        = $RegistryValue
               Value       = '00000000'
               WhatIf      = $false
               Force       = $true
               Confirm     = $false
               ErrorAction = 'Stop'
            }
            $null = (Set-ItemProperty @paramSetItemProperty)
            $paramSetItemProperty = $null
         }
         elseif ($PSBoundParameters.ContainsKey('Default'))
         {
            $paramRemoveItemProperty = @{
               Path        = $RegistryPath
               Name        = $RegistryValue
               WhatIf      = $false
               Force       = $true
               Confirm     = $false
               ErrorAction = 'Stop'
            }
            $null = (Remove-ItemProperty @paramRemoveItemProperty)
            $paramRemoveItemProperty = $null
         }
         else
         {
            $IsEffected
         }
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

         $info | Out-String | Write-Verbose

         Write-Warning -Message $info.Exception
      }
   }
   else
   {
      $IsEffected
   }
}

end
{
   $IsEffected = $null
   $RegistryValue = $null
   $RegistryPath = $null
}
