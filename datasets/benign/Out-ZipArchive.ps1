function Out-ZipArchive
{
   [CmdletBinding(ConfirmImpact = 'None')]
   param
   (
      [Parameter(Mandatory = $true,
         ValueFromPipeline = $true,
         ValueFromPipelineByPropertyName = $true,
         Position = 0,
         HelpMessage = 'Input Path')]
      [ValidateNotNullOrEmpty()]
      [Alias('Directory')]
      [string]
      $Path,
      [Parameter(Mandatory = $true,
         ValueFromPipeline = $true,
         ValueFromPipelineByPropertyName = $true,
         Position = 1,
         HelpMessage = 'Name of the archive to create')]
      [ValidateNotNullOrEmpty()]
      [Alias('FileName')]
      [string]
      $ArchiveName,
      [Parameter(ValueFromPipeline = $true,
         ValueFromPipelineByPropertyName = $true,
         Position = 2)]
      [Alias('overwrite')]
      [switch]
      $force,
      [Parameter(ValueFromPipeline = $true,
         ValueFromPipelineByPropertyName = $true,
         Position = 3)]
      [Alias('dotnet')]
      [switch]
      $fallback = $false
   )

   begin
   {
      $null = (Add-Type -AssemblyName System.IO.Compression.FileSystem)

      $compressionLevel = [IO.Compression.CompressionLevel]::Optimal

      Write-Verbose -Message "Compression level for $ArchiveName is $compressionLevel"

      $ExistingProgressPreference = ($ProgressPreference)
      $ProgressPreference = 'SilentlyContinue'
   }

   process
   {

      if (-not $ArchiveName.EndsWith('.zip'))
      {
         Write-Verbose -Message "Bad filename detected $ArchiveName"

         $ArchiveName += '.zip'

         Write-Verbose -Message "Corrected filename is $ArchiveName"
      }

      if ($force)
      {
         if (Test-Path -Path $ArchiveName -ErrorAction SilentlyContinue -WarningAction SilentlyContinue)
         {
            Write-Verbose -Message "Overwrite old archive $ArchiveName"

            try
            {
               $paramRemoveItem = @{
                  Path          = $ArchiveName
                  Force         = $true
                  Confirm       = $false
                  ErrorAction   = 'Stop'
                  WarningAction = 'Continue'
               }
               $null = (Remove-Item @paramRemoveItem)
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

               Write-Error -Message ($info.Exception) -TargetObject ($info.Target) -ErrorAction Stop
               break
            }
         }
      }

      try
      {
         Write-Verbose -Message "Try to create archive $ArchiveName"

         if ($fallback)
         {
            Write-Verbose -Message 'Run in fallback mode and using System.IO.Compression.ZipArchive instead of Compress-Archive'
            $zip = ([IO.Compression.ZipFile]::CreateFromDirectory($Path, $ArchiveName, $compressionLevel, $false))
            $zip.Dispose()
         }
         else
         {
            $paramCompressArchive = @{
               Path             = $Path
               CompressionLevel = $compressionLevel
               DestinationPath  = $ArchiveName
               Force            = $true
               Confirm          = $false
               ErrorAction      = 'Stop'
               WarningAction    = 'SilentlyContinue'
            }
            $null = (Compress-Archive @paramCompressArchive)
         }

         Write-Verbose -Message "Archive $ArchiveName was created"
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

         Write-Error -Message ($info.Exception) -TargetObject ($info.Target) -ErrorAction Stop
         break
      }
   }

   end
   {
      $ProgressPreference = $ExistingProgressPreference

      Write-Verbose -Message 'Out-ZipArchive done'
   }
}

