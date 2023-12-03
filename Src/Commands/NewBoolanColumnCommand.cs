
using Microsoft.Data.Analysis;
using System.Management.Automation;

namespace PSDataFrame.Commands;

[Cmdlet(VerbsCommon.New, "BooleanColumn")]
[OutputType(typeof(BooleanDataFrameColumn))]
public class NewBoolanColumnCommand : BaseNewPrimitiveColumnCommand<bool>
{
    protected override void BeginProcessing()
    {
        _column = new BooleanDataFrameColumn(Name, Length);
    }
}
