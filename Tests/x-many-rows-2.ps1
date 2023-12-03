<#
.Synopsis
	Adds many rows by Add-DataRow and shows times.

.Description
	Appending to DataFrame is slower than using indexes or appending to columns.
	But this way is simpler and suitable for temporary or interactive scenarios.

	Time                 Index Name       Check
	----                 ----- ----       -----
	2023-12-02 18:06:59      0 Name0       True
	2023-12-02 18:07:00 100000 Name100000  True
	2023-12-02 18:07:01 200000 Name200000  True
	2023-12-02 18:07:03 300000 Name300000  True
	2023-12-02 18:07:04 400000 Name400000  True
	2023-12-02 18:07:05 500000 Name500000  True

.Notes
	PS 7.4 shows much better performance than 5.1.
#>

Import-Module DataFrame
$n1 = 100000
$n2 = $n1 * 5 + 1

# DataFrame with times and extras
$df = New-DataFrame @(
	New-DateTimeColumn Time
	New-Int32Column Index
	New-StringColumn Name
	New-BooleanColumn Check
)

# add many rows
for($i = 0; $i -lt $n2; ++$i) {
	Add-DataRow $df ([DateTime]::Now), $i, "Name$i", ($i % $n1 -eq 0)
}

# show checkpoint rows
$df.Filter($df['Check']).ToTable()
