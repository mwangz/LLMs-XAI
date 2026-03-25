function Update-UnifiedGroupsToTeams
{
   [CmdletBinding(ConfirmImpact = 'Low')]
   param
   (
      [Parameter(ValueFromPipeline,
         ValueFromPipelineByPropertyName,
         Position = 0)]
      [Alias('DryRun')]
      [switch]
      $ReportOnly
   )

   begin
   {
      $CNT = 'Continue'
      $STP = 'Stop'

      try
      {
         if (-not (Get-Command -Name Get-UnifiedGroup -ErrorAction SilentlyContinue))
         {
            $ErrorParameter = @{
               Message           = 'Please connect to Office 365/Exchange Online before using this function!'
               Category          = 'ResourceUnavailable'
               RecommendedAction = 'Connect to Office 365/Exchange Online before using this function'
               ErrorAction       = $STP
            }
            Write-Error @ErrorParameter
         }

         $GetUnifiedGroupParameter = @{
            ResultSize    = 'Unlimited'
            ErrorAction   = $STP
            WarningAction = $CNT
         }
         $AllOffice365UnifiedGroups = (Get-UnifiedGroup @GetUnifiedGroupParameter | Select-Object -Property DisplayName, ExternalDirectoryObjectId)

         $GetTeamParameter = @{
            ErrorAction   = $STP
            WarningAction = $CNT
         }
         $AllMicrosoftTeams = (Get-Team @GetTeamParameter | Select-Object -ExpandProperty GroupId)
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

         Write-Warning -Message ($info | Out-String)

         Write-Error -Message $info.Exception -Exception $info.Exception -ErrorAction $STP

         break
      }
   }

   process
   {
      if ($AllOffice365UnifiedGroups)
      {
         foreach ($Office365UnifiedGroup in $AllOffice365UnifiedGroups)
         {
            if (-not ($AllMicrosoftTeams -match $Office365UnifiedGroup.ExternalDirectoryObjectId))
            {
               if ($ReportOnly)
               {
                  $SingleOffice365UnifiedGroup = $Office365UnifiedGroup.DisplayName
                  Write-Output -InputObject ('Microsoft Teams for Unified Group {0} is missing' -f $SingleOffice365UnifiedGroup)
                  #endregion ReportOnly
               }
               else
               {
                  Write-Verbose -Message ('Create Microsoft Teams Team for Unified Group {0}' -f $SingleOffice365UnifiedGroup)

                  try
                  {
                     $NewTeamParameter = @{
                        Group         = $Office365UnifiedGroup
                        ErrorAction   = $STP
                        WarningAction = $CNT
                     }
                     $NewTeam = (New-Team @NewTeamParameter)

                     Write-Debug -Message $NewTeam

                     Write-Verbose -Message ('Created Microsoft Teams Team for Unified Group {0}' -f $SingleOffice365UnifiedGroup)
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

                     $TheException = $info.Exception

                     Write-Warning -Message ('Microsoft Teams creation for {0} failed with {1} ' -f $SingleOffice365UnifiedGroup, $TheException)

                     Write-Verbose -Message ($info | Out-String)
                  }
               }
            }
         }
      }
      else
      {
         Write-Warning -Message 'No Unified Groups found in your Tenant...'
      }
   }

   end
   {
      Write-Verbose -Message 'Done.'
   }
}

