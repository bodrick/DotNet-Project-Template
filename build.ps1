[CmdletBinding(SupportsShouldProcess = $true)]
Param
(
    [switch]
    $Clean = $false,
    [switch]
    $CreatePackages,
    [ValidateSet('yes', 'no')]
    [string]
    $Publish = 'no',
    [switch]
    $NoIncremental,
    [switch]
    $Force,
    [string]
    $Project,
    [string]
    $SolutionDir = "$PSScriptRoot",
    [ValidateSet('Release', 'Debug')]
    [string]
    $Configuration = 'Release'
)

Import-Module -Name "$PSScriptRoot\build\scripts\Build.psm1"

if ($Project -eq '')
{
    $ProjectExtensions = '*.sln'
    $ProjectFiles = @(Get-ChildItem -Path $SolutionDir -Include $ProjectExtensions -File -Name)
    if ($ProjectFiles.Count -gt 0)
    {
        $Project = $ProjectFiles[0]
    }
}

Write-Host 'Run Parameters:' -ForegroundColor Cyan
Write-Host "  Project: $Project"
Write-Host "  Configuration: $Configuration"
Write-Host "  Clean: $Clean"
Write-Host "  CreatePackages: $CreatePackages"
Write-Host "  Publish: $(Convert-YesNoToBool($Publish))"
Write-Host "  NoIncremental: $NoIncremental"
Write-Host "  Force: $Force"

if ($PSCmdlet.ShouldProcess($SolutionDir, 'Clean build path'))
{
    if ($Clean.IsPresent)
    {
        Clean-Build
    }
    else
    {
        Write-Host 'Skipping clean build' -ForegroundColor 'Green'
    }
}

$CommonFlags = @{
    Project  = $Project
    BasePath = $SolutionDir
    Force    = $Force.IsPresent
}


if ($PSCmdlet.ShouldProcess($Project, 'Restore project'))
{
    Restore-Project @CommonFlags
}

if ($PSCmdlet.ShouldProcess($Project, 'Build project'))
{
    Build-Project @CommonFlags -NoIncremental:$NoIncremental.IsPresent -Configuration $Configuration
}

if ($CreatePackages.IsPresent)
{
    Build-Packages @CommonFlags -Configuration $Configuration
}

if (Convert-YesNoToBool($Publish))
{
    if ($PSCmdlet.ShouldProcess($Project, 'Publish project'))
    {
        Publish-Project @CommonFlags -Configuration $Configuration
    }
}
