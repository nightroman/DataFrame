﻿
using System.Globalization;
using System.Management.Automation;
using System.Text;

namespace PSDataFrame.Commands;

public abstract class BaseImportExportCommand : PSCmdlet
{
    protected const string PsnPath = "Path";
    protected const string PsnString = "String";
    protected const string PsnParquet = "Parquet";
    char _separator = ',';

    [Parameter(ParameterSetName = PsnPath)]
    [Parameter(ParameterSetName = PsnString)]
    public char Separator
    {
        get => _separator;
        set
        {
            _separator = value switch
            {
                'c' => ',',
                's' => ';',
                't' => '\t',
                _ => value
            };
        }
    }

    [Parameter(ParameterSetName = PsnPath)]
    [Parameter(ParameterSetName = PsnString)]
    public SwitchParameter NoHeader { get; set; }

    [Parameter(ParameterSetName = PsnPath)]
    public Encoding Encoding { get; set; }

    [Parameter(ParameterSetName = PsnPath)]
    [Parameter(ParameterSetName = PsnString)]
    public CultureInfo Culture { get; set; }
}
