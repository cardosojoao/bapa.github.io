# Run once from a local PowerShell session with write access to this repository's .git folder.
$ErrorActionPreference = 'Stop'
$repoRoot = Split-Path -Parent $PSScriptRoot

function Invoke-Git {
    param([string[]]$GitArguments)

    & git @GitArguments
    if ($LASTEXITCODE -ne 0) {
        throw "Git failed: git $($GitArguments -join ' ')"
    }
}

Push-Location -LiteralPath $repoRoot
try {
    $themePath = Join-Path $repoRoot 'themes/hugo-theme-stack'
    $gitMarker = Join-Path $themePath '.git'
    if (!(Test-Path -LiteralPath (Join-Path $themePath 'theme.toml'))) {
        throw 'The Stack theme files must be present before converting.'
    }
    if (Test-Path -LiteralPath $gitMarker -PathType Container) {
        throw 'Expected a submodule .git file, but found a directory. No changes made.'
    }

    $indexEntry = & git ls-files --stage -- themes/hugo-theme-stack
    if ($LASTEXITCODE -ne 0) { throw 'Cannot inspect the Git index.' }
    if ($indexEntry -match '^160000 ') {
        # Removes only the gitlink from the index; keeps all theme files on disk.
        Invoke-Git -GitArguments @('rm', '--cached', '--force', '--', 'themes/hugo-theme-stack')
    }

    if (Test-Path -LiteralPath $gitMarker -PathType Leaf) {
        Remove-Item -LiteralPath $gitMarker
    }

    $submoduleUrl = & git config --local --get submodule.themes/hugo-theme-stack.url
    if ($LASTEXITCODE -eq 0) {
        Invoke-Git -GitArguments @('config', '--local', '--remove-section', 'submodule.themes/hugo-theme-stack')
    } elseif ($LASTEXITCODE -ne 1) {
        throw 'Cannot inspect the local submodule configuration.'
    }

    Invoke-Git -GitArguments @('add', '--', 'themes/hugo-theme-stack', '.github/workflows/hugo.yml', 'STACK_SETUP.md', 'scripts/Convert-StackTheme.ps1')

    $themeEntries = & git ls-files --stage -- themes/hugo-theme-stack
    if ($LASTEXITCODE -ne 0) { throw 'Cannot verify theme tracking.' }
    if (!$themeEntries -or ($themeEntries -match '^160000 ')) {
        throw 'The theme is still missing or tracked as a submodule.'
    }

    Write-Host 'Stack is now tracked as regular files. Review the staged changes, then commit and push.'
    Invoke-Git -GitArguments @('diff', '--cached', '--stat')
} finally {
    Pop-Location
}
