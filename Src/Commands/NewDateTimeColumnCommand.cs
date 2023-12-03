
using Microsoft.Data.Analysis;
using System;
using System.Management.Automation;

namespace PSDataFrame.Commands;

[Cmdlet(VerbsCommon.New, "DateTimeColumn")]
[OutputType(typeof(DateTimeDataFrameColumn))]
public class NewDateTimeColumnCommand : BaseNewPrimitiveColumnCommand<DateTime>
{
    protected override void BeginProcessing()
    {
        _column = new DateTimeDataFrameColumn(Name, Length);
    }
}
