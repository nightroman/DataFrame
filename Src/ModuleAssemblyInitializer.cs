
using System;
using System.Management.Automation;
using System.Reflection;

namespace PSDataFrame;

public class ModuleAssemblyInitializer : IModuleAssemblyInitializer
{
    public void OnImport()
    {
        AppDomain.CurrentDomain.AssemblyResolve += AssemblyResolve;
    }

    Assembly AssemblyResolve(object sender, ResolveEventArgs args)
    {
        if (args.Name.StartsWith("System.Runtime.CompilerServices.Unsafe"))
        {
            var assemblies = AppDomain.CurrentDomain.GetAssemblies();
            foreach (var assembly in assemblies)
            {
                if (assembly.FullName.StartsWith("System.Runtime.CompilerServices.Unsafe"))
                    return assembly;
            }
        }
        return null;
    }
}
