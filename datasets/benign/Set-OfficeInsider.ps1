param
(
   [Parameter(ValueFromPipeline = $true,
      Position = 1)]
   [ValidateSet('Insiderfast', 'FirstReleaseCurrent', 'Current', 'Validation', 'Business', IgnoreCase = $true)]
   [ValidateNotNullOrEmpty()]
   [string]
   $Channel = 'Current'
)

begin
{
   $SC = 'SilentlyContinue'

   try
   {
      $paramNewItem = @{
         Path          = 'HKLM:\SOFTWARE\Policies\Microsoft\office\16.0\common\'
         Name          = 'officeupdate'
         Force         = $true
         ErrorAction   = $SC
         WarningAction = $SC
         Confirm       = $false
      }
      $null = (New-Item @paramNewItem)

      Write-Verbose -Message 'The Registry Structure was created.'
   }
   catch
   {
      Write-Verbose -Message 'The Registry Structure exists...'
   }
}

process
{
   try
   {
      $paramNewItemProperty = @{
         Path          = 'HKLM:\SOFTWARE\Policies\Microsoft\office\16.0\common\officeupdate'
         Name          = 'updatebranch'
         PropertyType  = 'String'
         Value         = $Channel
         Force         = $true
         ErrorAction   = $SC
         WarningAction = $SC
         Confirm       = $false
      }
      $null = (New-ItemProperty @paramNewItemProperty)

      Write-Verbose -Message 'Registry Entry was created.'
   }
   catch
   {
      $paramSetItem = @{
         Path          = 'HKLM:\SOFTWARE\Policies\Microsoft\office\16.0\common\officeupdate\updatebranch'
         Value         = $Channel
         Force         = $true
         ErrorAction   = $SC
         WarningAction = $SC
         Confirm       = $false
      }
      $null = (Set-Item @paramSetItem)

      Write-Verbose -Message 'Registry Entry was changed.'
   }
}

end
{
   Write-Output -InputObject "Office Release Channel Set to $Channel"
}
