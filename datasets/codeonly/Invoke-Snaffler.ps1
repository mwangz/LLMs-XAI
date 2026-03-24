function Invoke-Snaffler
{
    [CmdletBinding()]
    Param (
        [String]
        $Command = "-u -s -y -o .\snaffler.tsv"
    )
    $a=New-Object IO.MemoryStream(,[Convert]::FromBAsE64String("H4sIA...CwA=")) # The omitted "H4sIA...CwA=" is actually a 8959625 character long hexadecimal string. 
	$decompressed = New-Object IO.Compression.GzipStream($a,[IO.Compression.CoMPressionMode]::DEComPress)
    $output = New-Object System.IO.MemoryStream
    $decompressed.CopyTo( $output )
    [byte[]] $byteOutArray = $output.ToArray()
    $RAS = [System.Reflection.Assembly]::Load($byteOutArray)
    $OldConsoleOut = [Console]::Out
    $StringWriter = New-Object IO.StringWriter
    [Console]::SetOut($StringWriter)
    [sn4ffl3r.sn4ffl3r]::Main($Command.Split(" "))
    [Console]::SetOut($OldConsoleOut)
    $Results = $StringWriter.ToString()
    $Results
}
