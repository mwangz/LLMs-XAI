[CmdletBinding(ConfirmImpact = 'Low')]
param ()

$RoomName = 'Your-Teams-Room'

$RoomAlias = 'YourTeamsRoom'

$RoomPassword = 'YourSuperSecretRoomPassword'

$RoomDomain = 'contoso.com'

$RoomAdditionalResponse = 'This is a Microsoft Teams Team Room'

$RoomLicence = 'contoso:MEETING_ROOM'

$CsOnlineUser = 'john.doe'

$RoomUserPrincipalName = ($RoomAlias + '@' + $RoomDomain)
$CsOnlineUserTemplate = ($CsOnlineUser + '@' + $RoomDomain)

$paramNewMailbox = @{
   Name                      = $RoomName
   Alias                     = $RoomAlias
   Room                      = $true
   EnableRoomMailboxAccount  = $true
   MicrosoftOnlineServicesID = $RoomUserPrincipalName
   RoomMailboxPassword       = (ConvertTo-SecureString -String $RoomPassword -AsPlainText -Force)
}
New-Mailbox @paramNewMailbox

$paramSetCalendarProcessing = @{
   Identity              = $RoomName
   AutomateProcessing    = 'AutoAccept'
   AddOrganizerToSubject = $false
   DeleteComments        = $false
   DeleteSubject         = $false
   RemovePrivateProperty = $false
   AddAdditionalResponse = $true
   AdditionalResponse    = $RoomAdditionalResponse
}
Set-CalendarProcessing @paramSetCalendarProcessing

$paramSetMsolUser = @{
   UserPrincipalName    = $RoomUserPrincipalName
   PasswordNeverExpires = $true
   UsageLocation        = 'DE'
}
Set-MsolUser @paramSetMsolUser

$paramSetMsolUserLicense = @{
   UserPrincipalName = $RoomUserPrincipalName
   AddLicenses       = $RoomLicence
}
Set-MsolUserLicense @paramSetMsolUserLicense

$paramEnableCsMeetingRoom = @{
   Identity       = $RoomUserPrincipalName
   RegistrarPool  = (Get-CsOnlineUser -Identity $CsOnlineUserTemplate | Select-Object -ExpandProperty RegistrarPool)
   SipAddressType = 'EmailAddress'
}
Enable-CsMeetingRoom @paramEnableCsMeetingRoom

