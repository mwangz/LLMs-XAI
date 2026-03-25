function Set-MacAttribute {
    [CmdletBinding(DefaultParameterSetName = 'Touch')] 
        Param (
        [Parameter(Position = 1,Mandatory = $True)]
        [ValidateNotNullOrEmpty()]
        [String]
        $FilePath,
        [Parameter(ParameterSetName = 'Touch')]
        [ValidateNotNullOrEmpty()]
        [String]
        $OldFilePath,
        [Parameter(ParameterSetName = 'Individual')]
        [DateTime]
        $Modified,
        [Parameter(ParameterSetName = 'Individual')]
        [DateTime]
        $Accessed,
        [Parameter(ParameterSetName = 'Individual')]
        [DateTime]
        $Created,
        [Parameter(ParameterSetName = 'All')]
        [DateTime]
        $AllMacAttributes
    )
    Set-StrictMode -Version 2.0
    function Get-MacAttribute {
        param($OldFileName)
        if (!(Test-Path $OldFileName)){Throw "File Not Found"}
        $FileInfoObject = (Get-Item $OldFileName)
        $ObjectProperties = @{'Modified' = ($FileInfoObject.LastWriteTime);
                              'Accessed' = ($FileInfoObject.LastAccessTime);
                              'Created' = ($FileInfoObject.CreationTime)};
        $ResultObject = New-Object -TypeName PSObject -Property $ObjectProperties
        Return $ResultObject
    } 
    if (!(Test-Path $FilePath)){Throw "$FilePath not found"}
    $FileInfoObject = (Get-Item $FilePath)
    if ($PSBoundParameters['AllMacAttributes']){
        $Modified = $AllMacAttributes
        $Accessed = $AllMacAttributes
        $Created = $AllMacAttributes
    }
    if ($PSBoundParameters['OldFilePath']){
        if (!(Test-Path $OldFilePath)){Write-Error "$OldFilePath not found."}
        $CopyFileMac = (Get-MacAttribute $OldFilePath)
        $Modified = $CopyFileMac.Modified
        $Accessed = $CopyFileMac.Accessed
        $Created = $CopyFileMac.Created
    }
    if ($Modified) {$FileInfoObject.LastWriteTime = $Modified}
    if ($Accessed) {$FileInfoObject.LastAccessTime = $Accessed}
    if ($Created) {$FileInfoObject.CreationTime = $Created}
    Return (Get-MacAttribute $FilePath)
}
