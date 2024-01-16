
using System;
using System.IO;
using System.Management.Automation;
using System.Reflection;

namespace PSDataFrame;

public class ModuleAssemblyInitializer : IModuleAssemblyInitializer
{
    public void OnImport()
    {
    }

    static ModuleAssemblyInitializer()
    {
        AppDomain.CurrentDomain.AssemblyResolve += AssemblyResolve;
    }

    // Workaround for Desktop
    static Assembly AssemblyResolve(object sender, ResolveEventArgs args)
    {
        if (args.Name.StartsWith("System.Runtime.CompilerServices.Unsafe"))
        {
            var root = Path.GetDirectoryName(typeof(ModuleAssemblyInitializer).Assembly.Location);
            var path = Path.Combine(root, "System.Runtime.CompilerServices.Unsafe.dll");
            var assembly = Assembly.LoadFrom(path);
            return assembly;
        }
        return null;
    }
}
