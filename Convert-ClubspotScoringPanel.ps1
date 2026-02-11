param(
    [Parameter(Mandatory=$true)][string]$importfile,
    [Parameter(Mandatory=$true)][int]$columns
)
$lines = Get-Content -Path $importfile
$fieldnames = @()
$scores = @()
$linecount = 0
$fieldcount = 0
foreach ($line in $lines) {
    $fieldvalue = $line.trim()
    if ($fieldvalue -ne "") {
        $linecount++
        if ($linecount -le $columns) {
            $fieldnames += $fieldvalue
        } else {
            if ($fieldcount -lt ($columns - 1)) {
                if ($fieldcount -eq 0) {
                    $score = New-Object PSObject
                }
                $score | Add-member -NotePropertyName $fieldnames[$fieldcount] -NotePropertyValue $fieldvalue
                $fieldcount++
            } else {
                $score | Add-member -NotePropertyName $fieldnames[$fieldcount] -NotePropertyValue $fieldvalue
                $scores += $score
                $fieldcount = 0
            }
        }
    }
}
$scores | ConvertTo-CSV -NoTypeInformation