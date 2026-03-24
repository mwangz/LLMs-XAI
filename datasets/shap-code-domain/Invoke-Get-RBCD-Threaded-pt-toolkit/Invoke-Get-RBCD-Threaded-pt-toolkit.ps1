function Invoke-Get-RBCD-Threaded
{
    [CmdletBinding()]
    Param (
        [String]
        $Command = ""
    )
    $a=New-Object IO.MemoryStream(,[Convert]::FromBAsE64String("H4sIAAAAAAAEALy8CTxV6/c/vs98HByOeZ7nqZBZlCazMhdFmccTosxkKJkVEiGhUIYIiRRFI0VFGUMkQ+YM4b/3Phru/dzf536//9f/9z/uee+11rOe9ay1nnHv29kGR5IAFAAAaPC7uQkAtQDlswv4908Y+CXy1hGBKqpX/LUI/Vf8ps4uPnwnvclO3sc9+Oy...4vALr4mDG/ev2fff0v2ZAx9gCOAAA=")) # NOTE: The actual 30504-character Base64 string omitted for readability.
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
