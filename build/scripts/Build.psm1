using namespace System.Collections.Generic

Set-StrictMode -Version Latest

Write-Verbose 'Starting Importing'
Write-Verbose $PSScriptRoot

# Get public and private function definition files
$public = @(Get-ChildItem -Path "$PSScriptRoot\Public\*.ps1" -Exclude '*.Tests.*' -ErrorAction SilentlyContinue)

# Importing all functions
foreach ($import in $public)
{
    Write-Verbose "Importing $($import.FullName)..."
    try
    {
        . $import.FullName
    }
    catch
    {
        Write-Verbose "Failed to import function $($import.FullName): $_"
    }
}

# Export public functions
Export-ModuleMember -Function $public.BaseName
