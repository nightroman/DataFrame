﻿
Set-StrictMode -Version 3
Import-Module ./Zoo.psm1

task clean {
	remove z.*
}

task help {
	foreach($_ in Get-Command -Module DataFrame) {
		$r = Get-Help $_
		if (!"$($r.Description)") {
			Write-Warning "Missing help description: $($_.Name)"
		}
	}
}
