
Set-StrictMode -Version 3
Import-Module ./Zoo.psm1

task guess_error {
	# fails with the default guess count 10
	try {
		throw Import-DataFrame x-guess-count.csv
	}
	catch {
		assert ("$_" -like "*input string*was not in a correct format.")
	}

	# but works with 11
	$df = Import-DataFrame x-guess-count.csv -GuessCount 11
	equals $df.Columns[0].DataType ([string])

	# also works with column types
	$df = Import-DataFrame x-guess-count.csv -ColumnType string, string
	equals $df.Columns[0].DataType ([string])

	# writes warning with 10 and works with 11
	$df = Import-DataFrame x-guess-count.csv -GuessCount 10, 11 -WarningVariable WarningVariable
	equals $df.Columns[0].DataType ([string])
	assert ("$WarningVariable" -like "Retrying after failed guess count 10: *input string*was not in a correct format.")
}

task missing_column {
	$csv = @'
Id,Name
1
2
'@

	# with default columns Name is missing
	$df = Import-DataFrame -String $csv
	equals 1 $df.Columns.Count
	equals 2L $df.Rows.Count

	# with explicit columns Name is there
	$df = Import-DataFrame -String $csv -ColumnType int, string
	equals 2 $df.Columns.Count
	equals 2L $df.Rows.Count
}

task less_columns_than_expected {
	$csv2 = @'
Id,Name
1
2,boom
'@

	# fails with default column types
	try {
		throw Import-DataFrame -String $csv2
	}
	catch {
		equals "$_" 'Line 1 has less columns than expected'
	}

	# works with explicit column types
	$df = Import-DataFrame -String $csv2 -ColumnType int, string
	equals 2 $df.Columns.Count
	equals 2L $df.Rows.Count
}

# An empty line is written to CSV for one column frame with a null.
# Then on loading CSV the empty line is ignored and its row is lost.
# This does not happen with 2+ columns because commas are written.
task lost_row_in_one_column_with_null {
	$df = New-DataFrame @(
		New-StringColumn
	)

	Add-DataFrameRow $df $null
	Add-DataFrameRow $df bar
	equals 2L $df.Rows.Count

	($csv = Export-DataFrame $df -String)
	$df = Import-DataFrame -String $csv
	equals 1L $df.Rows.Count
}

# Nulls in string columns become empty strings after a trip to CSV.
task lost_string_null {
	$df = New-DataFrame @(
		New-StringColumn
		New-Int32Column
	)

	Add-DataFrameRow $df $null, 1
	Add-DataFrameRow $df bar, 2
	equals $df[0, 0] $null

	($csv = Export-DataFrame $df -String)
	$df = Import-DataFrame -String $csv
	equals $df[0, 0] ''
}
