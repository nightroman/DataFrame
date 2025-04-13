
Set-StrictMode -Version 3
Import-Module ./Zoo.psm1

task process -If (!(Test-Path z.process.csv)) {
	$df = New-DataFrame @(
		New-StringColumn Name
		New-Int64Column WS
		New-Int32Column Handles
		New-BooleanColumn Responding
	)

	foreach($_ in Get-Process) {
		Add-DataFrameRow $df @(
			$_.Name
			$_.WS
			$_.Handles
			$_.Responding
		)
	}

	Export-DataFrame $df z.process.csv
	Export-DataFrame $df z.ps.parquet -Parquet
}

task top_used -If (!(Test-Path z.top_10_used.csv)) process, {
	$df = Import-DataFrame z.process.csv
	$df["Name"].ValueCounts().OrderBy("Counts").Tail(10) | Out-Table
}

task top_means process, {
	$df = Import-DataFrame z.process.csv
	$df.GroupBy('Name').Mean("WS", "Handles").OrderBy("WS").Tail(10) | Out-Table
}

task top_means_parquet process, {
	$df = Import-DataFrame -ParquetPath 'z.ps.parquet'
	$df = $df["Name"].ValueCounts()
	$df.Filter($df["Counts"].ElementwiseGreaterThan(2)).OrderBy("Counts") | Out-Table
}

task used_more_than process, {
	$df = Import-DataFrame z.process.csv
	$df = $df["Name"].ValueCounts()
	$df.Filter($df["Counts"].ElementwiseGreaterThan(2)).OrderBy("Counts") | Out-Table
}

# This way is the most effective.
task set_length_and_use_columns {
	$name = New-StringColumn Name -Length 2
	$age = New-Int32Column Age -Length 2

	$name[0] = 'Joe'
	$age[0] = 42

	$name[1] = 'May'
	$age[1] = 33

	$df = New-DataFrame $name, $age
	$df | Out-Table
}

task set_length_and_use_index {
	$df = New-DataFrame @(
		New-StringColumn Name -Length 2
		New-Int32Column Age -Length 2
	)

	$df[0, 0] = 'Joe'
	$df[0, 1] = 42

	$df[1, 0] = 'May'
	$df[1, 1] = 33

	$df | Out-Table
}

task set_length_and_use_name {
	$df = New-DataFrame @(
		New-StringColumn Name -Length 2
		New-Int32Column Age -Length 2
	)

	$df['Name'][0] = 'Joe'
	$df['Name'][1] = 'May'

	$df['Age'][0] = 42
	$df['Age'][1] = 33

	$df | Out-Table
}

task read_bad {
	try {
		throw Read-DataFrame 42
	}
	catch {
		equals "$_" 'The source must be DataTable, DbDataReader, DbDataAdapter.'
	}
}

task read_data process, {
	$df = Import-DataFrame z.process.csv
	$str = $df.ToString()
	$nRows = $df.Rows.Count
	$nColumns = $df.Columns.Count

	$dt = $df.ToTable()

	$df = Read-DataFrame $dt
	equals $str ($df.ToString())
	equals $nRows $df.Rows.Count
	equals $nColumns $df.Columns.Count

	$df = Read-DataFrame ([System.Data.DataTableReader]::new($dt))
	equals $str ($df.ToString())
	equals $nRows $df.Rows.Count
	equals $nColumns $df.Columns.Count
}
