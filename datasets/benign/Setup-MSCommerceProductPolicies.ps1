[CmdletBinding(ConfirmImpact = 'Low')]
[OutputType([string])]
param ()

process
{
   Connect-MSCommerce

   $MSCommerceProductPolicies = (Get-MSCommerceProductPolicies -PolicyId AllowSelfServicePurchase)

   $AllowedProducts = @(
      'Viva Learning'
      'Viva Goals'
      'Teams Exploratory'
   )
   
   foreach ($MSCommerceProductPolicy in $MSCommerceProductPolicies)
   {
      $paramUpdateMSCommerceProductPolicy = $null
      
      if (($MSCommerceProductPolicy.PolicyId -eq 'AllowSelfServicePurchase') -and ($AllowedProducts -contains $MSCommerceProductPolicy.ProductName) -and ($MSCommerceProductPolicy.PolicyValue -ne 'Enabled'))
      {
         $paramUpdateMSCommerceProductPolicy = @{
            PolicyId      = $MSCommerceProductPolicy.PolicyId
            ProductId     = $MSCommerceProductPolicy.ProductId
            Enabled       = $true
            ErrorAction   = 'Continue'
            WarningAction = 'SilentlyContinue'
         }
         $null = (Update-MSCommerceProductPolicy @paramUpdateMSCommerceProductPolicy)
      }
      elseif (($MSCommerceProductPolicy.PolicyId -eq 'AllowSelfServicePurchase') -and (-not ($AllowedProducts -contains $MSCommerceProductPolicy.ProductName)) -and ($MSCommerceProductPolicy.PolicyValue -ne 'Disabled'))
      {
         $paramUpdateMSCommerceProductPolicy = @{
            PolicyId      = $MSCommerceProductPolicy.PolicyId
            ProductId     = $MSCommerceProductPolicy.ProductId
            Enabled       = $false
            ErrorAction   = 'Continue'
            WarningAction = 'SilentlyContinue'
         }
         $null = (Update-MSCommerceProductPolicy @paramUpdateMSCommerceProductPolicy)
      }
      
      $paramUpdateMSCommerceProductPolicy = $null
   }
}

end
{
   $MSCommerceProductPolicies = $null
   $AllowedProducts = $null

   [GC]::Collect()
   [GC]::WaitForPendingFinalizers()
}
