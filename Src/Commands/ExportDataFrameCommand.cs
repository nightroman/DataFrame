
using Microsoft.Data.Analysis;
using System.Management.Automation;

namespace PSDataFrame.Commands;

[Cmdlet(VerbsData.Export, "DataFrame")]
public class ExportDataFrameCommand : BaseImportExportCommand
{
    [Parameter(Position = 1, Mandatory = true)]
    public DataFrame DataFrame { get; set; }

    protected override void BeginProcessing()
    {
        DataFrame.SaveCsv(
            DataFrame,
            GetUnresolvedProviderPathFromPSPath(Path),
            separator: Separator,
            header: !NoHeader,
            encoding: Encoding,
            cultureInfo: Culture);
    }
}
