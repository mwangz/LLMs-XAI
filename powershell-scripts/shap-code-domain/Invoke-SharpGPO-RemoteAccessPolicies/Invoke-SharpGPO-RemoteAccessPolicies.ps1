function Invoke-SharpGPO-RemoteAccessPolicies
{
    [CmdletBinding()]
    Param (
        [String]
        $Command = ""
    )
    $base64binary="TVqQAA...AAA" # The omitted "TVqQAA...AAA" is actually a 73729 character long hexadecimal string.
    $RAS = [System.Reflection.Assembly]::Load([Convert]::FromBase64String($base64binary))
    $OldConsoleOut = [Console]::Out
    $StringWriter = New-Object IO.StringWriter
    [Console]::SetOut($StringWriter)
    [SharpGPO_RemoteAccessPolicies.Program]::main($Command.Split(" "))
    [Console]::SetOut($OldConsoleOut)
    $Results = $StringWriter.ToString()
    $Results
}
