param
(
   [Parameter(Mandatory,
      ValueFromPipeline,
      ValueFromPipelineByPropertyName,
      Position = 1,
      HelpMessage = 'Active Directory Group with users that would like to have a picture')]
   [ValidateNotNullOrEmpty()]
   [Alias('positive')]
   [string]
   $AddGroup,
   [Parameter(Mandatory,
      ValueFromPipeline,
      ValueFromPipelineByPropertyName,
      Position = 2,
      HelpMessage = 'Active Directory Group with users that would like have have the picture removed.')]
   [ValidateNotNullOrEmpty()]
   [string]
   $RemGroup,
   [Parameter(Mandatory,
      ValueFromPipeline,
      ValueFromPipelineByPropertyName,
      Position = 3,
      HelpMessage = 'Directory that contains the picures')]
   [ValidateNotNullOrEmpty()]
   [Alias('PixxDir')]
   [string]
   $PictureDir,
   [Parameter(ValueFromPipeline,
      ValueFromPipelineByPropertyName,
      Position = 5)]
   [Alias('defaultDomain')]
   [string]
   $UPNDomain,
   [Parameter(ValueFromPipeline,
      ValueFromPipelineByPropertyName,
      Position = 4)]
   [ValidateSet('png', 'jpg', 'gif', 'bmp')]
   [ValidateNotNullOrEmpty()]
   [string]
   $Extension = 'jpg',
   [switch]
   $workaround = $false
)

