function Get-BadFontPaths
{
   [CmdletBinding(ConfirmImpact = 'None')]
   [OutputType([string])]
   param
   (
      [Parameter(ValueFromPipeline,
      ValueFromPipelineByPropertyName)]
      [Alias('AutoFix')]
      [switch]
      $Fix
   )

   begin
   {
      $SearchLocations = @(
         ("{0}\Microsoft\Windows\Fonts" -f $env:LocalAppData),
         ("{0}\Fonts" -f $env:SystemRoot)
      )
   }

   process
   {
      $SearchLocations | ForEach-Object -Process {
         Write-Verbose -Message ('Scanning {0}' -f $_)

         Get-ChildItem -Recurse -Filter *.ttf -Path $_ | ForEach-Object -Process {
            $Stream = ('{0}:Zone.Identifier' -f $_.FullName)
            $ZoneId = (Get-Content -Path $Stream -ErrorAction SilentlyContinue)

            if ($ZoneId -like '*ZoneTransfer*')
            {
               if ($Fix.IsPresent)
               {
                  Write-Verbose -Message ('Try to unklock {0}' -f $_.FullName)

                  Unblock-File -Path $_.FullName -Confirm:$false
               }
               else
               {
                  $_.FullName
               }
            }
         }
      }
   }
}
