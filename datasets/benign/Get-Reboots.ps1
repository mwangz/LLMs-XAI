
[CmdletBinding(SupportsShouldProcess=$true)]

param([switch] $Uptime)

Begin
{
}
Process
{
    $ids = (41,1074,1076,6005,6006,6008,6009)

    if ($Uptime) {
        $ids += (6013)
    }

    $esc = [char]27
    $color = ''

    Get-EventLog System -Newest 10000 | `
        Where EventId -in $ids | `
        Sort-Object -Property TimeGenerated | `
        Format-Table `
            TimeGenerated,
            EventId,
            UserName,
            @{
                Label = 'Message'
                Expression =
                {
                    switch ($_.EventId)
                    {
                        6005 { $color = '94'; break } # blue
                        6006 { $color = '31'; break } # dark red
                        6008 { $color = '91'; break } # red
                        6009 { $color = '34'; break } # dark blue
                        6013 { $color = '90'; break } # dark gray
                        default { $color = '37' } # normal white
                    }
                    "$esc[$color`m$($_.Message)$esc[0m"
                }
             }`
            -AutoSize -Wrap
}

