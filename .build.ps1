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
task meta -Inputs (
	'.build.ps1', 'Release-Notes.md'
) -Outputs (
	"Module\$ModuleName.psd1", 'Src\Directory.Build.props'
) -Jobs version, {
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
		<FileVersion>$Version</FileVersion>
		<AssemblyVersion>$Version</AssemblyVersion>
	</PropertyGroup>
</Project>
"@
}

# Synopsis: Clean the workspace.
task clean {
	remove *.nupkg, z, Src\bin, Src\obj, README.htm
}

# Synopsis: Build the project (and post-build Publish).
task build meta, {
	exec { dotnet build Src\$AssemblyName.csproj -c $Configuration }
}

# Synopsis: Publish the module (post-build).
task publish {
	exec { dotnet publish Src\$AssemblyName.csproj -c $Configuration -o $ModuleRoot --no-build }
	exec { robocopy Module $ModuleRoot /s /np /r:0 /xf *-Help.ps1 } (0..3)
	remove $ModuleRoot\System.Management.Automation.dll
}

# Synopsis: Build help by Helps, https://github.com/nightroman/Helps
task help -Inputs {
	Get-Item Src\Commands\*, Module\en-US\DataFrame-Help.ps1
} -Outputs {
	"$ModuleRoot\en-US\DataFrame-Help.xml"
} -Jobs {
	. Helps.ps1
	Convert-Helps Module\en-US\DataFrame-Help.ps1 $Outputs
}

# Synopsis: Make an test help.
task testHelp help, {
	. Helps.ps1
	Test-Helps Module\en-US\$ModuleName-Help.ps1
}

# Synopsis: Test this edition, then another.
task test {
	$ErrorView = 'NormalView'
	Invoke-Build ** Tests

	if ($env:TEST_THIS_EDITION) {
		return
	}

	if ($PSEdition -eq 'Core') {
		Invoke-Build test5
	}
	else {
		Invoke-Build test7
	}
}

# Synopsis: Test Desktop edition.
task test5 {
	Use-BuildEnv @{TEST_THIS_EDITION = 1} {
		exec {powershell -NoProfile -Command Invoke-Build Test}
	}
}

# Synopsis: Test Core edition.
task test7 {
	Use-BuildEnv @{TEST_THIS_EDITION = 1} {
		exec {pwsh -NoProfile -Command Invoke-Build Test}
	}
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

# Synopsis: Set $script:Version.
task version {
	($script:Version = switch -Regex -File Release-Notes.md {'##\s+v(\d+\.\d+\.\d+)' {$Matches[1]; break} })
}

# Synopsis: Make the package in z\tools.
task package build, help, testHelp, test, markdown, {
	remove z
	$null = mkdir z\tools\$ModuleName

	Copy-Item -Recurse -Destination z\tools\$ModuleName $(
		'LICENSE'
		'README.htm'
		"$ModuleRoot\*"
	)
}

# Synopsis: Make and push the PSGallery package.
task pushPSGallery package, version, {
	# test assembly version
	assert ((Get-Item $ModuleRoot\$AssemblyName.dll).VersionInfo.FileVersion -eq ([Version]$Version))

	# test manifest version
	$data = & ([scriptblock]::Create([IO.File]::ReadAllText("$ModuleRoot\$ModuleName.psd1")))
	assert ($data.ModuleVersion -eq $Version)

	# publish
	$NuGetApiKey = Read-Host NuGetApiKey
	Publish-Module -Path z/tools/$ModuleName -NuGetApiKey $NuGetApiKey
},
clean

# Synopsis: Make and test.
task . build, help, clean
