function Get-MyProcessOne
{
   $ProcessList = $null

   $ProcessList = (Get-Process | Select-Object -Property Name, Id, PriorityClass, FileVersion, Path, Company, CPU, ProductVersion, Description, Product, ProcessName)

   $ProcessList

   $ProcessList = $null

   [GC]::Collect()
   [GC]::WaitForPendingFinalizers()
}
Get-MyProcessOne
Get-MyProcessOne | Select-Object -Property Name, Id, CPU
Get-MyProcessOne | Get-Member

function Get-MyProcessTwo
{
   [OutputType([pscustomobject])]
   [CmdletBinding()]
   param ()

   $ProcessList = $null

   $ProcessList = Get-Process | ForEach-Object -Process {
      [PSCustomObject]@{
         Name           = $PSItem.Name
         Id             = $PSItem.Id
         PriorityClass  = $PSItem.PriorityClass
         FileVersion    = $PSItem.FileVersion
         Path           = $PSItem.Path
         Company        = $PSItem.Company
         CPU            = $PSItem.CPU
         ProductVersion = $PSItem.ProductVersion
         Description    = $PSItem.Description
         Product        = $PSItem.Product
         ProcessName    = $PSItem.ProcessName
      }
   }

   $ProcessList

   $ProcessList = $null

   [GC]::Collect()
   [GC]::WaitForPendingFinalizers()
}
Get-MyProcessTwo
Get-MyProcessTwo | Select-Object -Property Name, Id, CPU
Get-MyProcessTwo | Get-Member

function Get-MyProcessThree
{
   [OutputType([pscustomobject])]
   [CmdletBinding()]
   param ()

   $ProcessList = $null

   $ProcessList = Get-Process | ForEach-Object -Process {
      [PSCustomObject]@{
         PSTypeName     = 'MyProcessList'
         Name           = $PSItem.Name
         Id             = $PSItem.Id
         PriorityClass  = $PSItem.PriorityClass
         FileVersion    = $PSItem.FileVersion
         Path           = $PSItem.Path
         Company        = $PSItem.Company
         CPU            = $PSItem.CPU
         ProductVersion = $PSItem.ProductVersion
         Description    = $PSItem.Description
         Product        = $PSItem.Product
         ProcessName    = $PSItem.ProcessName
      }
   }

   Remove-TypeData -TypeName MyProcessList -ErrorAction SilentlyContinue

   Update-TypeData -TypeName MyProcessList -DefaultDisplayPropertySet 'Name', 'Id', 'CPU'

   $ProcessList

   $ProcessList = $null

   [GC]::Collect()
   [GC]::WaitForPendingFinalizers()
}
Get-MyProcessThree
Get-MyProcessThree | Select-Object -Property *
Get-MyProcessThree | Get-Member

function Get-MyProcessFour
{
   [OutputType([pscustomobject])]
   [CmdletBinding()]
   param ()

   $defaultDisplaySet = 'Name', 'Id', 'CPU'

   $defaultDisplayPropertySet = (New-Object -TypeName System.Management.Automation.PSPropertySet -ArgumentList ('DefaultDisplayPropertySet', [string[]]$defaultDisplaySet))
   $PSStandardMembers = [Management.Automation.PSMemberInfo[]]@($defaultDisplayPropertySet)

   $ProcessList = $null

   $ProcessList = Get-Process | ForEach-Object -Process {
      [PSCustomObject]@{
         PSTypeName     = 'MyProcessList'
         Name           = $PSItem.Name
         Id             = $PSItem.Id
         PriorityClass  = $PSItem.PriorityClass
         FileVersion    = $PSItem.FileVersion
         Path           = $PSItem.Path
         Company        = $PSItem.Company
         CPU            = $PSItem.CPU
         ProductVersion = $PSItem.ProductVersion
         Description    = $PSItem.Description
         Product        = $PSItem.Product
         ProcessName    = $PSItem.ProcessName
      }
   }

   $ProcessList.PSObject.TypeNames.Insert(0, 'MyProcessList.Information')
   $ProcessList | Add-Member -NotePropertyName MemberSet -NotePropertyValue PSStandardMembers -InputObject $PSStandardMembers

   $ProcessList

   $ProcessList = $null

   [GC]::Collect()
   [GC]::WaitForPendingFinalizers()
}
Get-MyProcessFour
Get-MyProcessFour | Select-Object -Property *
Get-MyProcessFour | Get-Member

function Get-MyProcessFive
{
   $FormatFile = 'MyProcessListView.format.ps1xml'

   if (Test-Path -Path $FormatFile -ErrorAction SilentlyContinue)
   {
      $null = (Remove-Item -Path $FormatFile -Force -Confirm:$false)
   }

   $FormatData = @'
<?xml version="1.0" encoding="utf-8" ?>
<Configuration>
   <ViewDefinitions>
      <View>
         <Name>MyProcessListViewTable</Name>
         <ViewSelectedBy>
            <TypeName>MyProcessListView</TypeName>
         </ViewSelectedBy>
         <ListControl>
            <ListEntries>
                  <ListEntry>
                     <ListItems>
                        <ListItem>
                              <PropertyName>Name</PropertyName>
                        </ListItem>
                        <ListItem>
                              <PropertyName>Id</PropertyName>
                        </ListItem>
                        <ListItem>
                              <PropertyName>CPU</PropertyName>
                        </ListItem>
                     </ListItems>
                  </ListEntry>
            </ListEntries>
         </ListControl>
      </View>
   </ViewDefinitions>
</Configuration>
'@
   $FormatData | Set-Content -Path $FormatFile -Force

   $FormatData = $null

   Update-FormatData -AppendPath $FormatFile

   $ProcessList = $null

   $ProcessList = Get-Process | ForEach-Object -Process {
      [PSCustomObject]@{
         PSTypeName     = 'MyProcessListView'
         Name           = $PSItem.Name
         Id             = $PSItem.Id
         PriorityClass  = $PSItem.PriorityClass
         FileVersion    = $PSItem.FileVersion
         Path           = $PSItem.Path
         Company        = $PSItem.Company
         CPU            = $PSItem.CPU
         ProductVersion = $PSItem.ProductVersion
         Description    = $PSItem.Description
         Product        = $PSItem.Product
         ProcessName    = $PSItem.ProcessName
      }
   }

   $ProcessList

   if (Test-Path -Path $FormatFile -ErrorAction SilentlyContinue)
   {
      Remove-Item -Path $FormatFile -Force -Confirm:$false
   }

   $FormatFile = $null

   $ProcessList = $null

   [GC]::Collect()
   [GC]::WaitForPendingFinalizers()
}
Get-MyProcessFive
Get-MyProcessFive | Select-Object -Property *
Get-MyProcessFive | Get-Member
