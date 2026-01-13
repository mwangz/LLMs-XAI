$Source = @"
using System;
using System.Collections.Generic;
using System.Runtime.InteropServices;
using System.Reflection;
public class sRDI
{
    [StructLayout(LayoutKind.Sequential, Pack = 1)]
    struct IMAGE_DATA_DIRECTORY
    {
        public uint VirtualAddress;
        public uint Size;
    }
    //[StructLayout(LayoutKind.Sequential, Pack = 1)]
    [StructLayout(LayoutKind.Explicit)]
    unsafe struct IMAGE_SECTION_HEADER
    {
        [FieldOffset(0)]
        public fixed byte Name[8];
        [FieldOffset(8)]
        public uint PhysicalAddress;
        [FieldOffset(8)]
        public uint VirtualSize;
        [FieldOffset(12)]
        public uint VirtualAddress;
        [FieldOffset(16)]
        public uint SizeOfRawData;
        [FieldOffset(20)]
        public uint PointerToRawData;
        [FieldOffset(24)]
        public uint PointerToRelocations;
        [FieldOffset(28)]
        public uint PointerToLinenumbers;
        [FieldOffset(32)]
        public ushort NumberOfRelocations;
        [FieldOffset(34)]
        public ushort NumberOfLinenumbers;
        [FieldOffset(36)]
        public uint Characteristics;
    }
    [StructLayout(LayoutKind.Sequential, Pack = 1)]
    struct IMAGE_FILE_HEADER
    {
        public ushort Machine;
        public ushort NumberOfSections;
        public uint TimeDateStamp;
        public uint PointerToSymbolTable;
        public uint NumberOfSymbols;
        public ushort SizeOfOptionalHeader;
        public ushort Characteristics;
    }
    [StructLayout(LayoutKind.Sequential, Pack = 1)]
    struct IMAGE_EXPORT_DIRECTORY
    {
        public uint Characteristics;
        public uint TimeDateStamp;
        public ushort MajorVersion;
        public ushort MinorVersion;
        public uint Name;
        public uint Base;
        public uint NumberOfFunctions;
        public uint NumberOfNames;
        public uint AddressOfFunctions;     // RVA from base of image
        public uint AddressOfNames;         // RVA from base of image
        public uint AddressOfNameOrdinals;  // RVA from base of image
    }
    enum IMAGE_DOS_SIGNATURE : ushort
    {
        DOS_SIGNATURE = 0x5A4D,      // MZ
        OS2_SIGNATURE = 0x454E,      // NE
        OS2_SIGNATURE_LE = 0x454C,      // LE
    }
    enum MagicType : ushort
    {
        IMAGE_NT_OPTIONAL_HDR32_MAGIC = 0x10b,
        IMAGE_NT_OPTIONAL_HDR64_MAGIC = 0x20b,
    }
    [StructLayout(LayoutKind.Sequential, Pack = 1)]
    struct IMAGE_DOS_HEADER
    {
        public IMAGE_DOS_SIGNATURE e_magic;        // Magic number
        public ushort e_cblp;                      // public bytes on last page of file
        public ushort e_cp;                        // Pages in file
        public ushort e_crlc;                      // Relocations
        public ushort e_cparhdr;                   // Size of header in paragraphs
        public ushort e_minalloc;                  // Minimum extra paragraphs needed
        public ushort e_maxalloc;                  // Maximum extra paragraphs needed
        public ushort e_ss;                        // Initial (relative) SS value
        public ushort e_sp;                        // Initial SP value
        public ushort e_csum;                      // Checksum
        public ushort e_ip;                        // Initial IP value
        public ushort e_cs;                        // Initial (relative) CS value
        public ushort e_lfarlc;                    // File address of relocation table
        public ushort e_ovno;                      // Overlay number
        [MarshalAs(UnmanagedType.ByValTStr, SizeConst = 8)]
        public string e_res;                       // May contain 'Detours!'
        public ushort e_oemid;                     // OEM identifier (for e_oeminfo)
        public ushort e_oeminfo;                   // OEM information; e_oemid specific
        [MarshalAsAttribute(UnmanagedType.ByValArray, SizeConst = 10)]
        public ushort[] e_res2;                      // Reserved public ushorts
        public Int32 e_lfanew;                    // File address of new exe header
    }
    [StructLayout(LayoutKind.Sequential, Pack = 1)]
    struct IMAGE_OPTIONAL_HEADER
    {
        //
        // Standard fields.
        //
        public MagicType Magic;
        public byte MajorLinkerVersion;
        public byte MinorLinkerVersion;
        public uint SizeOfCode;
        public uint SizeOfInitializedData;
        public uint SizeOfUninitializedData;
        public uint AddressOfEntryPoint;
        public uint BaseOfCode;
        public uint BaseOfData;
        public uint ImageBase;
        public uint SectionAlignment;
        public uint FileAlignment;
        public ushort MajorOperatingSystemVersion;
        public ushort MinorOperatingSystemVersion;
        public ushort MajorImageVersion;
        public ushort MinorImageVersion;
        public ushort MajorSubsystemVersion;
        public ushort MinorSubsystemVersion;
        public uint Win32VersionValue;
        public uint SizeOfImage;
        public uint SizeOfHeaders;
        public uint CheckSum;
        public ushort Subsystem;
        public ushort DllCharacteristics;
        public uint SizeOfStackReserve;
        public uint SizeOfStackCommit;
        public uint SizeOfHeapReserve;
        public uint SizeOfHeapCommit;
        public uint LoaderFlags;
        public uint NumberOfRvaAndSizes;
        public IMAGE_DATA_DIRECTORY ExportTable;
        public IMAGE_DATA_DIRECTORY ImportTable;
        public IMAGE_DATA_DIRECTORY ResourceTable;
        public IMAGE_DATA_DIRECTORY ExceptionTable;
        public IMAGE_DATA_DIRECTORY CertificateTable;
        public IMAGE_DATA_DIRECTORY BaseRelocationTable;
        public IMAGE_DATA_DIRECTORY Debug;
        public IMAGE_DATA_DIRECTORY Architecture;
        public IMAGE_DATA_DIRECTORY GlobalPtr;
        public IMAGE_DATA_DIRECTORY TLSTable;
        public IMAGE_DATA_DIRECTORY LoadConfigTable;
        public IMAGE_DATA_DIRECTORY BoundImport;
        public IMAGE_DATA_DIRECTORY IAT;
        public IMAGE_DATA_DIRECTORY DelayImportDescriptor;
        public IMAGE_DATA_DIRECTORY CLRRuntimeHeader;
        public IMAGE_DATA_DIRECTORY Public;
    }
    [StructLayout(LayoutKind.Sequential, Pack = 1)]
    struct IMAGE_OPTIONAL_HEADER64
    {
        public MagicType Magic;
        public byte MajorLinkerVersion;
        public byte MinorLinkerVersion;
        public uint SizeOfCode;
        public uint SizeOfInitializedData;
        public uint SizeOfUninitializedData;
        public uint AddressOfEntryPoint;
        public uint BaseOfCode;
        public ulong ImageBase;
        public uint SectionAlignment;
        public uint FileAlignment;
        public ushort MajorOperatingSystemVersion;
        public ushort MinorOperatingSystemVersion;
        public ushort MajorImageVersion;
        public ushort MinorImageVersion;
        public ushort MajorSubsystemVersion;
        public ushort MinorSubsystemVersion;
        public uint Win32VersionValue;
        public uint SizeOfImage;
        public uint SizeOfHeaders;
        public uint CheckSum;
        public ushort Subsystem;
        public ushort DllCharacteristics;
        public ulong SizeOfStackReserve;
        public ulong SizeOfStackCommit;
        public ulong SizeOfHeapReserve;
        public ulong SizeOfHeapCommit;
        public uint LoaderFlags;
        public uint NumberOfRvaAndSizes;
        public IMAGE_DATA_DIRECTORY ExportTable;
        public IMAGE_DATA_DIRECTORY ImportTable;
        public IMAGE_DATA_DIRECTORY ResourceTable;
        public IMAGE_DATA_DIRECTORY ExceptionTable;
        public IMAGE_DATA_DIRECTORY CertificateTable;
        public IMAGE_DATA_DIRECTORY BaseRelocationTable;
        public IMAGE_DATA_DIRECTORY Debug;
        public IMAGE_DATA_DIRECTORY Architecture;
        public IMAGE_DATA_DIRECTORY GlobalPtr;
        public IMAGE_DATA_DIRECTORY TLSTable;
        public IMAGE_DATA_DIRECTORY LoadConfigTable;
        public IMAGE_DATA_DIRECTORY BoundImport;
        public IMAGE_DATA_DIRECTORY IAT;
        public IMAGE_DATA_DIRECTORY DelayImportDescriptor;
        public IMAGE_DATA_DIRECTORY CLRRuntimeHeader;
        public IMAGE_DATA_DIRECTORY Public;
    }
    [StructLayout(LayoutKind.Sequential, Pack = 1)]
    struct IMAGE_NT_HEADERS64
    {
        public uint Signature;
        public IMAGE_FILE_HEADER FileHeader;
        public IMAGE_OPTIONAL_HEADER64 OptionalHeader;
    }
    [StructLayout(LayoutKind.Sequential, Pack = 1)]
    struct IMAGE_NT_HEADERS
    {
        public uint Signature;
        public IMAGE_FILE_HEADER FileHeader;
        public IMAGE_OPTIONAL_HEADER OptionalHeader;
    }
    public delegate int SIZEOFHELPER(Type type, bool throwIfNotMarshalable);
    public static unsafe class InteropTools
    {   
        //static ctor
        static InteropTools()
        {
            BindingFlags flags = BindingFlags.NonPublic | BindingFlags.Static;
            MethodInfo tmi = typeof(System.Runtime.InteropServices.Marshal).GetMethod("SizeOfHelper", flags);
            if (null != tmi)
              SizeOfHelper_f = (SIZEOFHELPER)Delegate.CreateDelegate(typeof(SIZEOFHELPER), tmi);
            Type SafeBufferType = Type.GetType("System.Runtime.InteropServices.SafeBuffer");
            if (null == SafeBufferType)
                //.Net 2.0 SafePointer has the members instead of SafeBuffer
                SafeBufferType = Type.GetType("System.Runtime.InteropServices.SafePointer");
            MethodInfo PtrToStructureNativeMethod = SafeBufferType.GetMethod("PtrToStructureNative", flags);
            MethodInfo StructureToPtrNativeMethod = SafeBufferType.GetMethod("StructureToPtrNative", flags);
            PtrToStructureNative       = (PtrToStructureNativeDelegate)Delegate.CreateDelegate(typeof(PtrToStructureNativeDelegate), PtrToStructureNativeMethod);
            StructureToPtrNative       = (StructureToPtrNativeDelegate)Delegate.CreateDelegate(typeof(StructureToPtrNativeDelegate), StructureToPtrNativeMethod);
        }
        public delegate void PtrToStructureNativeDelegate(byte* ptr, TypedReference structure, uint sizeofT);
        public delegate void StructureToPtrNativeDelegate(TypedReference structure, byte* ptr, uint sizeofT);
        public static readonly PtrToStructureNativeDelegate PtrToStructureNative;
        public static readonly StructureToPtrNativeDelegate StructureToPtrNative;
        private static readonly SIZEOFHELPER SizeOfHelper_f = null;
        public static void StructureToPtrDirect(TypedReference structure, IntPtr ptr, int size)
        {
            StructureToPtrNative(structure, (byte*)ptr, unchecked((uint)size));
        }
        public static void StructureToPtrDirect(TypedReference structure, IntPtr ptr)
        {
            StructureToPtrDirect(structure, ptr, SizeOf(__reftype(structure)));
        }
        public static void PtrToStructureDirect(IntPtr ptr, TypedReference structure, int size)
        {
            PtrToStructureNative((byte*)ptr, structure, unchecked((uint)size));
        }
        public static void PtrToStructureDirect(IntPtr ptr, TypedReference structure)
        {
            PtrToStructureDirect(ptr, structure, SizeOf(__reftype(structure)));
        }
        public static void StructureToPtr<T>(ref T structure, IntPtr ptr)
        {
            StructureToPtrDirect(__makeref(structure), ptr);
        }
        public static void PtrToStructure<T>(IntPtr ptr, out T structure)
        {
            structure = default(T);
            PtrToStructureDirect(ptr, __makeref(structure));
        }
        public static T PtrToStructure<T>(IntPtr ptr)
        {
            T obj;
            PtrToStructure(ptr, out obj);
            return obj;
        }
        public static int SizeOf<T>(T structure)
        {
            return SizeOf<T>();
        }
        public static int SizeOf<T>()
        {
            return SizeOf(typeof(T));
        }
        public static int SizeOf(Type t)
        {
            if (null != SizeOfHelper_f)
                return SizeOfHelper_f(t, true);
            else 
                return System.Runtime.InteropServices.Marshal.SizeOf(t);
        }
    }
    public static IntPtr Rva2Offset(uint dwRva, IntPtr PEPointer)
    {
        bool is64Bit = false;
        ushort wIndex = 0;
        ushort wNumberOfSections = 0;
        IntPtr imageSectionPtr;
        IMAGE_SECTION_HEADER SectionHeader;
        int sizeOfSectionHeader = Marshal.SizeOf(typeof(IMAGE_SECTION_HEADER));
        IMAGE_DOS_HEADER dosHeader = InteropTools.PtrToStructure<IMAGE_DOS_HEADER>(PEPointer);
        IntPtr NtHeadersPtr = (IntPtr)((UInt64)PEPointer + (UInt64)dosHeader.e_lfanew);
        IMAGE_NT_HEADERS imageNtHeaders32 = (IMAGE_NT_HEADERS)Marshal.PtrToStructure(NtHeadersPtr, typeof(IMAGE_NT_HEADERS));
        IMAGE_NT_HEADERS64 imageNtHeaders64 = (IMAGE_NT_HEADERS64)Marshal.PtrToStructure(NtHeadersPtr, typeof(IMAGE_NT_HEADERS64));
        if (imageNtHeaders64.OptionalHeader.Magic == MagicType.IMAGE_NT_OPTIONAL_HDR64_MAGIC) is64Bit = true;
        if (is64Bit)
        {
            imageSectionPtr = (IntPtr)(((Int64)NtHeadersPtr + (Int64)Marshal.OffsetOf(typeof(IMAGE_NT_HEADERS64), "OptionalHeader") + (Int64)imageNtHeaders64.FileHeader.SizeOfOptionalHeader));
            SectionHeader = (IMAGE_SECTION_HEADER)Marshal.PtrToStructure(imageSectionPtr, typeof(IMAGE_SECTION_HEADER));
            wNumberOfSections = imageNtHeaders64.FileHeader.NumberOfSections;
        }
        else
        {
            imageSectionPtr = (IntPtr)(((Int64)NtHeadersPtr + (Int64)Marshal.OffsetOf(typeof(IMAGE_NT_HEADERS), "OptionalHeader") + (Int64)imageNtHeaders32.FileHeader.SizeOfOptionalHeader));
            SectionHeader = (IMAGE_SECTION_HEADER)Marshal.PtrToStructure(imageSectionPtr, typeof(IMAGE_SECTION_HEADER));
            wNumberOfSections = imageNtHeaders32.FileHeader.NumberOfSections;
        }
        if (dwRva < SectionHeader.PointerToRawData)
            return (IntPtr)((UInt64)dwRva + (UInt64)PEPointer);
        for (wIndex = 0; wIndex < wNumberOfSections; wIndex++)
        {
            SectionHeader = (IMAGE_SECTION_HEADER)Marshal.PtrToStructure((IntPtr)((uint)imageSectionPtr + (uint)(sizeOfSectionHeader * (wIndex))), typeof(IMAGE_SECTION_HEADER));
            if (dwRva >= SectionHeader.VirtualAddress && dwRva < (SectionHeader.VirtualAddress + SectionHeader.SizeOfRawData))
                return (IntPtr)((UInt64)(dwRva - SectionHeader.VirtualAddress + SectionHeader.PointerToRawData) + (UInt64)PEPointer);
        }
        return IntPtr.Zero;
    }
    public static unsafe bool Is64BitDLL(byte[] dllBytes)
    {
        bool is64Bit = false;
        GCHandle scHandle = GCHandle.Alloc(dllBytes, GCHandleType.Pinned);
        IntPtr scPointer = scHandle.AddrOfPinnedObject();
        IMAGE_DOS_HEADER dosHeader = (IMAGE_DOS_HEADER)Marshal.PtrToStructure(scPointer, typeof(IMAGE_DOS_HEADER));
        IntPtr NtHeadersPtr = (IntPtr)((UInt64)scPointer + (UInt64)dosHeader.e_lfanew);
        IMAGE_NT_HEADERS64 imageNtHeaders64 = (IMAGE_NT_HEADERS64)Marshal.PtrToStructure(NtHeadersPtr, typeof(IMAGE_NT_HEADERS64));
        IMAGE_NT_HEADERS imageNtHeaders32 = (IMAGE_NT_HEADERS)Marshal.PtrToStructure(NtHeadersPtr, typeof(IMAGE_NT_HEADERS));
        if (imageNtHeaders64.Signature != 0x00004550)
            throw new ApplicationException("Invalid IMAGE_NT_HEADER signature.");
        if (imageNtHeaders64.OptionalHeader.Magic == MagicType.IMAGE_NT_OPTIONAL_HDR64_MAGIC) is64Bit = true;
        scHandle.Free();
        return is64Bit;
    }
    [UnmanagedFunctionPointer(CallingConvention.StdCall)]
    delegate IntPtr ReflectiveLoader();
    [UnmanagedFunctionPointer(CallingConvention.Cdecl)]
    delegate bool ExportedFunction(IntPtr userData, uint userLength);
    public static byte[] ConvertToShellcode(byte[] dllBytes, uint functionHash, byte[] userData)
    {
        byte[] rdiShellcode64 = new byte[] { 0xe9, 0x1b, 0x04, 0x00, 0x00,..., 0xe6, 0x5e, 0xc3 }; # NOTE: The actual 6466-character Base64 string omitted for readability.
        byte[] rdiShellcode32 = new byte[] { 0x55, 0x8b, 0xec, 0x83, 0xec, 0x18,..., 0xc1, 0xeb, 0xe1 }; # NOTE: The actual 4966-character Base64 string omitted for readability.
        List<byte> newShellcode = new List<byte>();
        if (Is64BitDLL(dllBytes))
        {
            byte[] rdiShellcode = rdiShellcode64;
            int bootstrapSize = 34;
            // call next instruction (Pushes next instruction address to stack)
            newShellcode.Add(0xe8);
            newShellcode.Add(0x00);
            newShellcode.Add(0x00);
            newShellcode.Add(0x00);
            newShellcode.Add(0x00);
            //Here is where the we pop the address of our shellcode off the stack and into the first register
            // pop rcx
            newShellcode.Add(0x59);
            // mov r8, rcx - Backup our memory location to RCX before we start subtracting
            newShellcode.Add(0x49);
            newShellcode.Add(0x89);
            newShellcode.Add(0xc8);
            // Put the location of the DLL into RCX
            // add rcx, <Length of bootstrap> - 5 (For our call instruction) + <rdiShellcode Length>
            newShellcode.Add(0x48);
            newShellcode.Add(0x81);
            newShellcode.Add(0xc1);
            foreach (byte b in BitConverter.GetBytes((uint)(bootstrapSize - 5 + rdiShellcode.Length)))
                newShellcode.Add(b);
            // mov edx, <hash of function>
            newShellcode.Add(0xba);
            foreach (byte b in BitConverter.GetBytes((uint)functionHash))
                newShellcode.Add(b);
            // Put the location of our user data in 
            // add r8, (Size of bootstrap) + <Length of RDI Shellcode> + <Length of DLL>
            newShellcode.Add(0x49);
            newShellcode.Add(0x81);
            newShellcode.Add(0xc0);
            foreach (byte b in BitConverter.GetBytes((uint)(bootstrapSize - 5 + rdiShellcode.Length + dllBytes.Length)))
                newShellcode.Add(b);
            // mov r9d, <Length of User Data>
            newShellcode.Add(0x41);
            newShellcode.Add(0xb9);
            foreach (byte b in BitConverter.GetBytes((uint)userData.Length))
                newShellcode.Add(b);
            //Write the rest of RDI
            foreach (byte b in rdiShellcode)
                newShellcode.Add(b);
            //Write our DLL
            dllBytes[0] = 0x00;
            dllBytes[1] = 0x00;
            foreach (byte b in dllBytes)
                newShellcode.Add(b);
            //Write our userdata
            foreach (byte b in userData)
                newShellcode.Add(b);
        }
        else // 32 Bit
        {
            byte[] rdiShellcode = rdiShellcode32;
            int bootstrapSize = 40;
            // call next instruction (Pushes next instruction address to stack)
            newShellcode.Add(0xe8);
            newShellcode.Add(0x00);
            newShellcode.Add(0x00);
            newShellcode.Add(0x00);
            newShellcode.Add(0x00);
            //Here is where the we pop the address of our shellcode off the stack and into the first register
            // pop ecx
            newShellcode.Add(0x58);
            // mov ebx, eax - copy our location in memory to ebx before we start modifying eax
            newShellcode.Add(0x89);
            newShellcode.Add(0xc3);
            // Put the location of the DLL into ECX
            // add eax, <size of bootstrap> + <Size of RDI Shellcode>
            newShellcode.Add(0x05);
            foreach (byte b in BitConverter.GetBytes((uint)(bootstrapSize - 5 + rdiShellcode.Length)))
                newShellcode.Add(b);
            // add ebx, <size of bootstrap> + <Size of RDI Shellcode> + <Size of DLL>
            newShellcode.Add(0x81);
            newShellcode.Add(0xc3);
            foreach (byte b in BitConverter.GetBytes((uint)(bootstrapSize - 5 + rdiShellcode.Length + dllBytes.Length)))
                newShellcode.Add(b);
            //push <Length of User Data>
            newShellcode.Add(0x68);
            foreach (byte b in BitConverter.GetBytes((uint)userData.Length))
                newShellcode.Add(b);
            // push ebx
            newShellcode.Add(0x53);
            // push <hash of function>
            newShellcode.Add(0x68);
            foreach (byte b in BitConverter.GetBytes((uint)functionHash))
                newShellcode.Add(b);
            // push eax
            newShellcode.Add(0x50);
            // call instruction - We need to transfer execution to the RDI assembly this way (Skip over our next few op codes)
            newShellcode.Add(0xe8);
            newShellcode.Add(0x04);
            newShellcode.Add(0x00);
            newShellcode.Add(0x00);
            newShellcode.Add(0x00);
            // add esp, 0x10 - RDI pushes things to the stack it never removes, we need to make the correction ourselves
            newShellcode.Add(0x83);
            newShellcode.Add(0xc4);
            newShellcode.Add(0x10);
            // ret - because we used call earlier
            newShellcode.Add(0xc3);
            //Write the rest of RDI
            foreach (byte b in rdiShellcode)
                newShellcode.Add(b);
            //Write our DLL
            dllBytes[0] = 0x00;
            dllBytes[1] = 0x00;
            foreach (byte b in dllBytes)
                newShellcode.Add(b);
            //Write our userdata
            foreach (byte b in userData)
                newShellcode.Add(b);
        }
        return newShellcode.ToArray();
    }
}
"@
function ConvertTo-Shellcode{
    [CmdletBinding()]
    Param(
      [Parameter(Mandatory=$True,Position=1)]
      [string]$File,
      [Parameter(Position=2)]
      [int]$FunctionHash = 0x30627745,
      [Parameter(Position=3)]
      [string]$UserData = "None"
    )
    $Parameters = New-Object System.CodeDom.Compiler.CompilerParameters
    $Parameters.CompilerOptions += "/unsafe"
    Add-Type -TypeDefinition $Source -Language CSharp -CompilerParameters $Parameters
    $FileData = Get-Content $File -Encoding Byte
    $UserDataBytes =  [system.Text.Encoding]::Default.GetBytes($UserData + "\0")
    [sRDI]::ConvertToShellcode($FileData, $FunctionHash, $UserDataBytes)
}
