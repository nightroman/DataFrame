
using Microsoft.Data.Analysis;
using System.Management.Automation;

namespace PSDataFrame.Commands;

[Cmdlet(VerbsCommon.New, "Int32Column")]
[OutputType(typeof(Int32DataFrameColumn))]
public class NewInt32ColumnCommand : BaseNewPrimitiveColumnCommand<int>
{
    protected override void BeginProcessing()
    {
        _column = new Int32DataFrameColumn(Name, Length);
    }
}
