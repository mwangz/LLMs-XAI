function Add-HostsEntry
{
   [CmdletBinding(ConfirmImpact = 'Medium',
      SupportsShouldProcess)]
   param
   (
      [Parameter(Mandatory,
         Position = 0,
         HelpMessage = 'The IP address for the hosts entry.')]
      [ValidateNotNullOrEmpty()]
      [Alias('ipaddress', 'ip')]
      [string]
      $Address,
      [Parameter(Mandatory,
         ValueFromPipeline,
         ValueFromPipelineByPropertyName,
         Position = 1,
         HelpMessage = 'The hostname for the hosts entry.')]
      [ValidateNotNullOrEmpty()]
      [Alias('Host', 'Name')]
      [string]
      $HostName,
      [Parameter(ValueFromPipeline,
         ValueFromPipelineByPropertyName,
         Position = 3)]
      [switch]
      $force = $false,
      [Parameter(ValueFromPipeline,
         ValueFromPipelineByPropertyName,
         Position = 2)]
      [ValidateNotNullOrEmpty()]
      [Alias('filename', 'Hosts', 'hostsfile', 'file')]
      [string]
      $Path = "$env:windir\System32\drivers\etc\hosts"
   )
   begin
   {
      Write-Verbose -Message 'Start'
   }

   process
   {
      if ($force)
      {
         try
         {
            $null = (Remove-HostsEntry -HostName $HostName -Path $Path -ErrorAction SilentlyContinue -WarningAction SilentlyContinue)
         }
         catch
         {
            Write-Verbose -Message 'Looks like the entry was not there before'
         }
      }

      try
      {
         if ($pscmdlet.ShouldProcess('Target', 'Operation'))
         {
            $paramGetContent = @{
               Path          = $Path
               Raw           = $true
               Force         = $true
               ErrorAction   = 'Stop'
               WarningAction = 'SilentlyContinue'
            }
            $HostsFileContent = (((Get-Content @paramGetContent ).TrimEnd()).ToString())

            $NewValue = "`n" + $Address + "`t`t" + $HostName
            $NewHostsFileContent = $HostsFileContent + $NewValue

            $paramSetContent = @{
               Path          = $Path
               Value         = $NewHostsFileContent
               Force         = $true
               Confirm       = $false
               Encoding      = 'UTF8'
               ErrorAction   = 'Stop'
               WarningAction = 'SilentlyContinue'
            }
            $null = (Set-Content @paramSetContent)
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

         Write-Error -Message ($info.Exception) -ErrorAction Stop

         break
      }
   }

   end
   {
      Write-Verbose -Message 'Done'
   }
}

function Remove-HostsEntry
{
   [CmdletBinding(ConfirmImpact = 'Medium',
      SupportsShouldProcess)]
   param
   (
      [Parameter(Mandatory,
         ValueFromPipeline,
         ValueFromPipelineByPropertyName,
         Position = 0,
         HelpMessage = 'The hostname for the hosts entry.')]
      [ValidateNotNullOrEmpty()]
      [Alias('Host', 'Name')]
      [string]
      $HostName,
      [Parameter(ValueFromPipeline,
         ValueFromPipelineByPropertyName,
         Position = 1)]
      [ValidateNotNullOrEmpty()]
      [Alias('Hosts', 'hostsfile', 'file', 'Filename')]
      [string]
      $Path = "$env:windir\System32\drivers\etc\hosts"
   )

   begin
   {
      Write-Verbose -Message 'Start'

      try
      {
         $paramGetContent = @{
            Path          = $Path
            Raw           = $true
            Force         = $true
            ErrorAction   = 'Stop'
            WarningAction = 'SilentlyContinue'
         }
         $HostsFileContent = (((Get-Content @paramGetContent ).TrimEnd()).ToString())
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

         Write-Error -Message ($info.Exception) -ErrorAction Stop

         break
      }

      $newLines = @()
   }

   process
   {
      foreach ($line in $HostsFileContent)
      {
         $bits = [regex]::Split($line, '\t+')
         if ($bits.count -eq 2)
         {
            if ($bits[1] -ne $HostName)
            {
               $newLines += $line
            }
         }
         else
         {
            $newLines += $line
         }
      }

      try
      {
         if ($pscmdlet.ShouldProcess('Target', 'Operation'))
         {
            $paramClearContent = @{
               Path          = $Path
               Force         = $true
               Confirm       = $false
               ErrorAction   = 'Stop'
               WarningAction = 'SilentlyContinue'
            }
            $null = (Clear-Content @paramClearContent)

            $paramSetContent = @{
               Path          = $Path
               Value         = $newLines
               Force         = $true
               Confirm       = $false
               Encoding      = 'UTF8'
               ErrorAction   = 'Stop'
               WarningAction = 'SilentlyContinue'
            }
            $null = (Set-Content @paramSetContent)
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

         Write-Error -Message ($info.Exception) -ErrorAction Stop

         break
      }
   }

   end
   {
      Write-Verbose -Message 'Done'
   }
}

function Get-HostsFile
{
   [CmdletBinding(ConfirmImpact = 'None')]
   param
   (
      [Parameter(ValueFromPipeline,
         ValueFromPipelineByPropertyName,
         Position = 0)]
      [ValidateNotNullOrEmpty()]
      [Alias('Hosts', 'hostsfile', 'file', 'filename')]
      [string]
      $Path = "$env:windir\System32\drivers\etc\hosts",
      [Parameter(ValueFromPipeline,
         ValueFromPipelineByPropertyName,
         Position = 1)]
      [Alias('plain')]
      [switch]
      $raw = $false
   )

   begin
   {
      $HostsFileContent = Get-Content -Path $Path
   }

   process
   {
      foreach ($line in $HostsFileContent)
      {
         if ($raw)
         {
            Write-Output -InputObject $line
         }
         else
         {
            $bits = [regex]::Split($line, '\t+')
            if ($bits.count -eq 2)
            {
               [string]$HostsFileLine = $bits

               if (-not ($HostsFileLine.StartsWith('#')))
               {
                  Write-Output -InputObject $HostsFileLine
               }
            }
         }
      }
   }
}

