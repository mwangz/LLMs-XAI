function Get-LocalGroupMembership
{
   [CmdletBinding(ConfirmImpact = 'None')]
   [OutputType([psobject])]
   param
   (
      [Parameter(ValueFromPipeline,
         ValueFromPipelineByPropertyName)]
      [ValidateNotNullOrEmpty()]
      [Alias('User')]
      [string]
      $UserName = ("$env:USERDOMAIN" + '\' + "$env:USERNAME")
   )

   begin
   {
      $LocalGroupMembership = @()
   }

   process
   {
      $AllGroups = (Get-LocalGroup -Name *)

      foreach ($LocalGroup in $AllGroups)
      {
         if (Get-LocalGroupMember -Group $LocalGroup.Name -ErrorAction SilentlyContinue | Where-Object -FilterScript {
               $PSItem.name -eq $UserName
            })
         {
            $LocalGroupMembership += $LocalGroup.Name
         }
      }
   }
   end
   {
      $LocalGroupMembership
   }
}

