function Get-OutdatedPowerShellModules
{
   [CmdletBinding(ConfirmImpact = 'None')]
   [OutputType([array])]
   param
   (
      [ValidateNotNullOrEmpty()]
      [ValidateSet('dd.MM.yyyy', 'MM/dd/yy', 'yyyy-MM-dd')]
      [Alias('DateString')]
      [string]
      $UsedDateString = 'yyyy-MM-dd'
   )

   BEGIN
   {
      $InstalledModules = (Get-InstalledModule -ErrorAction SilentlyContinue | Where-Object -FilterScript {
            ($_.Repository -eq 'PSGallery')
      })

      $ModuleReport = @()
   }

   PROCESS
   {
      foreach ($Module in $InstalledModules)
      {
         Write-Verbose -Message ('Check the PSGallery for others versions of {0}' -f $Module.Name)

         $GalleryModule = (Find-Module -Name $Module.Name -ErrorAction SilentlyContinue)

         if ($GalleryModule.Version -ne $Module.version)
         {
            Write-Verbose -Message ('PSGallery has another version for {0}' -f $Module.Name)

            $modversions = [pscustomobject]@{
               PSTypeName       = 'PSGalleryModule.Object'
               Name             = $($Module.name)
               InstalledVersion = $($Module.Version)
               InstalledPubDate = $($Module.PublishedDate.tostring($UsedDateString))
               AvailableVersion = $($GalleryModule.Version)
               AvailablePubDate = $($GalleryModule.PublishedDate.tostring($UsedDateString))
            }

            [string[]]$DefaultvisibleProperties = 'Name', 'InstalledVersion', 'AvailableVersion'
            [Management.Automation.PSMemberInfo[]]$VisibleProperties = ([Management.Automation.PSPropertySet]::new('DefaultDisplayPropertySet', $DefaultvisibleProperties))

            $null = ($ModuleReport += ($modversions | Add-Member -MemberType MemberSet -Name PSStandardMembers -Value $VisibleProperties -PassThru))
         }
         else
         {
            Write-Verbose -Message ('{0} is up-to-date' -f $Module.Name)
         }
      }
   }

   end
   {
      $ModuleReport
   }
}
