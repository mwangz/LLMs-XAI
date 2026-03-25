
param ([switch] $Report)

Begin
{
	function GetStatusReport ()
	{
		if ($host.Version.Build -ge 6001)
		{
			$0 = 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Component Based Servicing\RebootPending'
			$cbs = ((Get-ChildItem $0 -ErrorAction SilentlyContinue) -ne $null)
		}
		else
		{
			$cbs = $false
		}

		$0 = 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update\RebootRequired'
		$wua = ((Get-Item $0 -ErrorAction SilentlyContinue) -ne $null)

		try
		{ 
			$util = [wmiclass]"\\.\root\ccm\clientsdk:CCM_ClientUtilities"
			$status = $util.DetermineIfRebootPending()
			$sdk = [bool](($status -ne $null) -and $status.RebootPending)
		}
		catch
		{
			$sdk = $false
		}

		$0 = 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager'
		$key = Get-Item -LiteralPath $0
		$val = $key.GetValue('PendingFileRenameOperations', $null)
		$msi = @{$true=($val | ? { $_ -notmatch 'TEMP' -and $_ -ne '' }).Count -gt 0; $false=$false}[$null -ne $val]

		$currName = (Get-ItemPropertyValue -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\ComputerName\ActiveComputerName' -Name 'ComputerName')
		$pendName = (Get-ItemPropertyValue -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\ComputerName\ComputerName' -Name 'ComputerName')
		$com = ($currName -ne $pendName)

		return @{
			CBSServicing = $cbs
			MSIFileRename = $msi
			WindowsUpdate = $wua
			ClientSDK = $sdk
			ComputerRename = $com
		}
	}
}
Process
{
	$status = GetStatusReport

	if ($Report)
	{
		return $status
	}

	return $status.CBSServicing -or $status.MSIFileRename -or $status.WindowsUpdate `
		-or $status.ClientSDK -or $status.ComputerRename
}
