[CmdletBinding(ConfirmImpact = 'None')]
[OutputType([bool])]
param
(
   [Parameter(ValueFromPipeline,
      ValueFromPipelineByPropertyName)]
   [Alias('IP6', '6')]
   [switch]
   $IPv6
)

begin
{
   $SCT = 'SilentlyContinue'
   $STP = 'Stop'
   $CNT = 'Continue'

   if (($PSCmdlet.MyInvocation.BoundParameters['Verbose']).IsPresent)
   {
      $IsVerbose = $true
   }
   else
   {
      $IsVerbose = $false
   }

   if (($PSCmdlet.MyInvocation.BoundParameters['Debug']).IsPresent)
   {
      $IsDebug = $true
   }
   else
   {
      $IsDebug = $false
   }

   if (($PSCmdlet.MyInvocation.BoundParameters['WhatIf']).IsPresent)
   {
      $IsWhatIf = $true
   }
   else
   {
      $IsWhatIf = $false
   }

   $ServerAddresses = @()

   $ServerAddressesIPv4 = @(
      '1.1.1.1'
      '1.0.0.1'
   )

   $ServerAddresses += $ServerAddressesIPv4

   if ((($PSCmdlet.MyInvocation.BoundParameters['IPv6']).IsPresent) -eq $true)
   {
      Write-Verbose -Message 'IPv6 Servers will be added to the serverlist'
      $ServerAddressesIPv6 = @(
         '2606:4700:4700::1111'
         '2606:4700:4700::1001'
      )

      $ServerAddresses += $ServerAddressesIPv6
   }
}

process
{
   $paramGetCimInstance = @{
      ClassName   = 'CIM_ComputerSystem'
      Verbose     = $IsVerbose
      Debug       = $IsDebug
      ErrorAction = $STP
   }
   if (((Get-CimInstance @paramGetCimInstance).PartOfDomain) -eq $false)
   {
      try
      {
         $paramNewItemProperty = @{
            Path         = 'HKLM:\SYSTEM\CurrentControlSet\Services\Dnscache\Parameters'
            Name         = 'EnableAutoDoh'
            Value        = 2
            PropertyType = 'DWord'
            Force        = $true
            WhatIf       = $IsWhatIf
            Verbose      = $IsVerbose
            Debug        = $IsDebug
            ErrorAction  = $CNT
         }
         $null = (New-ItemProperty @paramNewItemProperty)

         $paramGetNetAdapter = @{
            Verbose     = $IsVerbose
            Debug       = $IsDebug
            Physical    = $true
            ErrorAction = $SCT
         }
         $MACAddress = ((Get-NetAdapter @paramGetNetAdapter).MacAddress)

         $paramGetNetIPConfiguration = @{
            Verbose     = $IsVerbose
            Debug       = $IsDebug
            ErrorAction = $SCT
         }
         $IpConfig = (Get-NetIPConfiguration @paramGetNetIPConfiguration | Where-Object -FilterScript {
               $MACAddress -eq $PSItem.NetAdapter.MacAddress
            })

         $paramSetDnsClientServerAddress = @{
            ServerAddresses = $ServerAddresses
            Verbose         = $IsVerbose
            Debug           = $IsDebug
            ErrorAction     = $CNT
         }
         $null = ($IpConfig | Set-DnsClientServerAddress @paramSetDnsClientServerAddress)

         $paramClearDnsClientCache = @{
            Verbose     = $IsVerbose
            Debug       = $IsDebug
            ErrorAction = $SCT
         }
         $null = (Clear-DnsClientCache @paramClearDnsClientCache)

         $paramRegisterDnsClient = @{
            Verbose     = $IsVerbose
            Debug       = $IsDebug
            ErrorAction = $SCT
         }
         $null = (Register-DnsClient @paramRegisterDnsClient)
      }
      catch
      {
         [Management.Automation.ErrorRecord]$e = $_

         $info = [PSCustomObject]@{
            Exception = $e.Exception.Message
            Reason    = $e.CategoryInfo.Reason
            Target    = $e.CategoryInfo.TargetName
            Script    = $e.InvocationInfo.ScriptName
            Line      = $e.InvocationInfo.ScriptLineNumber
            Column    = $e.InvocationInfo.OffsetInLine
         }

         $info | Out-String | Write-Verbose

         $paramWriteError = @{
            Message      = $e.Exception.Message
            ErrorAction  = $CNT
            Exception    = $e.Exception
            TargetObject = $e.CategoryInfo.TargetName
         }
         Write-Error @paramWriteError
      }
   }
   else
   {
      $paramWriteError = @{
         Message      = 'Sorry, this computer seems to be part of a Active Directory domain!'
         Exception    = 'Active Directory Domain Members are not supported'
         Category     = 'NotEnabled'
         TargetObject = $env:COMPUTERNAME
         ErrorAction  = $CNT
      }
      Write-Error @paramWriteError

      Write-Output -InputObject $false

      exit 1
   }
}

end
{
   Write-Output -InputObject $true
   exit 0
}

