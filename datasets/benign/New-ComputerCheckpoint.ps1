function New-ComputerCheckpoint
{
   [CmdletBinding(ConfirmImpact = 'Low',
   SupportsShouldProcess)]
   [OutputType([string])]
   param
   (
      [Parameter(ValueFromPipeline,
      ValueFromPipelineByPropertyName)]
      [ValidateNotNullOrEmpty()]
      [Alias('AutoRestorePointInterval')]
      [int]
      $Interval = 720,
      [Parameter(ValueFromPipeline,
      ValueFromPipelineByPropertyName)]
      [ValidateNotNullOrEmpty()]
      [Alias('RestorePointDescription')]
      [string]
      $Description = 'Manual RestorePoint',
      [Parameter(ValueFromPipeline,
      ValueFromPipelineByPropertyName)]
      [ValidateNotNullOrEmpty()]
      [ValidateSet('APPLICATION_INSTALL', 'APPLICATION_UNINSTALL', 'DEVICE_DRIVER_INSTALL', 'MODIFY_SETTINGS', 'CANCELLED_OPERATION')]
      [Alias('RestorePointType')]
      [string]
      $Type = 'MODIFY_SETTINGS'
   )

   begin
   {
      function Invoke-DisableComputerRestore
      {
         [CmdletBinding(ConfirmImpact = 'Low',
         SupportsShouldProcess)]
         [OutputType([string])]
         param
         (
            [Parameter(ValueFromPipeline,
            ValueFromPipelineByPropertyName)]
            [ValidateNotNullOrEmpty()]
            [string]
            $Drive = $env:SystemDrive
         )

         process
         {
            if ($pscmdlet.ShouldProcess($Drive, 'Invoke Disable-ComputerRestore'))
            {
               $paramDisableComputerRestore = @{
                  Drive         = $Drive
                  Confirm       = $false
                  ErrorAction   = 'SilentlyContinue'
                  WarningAction = 'SilentlyContinue'
               }
               $null = (Disable-ComputerRestore @paramDisableComputerRestore)
            }
         }
      }

      function Invoke-EnableComputerRestore
      {
         [CmdletBinding(ConfirmImpact = 'Low',
         SupportsShouldProcess)]
         [OutputType([string])]
         param
         (
            [Parameter(ValueFromPipeline,
            ValueFromPipelineByPropertyName)]
            [ValidateNotNullOrEmpty()]
            [string]
            $Drive = $env:SystemDrive
         )

         process
         {
            if ($pscmdlet.ShouldProcess($Drive, 'Invoke Enable-ComputerRestore'))
            {
               $paramEnableComputerRestore = @{
                  Drive         = $Drive
                  Confirm       = $false
                  ErrorAction   = 'SilentlyContinue'
                  WarningAction = 'SilentlyContinue'
               }
               $null = (Enable-ComputerRestore @paramEnableComputerRestore)
            }
         }
      }
   }

   process
   {
      if ($pscmdlet.ShouldProcess("$env:SystemDrive on $env:COMPUTERNAME", 'Creates a system restore point'))
      {
         $null = (Invoke-DisableComputerRestore -Confirm:$false)

         $paramNewItemProperty = @{
            Path         = 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\SystemRestore'
            Name         = 'SystemRestorePointCreationFrequency'
            Value        = '0'
            PropertyType = 'Dword'
            Force        = $true
            ErrorAction  = 'SilentlyContinue'
         }
         $null = (New-ItemProperty @paramNewItemProperty)

         $null = (Invoke-EnableComputerRestore -Confirm:$false)

         $paramCheckpointComputer = @{
            Description      = 'Block Telemetry'
            RestorePointType = 'MODIFY_SETTINGS'
            ErrorAction      = 'SilentlyContinue'
            WarningAction    = 'SilentlyContinue'
         }
         $null = (Checkpoint-Computer @paramCheckpointComputer)
         $null = (Invoke-DisableComputerRestore -Confirm:$false)

         $paramNewItemProperty = @{
            Path         = 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\SystemRestore'
            Name         = 'SystemRestorePointCreationFrequency'
            Value        = $Interval
            PropertyType = 'Dword'
            Force        = $true
            ErrorAction  = 'SilentlyContinue'
         }
         $null = (New-ItemProperty @paramNewItemProperty)
         $null = (Invoke-EnableComputerRestore -Confirm:$false)
      }
   }
}
New-ComputerCheckpoint -Description 'Manual CheckPoint' -Type MODIFY_SETTINGS
