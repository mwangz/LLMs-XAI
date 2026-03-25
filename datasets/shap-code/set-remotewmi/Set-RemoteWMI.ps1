function Set-RemoteWMI
{    
    [CmdletBinding()] Param(
        [Parameter(Position = 0, Mandatory = $True)]
        [String]
        $UserName,
        [Parameter(Position = 1, Mandatory = $False)]
        [String]
        $ComputerName,
        [Parameter(Position = 2, Mandatory = $False)]
        [ValidateNotNull()]
        [System.Management.Automation.PSCredential]
        [System.Management.Automation.Credential()]
        $Credential = [System.Management.Automation.PSCredential]::Empty,
        [Parameter(Position = 3, Mandatory = $False)]
        [String]
        $Namespace = 'root',
        [Parameter(Mandatory = $False)]
        [Switch]
        $NotAllNamespaces,
        [Parameter(Mandatory = $False)]
        [Switch]
        $Remove
    )
    $currentPrincipal = New-Object Security.Principal.WindowsPrincipal( [Security.Principal.WindowsIdentity]::GetCurrent())
    if($currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator) -ne $true) 
    {
        Write-Warning "Run the script as an Administrator"
        Break
    }
    $SID = (New-Object System.Security.Principal.NTAccount($UserName)).Translate([System.Security.Principal.SecurityIdentifier]).value
    if ($NotAllNamespaces)
    {
        $SDDL = "A;;CCDCLCSWRPWPRCWD;;;$SID"
    }
    else
    {
        $SDDL = "A;CI;CCDCLCSWRPWPRCWD;;;$SID"
    }
    $DCOMSDDL = "A;;CCDCLCSWRP;;;$SID"
    if ($ComputerName)
    {
        $RegProvider = Get-WmiObject -Namespace root\default -Class StdRegProv -List -ComputerName $ComputerName -Credential $Credential
        $Security = Get-WmiObject -Namespace $Namespace -Class __SystemSecurity -List -ComputerName $ComputerName -Credential $Credential
        $Converter = Get-WmiObject -Namespace root\cimv2 -Class Win32_SecurityDescriptorHelper -List -ComputerName $ComputerName -Credential $Credential
    }
    else
    {
        $RegProvider = Get-WmiObject -Namespace root\default -Class StdRegProv -List
        $Security = Get-WmiObject -Namespace $Namespace -Class __SystemSecurity -List
        $Converter = Get-WmiObject -Namespace root\cimv2 -Class Win32_SecurityDescriptorHelper -List
    }
    $DCOM = $RegProvider.GetBinaryValue(2147483650,"Software\Microsoft\Ole","MachineLaunchRestriction").uValue
    $binarySD = @($null)
    $result = $Security.PSBase.InvokeMethod("GetSD",$binarySD)
    $outsddl = $converter.BinarySDToSDDL($binarySD[0])
    Write-Verbose "Existing ACL for namespace $Namespace is $($outsddl.SDDL)"
    $outDCOMSDDL = $converter.BinarySDToSDDL($DCOM)
    Write-Verbose "Existing ACL for DCOM is $($outDCOMSDDL.SDDL)"
    if (!$Remove)
    {
        $newSDDL = $outsddl.SDDL += "(" + $SDDL + ")"
        Write-Verbose "New ACL for namespace $Namespace is $newSDDL"
        $newDCOMSDDL = $outDCOMSDDL.SDDL += "(" + $DCOMSDDL + ")"
        Write-Verbose "New ACL for DCOM $newDCOMSDDL"
        $WMIbinarySD = $converter.SDDLToBinarySD($newSDDL)
        $WMIconvertedPermissions = ,$WMIbinarySD.BinarySD
        $DCOMbinarySD = $converter.SDDLToBinarySD($newDCOMSDDL)
        $DCOMconvertedPermissions = ,$DCOMbinarySD.BinarySD
        $result = $Security.PsBase.InvokeMethod("SetSD",$WMIconvertedPermissions)
        $result = $RegProvider.SetBinaryValue(2147483650,"Software\Microsoft\Ole","MachineLaunchRestriction", $DCOMbinarySD.binarySD)
    }
    elseif ($Remove)
    {
        Write-Verbose "Removing added entries"
        $SDDL = "(" + $SDDL + ")"
        $revertsddl = ($outsddl.SDDL).Replace($SDDL,"")
        Write-Verbose "Removing permissions for $UserName from ACL for $Namespace namespace"
        $DCOMSDDL = "(" + $DCOMSDDL + ")"
        $revertDCOMSDDL = ($outDCOMSDDL.SDDL).Replace($DCOMSDDL,"")
        Write-Verbose "Removing permissions for $UserName for DCOM"
        $WMIbinarySD = $converter.SDDLToBinarySD($revertsddl)
        $WMIconvertedPermissions = ,$WMIbinarySD.BinarySD
        $DCOMbinarySD = $converter.SDDLToBinarySD($revertDCOMSDDL)
        $DCOMconvertedPermissions = ,$DCOMbinarySD.BinarySD
        $result = $Security.PsBase.InvokeMethod("SetSD",$WMIconvertedPermissions)
        $result = $RegProvider.SetBinaryValue(2147483650,"Software\Microsoft\Ole","MachineLaunchRestriction", $DCOMbinarySD.binarySD)
        Write-Verbose "The new ACL for namespace $Namespace is $revertsddl"
        Write-Verbose "The new ACL for DCOM is $revertDCOMSDDL"
    }
}
