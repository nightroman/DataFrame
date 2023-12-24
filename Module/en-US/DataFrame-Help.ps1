<#
.Synopsis
	Help script, https://github.com/nightroman/Helps
#>

Import-Module DataFrame
Set-StrictMode -Version 3

## ImportExport
$ImportExport = @{
	parameters = @{
		Path = @'
Specifies the CSV file.
'@
		Separator = @'
The field separator char. The default is comma.
The value is either literal symbol or shortcut:
'c': comma, 's': semicolon, 't': tab.
'@
		NoHeader = @'
Tells that the file has no header.
'@
		Encoding = @'
The character encoding. Default is UTF8.
'@
		Culture = @'
Specifies the culture info for formatting values.
'@
	}
	examples = @{
		code = {
			# import
			$df = Import-DataFrame data.tsv -Separator t

			# modify
			... | Out-DataFrame $df

			# export
			Export-DataFrame $df data.tsv -Separator t
		}
	}
}

### Export-DataFrame
Merge-Helps $ImportExport @{
	command = 'Export-DataFrame'
	synopsis = 'Exports DataFrame to CSV file or string.'
	parameters = @{
		DataFrame = 'The DataFrame to export.'
		String = 'Tells to output the CSV string.'
	}
	outputs = @{
		type = 'System.String'
		description = 'When the switch String is specified.'
	}
}

### Import-DataFrame
Merge-Helps $ImportExport @{
	command = 'Import-DataFrame'
	synopsis = 'Imports DataFrame from CSV file or string.'
	parameters = @{
		String = @'
Specifies the source CSV string.
'@
		ColumnName = @'
Specifies the column names.
'@
		ColumnType = @'
Specifies the column types.
'@
		RowCount = @'
Tells how many rows to read.
'@
		GuessCount = @'
Tells how many rows to use for guessing types. Defaults to 10.
Specify more than one value to retry on type parsing errors.
'@
		IndexColumn = @'
Tells to add the row index column.
'@
		RenameColumn = @'
Tells to rename duplicated columns.
'@
	}
	outputs = @{type = 'Microsoft.Data.Analysis.DataFrame'}
}

### Read-DataFrame
@{
	command = 'Read-DataFrame'
	synopsis = 'Reads DataFrame from the specified source.'
	description = @'
This command returns a DataFrame populated from the specified source.
The data reader or adapter source is disposed by this operation.
'@
	parameters = @{
		Source = 'The source data table, reader or adapter.'
	}
	outputs = @{type = 'Microsoft.Data.Analysis.DataFrame'}
}

### New-DataFrame
@{
	command = 'New-DataFrame'
	synopsis = 'Creates a new DataFrame.'
	description = @'
This command creates a new DataFrame from the specified columns.
'@
	parameters = @{
		Column = 'DataFrame columns.'
	}
	outputs = @{type = 'Microsoft.Data.Analysis.DataFrame'}
	examples = @(
		@{
			code = {
				## The more effective way (but more typing)

				# create just columns first
				$name = New-StringColumn Name
				$age = New-Int32Column Age

				# append data to columns
				$name.Append('Joe')
				$age.Append(42)

				# create DataFrame
				$df = New-DataFrame $name, $age
			}
			test = {. $args[0]}
		}
		@{
			code = {
				## The less effective way (but less typing)

				# create columns and DataFrame
				$df = New-DataFrame @(
					New-StringColumn Name
					New-Int32Column Age
				)

				# append data rows
				Add-DataFrameRow $df Joe, 42
			}
			test = {. $args[0]}
		}
	)
}


### Out-DataFrame
@{
	command = 'Out-DataFrame'
	synopsis = 'Appends DataFrame rows from input objects.'
	description = @'
The DataFrame columns work as selectors of input object properties.
If they do not match, transform input objects by Select-Object.
'@
	parameters = @{
		DataFrame = 'The DataFrame for appending rows.'
		InputObject = 'DataFrame row source.'
	}
	inputs = @{description = 'DataFrame row source.'}
	examples = @{
		code = {
			# create DataFrame
			$df = New-DataFrame @(
				New-StringColumn Name
				New-Int64Column Length
			)

			# append rows from input objects
			Get-ChildItem -File | Out-DataFrame $df
		}
		test = {. $args[0]}
	}
	links = @(
		@{text = 'Add-DataFrameRow'}
	)
}

