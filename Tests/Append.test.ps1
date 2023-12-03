
Set-StrictMode -Version 3
Import-Module DataFrame

task add_all_some_none_via_parameter {
	$df = New-DataFrame @(
		New-StringColumn
		New-Int32Column
	)

	Add-DataRow $df 'Joe', 42
	Add-DataRow $df 'May'
	Add-DataRow $df

	equals 3L $df.Rows.Count
	equals $df[0, 0] Joe
	equals $df[0, 1] 42
	equals $df[1, 0] May
	equals $df[1, 1] $null
	equals $df[2, 0] $null
	equals $df[2, 1] $null
}

task add_all_some_none_via_pipeline {
	$df = New-DataFrame @(
		New-StringColumn
		New-Int32Column
	)

	'Joe', 42 | Add-DataRow $df
	'May' | Add-DataRow $df
	@() | Add-DataRow $df

	equals 3L $df.Rows.Count
	equals $df[0, 0] Joe
	equals $df[0, 1] 42
	equals $df[1, 0] May
	equals $df[1, 1] $null
	equals $df[2, 0] $null
	equals $df[2, 1] $null
}
