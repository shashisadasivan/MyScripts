function Remove-LabelFileDuplicates {
    
    param(
        [parameter(Mandatory=$true)]$labelFile
    )

    Write-Host "started $labelFile"

    [Collections.Generic.List[String]]$lines = [IO.File]::ReadAllLines($labelFile)
    [Collections.Generic.List[String]]$linesUsed
    $isLabel = $false
    $isPrevLineRemoved = $false

    foreach($line in $lines){
        $isLabel = $line.StartsWith(" ;");

        if($isLabel){
            if($isPrevLineRemoved -eq $false) {
                $linesUsed += $line
            }
            $isPrevLineRemoved = $false
        } else {
            if($linesUsed -contains $line){
                $isPrevLineRemoved = $true
            } else {
                $linesUsed += $line
                $isPrevLineRemoved = $false
            }
        }
    }

    [IO.File]::WriteAllLines($labelFile, $linesUsed)
}

Remove-LabelFileDuplicates "C:\LocalData\LocalDev\VSProjects\RemoveDuplicateLines\RemoveDuplicateLines\bin\Debug\netcoreapp3.1\DXC_Integria.en-AU.label.txt"