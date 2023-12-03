<#
.Synopsis
	Sets many rows using inexes and shows times.

.Description
	This way is much faster than using Add-DataRow, see x-many-rows-2.ps1.
	With unknown Length use columns Append(), it works fast as well.

	Time                 Index Name
	----                 ----- ----
	2023-12-02 18:19:07      0 Name0
	2023-12-02 18:19:07 100000 Name100000
	2023-12-02 18:19:07 200000 Name200000
	2023-12-02 18:19:07 300000 Name300000
	2023-12-02 18:19:07 400000 Name400000
	2023-12-02 18:19:07 500000 Name500000
#>

Import-Module DataFrame
$n1 = 100000
$n2 = $n1 * 5 + 1

# create just columns
$Time = New-DateTimeColumn Time -Length $n2
$Index= New-Int32Column Index -Length $n2
$Name = New-StringColumn Name -Length $n2
$Check = New-BooleanColumn Check -Length $n2

# set columns data
for($i = 0; $i -lt $n2; ++$i) {
	$Time[$i] = [DateTime]::Now
	$Index[$i] = $i
	$Name[$i] = "Name$i"
	$Check[$i] = $i % $n1 -eq 0
}

# now make DataFrame and show checked rows
$df = New-DataFrame $Time, $Index, $Name
$df.Filter($Check).ToTable()