### Add-DataFrameRow
@{
	command = 'Add-DataFrameRow'
	synopsis = 'Adds one row to DataFrame.'
	description = @'
This command adds one row of values to the DataFrame.
Values come from the pipeline or as the parameter.

The number of input values may be less than column count.
In this case nulls replace missing values.
'@
	parameters = @{
		DataFrame = 'The DataFrame to be appended with one row.'
		InputObject = 'Row values from the pipeline or the parameter.'
	}
	inputs = @{description = 'Row values.'}
	examples = @{
		code = {
			# create DataFrame
			$df = New-DataFrame @(
				New-StringColumn Name
				New-Int64Column Length
			)

			# append rows from input objects
			Get-ChildItem -File | % { Add-DataFrameRow $df $_.Name, $_.Length }
		}
		test = {. $args[0]}
	}
	links = @(
		@{text = 'Out-DataFrame'}
	)
}

### NewAnyColumn
$NewAnyColumn = @{
	description = @'
This command creates a new column with the specified or generated name,
optional initial length, and optional values added from the pipeline.
'@
	parameters = @{
		Name = @'
Specifies the column name. If it is omitted then "ColumnN" is used where N is
some number.
'@
		Length = @'
Specifies the initial column length.
'@
		InputObject = @'
Column values from the pipeline.
'@
	}
	inputs = @{
		description = 'Column values.'
	}
}

### New-BooleanColumn
Merge-Helps $NewAnyColumn @{
	command = 'New-BooleanColumn'
	synopsis = 'Creates Microsoft.Data.Analysis.BooleanDataFrameColumn'
	outputs = @{type = 'Microsoft.Data.Analysis.BooleanDataFrameColumn'}
}

### New-ByteColumn
Merge-Helps $NewAnyColumn @{
	command = 'New-ByteColumn'
	synopsis = 'Creates Microsoft.Data.Analysis.ByteDataFrameColumn'
	outputs = @{type = 'Microsoft.Data.Analysis.ByteDataFrameColumn'}
}

### New-CharColumn
Merge-Helps $NewAnyColumn @{
	command = 'New-CharColumn'
	synopsis = 'Creates Microsoft.Data.Analysis.CharDataFrameColumn'
	outputs = @{type = 'Microsoft.Data.Analysis.CharDataFrameColumn'}
}

### New-DateTimeColumn
Merge-Helps $NewAnyColumn @{
	command = 'New-DateTimeColumn'
	synopsis = 'Creates Microsoft.Data.Analysis.DateTimeDataFrameColumn'
	outputs = @{type = 'Microsoft.Data.Analysis.DateTimeDataFrameColumn'}
}

### New-DecimalColumn
Merge-Helps $NewAnyColumn @{
	command = 'New-DecimalColumn'
	synopsis = 'Creates Microsoft.Data.Analysis.DecimalDataFrameColumn'
	outputs = @{type = 'Microsoft.Data.Analysis.DecimalDataFrameColumn'}
}

### New-DoubleColumn
Merge-Helps $NewAnyColumn @{
	command = 'New-DoubleColumn'
	synopsis = 'Creates Microsoft.Data.Analysis.DoubleDataFrameColumn'
	outputs = @{type = 'Microsoft.Data.Analysis.DoubleDataFrameColumn'}
}

### New-Int16Column
Merge-Helps $NewAnyColumn @{
	command = 'New-Int16Column'
	synopsis = 'Creates Microsoft.Data.Analysis.Int16DataFrameColumn'
	outputs = @{type = 'Microsoft.Data.Analysis.Int16DataFrameColumn'}
}

### New-Int32Column
Merge-Helps $NewAnyColumn @{
	command = 'New-Int32Column'
	synopsis = 'Creates Microsoft.Data.Analysis.Int32DataFrameColumn'
	outputs = @{type = 'Microsoft.Data.Analysis.Int32DataFrameColumn'}
}

### New-Int64Column
Merge-Helps $NewAnyColumn @{
	command = 'New-Int64Column'
	synopsis = 'Creates Microsoft.Data.Analysis.Int64DataFrameColumn'
	outputs = @{type = 'Microsoft.Data.Analysis.Int64DataFrameColumn'}
}

### New-SingleColumn
Merge-Helps $NewAnyColumn @{
	command = 'New-SingleColumn'
	synopsis = 'Creates Microsoft.Data.Analysis.SingleDataFrameColumn'
	outputs = @{type = 'Microsoft.Data.Analysis.SingleDataFrameColumn'}
}

### New-StringColumn
Merge-Helps $NewAnyColumn @{
	command = 'New-StringColumn'
	synopsis = 'Creates Microsoft.Data.Analysis.StringDataFrameColumn'
	outputs = @{type = 'Microsoft.Data.Analysis.StringDataFrameColumn'}
}
