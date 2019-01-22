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

        $env:DirkRoot = $null

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

        Remove-Item (Join-Path -Path $TestPath -ChildPath 'Todd') -Force
        Mock Get-GithubRepo { New-Item -Path (Join-Path -Path $TestPath -ChildPath 'Todd') -ItemType Directory } -Verifiable
        #Mock New-Item { return $true } -Verifiable

        Install-Dirk -Path $TestPath -Force

        It "Should set env:DirkRoot" {
            $env:DirkRoot | Should -Be $TestPath
        }

        Assert-VerifiableMock
    }
}