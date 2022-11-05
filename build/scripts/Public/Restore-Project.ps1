
function Restore-Project
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
        $BasePath
    )

    $RestoreFlags = [List[string]]@(
        $Project,
        '--nologo',
        '--verbosity minimal'
    )

    if ($Force.IsPresent)
    {
        $RestoreFlags += '--force'
    }

    $BaseCommand = "{0} {1} -bl:""$BasePath\build_logs\{0}.binlog"""

    if ($PSCmdlet.ShouldProcess($Project, 'Restore project'))
    {
        $RestoreCommand = $BaseCommand -f 'restore', ( $RestoreFlags -join ' ')
        Write-Host 'Restore project...' -ForegroundColor 'Magenta'
        Write-Host "Restore Command: dotnet $RestoreCommand" -ForegroundColor 'Cyan'
        Start-Process dotnet -NoNewWindow -Wait -ArgumentList $RestoreCommand
        Write-Host 'Done restore.' -ForegroundColor 'Green'
    }
}
