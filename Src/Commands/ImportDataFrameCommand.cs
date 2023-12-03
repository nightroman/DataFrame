
using Microsoft.Data.Analysis;
using System;
using System.Management.Automation;

namespace PSDataFrame.Commands;

[Cmdlet(VerbsData.Import, "DataFrame")]
[OutputType(typeof(DataFrame))]
public class ImportDataFrameCommand : BaseImportExportCommand
{
    [Parameter]
    public string[] ColumnName { get; set; }

    [Parameter]
    public Type[] ColumnType { get; set; }

    [Parameter]
    public int RowCount { get; set; } = -1;

    [Parameter]
    public int GuessCount { get; set; } = 10;

    [Parameter]
    public SwitchParameter IndexColumn { get; set; }

    protected override void BeginProcessing()
    {
        var df = DataFrame.LoadCsv(
            GetUnresolvedProviderPathFromPSPath(Path),
            separator: Separator,
            header: !NoHeader,
            columnNames: ColumnName,
            dataTypes: ColumnType,
            numRows: RowCount,
            guessRows: GuessCount,
            addIndexColumn: IndexColumn,
            encoding: Encoding,
            cultureInfo: Culture);

        WriteObject(df);
    }
}
