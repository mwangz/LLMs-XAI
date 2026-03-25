function Clear-EnAllEventLogs
{
   [CmdletBinding(ConfirmImpact = 'Medium',
      SupportsShouldProcess)]
   param
   (
      [Parameter(ValueFromPipeline,
         ValueFromPipelineByPropertyName)]
      [string[]]
      $ComputerName = "$env:COMPUTERNAME"
   )

   process
   {

      foreach ($SingleComputerName in $ComputerName)
      {
         if ($pscmdlet.ShouldProcess($SingleComputerName, 'Cleanup All EventLogs'))
         {
            $paramGetEventLog = @{
               ComputerName = $SingleComputerName
               List         = $true
            }
            $null = (Get-EventLog @paramGetEventLog | ForEach-Object -Process {
                  if ($PSItem.Entries)
                  {
                     $paramClearEventLog = @{
                        LogName     = $PSItem.Log
                        Confirm     = $false
                        ErrorAction = 'SilentlyContinue'
                     }
                     $null = (Clear-EventLog @paramClearEventLog)
                  }
               })
         }
      }
   }
}

