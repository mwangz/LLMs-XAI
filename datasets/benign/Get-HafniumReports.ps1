[CmdletBinding(ConfirmImpact = 'None')]
param
(
   [Parameter(ValueFromPipeline,
      ValueFromPipelineByPropertyName)]
   [ValidateNotNullOrEmpty()]
   [ValidateNotNull()]
   [Alias('Path')]
   [string]
   $ReportPath = 'C:\scripts\PowerShell\reports\Hafnium\'
)

begin
{
   if (-not (Test-Path -Path $ReportPath -ErrorAction SilentlyContinue))
   {
      $null = (New-Item -Path $ReportPath -ItemType Directory -Force -ErrorAction Stop)
   }

   $TimeStamp = (Get-Date -Format 'yyyyMMdd_HHmmss')
}

process
{
   $null = (Get-WinEvent -LogName 'MSExchange Management' -ErrorAction SilentlyContinue | Export-Csv -Path ($ReportPath + 'MSExchangeManagement_' + $TimeStamp + '.csv') -NoTypeInformation -Force -Encoding UTF8 -ErrorAction SilentlyContinue)

   $null = (Get-ScheduledTask -ErrorAction SilentlyContinue | Select-Object -Property actions -ExpandProperty actions -ErrorAction SilentlyContinue | Export-Csv -Path ($ReportPath + 'ScheduledTaskInfo_' + $TimeStamp + '.csv') -NoTypeInformation -Force -Encoding UTF8 -ErrorAction SilentlyContinue)

   $null = (Get-WinEvent -LogName 'Microsoft-Windows-TaskScheduler/Operational' -ErrorAction SilentlyContinue | Export-Csv -Path ($ReportPath + 'TaskScheduler_' + $TimeStamp + '.csv') -NoTypeInformation -Force -Encoding UTF8 -ErrorAction SilentlyContinue)

   $null = (Get-ChildItem -Path 'C:\Users' -Filter 'ConsoleHost_history.txt' -Recurse -ErrorAction SilentlyContinue -Force | ForEach-Object -Process {
         $null = (Get-Content -Path $_.FullName -ErrorAction SilentlyContinue | Out-File -FilePath ($ReportPath + 'PowerShell_History_' + $TimeStamp + '.txt') -Encoding utf8 -Append -ErrorAction SilentlyContinue)
      })
}

end
{
   Invoke-Item -Path $ReportPath
}
