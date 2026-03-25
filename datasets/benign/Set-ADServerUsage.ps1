function Set-ADServerUsage
{
   param
   (
      [Parameter(ValueFromPipeline,
         ValueFromPipelineByPropertyName,
         Position = 1)]
      [switch]
      $pdc
   )

   begin
   {
      $SC = 'SilentlyContinue'
      $dc = $null
   }

   process
   {
      if ((Get-Command -Name Get-ADDomain -ErrorAction $SC) -and (Get-Command -Name Get-ADDomainController -ErrorAction $SC) )
      {
         if ($pdc)
         {
            $dc = ((Get-ADDomain -ErrorAction $SC -WarningAction $SC).PDCEmulator)
         }
         else
         {
            $dc = (Get-ADDomainController -Discover -NextClosestSite -ErrorAction $SC -WarningAction $SC)
         }

         if ($dc)
         {
            $PSDefaultParameterValues.add('*-AD*:Server', "$dc")
         }
      }
   }
}


