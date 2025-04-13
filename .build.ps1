<#
.Synopsis
	Build script, https://github.com/nightroman/Invoke-Build
#>

param(
	$Configuration = 'Release'
)

#requires -Version 7.4
Set-StrictMode -Version 3

$ModuleName = 'DataFrame'
$AssemblyName = 'PSDataFrame'
$ModuleRoot = $PSVersionTable.Platform -eq 'Unix' ? "$HOME/.local/share/powershell/Modules" : "$env:ProgramFiles\PowerShell\Modules\$ModuleName"

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

	PowerShellVersion = '7.4'
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
			Tags = 'DataFrame', 'DataTable', 'CSV', 'TSV', 'Parquet'
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
}

# Synopsis: Publish the module (post-build).
task publish {
	exec { dotnet publish "Src\$AssemblyName.csproj" -c $Configuration -o $ModuleRoot --no-build }
	remove "$ModuleRoot\System.Management.Automation.dll", "$ModuleRoot\*.deps.json"
	Copy-Item Module\* $ModuleRoot -Exclude *.ps1 -Force -Recurse
}

# Synopsis: Build help by https://github.com/nightroman/Helps
task help -After ?build -Inputs { Get-Item Src\Commands\*, "Module\en-US\$ModuleName-Help.ps1" } -Outputs "$ModuleRoot\en-US\DataFrame-Help.xml" -Jobs {
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
	equals (Get-Module $ModuleName -ListAvailable).Version ([Version]$Version)

	remove z
	$toModule = mkdir "z\$ModuleName"

	Copy-Item $ModuleRoot\* $toModule -Recurse -Exclude *.pdb
	Copy-Item -Destination $toModule LICENSE
	Move-Item -Destination z\$ModuleName README.htm

	$result = Get-ChildItem $toModule -Recurse -File -Name | Out-String
	$sample = @'
Apache.Arrow.dll
DataFrame.psd1
IronCompress.dll
LICENSE
Microsoft.Data.Analysis.dll
Microsoft.IO.RecyclableMemoryStream.dll
Microsoft.ML.DataView.dll
Parquet.Data.Analysis.dll
Parquet.dll
PSDataFrame.dll
README.htm
Snappier.dll
System.Numerics.Tensors.dll
ZstdSharp.dll
en-US\about_DataFrame.help.txt
en-US\DataFrame-Help.xml
runtimes\linux-arm64\native\libnironcompress.so
runtimes\linux-x64\native\libnironcompress.so
runtimes\osx-arm64\native\libnironcompress.dylib
runtimes\win-x64\native\nironcompress.dll
'@
	Assert-SameFile.ps1 -Text $sample $result $env:MERGE
}

# Synopsis: Make and push the PSGallery package.
task pushPSGallery package, {
	$NuGetApiKey = Read-Host NuGetApiKey
	Publish-Module -Path z\$ModuleName -NuGetApiKey $NuGetApiKey
},
clean

# Synopsis: Run tests.
task test {
	Invoke-Build ** Tests
}

# Synopsis: Build, test, clean.
task all build, test, clean

# Synopsis: Build and clean.
task . build, clean
