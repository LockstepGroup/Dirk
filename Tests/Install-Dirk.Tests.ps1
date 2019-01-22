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
        $TestPath = Join-Path $env:TMPDIR -ChildPath "Dirk"
        $env:DirkRoot = $null

        switch -Regex (Get-OsVersion) {
            'MacOS' {
                Mock sudo { return $true } -Verifiable
            }
            'Windows' {
                Mock Invoke-ElevatedProcess { return $true } -Verifiable
            }
        }

        Mock Get-GithubRepo { return $true } -Verifiable

        Install-Dirk -Path $TestPath

        It "Should set env:DirkRoot" {
            $env:DirkRoot | Should -Be $TestPath
        }

        Assert-VerifiableMock
    }
}