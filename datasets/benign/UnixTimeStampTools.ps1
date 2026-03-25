function ConvertFrom-UnixTimeStamp
{
   [CmdletBinding(ConfirmImpact = 'None')]
   [OutputType([datetime])]
   param
   (
      [Parameter(Mandatory,
         ValueFromPipeline,
         Position = 0,
         HelpMessage = 'Timestamp (Epochdate)')]
      [ValidateNotNullOrEmpty()]
      [Alias('Epochdate')]
      [long]
      $TimeStamp,
      [Parameter(ValueFromPipeline,
         ValueFromPipelineByPropertyName,
         Position = 1)]
      [Alias('UniFi')]
      [switch]
      $Milliseconds = $false
   )

   begin
   {
      $UnixStartTime = '1/1/1970'
      $Result = $null
   }

   process
   {
      try
      {
         if ($Milliseconds)
         {
            $Result = ((Get-Date -Date $UnixStartTime -ErrorAction Stop -WarningAction SilentlyContinue).AddMilliseconds($TimeStamp))
         }
         else
         {
            try
            {
               $Result = ((Get-Date -Date $UnixStartTime -ErrorAction Stop -WarningAction SilentlyContinue).AddSeconds($TimeStamp))
            }
            catch
            {
               $Result = ((Get-Date -Date $UnixStartTime -ErrorAction Stop -WarningAction SilentlyContinue).AddMilliseconds($TimeStamp))
            }
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

         Write-Error -Message ($info.Exception) -ErrorAction Stop
         break
      }
   }

   end
   {
      $Result
   }
}

function ConvertTo-UnixTimeStamp
{
   [CmdletBinding(ConfirmImpact = 'None')]
   [OutputType([long])]
   param
   (
      [Parameter(ValueFromPipeline,
         ValueFromPipelineByPropertyName,
         Position = 0)]
      [ValidateNotNullOrEmpty()]
      [Alias('TimeStamp', 'DateTimeStamp')]
      [datetime]
      $Date = (Get-Date),
      [Parameter(ValueFromPipeline,
         ValueFromPipelineByPropertyName,
         Position = 1)]
      [Alias('UniFi')]
      [switch]
      $Milliseconds = $false
   )

   begin
   {
      $UnixStartTime = '1/1/1970'
      $Result = $null
   }

   process
   {
      try
      {
         if ($Milliseconds)
         {
            $Result = ([long]((New-TimeSpan -Start (Get-Date -Date $UnixStartTime -ErrorAction Stop -WarningAction SilentlyContinue) -End (Get-Date -Date $Date -ErrorAction Stop -WarningAction SilentlyContinue) -ErrorAction Stop -WarningAction SilentlyContinue).TotalMilliseconds))
         }
         else
         {
            $Result = ([long]((New-TimeSpan -Start (Get-Date -Date $UnixStartTime -ErrorAction Stop -WarningAction SilentlyContinue) -End (Get-Date -Date $Date -ErrorAction Stop -WarningAction SilentlyContinue) -ErrorAction Stop -WarningAction SilentlyContinue).TotalSeconds))
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

         Write-Error -Message ($info.Exception) -ErrorAction Stop

         break
      }
   }

   end
   {
      $Result
   }
}

