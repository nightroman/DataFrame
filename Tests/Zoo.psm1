
filter Out-Table {
	$_.ToTable() | Out-Host
}

function Convert-NewLine([string]$text) {
	$text.Replace("`r`n", "`n")
}
