Function Get-enDomainInfo
{
   [CmdletBinding()]
   Param ()

   begin
   {
      $SelectProperties = 'Name', 'Forest', 'Parent', 'Children', 'DomainMode', 'DomainModeLevel', 'DomainControllers', 'PdcRoleOwner', 'RidRoleOwner', 'InfrastructureRoleOwner', 'Sites'
   }

   process
   {
      $CurrentDomain = [DirectoryServices.ActiveDirectory.Domain]::GetCurrentDomain()
      $null = ($CurrentDomain | Add-Member -MemberType NoteProperty -Name Sites -Value ([DirectoryServices.ActiveDirectory.Forest]::GetCurrentForest().Sites))
      $Domain = ($CurrentDomain | Select-Object -Property $SelectProperties)
   }

   end
   {
      $Domain
   }
}

