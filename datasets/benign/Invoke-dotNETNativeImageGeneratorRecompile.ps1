[CmdletBinding()]
[OutputType([string])]
param ()

process
{
   $NETPath = @(
      ('{0}\Microsoft.NET\Framework' -f $env:windir)
      ('{0}\Microsoft.NET\Framework64' -f $env:windir)
      ('{0}\Microsoft.NET\FrameworkArm64' -f $env:windir)
   )

   foreach ($NETPathItem in $NETPath)
   {
      if (Test-Path -Path $NETPathItem -ErrorAction SilentlyContinue)
      {
         (Get-ChildItem -Path $NETPathItem -Filter 'v*.*' -ErrorAction SilentlyContinue).FullName | ForEach-Object {
            $null = (Push-Location -Path $_)

            if (Test-Path -Path '.\ngen.exe' -ErrorAction SilentlyContinue)
            {
               $paramStartProcess = @{
                  FilePath         = '.\ngen.exe'
                  ArgumentList     = 'update /queue /nologo /silent'
                  WorkingDirectory = $_
                  NoNewWindow      = $true
                  Wait             = $true
                  ErrorAction      = 'SilentlyContinue'
                  WarningAction    = 'SilentlyContinue'
               }
               $null = (Start-Process @paramStartProcess)

               $paramStartProcess = @{
                  FilePath         = '.\ngen.exe'
                  ArgumentList     = 'executeQueuedItems /nologo /silent'
                  WorkingDirectory = $_
                  NoNewWindow      = $true
                  Wait             = $true
                  ErrorAction      = 'SilentlyContinue'
                  WarningAction    = 'SilentlyContinue'
               }
               $null = (Start-Process @paramStartProcess)
            }

            $null = (Pop-Location)
         }
      }
   }
}
