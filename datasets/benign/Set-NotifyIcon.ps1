
[CmdletBinding(SupportsShouldProcess = $true)]

param(
    [Parameter(Mandatory=$true, HelpMessage='Path of program')] [string] $ProgramPath,
    [Parameter(HelpMessage='Hide notify icon, default is to show')] [switch] $Hide
)

Begin
{
    $script:TrayNotifyKey = 'HKCU:\SOFTWARE\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\TrayNotify'
    $script:HeaderSize = 20
    $script:BlockSize = 1640
    $script:SettingOffset = 528

    function GetStreamData
    {
        param([byte[]] $stream)
        $builder = New-Object System.Text.StringBuilder
        

        $stream | % { [void]$builder.Append( ('{0:x2}' -f $_) ) }
        return $builder.ToString()
    }

    function EncodeProgramPath
    {
        param([string] $path)

        $encoding = New-Object System.Text.UTF8Encoding
        $bytes = $encoding.GetBytes($path)

        $builder = New-Object System.Text.StringBuilder
        $bytes | % { [void]$builder.Append( ('{0:x2}00' -f (Rot13 $_)) ) }
        return $builder.ToString()
    }

    function BuildItemTable
    {
        param([byte[]] $stream)

        $table = @{}
        for ($x = 0; $x -lt $(($stream.Count - $HeaderSize) / $BlockSize); $x++)
        {
            $offset = $HeaderSize + ($x * $BlockSize)
            $table.Add($offset, $stream[$offset..($offset + ($BlockSize - 1))] )
        }
    
        return $table
    }

    function Rot13
    {
        param([byte] $byte)

            if ($byte -ge  65 -and $byte -le  77) { return $byte + 13 } # A..M
        elseif ($byte -ge  78 -and $byte -le  90) { return $byte - 13 } # N..Z
        elseif ($byte -ge  97 -and $byte -le 109) { return $byte + 13 } # a..m
        elseif ($byte -ge 110 -and $byte -le 122) { return $byte - 13 } # n..z
        
        return $byte
    }
}
Process
{
    $Setting = 2
    if ($Hide) { $Setting = 1 }

    $trayNotifyPath = (Get-Item $TrayNotifyKey).PSPath
    $stream = (Get-ItemProperty $trayNotifyPath).IconStreams

    $data = GetStreamData $stream

    $path = EncodeProgramPath $ProgramPath

    if (-not $data.Contains($path))
    {
        Write-Warning "$ProgramPath not found. Programs are case sensitive."
        return
    }

    $table = BuildItemTable $stream

    foreach ($key in $table.Keys)
    {
        $item = $table[$key]

        $builder = New-Object System.Text.StringBuilder
        $item | % { [void]$builder.Append( ('{0:x2}' -f $_) ) }
        $hex = $builder.ToString()

        if ($hex.Contains($path))
        {
            Write-Host "$ProgramPath found in item at byte offset $key"

            $stream[$key + $SettingOffset] = $Setting

            if (!$WhatIfPreference)
            {
                Set-ItemProperty $trayNotifyPath -name IconStreams -value $stream
            }
        }
    }
}
