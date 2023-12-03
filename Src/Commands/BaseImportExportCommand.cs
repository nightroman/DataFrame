
using System.Globalization;
using System.Management.Automation;
using System.Text;

namespace PSDataFrame.Commands;

public abstract class BaseImportExportCommand : PSCmdlet
{
    char _separator = ',';

    [Parameter(Position = 0, Mandatory = true)]
    public string Path { get; set; }

    [Parameter]
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

    [Parameter]
    public SwitchParameter NoHeader { get; set; }

    [Parameter]
    public Encoding Encoding { get; set; }

    [Parameter]
    public CultureInfo Culture { get; set; }
}
