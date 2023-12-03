
using Microsoft.Data.Analysis;
using System.Management.Automation;

namespace PSDataFrame.Commands;

[Cmdlet(VerbsCommon.New, "CharColumn")]
[OutputType(typeof(CharDataFrameColumn))]
public class NewCharColumnCommand : BaseNewPrimitiveColumnCommand<char>
{
    protected override void BeginProcessing()
    {
        _column = new CharDataFrameColumn(Name, Length);
    }
}
