
# Gets all the Entity, public Collection name, public entity name & saves as a CSV file

# Base folder location
$baseFolder = "K:\AosService\PackagesLocalDirectory"
Write-Host "[1/6] Base folder set to: $baseFolder"


# go through each folder in the baseFolder, save to a variable
Write-Host "[2/6] Getting top-level folders in base folder..."
$folders = Get-ChildItem -Path $baseFolder -Directory
Write-Host ("  Found {0} top-level folders." -f $folders.Count)


# foreach folders , get the inner folders as well in a variable
Write-Host "[3/6] Getting inner folders for each top-level folder..."
$innerFolders = foreach ($folder in $folders) {
    Get-ChildItem -Path $folder.FullName -Directory
}
Write-Host ("  Found {0} inner folders." -f $innerFolders.Count)


# for each inner folder, find if it contains a folder called AxDataEntityView and save it to variable
Write-Host "[4/6] Searching for 'AxDataEntityView' folders..."
$axDataEntityViewFolders = foreach ($innerFolder in $innerFolders) {
    $axDataEntityViewFolder = Join-Path -Path $innerFolder.FullName -ChildPath "AxDataEntityView"
    if (Test-Path -Path $axDataEntityViewFolder) {
        $axDataEntityViewFolder
    }
}
Write-Host ("  Found {0} AxDataEntityView folders." -f $axDataEntityViewFolders.Count)

# print the found AxDataEntityView folders to console
# $axDataEntityViewFolders


# foreach of the dataentityviewfolders, get all the xml files in them
Write-Host "[5/6] Collecting XML files from AxDataEntityView folders..."
$dataentityXmlFiles = foreach ($axDataEntityViewFolder in $axDataEntityViewFolders) {
    Get-ChildItem -Path $axDataEntityViewFolder -Filter "*.xml" -File
}
Write-Host ("  Found {0} XML files." -f $dataentityXmlFiles.Count)



# Foreach dataentityXmlFiles, read it as an xml file and extract the following tags: <Name>,<PublicCollectionName>,<PublicEntityName>
Write-Host "[6/6] Extracting entity info from XML files..."
$dataentityInfo = foreach ($xmlFile in $dataentityXmlFiles) {
    [xml]$xmlContent = Get-Content -Path $xmlFile.FullName
    $nameNode = $xmlContent.SelectSingleNode("//Name")
    $name = if ($nameNode) { $nameNode.InnerText } else { $null }
    $publicCollectionNameNode = $xmlContent.SelectSingleNode("//PublicCollectionName")
    $publicCollectionName = if ($publicCollectionNameNode) { $publicCollectionNameNode.InnerText } else { $null }
    $publicEntityNameNode = $xmlContent.SelectSingleNode("//PublicEntityName")
    $publicEntityName = if ($publicEntityNameNode) { $publicEntityNameNode.InnerText } else { $null }

    [PSCustomObject]@{
        Name                 = $name
        PublicCollectionName = $publicCollectionName
        PublicEntityName     = $publicEntityName
    }
}
Write-Host ("  Extracted info for {0} entities." -f $dataentityInfo.Count)


# save the 3 values to a csv file in the current running directory
Write-Host "Saving results to DataEntityInfo.csv..."
$dataentityInfo | Export-Csv -Path ".\DataEntityInfo.csv" -NoTypeInformation
Write-Host "Done."
