[CmdletBinding(ConfirmImpact = 'Low')]
param
(
   [Parameter(ValueFromPipelineByPropertyName = $true,
      ValueFromRemainingArguments = $true)]
   [ValidateNotNullOrEmpty()]
   [Alias('Threshold', 'Days')]
   [int]
   $TimeFrame = 90
)

begin
{
   $InactivityTimeFrame = ((Get-Date).AddDays(-$TimeFrame))
}

process
{
   $paramGetAzureADDevice = @{
      All           = $true
      ErrorAction   = 'SilentlyContinue'
      WarningAction = 'SilentlyContinue'
   }
   $null = ((Get-AzureADDevice @paramGetAzureADDevice | Where-Object -FilterScript {
            $PSItem.ApproximateLastLogonTimeStamp -le $InactivityTimeFrame
         }) | ForEach-Object -Process {
         Write-Output -InputObject ('Removing device {0}' -f $PSItem.ObjectId)

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
      })
}
