
$labelFile = "labelfile.label.txt" # Put the path to your label file here

# Ignore lines with a space and ;
# From the rest, extract the value up to the = (without the equal sign)
# Then find which values appear more than once

$labelFile = "labelfile.label.txt"
$lines = Get-Content $labelFile

# Filter out lines that contain ' ;'
$filteredLines = $lines | Where-Object { $_ -notmatch '\s;' }

# Extract the value up to the = (without the equal sign)
$values = $filteredLines | ForEach-Object {
    if ($_ -match '^(.*?)=') {
        $matches[1]
    }
}

# Find duplicates
$duplicates = $values | Group-Object | Where-Object { $_.Count -gt 1 }

if ($duplicates) {
    Write-Host "Duplicate values found:"
    $duplicates | ForEach-Object { Write-Host ("$($_.Name) appears $($_.Count) times") }
}
else {
    Write-Host "No duplicate values found."
}
