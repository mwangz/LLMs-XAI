function Remove-Signature
{
   [CmdletBinding(ConfirmImpact = 'Low',
      SupportsShouldProcess)]
   param
   (
      [Parameter(Mandatory,
         ValueFromPipeline,
         ValueFromPipelineByPropertyName,
         Position = 1,
         HelpMessage = 'Single File or Path you want to parse for digital signatures.')]
      [ValidateNotNullOrEmpty()]
      [Alias('FilePath')]
      [string]
      $Path,
      [Parameter(ValueFromPipeline,
         ValueFromPipelineByPropertyName,
         Position = 2)]
      [switch]
      $Recurse = $false
   )

   begin
   {
      $paramGetChildItem = @{
         Path    = $Path
         File    = $true
         Include = '*.psm1', '*.ps1', '*.psd1', '*.ps1xml'
      }

      if ($Recurse)
      {
         Write-Verbose -Message 'Work recursively'
         $paramGetChildItem.Recurse = $true
      }
   }

   process
   {

      $FilesToProcess = (Get-ChildItem @paramGetChildItem)

      $FilesToProcess | ForEach-Object -Process {
         $SignatureStatus = (Get-AuthenticodeSignature -FilePath $_).Status
         $ScriptFileFullName = $PSItem.FullName

         if ($SignatureStatus -ne 'NotSigned')
         {
            try
            {
               $paramGetContent = @{
                  Path          = $ScriptFileFullName
                  ErrorAction   = 'Stop'
                  WarningAction = 'Continue'
               }
               $Content = (Get-Content @paramGetContent)

               $paramNewObject = @{
                  TypeName      = 'System.Text.StringBuilder'
                  ErrorAction   = 'Stop'
                  WarningAction = 'Continue'
               }
               $StringBuilder = (New-Object @paramNewObject)

               foreach ($Line in $Content)
               {
                  if ($Line -match '^# SIG # Begin signature block|^<!-- SIG # Begin signature block -->')
                  {
                     break
                  }
                  else
                  {
                     $null = $StringBuilder.AppendLine($Line)
                  }
               }
               if ($pscmdlet.ShouldProcess("$ScriptFileFullName"))
               {
                  $paramSetContent = @{
                     Path          = $ScriptFileFullName
                     Value         = $StringBuilder.ToString()
                     Force         = $true
                     Confirm       = $false
                     Encoding      = 'UTF8'
                     ErrorAction   = 'Stop'
                     WarningAction = 'Continue'
                  }
                  $null = (Set-Content @paramSetContent)

                  Write-Verbose -Message ('Removed signature from {0}' -f $ScriptFileFullName)
               }
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
         else
         {
            Write-Verbose -Message ('No signature found in {0}' -f $ScriptFileFullName)
         }
      }
   }

   end
   {
      Write-Verbose -Message 'Remove-Signature Done'
   }
}

