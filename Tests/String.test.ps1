
Set-StrictMode -Version 3
Import-Module ./Zoo.psm1

task string {
	$str1 = @'
Name,Age
Joe,42
May,33

'@

	$df = Import-DataFrame -String $str1
	$str2 = Export-DataFrame $df -String

	equals (Convert-NewLine $str1) (Convert-NewLine $str2)
}
