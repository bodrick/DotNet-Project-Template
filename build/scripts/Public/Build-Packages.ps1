
function Build-Packages
{
    [CmdletBinding(SupportsShouldProcess = $true)]
    param
    (
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
        '--no-build',
        '--nologo',
        '--verbosity minimal'
    )

    if ($Force.IsPresent)
    {
        $BuildFlags += '--force'
    }

    $BaseCommand = "{0} {1} -bl:""$BasePath\build_logs\{0}.binlog"""

    if ($PSCmdlet.ShouldProcess($Project, 'Create packages'))
    {
        $PackCommand = $BaseCommand -f 'pack', ($BuildFlags -join ' ')
        Write-Host 'Creating packages...' -ForegroundColor 'Magenta'
        Write-Host "Pack Command: dotnet $PackCommand" -ForegroundColor 'Cyan'
        Start-Process dotnet -NoNewWindow -Wait -ArgumentList $PackCommand
        Write-Host 'Done creating packages.' -ForegroundColor 'Green'
    }
}
