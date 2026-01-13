function Invoke-OxidResolver
{
    [CmdletBinding()]
    Param (
        [String]
        $Command = "domain"
    )
    $base64binary="TVqQAAMAAAAEAAAA//8AAL...AAAAAAAAAAAAAAAAAA=" # NOTE: The actual 72364-character Base64 string omitted for readability.
    $RAS = [System.Reflection.Assembly]::Load([Convert]::FromBase64String($base64binary))
    $OldConsoleOut = [Console]::Out
    $StringWriter = New-Object IO.StringWriter
    [Console]::SetOut($StringWriter)
    [OxidResolver.Program]::main($Command.Split(" "))
    [Console]::SetOut($OldConsoleOut)
    $Results = $StringWriter.ToString()
    $Results
}
