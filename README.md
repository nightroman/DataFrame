# DataFrame

PowerShell cmdlets for [Microsoft.Data.Analysis.DataFrame](https://learn.microsoft.com/en-us/dotnet/api/microsoft.data.analysis.dataframe)

This module is designed for PowerShell Core and Windows PowerShell 5.1

## Install

The module is available at [PSGallery](https://www.powershellgallery.com/packages/DataFrame) and may be installed as:

```powershell
Install-Module DataFrame
```

## Explore

Explore the available commands and help:

```powershell
Import-Module DataFrame
Get-Command -Module DataFrame

help about_DataFrame
help Import-DataFrame
```

## Cmdlets

Import and export `DataFrame` data:

- `Import-DataFrame`
- `Export-DataFrame`

Create and populate `DataFrame`:

- `New-DataFrame`
- `Out-DataFrame`
- `Add-DataRow`

Create `DataFrame` columns:

- `New-BooleanColumn`
- `New-ByteColumn`
- `New-CharColumn`
- `New-DateTimeColumn`
- `New-DecimalColumn`
- `New-DoubleColumn`
- `New-Int16Column`
- `New-Int32Column`
- `New-Int64Column`
- `New-SingleColumn`
- `New-StringColumn`

## Example

```powershell
# create a new DataFrame for process names and memory
$df = New-DataFrame @(
    New-StringColumn Name
    New-Int64Column WS
)

# get processes and output to the DataFrame
Get-Process | Out-DataFrame $df

# top 10 processes by average used memory
$df.GroupBy('Name').Mean('WS').OrderBy('WS').Tail(10).ToTable()
```

## See also

- [DataFrame Release Notes](https://github.com/nightroman/DataFrame/blob/main/Release-Notes.md)
- [Getting started with DataFrames - ML.NET | Microsoft Learn](https://learn.microsoft.com/en-us/dotnet/machine-learning/how-to-guides/getting-started-dataframe)
- [DataFrame Class (Microsoft.Data.Analysis) | Microsoft Learn](https://learn.microsoft.com/en-us/dotnet/api/microsoft.data.analysis.dataframe)
