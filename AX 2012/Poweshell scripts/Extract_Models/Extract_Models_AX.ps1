Param( 
	#[Parameter(Mandatory=$true)]
	[String]
	$AxDBServerSource = 'SQL2012Server', #SQL SERVER INSTANCE
    [String]
	#[Parameter(Mandatory=$true)]
	$AxDBSource = 'AX_2012_R2_model', #Database name (model, prior to R2 just the database)
	#[Parameter(Mandatory=$true)]
	[String]$FolderTempModelStore = 'E:\temp\modelExport' #This folder should exist, Not subfolders will be deleted from this folder
	,[Parameter(Mandatory=$true)]
	[int[]]$ModelIds
)

#Deleted the AUC files for the current user
function deleteLocalCache {
	Write-host 'Deleting *.AUC files'
    $localAppDataDir = "$(gc env:LOCALAPPDATA)"
	del $localAppDataDir\*.auc
}

#CLS #Clears the screen

#Load the Ax Powershell script
## Change the path of the Management utilities here
Write-Host 'Loading Ax powershell scripts....'
& "E:\Program Files\Microsoft Dynamics AX\60\ManagementUtilities\Microsoft.Dynamics.ManagementUtilities.ps1"

Write-Host 'Host Database: ' $AxDBServerSource'\'$AxDBSource
#Write-Host 'Destination Database: ' $AxDBServerDest'\'$AxDBDest
Write-Host 'Temporary folder:' $FolderTempModelStore

deleteLocalCache

#Export Models from source
#Delete Contents of Folder first
Write-Host 'Deleting Contents of Folder.....'
Get-ChildItem -Path $FolderTempModelStore -Recurse | Remove-Item -Force -Recurse
Write-Host 'Exporting Models to Folder......'

# Gets list of models
$AxModelListSource = Get-AXModel -Server $AxDBServerSource -Database $AxDBSource
$sequence = 0
foreach($modelId in $ModelIds)
{	
	$sequence++
	$modelSource = $AxModelListSource | Where-Object {$_.ModelId -eq $modelId}
	if($modelSource -eq $null) {
		Write-Host "Model id" $modelId "not found in the application" -foregroundcolor "Red"
	}
	else {
		#Export the model applying the naming convention
		#Write-Host "Export Model " $modelSource.Name
		$locFileName = "$FolderTempModelStore\$($sequence)_$($modelSource.Layer)_$($modelSource.Name)_$($modelSource.Version).axmodel"
		#Write-Host $locFileName
		Write-Host 'Exporting Model' $modelSource.Name
		Export-AXModel -Server $AxDBServerSource -Database $AxDBSource -Model $modelSource.ModelId -File $locFileName
	}
}

<#
foreach($modelSource in $AxModelListSource) {
	if(!($modelSource -eq $null))
	{
	if($modelSource.Layer.ToString().ToLower().StartsWith('is') -eq 1 -or $modelSource.Layer.ToString().ToLower().StartsWith('va') -or $modelSource.Layer.ToString().ToLower().StartsWith('cu') -or $modelSource.Layer.ToString().ToLower().StartsWith('us')) {
		$locFileName = "$FolderTempModelStore\$($modelSource.Layer)_$($modelSource.Name)_$($modelSource.Version).axmodel"
		#Write-Host 'Exporting Model' $modelSource.Name
		Export-AXModel -Server $AxDBServerSource -Database $AxDBSource -Model $modelSource.ModelId -File $locFileName
	}
	}
}
#>
