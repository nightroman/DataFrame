
using Microsoft.Data.Analysis;
using System.Collections.Generic;
using System.Management.Automation;

namespace PSDataFrame.Commands;

[Cmdlet(VerbsData.Out, "DataFrame")]
public class OutDataFrameCommand : PSCmdlet
{
    readonly List<object> _row = [];

    [Parameter(Position = 0, Mandatory = true)]
    public DataFrame DataFrame { get; set; }

    [Parameter(ValueFromPipeline = true)]
    public PSObject InputObject;

    protected override void ProcessRecord()
    {
        _row.Clear();

        var properties = InputObject.Properties;
        foreach (var column in DataFrame.Columns)
        {
            var property = properties[column.Name];
            object value = null;
            if (property is not null)
            {
                value = property.Value;
                if (value is PSObject ps)
                    value = ps.BaseObject;
            }
            _row.Add(value);
        }

        DataFrame.Append(_row, true);
    }
}
