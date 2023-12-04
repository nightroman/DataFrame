
Set-StrictMode -Version 3
Import-Module DataFrame

task clean {
	remove z.*
}

task help {
	foreach($_ in Get-Command -Module DataFrame) {
		$r = Get-Help $_
		if (!"$($r.Description)") {
			Write-Warning "Missing help description: $($_.Name)"
		}
	}
}

task guess {
	# fails with the default 10
	try {
		throw Import-DataFrame x-guess-count.csv
	}
	catch {
		"$_"
		assert ("$_" -like "*input string*was not in a correct format.")
	}

	# but works with 11
	$df = Import-DataFrame x-guess-count.csv -GuessCount 11
	equals $df.Columns[0].DataType ([string])

	# writes warning with 10 and works with 11
	$df = Import-DataFrame x-guess-count.csv -GuessCount 10, 11 -WarningVariable WarningVariable
	assert ("$WarningVariable" -like "Retrying after failed guess count 10: *input string*was not in a correct format.")
}
