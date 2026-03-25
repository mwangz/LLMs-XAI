function Get-enMailboxPermissionReport
{
   [CmdletBinding(ConfirmImpact = 'None')]
   param
   (
      [Parameter(ValueFromPipeline = $true,
         ValueFromPipelineByPropertyName = $true)]
      [AllowEmptyString()]
      [AllowEmptyCollection()]
      [Alias('Mailbox', 'MailboxID', 'MailboxIdentity')]
      [string]
      $Identity = '*',
      [Parameter(ValueFromPipeline = $true,
         ValueFromPipelineByPropertyName = $true)]
      [ValidateSet('UserMailbox', 'User', 'SharedMailbox', 'Shared', 'All', IgnoreCase = $true)]
      [string]
      $MailboxType = 'All',
      [Parameter(ValueFromPipeline = $true,
         ValueFromPipelineByPropertyName = $true)]
      [AllowEmptyCollection()]
      [AllowEmptyString()]
      [Alias('MailboxResultSize')]
      [string]
      $ResultSize = 'Unlimited',
      [Parameter(ValueFromPipeline = $true,
         ValueFromPipelineByPropertyName = $true)]
      [AllowEmptyCollection()]
      [AllowEmptyString()]
      [Alias('CsvReport', 'CsvFile')]
      [string]
      $Path = 'C:\scripts\PowerShell\Reports\MailboxPermissionReport.csv',
      [Parameter(ValueFromPipeline = $true,
         ValueFromPipelineByPropertyName = $true)]
      [ValidateSet('Unicode', 'UTF7', 'UTF8', 'ASCII', 'UTF32', 'BigEndianUnicode', 'Default', 'OEM', IgnoreCase = $true)]
      [AllowEmptyCollection()]
      [AllowEmptyString()]
      [Alias('CsvEncoding')]
      [string]
      $Encoding = 'UTF8'
   )

   begin
   {
      $MailboxPermissionReport = $null
      $AllMailboxes = $null
      $SCT = 'SilentlyContinue'
      $CNT = 'Continue'

      if (-not ($Identity))
      {
         $Identity = '*'
      }

      if (-not ($MailboxType))
      {
         $MailboxType = 'All'
      }

      if (-not ($ResultSize))
      {
         $ResultSize = 'Unlimited'
      }

      if (-not ($Path))
      {
         $Path = 'C:\scripts\PowerShell\Reports\MailboxPermissionReport.csv'
      }

      if (-not ($Encoding))
      {
         $Encoding = 'UTF8'
      }

      Write-Verbose -Message 'Get the mailboxes'

      $paramGetMailbox = @{
         Identity      = $Identity
         ResultSize    = $ResultSize
         ErrorAction   = $SCT
         WarningAction = $CNT
      }

      switch ($MailboxType)
      {
         UserMailbox
         {
            $paramWhereObject = @{
               FilterScript = {
                  $PSItem.RecipientTypeDetails -eq 'UserMailbox'
               }
            }
         }
         User
         {
            $paramWhereObject = @{
               FilterScript = {
                  $PSItem.RecipientTypeDetails -eq 'UserMailbox'
               }
            }
         }
         SharedMailbox
         {
            $paramWhereObject = @{
               FilterScript = {
                  $PSItem.RecipientTypeDetails -eq 'SharedMailbox'
               }
            }
         }
         Shared
         {
            $paramWhereObject = @{
               FilterScript = {
                  $PSItem.RecipientTypeDetails -eq 'SharedMailbox'
               }
            }
         }
         All
         {
            $paramWhereObject = @{
               FilterScript = {
                  $PSItem.RecipientTypeDetails -eq 'UserMailbox' -or $PSItem.RecipientTypeDetails -eq 'SharedMailbox'
               }
            }
         }
         default
         {
            $paramWhereObject = @{
               FilterScript = {
                  $PSItem.RecipientTypeDetails -eq 'UserMailbox' -or $PSItem.RecipientTypeDetails -eq 'SharedMailbox'
               }
            }
         }
      }

      $AllMailboxes = (Get-Mailbox @paramGetMailbox | Where-Object @paramWhereObject | Sort-Object)

   }

   process
   {
      if ($AllMailboxes)
      {
         $MailboxPermissionReport = @()

         $MailboxCounter = ($AllMailboxes | Measure-Object).Count

         $MailboxCount = 1

         Write-Verbose -Message 'Process all mailboxes'

         ForEach ($SingleMailbox in $AllMailboxes)
         {
            $ProgressActivity = ('Working on Mailbox {0} of {1} ({2})' -f $MailboxCount, $MailboxCounter, $SingleMailbox.UserPrincipalName)
            $ProgressStatus = ('Getting folders for mailbox: {0} ({1})' -f $SingleMailbox.DisplayName, $SingleMailbox.UserPrincipalName)

            Write-Verbose -Message $ProgressStatus

            $paramWriteProgress = @{
               Status          = $ProgressStatus
               Activity        = $ProgressActivity
               PercentComplete = (($MailboxCount / $MailboxCounter) * 100)
            }
            Write-Progress @paramWriteProgress

            $MailboxPermissionReport += $SingleMailbox | Get-MailboxPermission | Where-Object -FilterScript {
               ($PSItem.IsInherited -eq $false) -and -not ($PSItem.User -match 'NT AUTHORITY')
            } | Select-Object -Property 'Identity', @{
               Name       = 'UserPrincipalName'
               Expression = {
                  $SingleMailbox.UserPrincipalName
               }
            }, 'User', @{
               Name       = 'Access Rights'
               Expression = {
                  $PSItem.AccessRights -join ','
               }
            } -ErrorAction $CNT -WarningAction $CNT
         }

         if ($MailboxPermissionReport)
         {
            $paramExportCsv = @{
               Path              = $Path
               Force             = $true
               NoTypeInformation = $true
               Confirm           = $false
               ErrorAction       = 'Stop'
               WarningAction     = $CNT
            }
            $null = ($MailboxPermissionReport | Export-Csv @paramExportCsv)
         }
         else
         {
            Write-Warning -Message 'None of the Mailboxes has special permissions set'
         }
      }
      else
      {
         Write-Warning -Message 'No Mailboxes found that matches your search criteria'
      }
   }

   end
   {
      $MailboxPermissionReport = $null
      $AllMailboxes = $null
   }
}

