[CmdletBinding(ConfirmImpact = 'Low',
   SupportsShouldProcess = $true)]
param
(
   [Parameter(Mandatory = $true,
      ValueFromPipeline = $true,
      ValueFromPipelineByPropertyName = $true)]
   [ValidateNotNullOrEmpty()]
   [Alias('DomainToReplace')]
   [string]
   $OldDomain,
   [Parameter(Mandatory = $true,
      ValueFromPipeline = $true,
      ValueFromPipelineByPropertyName = $true)]
   [ValidateNotNullOrEmpty()]
   [string]
   $NewDomain
)

begin
{
   $OldMailFilter = ('@' + $OldDomain)

   $AllUnifiedGroups = $null
}

process
{
   $AllUnifiedGroups = (Get-UnifiedGroup | Where-Object -FilterScript {
         $PSItem.PrimarySmtpAddress -like ('*' + $OldMailFilter)
      } | Select-Object -Property Identity, DisplayName, PrimarySmtpAddress)

   if ($AllUnifiedGroups)
   {
      foreach ($item in $AllUnifiedGroups)
      {
         if ($item.PrimarySmtpAddress -like ('*' + $OldMailFilter))
         {
            $OldMailAddress = $null
            $OldMailAddress = (($item).PrimarySmtpAddress)

            $NewMailAddress = $null
            $NewMailAddress = ($OldMailAddress.Replace($OldMailFilter, ('@' + $NewDomain)))
            Write-Verbose -Message ('Replace: {0} with: {1}' -f $OldMailAddress, $NewMailAddress)

            $null = (Set-UnifiedGroup -Identity (($item).Identity) -EmailAddresses: @{
                  Add = $NewMailAddress
               } -Confirm:$false)

            $null = (Set-UnifiedGroup -Identity (($item).Identity) -PrimarySmtpAddress $NewMailAddress -Confirm:$false)

            $null = (Set-UnifiedGroup -Identity (($item).Identity) -EmailAddresses: @{
                  Remove = $OldMailAddress
               } -Confirm:$false)
         }
         else
         {
            Write-Warning -Message ('Sorry, the PrimarySmtpAddress of {0} is not in {1}' -f $item.DisplayName, $OldDomain)
         }
      }
   }
   else
   {
      Write-Output -InputObject 'Nothing to do!!!'
   }
}


