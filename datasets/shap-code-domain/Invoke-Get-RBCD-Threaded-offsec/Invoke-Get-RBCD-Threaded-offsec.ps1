function Invoke-Get-RBCD-Threaded
{
    [CmdletBinding()]
    Param (
        [String]
        $Command = ""
    )
    $a=New-Object IO.MemoryStream(,[Convert]::FromBAsE64String("H4sIAAAAAAAEAL,,,2fff0v2ZAx9gCOAAA=")) # NOTE: The actual 30504-character Base64 string omitted for readability.
    $decompressed = New-Object IO.Compression.GzipStream($a,[IO.Compression.CoMPressionMode]::DEComPress)
    $output = New-Object System.IO.MemoryStream
    $decompressed.CopyTo( $output )
    [byte[]] $byteOutArray = $output.ToArray()
    $RAS = [System.Reflection.Assembly]::Load($byteOutArray)
    $OldConsoleOut = [Console]::Out
    $StringWriter = New-Object IO.StringWriter
    [Console]::SetOut($StringWriter)
    [Get_RBCD.Program]::main($Command.Split(" "))
    [Console]::SetOut($OldConsoleOut)
    $Results = $StringWriter.ToString()
    $Results
}
