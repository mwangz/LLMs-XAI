function Remove-FileEndingBlankLines
{
   [CmdletBinding(ConfirmImpact = 'Low',
      SupportsShouldProcess)]
   param
   (
      [Parameter(Mandatory,
         ValueFromPipeline,
         ValueFromPipelineByPropertyName,
         Position = 1,
         HelpMessage = 'Single File or Path you want to unclutter.')]
      [ValidateNotNullOrEmpty()]
      [Alias('FilePath')]
      [string]
      $Path,
      [Parameter(ValueFromPipeline,
         ValueFromPipelineByPropertyName,
         Position = 2)]
      [switch]
      $Recurse = $false,
      [Parameter(ValueFromPipeline,
         ValueFromPipelineByPropertyName,
         Position = 3)]
      [switch]
      $noNewLine = $false,
      [Parameter(ValueFromPipeline,
         ValueFromPipelineByPropertyName,
         Position = 4)]
      [switch]
      $SafeFilesOnly = $true
   )

   begin
   {
      $paramGetChildItem = @{
         Path = $Path
         File = $true
      }

      if ($SafeFilesOnly)
      {
         Write-Verbose -Message 'Only safe files are processed'
         $paramGetChildItem.Include = '*.psm1', '*.ps1', '*.psd1', '*.ps1xml', '*.md'
      }
      else
      {
         Write-Verbose -Message 'All are processed - Might be a bad idea!!!'
      }

      if ($Recurse)
      {
         Write-Verbose -Message 'Read the info recursively'
         $paramGetChildItem.Recurse = $true
      }
      else
      {
         Write-Verbose -Message 'Read the info'
      }
   }

   process
   {
      (Get-ChildItem @paramGetChildItem | Where-Object -FilterScript {
         -not $PSItem.PSIsContainer
      } | Select-Object -ExpandProperty FullName) | ForEach-Object -Process {
         Write-Verbose -Message ('Try to unclutter {0}' -f $_)

         $UnclutteredText = (((Get-Content -Path $_ -Raw).TrimEnd()).ToString())

         try
         {
            if ($noNewLine)
            {
               Write-Verbose -Message ('Try to unclutter {0} (no final new line)' -f $_)

               $null = ([io.file]::WriteAllText($PSItem.FullName, $UnclutteredText))
            }
            else
            {
               Write-Verbose -Message ('Try to unclutter {0}' -f $_)

               $paramSetContent = @{
                  Path          = $_
                  Value         = $UnclutteredText
                  Force         = $true
                  Confirm       = $false
                  Encoding      = 'UTF8'
                  ErrorAction   = 'Stop'
                  WarningAction = 'Continue'
               }
               $null = (Set-Content @paramSetContent)
            }

            Write-Verbose -Message ('Uncluttered {0}' -f $_)
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

   end
   {
      Write-Verbose -Message 'Clear-FileEnding Done'
   }
}

