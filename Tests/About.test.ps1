
Set-StrictMode -Version 3
Import-Module ./Zoo.psm1

task clean {
	remove z.*
}

task help_synopsis {
	Get-Command -Module DataFrame | Get-Help | .{process{
		if (!$_.Synopsis.EndsWith('.')) {
			Write-Warning "$($_.Name) : unexpected/missing synopsis"
		}
	}}
}

# task help_exaples {
# 	. Helps.ps1
# 	Test-Helps ..\Module\en-US\DataFrame-Help.ps1
# }
