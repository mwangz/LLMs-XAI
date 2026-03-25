function Get-DirectorySize
{
   [CmdletBinding(ConfirmImpact = 'None')]
   [OutputType([string])]
   param
   (
      [Parameter(ValueFromPipeline,
         ValueFromPipelineByPropertyName)]
      [ValidateNotNullOrEmpty()]
      [Alias('Directory', 'Folder')]
      [string]
      $Path = '.',
      [Parameter(ValueFromPipeline,
         ValueFromPipelineByPropertyName)]
      [ValidateNotNullOrEmpty()]
      [ValidateSet('GB', 'MB', 'KB', 'B', IgnoreCase = $true)]
      [Alias('InType')]
      [string]
      $Type = 'MB'
   )

   process
   {
      try
      {
         $AllFolderItems = (Get-ChildItem -Path $Path -Recurse -ErrorAction Stop | Measure-Object -Property length -Sum)

         switch ($Type)
         {
            'GB'
            {
               $FolderSize = '{0:N2}' -f ($AllFolderItems.sum / 1GB) + ' GB'
            }
            'MB'
            {
               $FolderSize = '{0:N2}' -f ($AllFolderItems.sum / 1MB) + ' MB'
            }
            'KB'
            {
               $FolderSize = '{0:N2}' -f ($AllFolderItems.sum / 1KB) + ' KB'
            }
            'B'
            {
               $FolderSize = '{0:N2}' -f ($AllFolderItems.sum) + ' B'
            }
            Default
            {
               $FolderSize = '{0:N2}' -f ($AllFolderItems.sum) + ' MB'
            }
         }

         return $FolderSize
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

         Write-Error -Message $e.Exception.Message -ErrorAction Continue -Exception $e.Exception -TargetObject $e.CategoryInfo.TargetName
      }
   }
}
