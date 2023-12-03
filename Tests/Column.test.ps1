
Set-StrictMode -Version 3
Import-Module DataFrame

task Boolean {
	$r = $false, $true, 0.0, 3.14, $null | New-BooleanColumn
	equals 5L $r.Length
	equals $r[0] $false
	equals $r[1] $true
	equals $r[2] $false
	equals $r[3] $true
	equals $r[4]
}

task Byte {
	$r = [byte]1, 42, $null | New-ByteColumn
	equals 3L $r.Length
	equals $r[0] ([byte]1)
	equals $r[1] ([byte]42)
	equals $r[2]
}

task Char {
	$r = [char]1, 42, $null | New-CharColumn
	equals 3L $r.Length
	equals $r[0] ([char]1)
	equals $r[1] ([char]42)
	equals $r[2]
}

task DateTime {
	$now = Get-Date
	$r = $now, 0, 1, $null | New-DateTimeColumn
	equals 4L $r.Length
	equals $r[0] $now
	equals $r[1] ([DateTime]0)
	equals $r[2] ([DateTime]1)
	equals $r[3]
}

task Decimal {
	$r = 12345678901234567890d, 42, $null | New-DecimalColumn
	equals 3L $r.Length
	equals $r[0] 12345678901234567890d
	equals $r[1] 42d
	equals $r[2]
}

task Double {
	$r = 3.14, 42, $null | New-DoubleColumn
	equals 3L $r.Length
	equals $r[0] 3.14
	equals $r[1] 42.0
	equals $r[2]
}

task Int16 {
	$r = [int16]42, 3.14, $null | New-Int16Column
	equals 3L $r.Length
	equals $r[0] ([int16]42)
	equals $r[1] ([int16]3)
	equals $r[2]
}

task Int32 {
	$r = 42, 3.14, $null | New-Int32Column
	equals 3L $r.Length
	equals $r[0] 42
	equals $r[1] 3
	equals $r[2]
}

task Int64 {
	$r = 42L, 3.14, $null | New-Int64Column
	equals 3L $r.Length
	equals $r[0] 42L
	equals $r[1] 3L
	equals $r[2]
}

task Single {
	$r = [float]3.14, 42, $null | New-SingleColumn
	equals 3L $r.Length
	equals $r[0] ([float]3.14)
	equals $r[1] ([float]42)
	equals $r[2]
}

task String {
	$r = 'bar', 42L, $null | New-StringColumn
	equals 3L $r.Length
	equals $r[0] bar
	equals $r[1] '42'
	equals $r[2]
}
