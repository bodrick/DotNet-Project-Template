
function Publish-Project
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
        $PublishCommand = $BaseCommand -f 'publish', ($BuildFlags -join ' ')
        Write-Host 'Publishing project...' -ForegroundColor 'Magenta'
        Write-Host "Publish Command: dotnet $PublishCommand" -ForegroundColor 'Cyan'
        Start-Process dotnet -NoNewWindow -Wait -ArgumentList $PublishCommand
        Write-Host 'Done publishing.' -ForegroundColor 'Green'
    }
}
