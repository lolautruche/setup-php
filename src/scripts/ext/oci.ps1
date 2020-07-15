Param (
  [Parameter(Position = 0, Mandatory = $true)]
  [ValidateNotNull()]
  [ValidateLength(1, [int]::MaxValue)]
  [string]
  $version
)

$tick = ([char]8730)
$php_dir = 'C:\tools\php'
if($env:RUNNER -eq 'self-hosted') { $php_dir = "$php_dir$version" }
$ext_dir = "$php_dir\ext"
$suffix = 'windows'
if(-not([Environment]::Is64BitOperatingSystem) -or $version -lt '7.0') {
  $suffix = 'nt'
}
$ociVersion='2.2.0'
if($version -eq '7.0') {
  $ociVersion='2.1.8'
}
if($version -lt '7.0') {
  $ociVersion='2.0.12'
}
$PhpVersion = Get-Php -Path $php_dir
$ociUrl = Get-PeclArchiveUrl oci8 $ociVersion $phpVersion

Invoke-WebRequest -UseBasicParsing -Uri https://download.oracle.com/otn_software/nt/instantclient/instantclient-basiclite-$suffix.zip -OutFile $php_dir\instantclient.zip
Expand-Archive -Path $php_dir\instantclient.zip -DestinationPath $php_dir -Force
Copy-Item $php_dir\instantclient*\* $php_dir
Invoke-WebRequest -UseBasicParsing -Uri $ociUrl -OutFile $php_dir\oci8.zip
Expand-Archive -Path $php_dir\oci8.zip -DestinationPath $ext_dir -Force
Add-Content -Value "`r`nextension=php_oci8.dll" -Path $php_dir\php.ini
printf "\033[%s;1m%s \033[0m\033[34;1m%s \033[0m\033[90;1m%s \033[0m\n" "32" $tick "oci8" "Installed and enabled"