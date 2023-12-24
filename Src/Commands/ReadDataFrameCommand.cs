
using Microsoft.Data.Analysis;
using System.Data;
using System.Data.Common;
using System.Management.Automation;

namespace PSDataFrame.Commands;

[Cmdlet(VerbsCommunications.Read, "DataFrame")]
[OutputType(typeof(DataFrame))]
public class ReadDataFrameCommand : PSCmdlet
{
    [Parameter(Position = 0, Mandatory = true)]
    public object Source { get; set; }

    protected override void BeginProcessing()
    {
        if (Source is DataTable dataTable)
        {
            using DataTableReader dataTableReader = new(dataTable);
            var df = DataFrame.LoadFrom(dataTableReader).GetAwaiter().GetResult();
            WriteObject(df);
            return;
        }

        if (Source is DbDataReader dataReader)
        {
            try
            {
                var df = DataFrame.LoadFrom(dataReader).GetAwaiter().GetResult();
                WriteObject(df);
            }
            finally
            {
                dataReader.Dispose();
            }
            return;
        }

        if (Source is DbDataAdapter dataAdapter)
        {
            try
            {
                var df = DataFrame.LoadFrom(dataAdapter).GetAwaiter().GetResult();
                WriteObject(df);
            }
            finally
            {
                dataAdapter.Dispose();
            }
            return;
        }

        throw new PSArgumentException("The source must be DataTable, DbDataReader, DbDataAdapter.", nameof(Source));
    }
}
