
using Microsoft.Data.Analysis;
using System.Management.Automation;

namespace PSDataFrame.Commands;

[Cmdlet(VerbsCommon.New, "Int16Column")]
[OutputType(typeof(Int16DataFrameColumn))]
public class NewInt16ColumnCommand : BaseNewPrimitiveColumnCommand<short>
{
    protected override void BeginProcessing()
    {
        _column = new Int16DataFrameColumn(Name, Length);
    }
}
