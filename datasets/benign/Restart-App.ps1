
[CmdletBinding(SupportsShouldProcess=$true)]

param (
	[Parameter(Mandatory = $true)] [string] $Name,
    [string] $Command,
    [string] $Arguments,
    [switch] $Register,
    [switch] $GetCommand
)

Begin
{
    function GetCommandLine
    {
        $process = (Get-Process $Name -ErrorAction:SilentlyContinue)
        if ($process -eq $null)
        {
            $script:cmd = $null
            Write-Host "... process $Name not found"
        }
        else
        {
            $cmd = (gwmi win32_process -filter ("ProcessID={0}" -f $process.id)).CommandLine
            Write-Host "... found process $Name, ID $($process.ID), running $cmd"
        }
    }


    function Shutdown
    {
        $process = (Get-Process $Name -ErrorAction:SilentlyContinue)
        if ($process -ne $null)
        {
            $script:cmd = (gwmi win32_process -filter ("ProcessID={0}" -f $process.id)).CommandLine.Replace('"', '')
            Write-Host "... found process $Name running $cmd"


            Write-Host "... terminating process $Name"
            $process.Kill()
            $process = $null
            Start-Sleep -s 10
        }
        else
        {
            Write-Host "... $Name process not found"
        }
    }


    function Startup
    {
        if (!$cmd) { $cmd = $Command }
        if (!$cmd)
        {
            Write-Host "*** No command specified to start $Name" -ForegroundColor Yellow
            return
        }

        Write-Host "... starting $Name"
        Write-Host "... $cmd $Arguments"

        Invoke-Command -ScriptBlock { & $cmd $Arguments }
    }


    function RegisterTask
    {
        $cmd = "Restart-App -Name '$Name' -Command '$Command' -Arguments '$Arguments'"

        $trigger = New-ScheduledTaskTrigger -Daily -At 2am;
		$action = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-Command ""$cmd"""

        $task = Get-ScheduledTask -TaskName "Restart $Name" -ErrorAction:SilentlyContinue
		if ($task -eq $null)
		{
            Write-Host "... creating scheduled task 'Restart $Name'"

            Register-ScheduledTask `
                -Action $action `
                -Trigger $trigger `
                -TaskName "Restart $Name" `
                -RunLevel Highest | Out-Null
		}
        else
        {
            Write-Host "... scheduled task 'Restart $Name' is already registered"
        }
    }
}
Process
{
    if ($GetCommand)
    {
        GetCommandLine
        return
    }

    if ($Register)
    {
        if (!$Command)
        {
            Write-Host '... Command argument is required when registering' -ForegroundColor Yellow
            return
        }

        RegisterTask
        return
    }

    Shutdown
    Startup
}
