
using Microsoft.Data.Analysis;
using System.Management.Automation;

namespace PSDataFrame.Commands;

[Cmdlet(VerbsCommon.New, "DecimalColumn")]
[OutputType(typeof(DecimalDataFrameColumn))]
public class NewDecimalColumnCommand : BaseNewPrimitiveColumnCommand<decimal>
{
    protected override void BeginProcessing()
    {
        _column = new DecimalDataFrameColumn(Name, Length);
    }
}
