[CmdletBinding(ConfirmImpact = 'Low')]
[OutputType([string])]
param ()

process
{
   $RegPath = 'HKLM:\SOFTWARE\Microsoft\Teams'

   $paramTestPath = @{
      LiteralPath = $RegPath
      ErrorAction = 'SilentlyContinue'
   }
   if ((Test-Path @paramTestPath) -ne $true)
   {
      $paramNewItem = @{
         Path          = $RegPath
         Force         = $true
         Confirm       = $false
         ErrorAction   = 'SilentlyContinue'
         WarningAction = 'SilentlyContinue'
      }
      $null = (New-Item @paramNewItem)
   }

   $paramNewItemProperty = @{
      LiteralPath   = $RegPath
      Name          = 'IsWVDEnvironment'
      Value         = 1
      PropertyType  = 'DWord'
      Force         = $true
      Confirm       = $false
      ErrorAction   = 'SilentlyContinue'
      WarningAction = 'SilentlyContinue'
   }
   $null = (New-ItemProperty @paramNewItemProperty)

   $RegPath = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\Appx'

   $paramTestPath = @{
      LiteralPath   = $RegPath
      ErrorAction   = 'SilentlyContinue'
      WarningAction = 'SilentlyContinue'
   }
   if ((Test-Path @paramTestPath) -ne $true)
   {
      $paramNewItem = @{
         Path          = $RegPath
         Force         = $true
         Confirm       = $false
         ErrorAction   = 'SilentlyContinue'
         WarningAction = 'SilentlyContinue'
      }
      $null = (New-Item @paramNewItem)
   }

   $paramNewItemProperty = @{
      LiteralPath   = $RegPath
      Name          = 'AllowDeploymentInSpecialProfiles'
      Value         = 1
      PropertyType  = 'DWord'
      Force         = $true
      Confirm       = $false
      ErrorAction   = 'SilentlyContinue'
      WarningAction = 'SilentlyContinue'
   }
   $null = (New-ItemProperty @paramNewItemProperty)

   $paramNewItemProperty = @{
      LiteralPath   = $RegPath
      Name          = 'AllowAllTrustedApps'
      Value         = 1
      PropertyType  = 'DWord'
      Force         = $true
      Confirm       = $false
      ErrorAction   = 'SilentlyContinue'
      WarningAction = 'SilentlyContinue'
   }
   $null = (New-ItemProperty @paramNewItemProperty)

   $paramNewItemProperty = @{
      LiteralPath   = $RegPath
      Name          = 'AllowDevelopmentWithoutDevLicense'
      Value         = 1
      PropertyType  = 'DWord'
      Force         = $true
      Confirm       = $false
      ErrorAction   = 'SilentlyContinue'
      WarningAction = 'SilentlyContinue'
   }
   $null = (New-ItemProperty @paramNewItemProperty)

   $WebView2 = $null
   $paramGetAppxPackage = @{
      AllUsers      = $true
      ErrorAction   = 'SilentlyContinue'
      WarningAction = 'SilentlyContinue'
   }
   $WebView2 = (Get-AppxPackage @paramGetAppxPackage | Where-Object {
         $_.Name -eq 'Microsoft.Win32WebViewHost'
   })

   if (!($WebView2))
   {

      $WebView2InstallerPath = ('{0}\WebView2.exe' -f $env:temp)

      $paramRemoveItem = @{
         Path          = $WebView2InstallerPath
         ErrorAction   = 'SilentlyContinue'
         WarningAction = 'SilentlyContinue'
      }
      $null = (Remove-Item @paramRemoveItem)

      $paramNewObject = @{
         TypeName      = 'System.Net.WebClient'
         ErrorAction   = 'Stop'
         WarningAction = 'SilentlyContinue'
      }
      $null = (New-Object @paramNewObject).DownloadFile('https://go.microsoft.com/fwlink/p/?LinkId=2124703', $WebView2InstallerPath)

      $paramStartProcess = @{
         FilePath      = $WebView2InstallerPath
         Wait          = $true
         ArgumentList  = '/silent /install'
         PassThru      = $true
         ErrorAction   = 'SilentlyContinue'
         WarningAction = 'SilentlyContinue'
      }
      $WebView2Installer = (Start-Process @paramStartProcess)

      $null = (Remove-Item @paramRemoveItem)

      Write-Verbose -Message ('WebView2 installer ExitCode was: {0}' -f $WebView2Installer.ExitCode)
   }

   $MSTeamsInstalled = $null
   $paramGetAppxPackage = @{
      AllUsers      = $true
      ErrorAction   = 'SilentlyContinue'
      WarningAction = 'SilentlyContinue'
   }
   $MSTeamsInstalled = (Get-AppxPackage @paramGetAppxPackage | Where-Object {
         $_.Name -eq 'MSTeams'
   })

   if (!($MSTeamsInstalled))
   {
      $TeamsBootstrapperInstallerPath = ('{0}\TeamsBootstrapper.exe' -f $env:temp)

      $paramRemoveItem = @{
         Path          = $TeamsBootstrapperInstallerPath
         ErrorAction   = 'SilentlyContinue'
         WarningAction = 'SilentlyContinue'
      }
      $null = (Remove-Item @paramRemoveItem)

      $paramNewObject = @{
         TypeName      = 'System.Net.WebClient'
         ErrorAction   = 'Stop'
         WarningAction = 'SilentlyContinue'
      }
      $null = (New-Object @paramNewObject).DownloadFile('https://go.microsoft.com/fwlink/?linkid=2243204', $TeamsBootstrapperInstallerPath)

      $paramStartProcess = @{
         FilePath      = $TeamsBootstrapperInstallerPath
         Wait          = $true
         ArgumentList  = '-p'
         PassThru      = $true
         ErrorAction   = 'SilentlyContinue'
         WarningAction = 'SilentlyContinue'
      }
      $TeamsBootstrapperInstaller = (Start-Process @paramStartProcess)

      $null = (Remove-Item @paramRemoveItem)

      Write-Verbose -Message ('TeamsBootstrapper installer ExitCode was: {0}' -f $TeamsBootstrapperInstaller.ExitCode)
   }
}
