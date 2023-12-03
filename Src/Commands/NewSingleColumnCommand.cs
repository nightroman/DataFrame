
using Microsoft.Data.Analysis;
using System.Management.Automation;

namespace PSDataFrame.Commands;

[Cmdlet(VerbsCommon.New, "SingleColumn")]
[OutputType(typeof(SingleDataFrameColumn))]
public class NewSingleColumnCommand : BaseNewPrimitiveColumnCommand<float>
{
    protected override void BeginProcessing()
    {
        _column = new SingleDataFrameColumn(Name, Length);
    }
}
