function Search-MailboxItemDeletion
{
   [CmdletBinding(DefaultParameterSetName = 'All',
      ConfirmImpact = 'None')]
   [OutputType([array])]
   param
   (
      [Parameter(ValueFromPipeline,
         ValueFromPipelineByPropertyName)]
      [ValidateNotNullOrEmpty()]
      [ValidateNotNull()]
      [int]
      $Days = 7,
      [Parameter(ParameterSetName = 'Single', HelpMessage = 'Mailbox Address e.g. info@contoso.com',
         Mandatory,
         ValueFromPipeline,
         ValueFromPipelineByPropertyName)]
      [ValidateNotNullOrEmpty()]
      [ValidateNotNull()]
      [Alias('MailboxName', 'MailboxAddress')]
      [string]
      $Mailbox,
      [Parameter(ParameterSetName = 'All')]
      [switch]
      $All
   )

   begin
   {
      [GC]::Collect()

      $Records = $null

      $StartDate = (Get-Date).AddDays(-$Days)

      $EndDate = (Get-Date)

      function Get-StandardMembersFromPSObject
      {
         [CmdletBinding(ConfirmImpact = 'None')]
         [OutputType([psobject])]
         param
         (
            [Parameter(Mandatory,
               ValueFromPipeline,
               ValueFromPipelineByPropertyName,
               HelpMessage = 'The input object, must be a psobject.')]
            [ValidateNotNull()]
            [ValidateNotNullOrEmpty()]
            [psobject]
            $InputObject,
            [Parameter(ValueFromPipeline,
               ValueFromPipelineByPropertyName)]
            [ValidateNotNull()]
            [ValidateNotNullOrEmpty()]
            [Alias('DefaultProperties')]
            [string[]]
            $Properties = $null
         )

         process
         {
            try
            {
               $defaultDisplayPropertySet = (New-Object -TypeName System.Management.Automation.PSPropertySet -ArgumentList ('DefaultDisplayPropertySet', [string[]]$Properties))
               $PSStandardMembers = ([Management.Automation.PSMemberInfo[]]@($defaultDisplayPropertySet))
               $InputObject | Add-Member -MemberType MemberSet -Name PSStandardMembers -Value $PSStandardMembers -Force
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
            }
         }
      }
   }

   process
   {
      $Records = (Search-UnifiedAuditLog -StartDate $StartDate -EndDate $EndDate -Operations 'HardDelete', 'SoftDelete')

      if ($Records)
      {
         Write-Verbose -Message ('Processing ' + $Records.Count + ' audit records...')

         $Report = [Collections.Generic.List[Object]]::new()

         foreach ($Rec in $Records)
         {
            $AuditData = (ConvertFrom-Json -InputObject $Rec.Auditdata)

            if ($AuditData.ResultStatus -eq 'PartiallySucceeded')
            {
               $MessageSubject = '# Not fully deleted by' + $AuditData.ClientInfoString + ' #'
            }
            else
            {
               $MessageSubject = ($AuditData.AffectedItems.Subject -split '\n')[0]
            }

            $ReportLine = [PSCustomObject] @{
               TimeStamp         = (Get-Date -Date ($AuditData.CreationTime) -Format g)
               User              = $AuditData.UserId
               Action            = $AuditData.Operation
               Status            = $AuditData.ResultStatus
               Mailbox           = $AuditData.MailboxOwnerUPN
               MailboxGuid       = $AuditData.MailboxGuid
               Subject           = $MessageSubject
               MessageId         = ($AuditData.AffectedItems.Id -split '\n')[0]
               InternetMessageId = ($AuditData.AffectedItems.InternetMessageId -split '\n')[0]
               Folder            = $AuditData.Folder.Path.Split('\')[1]
               Client            = $AuditData.ClientInfoString
               AppId             = $AuditData.AppId
               ClientIP          = $AuditData.ClientIP
               External          = $AuditData.ExternalAccess
               SessionId         = $AuditData.SessionId
               ExternalAccess    = $AuditData.ExternalAccess
               InternalLogonType = $AuditData.InternalLogonType
               LogonType         = $AuditData.LogonType
               OrganizationName  = $AuditData.OrganizationName
               OrganizationId    = $AuditData.OrganizationId
               OriginatingServer = $AuditData.OriginatingServer
            }

            Get-StandardMembersFromPSObject -InputObject $ReportLine -Properties 'Timestamp', 'Action', 'User', 'Mailbox', 'Subject', 'Folder'

            $Report.Add($ReportLine)
         }

         $Records = $null
      }
      else
      {
         Write-Output -InputObject 'No deletion records found.'
         break
      }

      $Output = @()

      switch ($PsCmdlet.ParameterSetName)
      {
         'Single'
         {
            $Output = ($Report | Where-Object -FilterScript {

                  $PSItem.Mailbox -eq $Mailbox
               })
         }
         'All'
         {
            $Output = ($Report | Sort-Object -Property Mailbox)
         }
      }

      $Report = $null
   }

   end
   {
      $Output

      $Output = $null

      [GC]::Collect()
   }
}

