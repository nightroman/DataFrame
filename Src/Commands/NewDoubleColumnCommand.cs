
using Microsoft.Data.Analysis;
using System.Management.Automation;

namespace PSDataFrame.Commands;

[Cmdlet(VerbsCommon.New, "DoubleColumn")]
[OutputType(typeof(DoubleDataFrameColumn))]
public class NewDoubleColumnCommand : BaseNewPrimitiveColumnCommand<double>
{
    protected override void BeginProcessing()
    {
        _column = new DoubleDataFrameColumn(Name, Length);
    }
}
