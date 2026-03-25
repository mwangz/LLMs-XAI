[CmdletBinding(ConfirmImpact = 'Low',
   SupportsShouldProcess)]
param
(
   [Parameter(Mandatory,
      ValueFromPipeline,
      ValueFromPipelineByPropertyName,
      Position = 0,
      HelpMessage = 'Username to apply the exclusion to.')]
   [ValidateNotNullOrEmpty()]
   [Alias('User', 'Name')]
   [string]
   $Username
)

begin
{
   $ExcludePathList = @(
      ('C:\Users\' + $Username + '\Microsoft\Teams\Update.exe'),
      ('C:\Users\' + $Username + '\Microsoft\Teams\current\Teams.exe'),
      ('C:\Users\' + $Username + '\Microsoft\Teams\'),
      ('C:\Users\' + $Username + '\Microsoft\Teams\')
   )
}

process
{
   foreach ($ExcludePath in $ExcludePathList)
   {
      try
      {
         $SplatAddMpPreference = @{
            ExclusionPath = $ExcludePath
            Force         = $true
            ErrorAction   = 'Stop'
            WarningAction = 'Continue'
         }
         $null = (Add-MpPreference @SplatAddMpPreference)
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

         Write-Warning -Message ($info.Exception) -ErrorAction Continue -WarningAction Continue

         $info = $null
         $e = $null
      }
   }
}

