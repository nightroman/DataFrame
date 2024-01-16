<#
.Synopsis
	Build script, https://github.com/nightroman/Invoke-Build
#>

param(
	$Configuration = 'Release'
)

Set-StrictMode -Version 3
$ModuleName = 'DataFrame'
$AssemblyName = 'PSDataFrame'
$ModuleRoot = "$env:ProgramFiles\WindowsPowerShell\Modules\$ModuleName"

# Synopsis: Generate meta files.
task meta -Inputs $BuildFile, Release-Notes.md -Outputs "Module\$ModuleName.psd1", Src\Directory.Build.props -Jobs version, {
	$Project = 'https://github.com/nightroman/DataFrame'
	$Summary = 'Cmdlets for Microsoft.Data.Analysis.DataFrame'
	$Copyright = 'Copyright (c) Roman Kuzmin'

	Set-Content Module\$ModuleName.psd1 @"
@{
	Author = 'Roman Kuzmin'
	ModuleVersion = '$Version'
	Description = '$Summary'
	CompanyName = 'https://github.com/nightroman'
	Copyright = '$Copyright'

	RootModule = '$AssemblyName.dll'
	RequiredAssemblies = 'Microsoft.Data.Analysis.dll'

	PowerShellVersion = '5.1'
	GUID = '8e619a4d-49bd-47d7-980e-842733c17482'

	AliasesToExport = @()
	VariablesToExport = @()
	FunctionsToExport = @()
	CmdletsToExport = @(
		'Add-DataFrameRow'
		'Export-DataFrame'
		'Import-DataFrame'
		'New-BooleanColumn'
		'New-ByteColumn'
		'New-CharColumn'
		'New-DataFrame'
		'New-DateTimeColumn'
		'New-DecimalColumn'
		'New-DoubleColumn'
		'New-Int16Column'
		'New-Int32Column'
		'New-Int64Column'
		'New-SingleColumn'
		'New-StringColumn'
		'Out-DataFrame'
		'Read-DataFrame'
	)

	PrivateData = @{
		PSData = @{
			Tags = 'DataFrame', 'DataTable', 'CSV', 'TSV'
			ProjectUri = '$Project'
			LicenseUri = '$Project/blob/main/LICENSE'
			ReleaseNotes = '$Project/blob/master/Release-Notes.md'
		}
	}
}
"@

	Set-Content Src\Directory.Build.props @"
<Project>
	<PropertyGroup>
		<Company>$Project</Company>
		<Copyright>$Copyright</Copyright>
		<Description>$Summary</Description>
		<Product>$ModuleName</Product>
		<Version>$Version</Version>
		<IncludeSourceRevisionInInformationalVersion>False</IncludeSourceRevisionInInformationalVersion>
	</PropertyGroup>
</Project>
"@
}

# Synopsis: Remove temp files.
task clean {
	remove z, Src\bin, Src\obj, README.htm
}

# Synopsis: Build, publish in post-build, make help.
task build meta, {
	exec { dotnet build "Src\$AssemblyName.csproj" -c $Configuration }
},
?help

# Synopsis: Publish the module (post-build).
task publish {
	exec { dotnet publish "Src\$AssemblyName.csproj" -c $Configuration -o $ModuleRoot --no-build }
	remove "$ModuleRoot\System.Management.Automation.dll", "$ModuleRoot\*.deps.json"

	exec { robocopy Module $ModuleRoot /s /np /r:0 /xf *-Help.ps1 } (0..3)
}

# Synopsis: Build help by https://github.com/nightroman/Helps
task help -Inputs { Get-Item Src\Commands\*, "Module\en-US\$ModuleName-Help.ps1" } -Outputs "$ModuleRoot\en-US\DataFrame-Help.xml" -Jobs {
	. Helps.ps1
	Convert-Helps "Module\en-US\$ModuleName-Help.ps1" $Outputs
}

# Synopsis: Set $script:Version.
task version {
	($script:Version = switch -Regex -File Release-Notes.md {'##\s+v(\d+\.\d+\.\d+)' {$Matches[1]; break} })
}

# Synopsis: Convert markdown to HTML.
task markdown {
	assert (Test-Path $env:MarkdownCss)
	exec { pandoc.exe @(
		'README.md'
		'--output=README.htm'
		'--from=gfm'
		'--embed-resources'
		'--standalone'
		"--css=$env:MarkdownCss"
		"--metadata=pagetitle=$ModuleName"
	)}
}

# Synopsis: Make the package.
task package help, markdown, version, {
	assert ((Get-Module $ModuleName -ListAvailable).Version -eq ([Version]$Version))
	assert ((Get-Item $ModuleRoot\$AssemblyName.dll).VersionInfo.FileVersion -eq ([Version]"$Version.0"))

	remove z
	exec { robocopy $ModuleRoot z\$ModuleName /s /xf *.pdb } (0..3)

	Copy-Item LICENSE -Destination z\$ModuleName
	Move-Item README.htm -Destination z\$ModuleName

	$actual = (Get-ChildItem z\$ModuleName -File -Force -Recurse -Name) -join "`n"
	$expected = @'
Apache.Arrow.dll
DataFrame.psd1
LICENSE
Microsoft.Data.Analysis.dll
Microsoft.ML.DataView.dll
PSDataFrame.dll
README.htm
System.Buffers.dll
System.Collections.Immutable.dll
System.Memory.dll
System.Numerics.Vectors.dll
System.Runtime.CompilerServices.Unsafe.dll
System.Threading.Tasks.Extensions.dll
en-US\about_DataFrame.help.txt
en-US\DataFrame-Help.xml
'@

	equals $actual ($expected -split '\r?\n' -join "`n")
}

# Synopsis: Make and push the PSGallery package.
task pushPSGallery package, {
	$NuGetApiKey = Read-Host NuGetApiKey
	Publish-Module -Path z\$ModuleName -NuGetApiKey $NuGetApiKey
},
clean

task test_core {
	exec { pwsh -NoProfile -Command Invoke-Build test }
}

task test_desktop {
	exec { powershell -NoProfile -Command Invoke-Build test }
}

# Synopsis: Test PowerShell editions.
task tests test_core, test_desktop

# Synopsis: Test current PowerShell.
task test {
	Invoke-Build ** Tests
}

# Synopsis: Build, test, clean.
task all build, tests, clean

# Synopsis: Build and clean.
task . build, clean
