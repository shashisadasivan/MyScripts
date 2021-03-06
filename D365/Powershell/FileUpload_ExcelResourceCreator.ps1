<#
.SYNOPSIS
	Powershell script for File attachment upload to D365
.DESCRIPTION
	Uploading documents to D365 Finance requires the files to be send in a folder. Each file requires to be named as a guid and that guid is to exist in the excel sheet.
	This tool reduces the work of having to move a file, rename the file to a guid.
	All you need to do it fill the excel file with the full file path and assign it to the key that the file gets uploaded to. This tool will take crea of the rest
.PARAMETER ExcelFilePath
	Specifies path to the excel file to be uploaded. The excel file will be filled with the file location (in UNC i.e. C:\myfolder\myfile.txt)
.PARAMETER TargetFolderPath
	Specifies the folder where the end Excel file and the attached files will be located
	You will need to fip this folder up to upload it to D365
.PARAMETER TargetEntity
	The entity name that this will be uploaded to
.PARAMETER FirstLineHasHeader
	This will ignore the first line
	Default value = true
.PARAMETER ColumnAttachmentFileName
    The location of the File name column from the left (Starting at 1) in the excel file.
	This field will be overritten so best to keep it empty
.PARAMETER ColumnAttachmentFileType
    The location of the File type column from the left (Starting at 1) in the excel file.
	This field will be overritten so best to keep it empty
.PARAMETER ColumnAttachmentFilePath
	The location of the File path column from the left (Starting at 1) in the excel file.
	This should contain the entire file path i.e. c:\tempFolder\File1.txt
.EXAMPLE
	Example .\FileUpload_ExcelResourceCreator.ps1 -ExcelFilePath "C:\temp\FileUpload\Released product document attachments1.xlsx" -TargetFolderPath "C:\temp\FileUpload\target" -TargetEntity "This is my Entity" -ColumnAttachmentFileName 10 -ColumnAttachmentFileType 8 -ColumnAttachmentFilePath 12
.NOTES
	Author: Shashi Sadasivan
	Date:   March 6, 2019
#>
Param(

   [Parameter(Mandatory=$true)] #We need the full path of the excel file
   [string]$ExcelFilePath,

   [Parameter(Mandatory=$true)] #Full path of target folder (where the manifest file is)
   [string]$TargetFolderPath,

   [Parameter(Mandatory=$true)] #Entity name to create a folder in the Target\resources directory
   [string]$TargetEntity,

   [Parameter(Mandatory=$false)]
   [boolean]$FirstLineHasHeader = $true, #Is the first line of excel header

   [Parameter(Mandatory=$false)]
   [int]$ColumnAttachmentFileName = 12, # Column position for -> File name

   [Parameter(Mandatory=$false)]
   [int]$ColumnAttachmentFileType = 8, # Column position for -> Extension of the file

   [Parameter(Mandatory=$false)]
   [int]$ColumnAttachmentFilePath = 14 # Column position for -> This will be replaced with the GUID

) #end param

	# Powershell script for File attachment upload to D365
	# With entities that use the DocuRefEntity, we canupload FirstLineHasHeader
	# With this tool, enter the File Path e.g. c:\tempFolder\File1.txt to the FileName column and run this tool
	# This tool will move the file to the Resources folder in the Target folder with a GUID fileName and update the file name in Excel to the same GUID #Shashi Sadasivan
	# The excel file is also saved into the Target folder
	# Example .\FileUpload.ps1 -ExcelFilePath "C:\temp\FileUpload\Released product document attachments1.xlsx" -TargetFolderPath "C:\temp\FileUpload\target" -TargetEntity "This is my Entity"
	
$fileName = ""
$fileType = ""
$filePath = ""
$TargetFolderPathResources = "$TargetFolderPath\Resources"
$TargetFolderPathResourcesEntity = "$TargetFolderPathResources\$TargetEntity"

Function closeExcelFile() {
    $excelFileName = [System.IO.Path]::GetFileName($excelFilePath)
    $wb.SaveAs("$TargetFolderPath\$excelFileName")
    $wb.close()
    $excel.quit()
    [System.Runtime.Interopservices.Marshal]::ReleaseComObject($excel)
    # no $ needed on variable name in Remove-Variable call
    # Remove-Variable $excel
    Write-Output "Closed excel file"
}

Function checkResourceFolderExists() {
    Write-Output "Create resource folder if not exists"
    New-Item -Force -ItemType directory -Path $TargetFolderPathResources | Out-Null #out-Null will keep this operation silent
    #Clean the resource folder
    #Get-ChildItem -Path $TargetFolderPathResources -Include * -File -Recurse | foreach { $_.Delete() }
    Remove-Item "$TargetFolderPathResources\*" -Recurse -Force

    Write-Output "Create entity folder in resource folder if not exists"
    New-Item -Force -ItemType directory -Path $TargetFolderPathResourcesEntity | Out-Null #out-Null will keep this operation silent
    Remove-Item "$TargetFolderPathResourcesEntity\*" -Recurse -Force
}

Function processFile ([string]$filePathToPackage) {
    $script:fileName = ""
    $script:fileType = ""
    $script:filePath = ""

    $script:filePath = [guid]::NewGuid().ToString("B")
	$script:fileName = [System.IO.Path]::GetFileName($filePathToPackage)
    #$script:fileName = [System.IO.Path]::GetFileNameWithoutExtension($filePathToPackage)
    $script:fileType = [System.IO.Path]::GetExtension($filePathToPackage).Replace(".", "")

    #Copy-Item -Path $filePathToPackage -Destination "$script:TargetFolderPathResources\$filePath" -Force #dont open a dialog for this
    Copy-Item -Path $filePathToPackage -Destination "$script:TargetFolderPathResourcesEntity\$filePath" -Force #dont open a dialog for this

    #Write-Output $script:fileName $script:fileType $script:filePath
}

$worksheetToRead = 1; # only 1 sheet to read

checkResourceFolderExists

Write-Output "Reading file: $ExcelFilePath"

$excel = New-Object -Com Excel.Application;
$wb = $excel.Workbooks.Open($ExcelFilePath);

Write-Output "Excel file read complete"

Write-Output "Reading sheet $worksheetToRead"
$worksheet = $wb.Sheets.Item($worksheetToRead); # We will only ever read the first sheet

Write-Output "Processing lines on sheet $worksheetToRead"
$rows = ($worksheet.UsedRange.Rows).count

Write-Output "No of rows: $rows"
$intRow = 1;
if($FirstLineHasHeader -eq $true) {
    $intRow = 2;
}

for(; $intRow -le $rows; $intRow++){
    $AttachmentFilePath = $worksheet.cells.item($intRow, $ColumnAttachmentFilePath).value2
    if($AttachmentFilePath.length -gt 0) {
        Write-Output "Processing line $intRow, File $AttachmentFilePath"
        processFile($AttachmentFilePath)
        # write to excel file
        $worksheet.cells.item($intRow, $ColumnAttachmentFileName) = $fileName
        $worksheet.cells.item($intRow, $ColumnAttachmentFileType) = $fileType
        $worksheet.cells.item($intRow, $ColumnAttachmentFilePath) = $filePath.ToString() #change this value to a GUID
        # Write-Output $fileName $fileType $filePath
    }
    else {
        Write-Output "Skipping line $intRow and file path is empty"
    }
}


closeExcelFile
#Write-Output $ColumnAttachmentFilePath

Write-Output "Complete"

#Create by Shashi Sadasivan
#http://shashidotnet.wordpress.com
