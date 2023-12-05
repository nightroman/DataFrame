
using Microsoft.Data.Analysis;
using System;
using System.IO;
using System.Management.Automation;

namespace PSDataFrame.Commands;

[Cmdlet(VerbsData.Export, "DataFrame", DefaultParameterSetName = PsnPath)]
[OutputType(typeof(string), ParameterSetName = [PsnString])]
public class ExportDataFrameCommand : BaseImportExportCommand
{
    [Parameter(Position = 0, Mandatory = true)]
    public DataFrame DataFrame { get; set; }

    [Parameter(ParameterSetName = PsnPath, Position = 1, Mandatory = true)]
    public string Path { get; set; }

    [Parameter(ParameterSetName = PsnString, Mandatory = true)]
    public SwitchParameter String { get; set; }

    protected override void BeginProcessing()
    {
        if (ParameterSetName == PsnPath)
        {
            DataFrame.SaveCsv(
                DataFrame,
                GetUnresolvedProviderPathFromPSPath(Path),
                separator: Separator,
                header: !NoHeader,
                encoding: Encoding,
                cultureInfo: Culture);
            return;
        }

        if (ParameterSetName == PsnString)
        {
            var streamEncoding = System.Text.Encoding.UTF8;

            using var stream = new MemoryStream();
            DataFrame.SaveCsv(
                DataFrame,
                stream,
                separator: Separator,
                header: !NoHeader,
                encoding: streamEncoding,
                cultureInfo: Culture);

            stream.Position = 0;
            using var reader = new StreamReader(stream, streamEncoding);
            var text = reader.ReadToEnd();

            WriteObject(text);
            return;
        }

        throw new NotImplementedException();
    }
}
