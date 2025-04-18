﻿
using Microsoft.Data.Analysis;
using Parquet;
using System.Management.Automation;

namespace PSDataFrame.Commands;

[Cmdlet(VerbsData.Import, "DataFrame", DefaultParameterSetName = PsnPath)]
[OutputType(typeof(DataFrame))]
public class ImportDataFrameCommand : BaseImportExportCommand
{
    [Parameter(ParameterSetName = PsnPath, Position = 0, Mandatory = true)]
    public string Path { get; set; }

    [Parameter(ParameterSetName = PsnParquet, Mandatory = true)]
    public string ParquetPath { get; set; }

    [Parameter(ParameterSetName = PsnString, Mandatory = true)]
    public string String { get; set; }

    [Parameter(ParameterSetName = PsnPath)]
    [Parameter(ParameterSetName = PsnString)]
    public string[] ColumnName { get; set; }

    [Parameter(ParameterSetName = PsnPath)]
    [Parameter(ParameterSetName = PsnString)]
    public Type[] ColumnType { get; set; }

    [Parameter(ParameterSetName = PsnPath)]
    [Parameter(ParameterSetName = PsnString)]
    public int RowCount { get; set; } = -1;

    [Parameter(ParameterSetName = PsnPath)]
    [Parameter(ParameterSetName = PsnString)]
    public int[] GuessCount { get; set; }

    [Parameter(ParameterSetName = PsnPath)]
    [Parameter(ParameterSetName = PsnString)]
    public SwitchParameter IndexColumn { get; set; }

    [Parameter(ParameterSetName = PsnPath)]
    [Parameter(ParameterSetName = PsnString)]
    public SwitchParameter RenameColumn { get; set; }

    protected override void BeginProcessing()
    {
        var guesses = GuessCount?.Length > 0 ? GuessCount : [10];
        for (int iGuess = 0; iGuess < guesses.Length; ++iGuess)
        {
            try
            {
                if (ParameterSetName == PsnPath)
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
                        renameDuplicatedColumns: RenameColumn,
                        encoding: Encoding,
                        cultureInfo: Culture);

                    WriteObject(df);
                    return;
                }

                if (ParameterSetName == PsnString)
                {
                    var df = DataFrame.LoadCsvFromString(
                        String,
                        separator: Separator,
                        header: !NoHeader,
                        columnNames: ColumnName,
                        dataTypes: ColumnType,
                        numberOfRowsToRead: RowCount,
                        guessRows: guesses[iGuess],
                        addIndexColumn: IndexColumn,
                        renameDuplicatedColumns: RenameColumn,
                        cultureInfo: Culture);

                    WriteObject(df);
                    return;
                }

                if (ParameterSetName == PsnParquet)
                {
                    using var parquetStream = new FileStream(GetUnresolvedProviderPathFromPSPath(ParquetPath), FileMode.Open, FileAccess.Read, FileShare.None);
                    var df = parquetStream.ReadParquetAsDataFrameAsync().GetAwaiter().GetResult();

                    WriteObject(df);
                    return;
                }

                throw new NotImplementedException();
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
