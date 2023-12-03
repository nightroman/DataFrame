
using Microsoft.Data.Analysis;
using System.Management.Automation;

namespace PSDataFrame.Commands;

[Cmdlet(VerbsCommon.New, "StringColumn")]
[OutputType(typeof(StringDataFrameColumn))]
public class NewStringColumnCommand : BaseNewAnyColumnCommand
{
    StringDataFrameColumn _column;

    [Parameter(ValueFromPipeline = true)]
    public string InputObject { get; set; }

    protected override void BeginProcessing()
    {
        _column = new StringDataFrameColumn(Name, Length);
    }

    protected override void EndProcessing()
    {
        WriteObject(_column);
    }

    protected override void ProcessRecord()
    {
        if (MyInvocation.ExpectingInput)
            _column.Append(InputObject);
    }
}
