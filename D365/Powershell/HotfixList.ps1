#https://community.dynamics.com/365/financeandoperations/b/yetanotherdynamicsaxblog/archive/2018/01/13/list-hotfixes-using-powershell-in-d365fo-ax7
function Get-HotfixList()
{
    # Find the correct Package Local Directory (PLD)
    $pldPath = "\AOSService\PackagesLocalDirectory"
    $packageDirectory = "{0}:$pldPath" -f ('J','K')[$(Test-Path $("K:$pldPath"))]

    [array]$Updates = @()

    # Get all updates XML
    foreach ($packagefile in Get-ChildItem $packageDirectory\*\*\AxUpdate\*.xml)
    {
        [xml]$xml = Get-Content $packagefile
        [string]$KBs = $xml.AxUpdate.KBNumbers.string

        # One package may refer many KBs
        foreach ($KB in $KBs -split " ")
        {
            [string]$package = $xml.AxUpdate.Name
            $moduleFolder = $packagefile.Directory.Parent

            $Updates += [PSCustomObject]@{
                Module = $moduleFolder.Parent
                Model = $moduleFolder
                KB = $KB
                Package = $package
                Folder = $moduleFolder.FullName
            }
        }
    }
    return $Updates
}

#run using
#Import-Module .\HotfixList.ps1

#To output to a grid
#Get-HotfixList | Out-GridView

# To output to a CSV file: select all rows in grid and then select OK
# Get-HotfixList | Out-GridView -PassThru | Export-Csv -Path .\hotfixList_20180716.csv
