[CmdletBinding()]
param ()

$parameters = @{
   Path          = 'HKCU:\Software\Microsoft\UCCPlatform\Lync'
   Name          = 'EnableDetectProxyForAllConnections'
   PropertyType  = 'DWORD'
   Value         = '1'
   Force         = $true
   ErrorAction   = 'Stop'
   WarningAction = 'SilentlyContinue'
}

try
{
   $null = (New-ItemProperty @parameters)
   Write-Verbose -Message 'New value set.'
}
catch
{
   try
   {
      $null = (Set-ItemProperty @parameters)
      Write-Verbose -Message 'Existing value modified.'
   }
   catch
   {
      Write-Warning -Message 'Unable to create/set the value.'
   }
}

