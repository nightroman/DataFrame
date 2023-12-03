
using Microsoft.Data.Analysis;
using System.Management.Automation;

namespace PSDataFrame.Commands;

[Cmdlet(VerbsCommon.New, "Int64Column")]
[OutputType(typeof(Int64DataFrameColumn))]
public class NewInt64ColumnCommand : BaseNewPrimitiveColumnCommand<long>
{
    protected override void BeginProcessing()
    {
        _column = new Int64DataFrameColumn(Name, Length);
    }
}
