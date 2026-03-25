[CmdletBinding(ConfirmImpact = 'Low')]
[OutputType([string])]
param
(
   [Parameter(ValueFromPipeline,
   ValueFromPipelineByPropertyName)]
   [Alias('AllVersions', 'ScanAll')]
   [bool]
   $All = $false
)

begin
{
   if ($All -eq $true)
   {
      $OpensslRegex = 'OpenSSL\s*[0-9]\.[0-9]\.[0-9]'
   }
   else
   {
      $OpensslRegex = 'OpenSSL\s*3\.0\.[0-6]'
   }
}

process
{
   $AllDrives = ((Get-PSDrive -PSProvider FileSystem).Root)

   foreach ($DriveToScan in $AllDrives)
   {
      Write-Output -InputObject ('Start Scan on {1} on {0}' -f $env:COMPUTERNAME, $DriveToScan)
   
      try
      {
         Get-ChildItem -Path $DriveToScan -Include libcrypto*.dll, libssl*.dll -File -Recurse -ErrorAction SilentlyContinue | ForEach-Object -Process {
            $OpensslVersion = (Select-String -Path $_ -Pattern $OpensslRegex -AllMatches | ForEach-Object -Process {
                  $_.Matches
               } | ForEach-Object -Process {
                  $_.Value
            })
            if ($OpensslVersion) 
            {
               Write-Warning -Message ('{0} - {1} ' -f $OpensslVersion, $_)
            }
         }
      }
      catch
      {
         $_ | Write-Verbose
      }

      Write-Output -InputObject ('Done Scan on {1} on {0}' -f $env:COMPUTERNAME, $DriveToScan)
   }
}
