if (-not $ENV:BHProjectPath) {
    Set-BuildEnvironment -Path $PSScriptRoot\..
}
Remove-Module $ENV:BHProjectName -ErrorAction SilentlyContinue
Import-Module (Join-Path $ENV:BHProjectPath $ENV:BHProjectName) -Force


InModuleScope $ENV:BHProjectName {
    $PSVersion = $PSVersionTable.PSVersion.Major
    $ProjectRoot = $ENV:BHProjectPath

    $Verbose = @{}
    if ($ENV:BHBranchName -notlike "master" -or $env:BHCommitMessage -match "!verbose") {
        $Verbose.add("Verbose", $True)
    }

    Describe "Install-Dirk" {
        Context "Non-Windows" {
            Mock Get-Item { return @{Value = "macos"} } -ParameterFilter { $Path -eq 'env:os' }
            It "Should throw on non-windows systems" {
                { Get-Ninite -Apps 7zip } | Should -Throw
            }
        }
    }
}