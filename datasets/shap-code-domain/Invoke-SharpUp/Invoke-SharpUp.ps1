function Invoke-SharpUp
{
    [CmdletBinding()]
    Param (
        [Parameter(Position = 0, Mandatory = $true)]
        [ValidateNotNullorEmpty()]
        [String]
        $Command
    )
    $base64binary="TVqQA...AAA="  # The omitted "TVqQA...AAA=" is actually a 41654 character long hexadecimal string.
    $RAS = [System.Reflection.Assembly]::Load([Convert]::FromBase64String($base64binary))
    $OldConsoleOut = [Console]::Out
    $StringWriter = New-Object IO.StringWriter
    [Console]::SetOut($StringWriter)
    [SharpUp.Program]::main($Command.Split(" "))
    [Console]::SetOut($OldConsoleOut)
    $Results = $StringWriter.ToString()
    $Results
}
