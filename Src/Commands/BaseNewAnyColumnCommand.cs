
using System;
using System.Management.Automation;

namespace PSDataFrame.Commands;

public abstract class BaseNewAnyColumnCommand : PSCmdlet
{
    [ThreadStatic]
    static int s_number;
    string _name;

    [Parameter(Position = 0)]
    [ValidateNotNullOrEmpty]
    public string Name
    {
        get => _name ??= NextName();
        set => _name = value;
    }

    [Parameter]
    public long Length { get; set; }

    static string NextName()
    {
        return $"Column{++s_number}";
    }
}
