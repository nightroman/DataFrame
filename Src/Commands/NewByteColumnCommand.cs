
using Microsoft.Data.Analysis;
using System.Management.Automation;

namespace PSDataFrame.Commands;

[Cmdlet(VerbsCommon.New, "ByteColumn")]
[OutputType(typeof(ByteDataFrameColumn))]
public class NewByteColumnCommand : BaseNewPrimitiveColumnCommand<byte>
{
    protected override void BeginProcessing()
    {
        _column = new ByteDataFrameColumn(Name, Length);
    }
}
