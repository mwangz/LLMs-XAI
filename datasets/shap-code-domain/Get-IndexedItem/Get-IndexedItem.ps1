function Get-IndexedItem {
[CmdletBinding()]
Param ( [Alias("Where","Include")][String[]]$Filter , 
        [String]$path, 
        [Alias("Sort")][String[]]$orderby, 
        [Alias("Top")][int]$First,
        [Alias("Group")][String]$Value, 
        [Alias("Select")][String[]]$Property, 
        [String[]]$Terms,
        [Switch]$recurse,
        [Switch]$list,
        [Switch]$NoFiles)
 if($terms){
    $Filter = "FreeText(*,'" + $($terms -join "') OR FreeText(*,'") + "')"
 }
 $PropertyAliases   = @{Width         ="System.Image.HorizontalSize"; Height        = "System.Image.VerticalSize";  Name    = "System.FileName" ; 
                        Extension     ="System.FileExtension"       ; CreationTime  = "System.DateCreated"       ;  Length  = "System.Size" ; 
                        LastWriteTime ="System.DateModified"        ; Keyword       = "System.Keywords"          ;  Tag     = "System.Keywords"
                        CameraMaker  = "System.Photo.Cameramanufacturer"}
 $fieldTypes = "System","Photo","Image","Music","Media","RecordedTv","Search","Audio" 
 $SystemPrefix     = "System."            ;     $SystemFields = "ItemName|ItemUrl|FileExtension|FileName|FileAttributes|FileOwner|ItemType|ItemTypeText|KindText|Kind|MIMEType|Size|DateModified|DateAccessed|DateImported|DateAcquired|DateCreated|Author|Company|Copyright|Subject|Title|Keywords|Comment|SoftwareUsed|Rating|RatingText|ComputerName"
 $PhotoPrefix      = "System.Photo."      ;      $PhotoFields = "fNumber|ExposureTime|FocalLength|IsoSpeed|PeopleNames|DateTaken|Cameramodel|Cameramanufacturer|orientation"
 $ImagePrefix      = "System.Image."      ;      $ImageFields = "Dimensions|HorizontalSize|VerticalSize"
 $MusicPrefix      = "System.Music."      ;      $MusicFields = "AlbumArtist|AlbumID|AlbumTitle|Artist|BeatsPerMinute|Composer|Conductor|DisplayArtist|Genre|PartOfSet|TrackNumber"
 $AudioPrefix      = "System.Audio."      ;      $AudioFields = "ChannelCount|EncodingBitrate|PeakValue|SampleRate|SampleSize"
 $MediaPrefix      = "System.Media."      ;      $MediaFields = "Duration|Year"
 $RecordedTVPrefix = "System.RecordedTV." ; $RecordedTVFields = "ChannelNumber|EpisodeName|OriginalBroadcastDate|ProgramDescription|RecordingTime|StationName"
 $SearchPrefix     = "System.Search."     ;     $SearchFields = "AutoSummary|HitCount|Rank|Store"
 if ($list)  {  #Output a list of the fields and aliases we currently support. 
    $( foreach ($type in $fieldTypes) { 
          (get-variable "$($type)Fields").value -split "\|" | select-object @{n="FullName" ;e={(get-variable "$($type)prefix").value+$_}},
                                                                            @{n="ShortName";e={$_}}    
       }
    ) + ($PropertyAliases.keys | Select-Object  @{name="FullName" ;expression={$PropertyAliases[$_]}},
                                                @{name="ShortName";expression={$_}}
    ) | Sort-Object -Property @{e={$_.FullName -split "\.\w+$"}},"FullName" 
  return
 }  
 if ($first)    {$SQL =  "SELECT TOP $first "}
 else           {$SQL =  "SELECT "}
 if ($property) {$SQL += ($property -join ", ") + ", "}
 else {
    foreach ($type in $fieldTypes) { 
        $SQL += ((get-variable "$($type)Fields").value -replace "\|",", " ) + ", " 
    }
 }   
 $sql += " FROM SYSTEMINDEX WHERE "
 if ($Filter) { #Convert * to % 
                $Filter = $Filter -replace "(?<=\w)\*","%"
                $Filter = $Filter -replace "\s*(=|<|>|like)\s*([^\''\d][^\d\s\'']*)$"  , ' $1 ''$2'' '
                $Filter = $Filter -replace "\s*=\s*(?='.+%'\s*$)" ," LIKE " 
                $filter = ($filter | ForEach-Object {
                                if ($_ -match "'|=|<|>|like|contains|freetext") {$_}
                                else {"Contains(*,'$_')"}
                }) 
                  $SQL += $Filter -join " AND "  } 
 if ($path)     {if ($path -notmatch "\w{4}:") {$path = "file:" + (resolve-path -path $path).providerPath}  # Path has to be in the form "file:C:/users" 
                $path  = $path -replace "\\","/"
                if ($sql -notmatch "WHERE\s$") {$sql += " AND " }                       #If the SQL statement doesn't end with "WHERE", add "AND"  
                if ($recurse)                  {$sql += " SCOPE = '$path' "       }     #INDEX uses SCOPE <folder> for recursive search, 
                else                           {$sql += " DIRECTORY = '$path' "   }     # and DIRECTORY <folder> for non-recursive
 }   
 if ($Value) {
                if ($sql -notmatch "WHERE\s$") {$sql += " AND " }                       #If the SQL statement doesn't end with "WHERE", add "AND"  
                                                $sql += " $Value Like '%'" 
                                                $sql =  $SQL -replace "^SELECT.*?FROM","SELECT $Value, FROM"
 }
 if ($sql -match "WHERE\s*$")  { Write-warning "You need to specify either a path , or a filter." ; return} 
 if ($Value) {$SQL =  "GROUP ON $Value, OVER ( $SQL )"}
 elseif ($orderby)  {$sql += " ORDER BY " + ($orderby   -join " , " ) + ","}             
 $PropertyAliases.Keys | ForEach-Object { $sql= $SQL -replace "(?<=\s)$($_)(?=\s*(=|>|<|,|Like))",$PropertyAliases.$_}      
 foreach ($type in $fieldTypes) { 
    $fields = (get-variable "$($type)Fields").value 
    $prefix = (get-variable "$($type)Prefix").value 
    $sql = $sql -replace "(?<=\s)(?=($Fields)\s*(=|>|<|,|Like))" , $Prefix
 }
 $sql = $sql -replace "\s*,\s*FROM\s+" , " FROM " 
 $sql = $sql -replace "\s*,\s*OVER\s+" , " OVER " 
 $sql = $sql -replace "\s*,\s*$"       , "" 
 write-debug $sql 
 $adapter = new-object system.data.oledb.oleDBDataadapter -argumentlist $sql, "Provider=Search.CollatorDSO;Extended Properties='Application=Windows';"
 $ds      = new-object system.data.dataset
 if ($adapter.Fill($ds)) { foreach ($row in $ds.Tables[0])  {
    if ($Value) {$row | Select-Object -Property @{name=$Value; expression={$_.($ds.Tables[0].columns[0].columnname)}}}
    else {
        if (($row."System.ItemUrl" -match "^file:") -and (-not $NoFiles)) { 
               $obj = (Get-item -force -LiteralPath (($row."System.ItemUrl" -replace "^file:","") -replace "\/","\"))
               if (-not $obj) {$obj = New-Object psobject }
        }
        else { 
               if ($row."System.ItemUrl") {
                     $obj = New-Object psobject -Property @{Path = $row."System.ItemUrl"}
                     Add-Member -force -InputObject $obj -Name "ToString"  -MemberType "scriptmethod" -Value {$this.path} 
               }
               else {$obj = New-Object psobject }   
        }
        if ($obj) {
            foreach ($prop in (Get-Member -InputObject $row -MemberType property | where-object {$row."$($_.name)" -isnot [system.dbnull] })) {                            
                Add-member -ErrorAction "SilentlyContinue" -InputObject $obj -MemberType NoteProperty  -Name (($prop.name -split "\." )[-1]) -Value  $row."$($prop.name)"
            }                       
            foreach ($prop in ($PropertyAliases.Keys | where-object {  ($row."$($propertyAliases.$_)" -isnot [system.dbnull] ) -and
                                                                       ($row."$($propertyAliases.$_)" -ne $null )})) {
                Add-member -ErrorAction "SilentlyContinue" -InputObject $obj -MemberType AliasProperty -Name $prop -Value ($propertyAliases.$prop  -split "\." )[-1] 
            }
            If ($obj.duration) { $obj.duration =([timespan]::FromMilliseconds($obj.Duration / 10000) )}
            $obj
        }
    }                               
 }}
}
