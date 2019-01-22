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

    switch -Regex (Get-OsVersion) {
        'MacOS' {
            Mock sudo { return $true } -Verifiable
            $TestPath = Join-Path $env:TMPDIR -ChildPath "Dirk"
        }
        'Windows' {
            Mock Invoke-ElevatedProcess { return $true } -Verifiable
            $TestPath = Join-Path $env:TEMP -ChildPath "Dirk"
        }
    }
    #$TestPath = Join-Path $env:TMPDIR -ChildPath "Dirk"
    Describe "Install-Dirk to Path: $TestPath" {
        $env:DirkRoot = $null

        $ToddPath = Join-Path -Path $TestPath -ChildPath 'Todd'
        if (Test-Path $ToddPath) {
            Remove-Item -Path $ToddPath -Force
        }
        Mock Get-GithubRepo { New-Item -Path (Join-Path -Path $TestPath -ChildPath 'Todd') -ItemType Directory } -Verifiable
        Mock Get-Content { return @('$env:DirkRoot = "c:\lockstep"') } -Verifiable

        Install-Dirk -Path $TestPath -Force

        It "Should set env:DirkRoot" {
            $env:DirkRoot | Should -Be $TestPath
        }

        Assert-VerifiableMock
    }
}