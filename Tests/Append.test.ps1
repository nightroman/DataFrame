
Set-StrictMode -Version 3
Import-Module ./Zoo.psm1

task add_all_some_none_to_columns {
	$name = New-StringColumn
	$age = New-Int32Column

	$name.Append('Joe')
	$age.Append(42)

	$name.Append('May')
	$age.Append($null)

	#! $null results in '' by PS design
	$name.Append([System.Management.Automation.Internal.AutomationNull]::Value)
	$age.Append($null)

	$df = New-DataFrame $name, $age
	Export-DataFrame $df -String
	equals 3L $df.Rows.Count
	equals $df[0, 0] Joe
	equals $df[0, 1] 42
	equals $df[1, 0] May
	equals $df[1, 1] $null
	equals $df[2, 0] $null
	equals $df[2, 1] $null
}

task add_all_some_none_via_parameter {
	$df = New-DataFrame @(
		New-StringColumn
		New-Int32Column
	)

	Add-DataFrameRow $df 'Joe', 42
	Add-DataFrameRow $df 'May'
	Add-DataFrameRow $df

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

	'Joe', 42 | Add-DataFrameRow $df
	'May' | Add-DataFrameRow $df
	@() | Add-DataFrameRow $df

	equals 3L $df.Rows.Count
	equals $df[0, 0] Joe
	equals $df[0, 1] 42
	equals $df[1, 0] May
	equals $df[1, 1] $null
	equals $df[2, 0] $null
	equals $df[2, 1] $null
}

task out_all_some_none_via_pipeline {
	$df = New-DataFrame @(
		New-StringColumn Name
		New-Int32Column Age
	)

	$(
		[pscustomobject]@{Name = 'Joe'; Age = 42}
		[pscustomobject]@{Name = 'May'; Bar = 33}
		[pscustomobject]@{User = 'Foo'; Bar = 22}
	) |
	Out-DataFrame $df

	equals 3L $df.Rows.Count
	equals $df[0, 0] Joe
	equals $df[0, 1] 42
	equals $df[1, 0] May
	equals $df[1, 1] $null
	equals $df[2, 0] $null
	equals $df[2, 1] $null
}
