#------------------------------------
# Author: Shashi Sadasivan
# How to run this script
# 1. Make a copy of the .bacpac file and rename the extension to .zip
# 2. Extract only the model.xml file into a folder I:\bacpac\model.xml
# 3. Change $filename in this file to the path and filename as per step #2
# 4. Change $filenameSave to a new file that will be created by this script e.g. model_new
# 5. Run this script - the new model_new.xml will get created in the folder
# 6. Now import the bacpac using d365fo.tools as per: 
# 		Import-D365Bacpac -ImportModeTier1 -BacpacFile "I:\bacpac\axdb.bacpac" -NewDatabaseName "axdb_new" -Model "I:\bacpac\model_new.xml" -MaxParallelism 32 -ShowOriginalProgress -Verbose
#		https://github.com/shashisadasivan/MyScripts/blob/master/D365/Powershell/RestoreBacpacCommands.txt
#------------------------------------


# create variable for filename
# $filename = "model.xml"
$filename = "I:\bacpac\model.xml"
$filenameSave = "I:\bacpac\model_new.xml"

Write-Host("" + (Get-Date -Format "HH:mm:ss") + " " + "Opening file")
# open file as xml
#[xml]$xml = Get-Content $filename
$xml = [xml]::new()
$xml.Load($filename)

# Write-Host($xml.OuterXml)

Write-Host("" + (Get-Date -Format "HH:mm:ss") + " " + "Finding nodes")

# $nodes = $xml.SelectNodes("//*[local-name()='Property']")
$nodes = $xml.SelectNodes("//*[local-name()='Property'][@*[local-name()='Name']='AutoDrop' and @*[local-name()='Value']='True']")
# $nodes = $xml.SelectNodes("//*[local-name()='Property'][@*[local-name()='AutoDrop']")

# Print the number of nodes
Write-Host("" + (Get-Date -Format "HH:mm:ss") + " " + "Number of nodes (//Property): " + $nodes.Count)

Write-Host("Running through nodes...")
# # loop through nodes
foreach ($node in $nodes) {
    #Write-Host("Node: " + $node.Name + " Value: " + $node.Value)
    # if node has attribute "name" and attribute "value" and attribute "name" is "AutoDrop" and attribute "value" is "True"
    if ($node.HasAttribute("Name") -and $node.HasAttribute("Value") -and $node.GetAttribute("Name") -eq "AutoDrop" -and $node.GetAttribute("Value") -eq "True") {
        # Remove the Parent Node in which $node exists
        $node.ParentNode.ParentNode.RemoveChild($node.ParentNode)
        $nodesToDelete++
    }
}

# Write-Host("Nodes to delete: " + $nodesToDelete)

# save file
if ($nodesToDelete -gt 0) {
    Write-Host("" + (Get-Date -Format "HH:mm:ss") + " " + "Saving file")
    $xml.Save($filenameSave)
}
