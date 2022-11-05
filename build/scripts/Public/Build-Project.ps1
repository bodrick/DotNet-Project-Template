
function Build-Project
{
    [CmdletBinding(SupportsShouldProcess = $true)]
    param
    (
        [switch]
        $NoIncremental,
        [Parameter(Mandatory)]
        [string]
        $Project,
        [switch]
        $Force,
        [Parameter(Mandatory)]
        [string]
        $BasePath,
        [ValidateSet('Release', 'Debug')]
        [string]
        $Configuration = 'Release'
    )

    $BuildFlags = [List[string]]@(
        $Project,
        "--configuration $Configuration",
        '--no-restore'
        '--nologo',
        '--verbosity minimal'
    )

    if ($Force.IsPresent)
    {
        $BuildFlags += '--force'
    }

    if ($NoIncremental.IsPresent)
    {
        $BuildFlags += '--no-incremental'
    }

    $BaseCommand = "{0} {1} -bl:""$BasePath\build_logs\{0}.binlog"""

    if ($PSCmdlet.ShouldProcess($Project, 'Build project'))
    {
        $BuildCommand = $BaseCommand -f 'build', ($BuildFlags -join ' ')
        Write-Host 'Building project...' -ForegroundColor 'Magenta'
        Write-Host "Build Command: dotnet $BuildCommand" -ForegroundColor 'Cyan'
        Start-Process dotnet -NoNewWindow -Wait -ArgumentList $BuildCommand
        Write-Host 'Done building.' -ForegroundColor 'Green'
    }
}
