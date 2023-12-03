
using Microsoft.Data.Analysis;
using System.Management.Automation;

namespace PSDataFrame.Commands;

[Cmdlet(VerbsCommon.New, "DataFrame")]
[OutputType(typeof(DataFrame))]
public class NewDataFrameCommand : PSCmdlet
{
    [Parameter(Position = 0, Mandatory = true)]
    public DataFrameColumn[] Column { get; set; }

    protected override void BeginProcessing()
    {
        WriteObject(new DataFrame(Column));
    }
}