begin
{
   if ($workaround)
   {
      $null = (Add-PSSnapin -Name Microsoft.Exchange.Management.PowerShell.SnapIn)
   }

   $AddUserPixx = $null
   $NoUserPixx = $null

   if (-not ($PictureDir).EndsWith('\'))
   {
      $PictureDir = $PictureDir + '\'

      $paramWriteVerbose = @{
         Message = 'Fixed the Source Directory String!'
      }
      Write-Verbose @paramWriteVerbose
   }

   try
   {
      $paramGetADGroupMember = @{
         Identity      = $AddGroup
         ErrorAction   = 'Stop'
         WarningAction = 'SilentlyContinue'
      }
      $AddUserPixx = (Get-ADGroupMember @paramGetADGroupMember | Select-Object -ExpandProperty samaccountname)
   }
   catch
   {
      $paramWriteError = @{
         Message     = ('Unable to find {0}' -f $AddGroup)
         ErrorAction = 'Stop'
      }
      Write-Error @paramWriteError

      return
   }

   try
   {
      $paramGetADGroupMember = @{
         Identity      = $RemGroup
         ErrorAction   = 'Stop'
         WarningAction = 'SilentlyContinue'
      }
      $NoUserPixx = (Get-ADGroupMember @paramGetADGroupMember | Select-Object -ExpandProperty samaccountname)
   }
   catch
   {
      $paramWriteError = @{
         Message     = ('Unable to find {0}' -f $AddGroup)
         ErrorAction = 'Stop'
      }
      Write-Error @paramWriteError

      return
   }

   function Test-ValidEmail
   {
      [OutputType([bool])]
      param
      (
         [Parameter(Mandatory,
            HelpMessage = 'Address String to Check')]
         [ValidateNotNullOrEmpty()]
         [string]
         $address
      )

      process
      {
         ($address -as [mailaddress]).Address -eq $address -and $address -ne $null
      }
   }
}

process
{
   if (-not ($AddUserPixx.samaccountname))
   {
      $paramWriteVerbose = @{
         Message = ('The AD Group {0} has no members.' -f $AddGroup)
      }
      Write-Verbose @paramWriteVerbose
   }
   else
   {
      $AddUserPixxCount = (($AddUserPixx.samaccountname).count)

      $paramWriteVerbose = @{
         Message = ('The AD Group {0} has {1} members.' -f $AddGroup, $AddUserPixxCount)
      }
      Write-Verbose @paramWriteVerbose

      foreach ($AddUser in $AddUserPixx.samaccountname)
      {
         if (($NoUserPixx.samaccountname) -notcontains $AddUser)
         {
            if (-not (Test-ValidEmail -address ($AddUser)))
            {
               if (-not ($UPNDomain))
               {
                  $paramWriteError = @{
                     Message     = 'UPN Default Domain not set but needed!'
                     ErrorAction = 'Stop'
                  }
                  Write-Error @paramWriteError
               }
               else
               {
                  $AddUserUPN = ($AddUser + '@' + $UPNDomain)
               }
            }

            $SingleUserPicture = ($PictureDir + $AddUser + '.' + $Extension)

            $paramTestPath = @{
               Path          = $SingleUserPicture
               ErrorAction   = 'Stop'
               WarningAction = 'SilentlyContinue'
            }

            if (Test-Path @paramTestPath)
            {
               try
               {
                  $paramSetUserPhoto = @{
                     Identity      = $AddUserUPN
                     PictureData   = ([IO.File]::ReadAllBytes($SingleUserPicture))
                     Confirm       = $false
                     ErrorAction   = 'Stop'
                     WarningAction = 'SilentlyContinue'
                  }

                  $null = (Set-UserPhoto @paramSetUserPhoto)
               }
               catch
               {
                  $paramWriteWarning = @{
                     Message     = ('Unable to set Image {0} for User {1}' -f $SingleUserPicture, $AddUser)
                     ErrorAction = 'SilentlyContinue'
                  }
                  Write-Warning @paramWriteWarning
               }
            }
            else
            {
               $paramWriteWarning = @{
                  Message     = ('The Image {0} for User {1} was not found' -f $SingleUserPicture, $AddUser)
                  ErrorAction = 'SilentlyContinue'
               }
               Write-Warning @paramWriteWarning
            }
         }
         else
         {
            $paramWriteVerbose = @{
               Message = ('Sorry, User {0} is member of {1} and {2}' -f $AddUser, $AddGroup, $RemGroup)
            }
            Write-Verbose @paramWriteVerbose
         }
      }
   }

   if (-not ($NoUserPixx.samaccountname))
   {
      $paramWriteVerbose = @{
         Message = ('The AD Group {0} has no members.' -f $RemGroup)
      }
      Write-Verbose @paramWriteVerbose
   }
   else
   {
      $NoUserPixxCount = (($NoUserPixx.samaccountname).count)

      $paramWriteVerbose = @{
         Message = ('The AD Group {0} has {1} members.' -f $RemGroup, $NoUserPixxCount)
      }
      Write-Verbose @paramWriteVerbose

      foreach ($NoUser in $NoUserPixx.samaccountname)
      {
         if (-not (Test-ValidEmail -address ($NoUser)))
         {
            if (-not ($UPNDomain))
            {
               $paramWriteError = @{
                  Message     = 'UPN Default Domain not set but needed!'
                  ErrorAction = 'Stop'
               }
               Write-Error @paramWriteError
            }
            else
            {
               $NoUserUPN = ($NoUser + '@' + $UPNDomain)
            }
         }

         $paramSetUserPhoto = @{
            Identity      = $NoUserUPN
            Confirm       = $false
            ErrorAction   = 'Stop'
            WarningAction = 'SilentlyContinue'
         }

         try
         {
            $null = (Remove-UserPhoto @paramSetUserPhoto)
         }
         catch
         {
            $paramWriteWarning = @{
               Message     = ('Unable to handle {0} - Check that this user has a valid Mailbox!' -f $NoUser)
               ErrorAction = 'SilentlyContinue'
            }
            Write-Warning @paramWriteWarning
         }
      }
   }
}

end
{
   $AddUserPixx = $null
   $NoUserPixx = $null
   $AddUserPixxCount = $null
   $NoUserPixxCount = $null

   $null = ([GC]::Collect())
}

