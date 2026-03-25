
[CmdletBinding(SupportsShouldProcess = $true)]

param(
	[parameter(Position = 0, Mandatory = $true)]
    [string] $Replace,

    [string] $Path = $pwd,
    [string] $Type = 'm3u'
)

$slash = [IO.Path]::DirectorySeparatorChar
if (!($Replace.EndsWith($slash)))
{
    $Replace = $Replace + $slash
}

$music = [Environment]::GetFolderPath('MyMusic') + $slash
Write-Host "... Music is located here: $music"
Write-Host

Get-Item "*.$Type" | % `
{
    $fullName = $_.FullName
    Write-Host "... updating $fullName"

    (Get-Content $fullName | % { $_ -replace $Replace, $music }) | Set-Content $fullName
}
