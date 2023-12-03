
using Microsoft.Data.Analysis;
using System.Management.Automation;

namespace PSDataFrame.Commands;

[Cmdlet(VerbsCommon.Add, "DataRow")]
public class AddDataRowCommand : PSCmdlet
{
    int _count;
    object[] _values;

    [Parameter(Position = 0, Mandatory = true)]
    public DataFrame DataFrame { get; set; }

    [Parameter(Position = 1, ValueFromPipeline = true)]
    public object InputObject { get; set; }

    protected override void BeginProcessing()
    {
        _values = new object[DataFrame.Columns.Count];
    }

    protected override void EndProcessing()
    {
        DataFrame.Append(_values, true);
    }

    protected override void ProcessRecord()
    {
        if (MyInvocation.ExpectingInput || LanguagePrimitives.GetEnumerable(InputObject) is not { } values)
        {
            if (_count == _values.Length)
                throw new PSInvalidOperationException("Too many input values.");

            _values[_count] = InputObject is PSObject ps ? ps.BaseObject : InputObject;
            ++_count;
        }
        else
        {
            foreach (var value in values)
            {
                if (_count == _values.Length)
                    throw new PSInvalidOperationException("Too many input values.");

                _values[_count] = value is PSObject ps ? ps.BaseObject : value;
                ++_count;
            }
        }
    }
}
