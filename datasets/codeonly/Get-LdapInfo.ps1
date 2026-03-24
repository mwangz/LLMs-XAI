Function Get-LdapInfo {
    [CmdletBinding()]
        param(
            [Parameter(
                Mandatory=$False)]
            [switch][bool]$Detailed,
            [Parameter(
                Mandatory=$False)]
            [switch][bool]$LDAPS,
            [Parameter(
                Mandatory=$False)]
            [switch][bool]$DomainControllers,
            [Parameter(
                Mandatory=$False)]
            [switch][bool]$AllServers,
            [Parameter(
                Mandatory=$False)]
            [switch][bool]$AllMemberServers,
            [Parameter(
                Mandatory=$False)]
            [switch][bool]$DomainTrusts,
            [Parameter(
                Mandatory=$False)]
            [switch][bool]$DomainAdmins,
            [Parameter(
                Mandatory=$False)]
            [switch][bool]$UACTrusted,
            [Parameter(
                Mandatory=$False)]
            [switch][bool]$NotUACTrusted,
            [Parameter(
                Mandatory=$False)]
            [switch][bool]$SPNNamedObjects,
            [Parameter(
                Mandatory=$False)]
            [switch][bool]$EnabledUsers,
            [Parameter(
                Mandatory=$False)]
            [switch][bool]$PossibleExecutives,
            [Parameter(
                Mandatory=$False)]
            [switch][bool]$LogonScript,
            [Parameter(
                Mandatory=$False)]
            [switch][bool]$ListAllOU,
            [Parameter(
                Mandatory=$False)]
            [switch][bool]$ListComputers,
            [Parameter(
                Mandatory=$False)]
            [switch][bool]$ListContacts,
            [Parameter(
                Mandatory=$False)]
            [switch][bool]$ListGroups,
            [Parameter(
                Mandatory=$False)]
            [switch][bool]$ListUsers,
            [Parameter(
                Mandatory=$False)]
            [switch][bool]$ListContainers,
            [Parameter(
                Mandatory=$False)]
            [switch][bool]$ListDomainObjects,
            [Parameter(
                Mandatory=$False)]
            [switch][bool]$ListBuiltInContainers,
            [Parameter(
                Mandatory=$False)]
            [switch][bool]$ChangePasswordAtNextLogon,
            [Parameter(
                Mandatory=$False)]
            [switch][bool]$PasswordNeverExpires,
            [Parameter(
                Mandatory=$False)]
            [switch][bool]$NoPasswordRequired,
            [Parameter(
                Mandatory=$False)]
            [switch][bool]$NoKerberosPreAuthRequired,
            [Parameter(
                Mandatory=$False)]
            [switch][bool]$PasswordsThatHaveNotChangedInYears,
            [Parameter(
                Mandatory=$False)]
            [switch][bool]$DistributionGroups,
            [Parameter(
                Mandatory=$False)]
            [switch][bool]$SecurityGroups,
            [Parameter(
                Mandatory=$False)]
            [switch][bool]$BuiltInGroups,
            [Parameter(
                Mandatory=$False)]
            [switch][bool]$AllGLobalGroups,
            [Parameter(
                Mandatory=$False)]
            [switch][bool]$DomainLocalGroups,
            [Parameter(
                Mandatory=$False)]
            [switch][bool]$UniversalGroups,
            [Parameter(
                Mandatory=$False)]
            [switch][bool]$GlobalSecurityGroups,
            [Parameter(
                Mandatory=$False)]
            [switch][bool]$UniversalSecurityGroups,
            [Parameter(
                Mandatory=$False)]
            [switch][bool]$DomainLocalSecurityGroups,
            [Parameter(
                Mandatory=$False)]
            [switch][bool]$GlobalDistributionGroups
        ) # End param
    BEGIN
    {
        Write-Verbose "Creating LDAP query..."
            If ($DomainControllers.IsPresent) {$LdapFilter = "(primaryGroupID=516)"}
            ElseIf ($AllServers.IsPresent) {$LdapFilter = '(&(objectCategory=computer)(operatingSystem=*server*))'}
            ElseIf ($AllMemberServers.IsPresent) {$LdapFilter = '(&(objectCategory=computer)(operatingSystem=*server*)(!(userAccountControl:1.2.840.113556.1.4.803:=8192)))'}
            ElseIf ($DomainTrusts.IsPresent) {$LdapFilter = '(objectClass=trustedDomain)'}
            ElseIf ($DomainAdmins.IsPresent) {$LdapFilter =  "(&(objectCategory=person)(objectClass=user)((memberOf=CN=Domain Admins,OU=Admin Accounts,DC=usav,DC=org)))"}
            ElseIf ($UACTrusted.IsPresent) {$LdapFilter =  "(userAccountControl:1.2.840.113556.1.4.803:=524288)"}
            ElseIf ($NotUACTrusted.IsPresent) {$LdapFilter = '(userAccountControl:1.2.840.113556.1.4.803:=1048576)'}
            ElseIf ($SPNNamedObjects.IsPresent) {$LdapFilter = '(servicePrincipalName=*)'}
            ElseIf ($EnabledUsers.IsPresent) {$LdapFilter = '(&(objectCategory=person)(objectClass=user)(!(userAccountControl:1.2.840.113556.1.4.803:=2)))'}
            ElseIf ($PossibleExecutives.IsPresent) {$LdapFilter = '(&(objectCategory=person)(objectClass=user)(directReports=*)(!(manager=*)))'}
            ElseIf ($LogonScript.IsPresent) {$LdapFilter = '(&(objectCategory=person)(objectClass=user)(scriptPath=*))'}
            ElseIf ($ListAllOU.IsPresent) {$LdapFilter = '(objectCategory=organizationalUnit)'}
            ElseIf ($ListComputers.IsPresent) {$LdapFilter = '(objectCategory=computer)'}
            ElseIf ($ListContacts.IsPresent) {$LdapFilter = '(objectClass=contact)'}
            ElseIf ($ListUsers.IsPresent) {$LdapFilter = 'samAccountType=805306368'}
            ElseIf ($ListGroups.IsPresent) {$LdapFilter = '(objectCategory=group)'}
            ElseIf ($ListContainers.IsPresent) {$LdapFilter = '(objectCategory=container)'}
            ElseIf ($ListDomainObjects.IsPresent) {$LdapFilter = '(objectCategory=domain)'}
            ElseIf ($ListBuiltInContainers.IsPresent) {$LdapFilter = '(objectCategory=builtinDomain)'}
            ElseIf ($ChangePasswordAtNextLogon.IsPresent) {$LdapFilter = '(&(objectCategory=person)(objectClass=user)(pwdLastSet=0))'}
            ElseIf ($PasswordNeverExpires.IsPresent) {$LdapFilter = '(&(objectCategory=person)(objectClass=user) (userAccountControl:1.2.840.113556.1.4.803:=65536))'}
            ElseIf ($NoPasswordRequired.IsPresent) {$LdapFilter = '(&(objectCategory=person)(objectClass=user) (userAccountControl:1.2.840.113556.1.4.803:=32))'}
            ElseIf ($NoKerberosPreAuthRequired.IsPresent) {'(&(objectCategory=person)(objectClass=user)(userAccountControl:1.2.840.113556.1.4.803:=4194304))'}
            ElseIf ($PasswordsThatHaveNotChangedInYears.IsPresent) {$LdapFilter = '(&(objectCategory=person)(objectClass=user) (pwdLastSet>=129473172000000000))'}
            ElseIf ($DistributionGroups.IsPresent) {$LdapFilter = '(&(objectCategory=group)(!(groupType:1.2.840.113556.1.4.803:=2147483648)))'}
            ElseIf ($SecurityGroups.IsPresent) {$LdapFilter = '(groupType:1.2.840.113556.1.4.803:=2147483648)'}
            ElseIf ($BuiltInGroups.IsPresent) {$LdapFilter = '(groupType:1.2.840.113556.1.4.803:=1)'}
            ElseIf ($AllGlobalGroups.IsPresent) {$LdapFilter = '(groupType:1.2.840.113556.1.4.803:=2)'}
            ElseIf ($DomainLocalGroups.IsPresent) {$LdapFilter = '(groupType:1.2.840.113556.1.4.803:=4)'}
            ElseIf ($UniversalGroups.IsPresent) {$LdapFilter = '(groupType:1.2.840.113556.1.4.803:=8)'}
            ElseIf ($GlobalSecurityGroups.IsPresent) {$LdapFilter = '(groupType=-2147483646)'}
            ElseIf ($UniversalSecurityGroups.IsPresent) {$LdapFilter = '(groupType=-2147483640)'}
            ElseIf ($DomainLocalSecurityGroups.IsPresent) {$LdapFilter = '(groupType=-2147483644)'}
            ElseIf ($GlobalDistributionGroups.IsPresent) {$LdapFilter = '(groupType=2)'}
            $DomainObj = [System.DirectoryServices.ActiveDirectory.Domain]::GetCurrentDomain()
            $Domain = New-Object -TypeName System.DirectoryServices.DirectoryEntry
            $Searcher = New-Object -TypeName System.DirectoryServices.DirectorySearcher([ADSI]$SearchString)
            $ObjDomain = New-Object -TypeName System.DirectoryServices.DirectoryEntry
            If ($LDAPS.IsPresent)
            {
                Write-Verbose "[*] LDAP over SSL was specified. Using port 636"
                $SearchString =  "LDAP://" + $PrimaryDC + ":636/"
            }  # End If
            Else
            {
                $SearchString =  "LDAP://" + $PrimaryDC + ":389/"
            }  # End Else
            $PrimaryDC = ($DomainObj.PdcRoleOwner).Name
            $DistinguishedName = "DC=$($DomainObj.Name.Replace('.',',DC='))"
            $SearchString += $DistinguishedName
            $Searcher.SearchRoot = $ObjDomain
            $Searcher.Filter = $LdapFilter
            $Searcher.SearchScope = "Subtree"
        } # End BEGIN
    PROCESS
    {
        $Results = $Searcher.FindAll()
        Write-Verbose "[*] Getting results..."
        If ($Detailed.IsPresent)
        {
            If ($Results.Properties)
            {
                ForEach ($Result in $Results)
                {
                    [array]$ObjProperties = @()
                    ForEach ($Property in $Result.Properties)
                    {
                        $ObjProperties += $Property
                    }  # End ForEach
                    $ObjProperties
                    Write-Host "-----------------------------------------------------------------------`n"
                } # End ForEach
            }  # End If
            Else
            {
                ForEach ($Result in $Results)
                {
                    $Object = $Result.GetDirectoryEntry()
                    $Object
                }  # End ForEach
            }  # End Else
        }  # End If
        Else
        {
            ForEach ($Result in $Results)
            {
                $Object = $Result.GetDirectoryEntry()
                $Object
            }  # End ForEach
        }  # End Else
    } # End PROCESS
    END
    {
        Write-Verbose "[*] LDAP Query complete. "
    } # End END
} # End Get-LdapInfo
