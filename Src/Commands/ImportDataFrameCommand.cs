
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
    public int[] GuessCount { get; set; }

    [Parameter]
    public SwitchParameter IndexColumn { get; set; }

    protected override void BeginProcessing()
    {
        var guesses = GuessCount?.Length > 0 ? GuessCount : [10];
        for (int iGuess = 0; iGuess < guesses.Length; ++iGuess)
        {
            try
            {
                var df = DataFrame.LoadCsv(
                    GetUnresolvedProviderPathFromPSPath(Path),
                    separator: Separator,
                    header: !NoHeader,
                    columnNames: ColumnName,
                    dataTypes: ColumnType,
                    numRows: RowCount,
                    guessRows: guesses[iGuess],
                    addIndexColumn: IndexColumn,
                    encoding: Encoding,
                    cultureInfo: Culture);

                WriteObject(df);
                return;
            }
            catch (FormatException ex)
            {
                if (ColumnType is not null || iGuess == guesses.Length - 1)
                    throw;

                WriteWarning($"Retrying after failed guess count {guesses[iGuess]}: {ex.Message}");
            }
        }
    }
}
