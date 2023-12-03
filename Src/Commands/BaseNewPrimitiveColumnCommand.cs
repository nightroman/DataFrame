
using Microsoft.Data.Analysis;
using System.Management.Automation;

namespace PSDataFrame.Commands;

public abstract class BaseNewPrimitiveColumnCommand<T> : BaseNewAnyColumnCommand where T : unmanaged
{
    protected PrimitiveDataFrameColumn<T> _column;

    [Parameter(ValueFromPipeline = true)]
    public T? InputObject { get; set; }

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
