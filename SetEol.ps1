$VerbosePreference = 'Continue'
$InformationPreference = 'Continue'

$includedExtensions = '*.cs', '*.tt', '*.csproj', '*.json'
$currentPath = Split-Path $MyInvocation.MyCommand.Path
$files = Get-ChildItem -Path $currentPath -Recurse -Include $includedExtensions
foreach ($file in $files)
{
    Write-Host "Set CRLF for $file"
    $text = [IO.File]::ReadAllText($file) -replace '(?<!\r)\n', "`r`n"
    $text = $text.Replace("`t", "    ")
    [IO.File]::WriteAllText($file, $text)
}
