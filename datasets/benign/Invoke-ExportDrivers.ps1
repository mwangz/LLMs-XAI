function Invoke-ExportDrivers
{
   [CmdletBinding(ConfirmImpact = 'None')]
   param
   (
      [Parameter(Mandatory,
         ValueFromPipeline,
         ValueFromPipelineByPropertyName,
         HelpMessage = 'Destination Directory')]
      [ValidateNotNullOrEmpty()]
      [Alias('destdir')]
      [string]
      $Path
   )

   begin
   {
      $DriverTable = $null
      $DriverPath = $null

      [GC]::Collect()
      [GC]::WaitForPendingFinalizers()
      [GC]::Collect()
      [GC]::WaitForPendingFinalizers()

      if ($Path -notmatch '\\$')
      {
         $Path += '\'
      }

      $DriverPath = ($Path + (Get-Date -Format 'yyyy-MM-dd'))

      if (-not (Test-Path -Path $DriverPath -ErrorAction SilentlyContinue))
      {
         try
         {
            Write-Verbose -Message ('Try to create {0}' -f $DriverPath)

            $paramNewItem = @{
               ItemType    = 'Directory'
               Path        = $DriverPath
               Force       = $true
               Confirm     = $false
               ErrorAction = 'Stop'
            }
            $null = (New-Item @paramNewItem)
            $paramNewItem = $null

            Write-Verbose -Message ('[{0}] Done' -f ([Char]8730))
         }
         catch
         {
            Write-Verbose -Message ('[X] Failed')

            [Management.Automation.ErrorRecord]$e = $_
            $info = @{
               Exception = $e.Exception.Message
               Reason    = $e.CategoryInfo.Reason
               Target    = $e.CategoryInfo.TargetName
               Script    = $e.InvocationInfo.ScriptName
               Line      = $e.InvocationInfo.ScriptLineNumber
               Column    = $e.InvocationInfo.OffsetInLine
            }
            $info | Out-String | Write-Verbose

            Write-Error -Message ($info.Exception) -ErrorAction Stop

            break
         }
      }
   }


   process
   {
      try
      {
         Write-Verbose -Message ('Export drivers via Deployment Image Servicing and Management to {0}' -f $DriverPath)

         $null = (& "$env:windir\system32\dism.exe" /online /export-driver /destination:$DriverPath)

         Write-Verbose -Message ('[{0}] Done' -f ([Char]8730))
      }
      catch
      {
         Write-Output -InputObject ('[X] Failed')

         [Management.Automation.ErrorRecord]$e = $_
         $info = @{
            Exception = $e.Exception.Message
            Reason    = $e.CategoryInfo.Reason
            Target    = $e.CategoryInfo.TargetName
            Script    = $e.InvocationInfo.ScriptName
            Line      = $e.InvocationInfo.ScriptLineNumber
            Column    = $e.InvocationInfo.OffsetInLine
         }
         $info | Out-String | Write-Verbose

         Write-Error -Message ($info.Exception) -ErrorAction Stop

         break
      }

      try
      {
         Write-Verbose -Message 'Gathering Driver infos'

         $DriverTable = (Get-WindowsDriver -Online -ErrorAction Stop | Select-Object -Property Driver, CatalogFile, ClassName, ClassDescription, ProviderName, Online, Version, Date)

         Write-Verbose -Message ('[{0}] Done' -f ([Char]8730))

         Write-Verbose -Message ('Export Driver infos to {0}\Driver-Details.csv' -f $DriverPath)

         $null = ($DriverTable | Sort-Object -Property Date -Descending | ConvertTo-Csv -Delimiter ';' -NoTypeInformation -ErrorAction Stop | Out-File -FilePath ('{0}\Driver-Details.csv' -f $DriverPath) -Force -Confirm:$false -Encoding utf8 -ErrorAction Stop)

         Write-Verbose -Message ('[{0}] Done' -f ([Char]8730))

      }
      catch
      {
         Write-Output -InputObject ('[X] Failed')

         [Management.Automation.ErrorRecord]$e = $_
         $info = @{
            Exception = $e.Exception.Message
            Reason    = $e.CategoryInfo.Reason
            Target    = $e.CategoryInfo.TargetName
            Script    = $e.InvocationInfo.ScriptName
            Line      = $e.InvocationInfo.ScriptLineNumber
            Column    = $e.InvocationInfo.OffsetInLine
         }
         $info | Out-String | Write-Verbose

         Write-Error -Message ($info.Exception) -ErrorAction Stop

         break
      }
   }

   end
   {
      Write-Verbose -Message ('Exported drivers and info can be found in {0}' -f $DriverPath)

      $DriverTable = $null
      $DriverPath = $null

      [GC]::Collect()
      [GC]::WaitForPendingFinalizers()
      [GC]::Collect()
      [GC]::WaitForPendingFinalizers()
   }
}

Invoke-ExportDrivers -Path 'c:\drivers\' -Verbose
