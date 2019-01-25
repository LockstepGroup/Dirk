if (-not $ENV:BHProjectPath) {
    Set-BuildEnvironment -Path $PSScriptRoot\..
}
Remove-Module $ENV:BHProjectName -ErrorAction SilentlyContinue
Import-Module (Join-Path $ENV:BHProjectPath $ENV:BHProjectName) -Force


InModuleScope $ENV:BHProjectName {
    # Setup creds to use for cmdlets
    $TestAesKey = @(
        226,
        44,
        221,
        255,
        218,
        191,
        19,
        253,
        10,
        127,
        225,
        196,
        43,
        26,
        228,
        72,
        101,
        187,
        186,
        142,
        250,
        64,
        230,
        188,
        190,
        47,
        64,
        249,
        195,
        11,
        230,
        193
    )
    $TestUserName = "testuser"
    $TestPassword = New-EncryptedString -PlainTextString 'testpassword' -AesKey $TestAesKey
    $TestPassword = ConvertTo-SecureString $TestPassword -Key $TestAesKey
    $TestCredential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $TestUserName, $TestPassword

    $PSVersion = $PSVersionTable.PSVersion.Major
    $ProjectRoot = $ENV:BHProjectPath

    $Verbose = @{}
    if ($ENV:BHBranchName -notlike "master" -or $env:BHCommitMessage -match "!verbose") {
        $Verbose.add("Verbose", $True)
    }

    switch -Regex (Get-OsVersion) {
        'MacOS' {
            Mock sudo { return $true } -Verifiable

            #############################################################
            # Dummy fuctions for scheduled tasks, these have to be defined somewhere for Mock to work
            function New-ScheduledTaskAction () {}
            function New-ScheduledTaskTrigger () {}
            function New-ScheduledTask () {}
            function Register-ScheduledTask () {}
            # Mocks for scheduled tasks that don't exist in MacOS
            Mock New-ScheduledTaskAction { return $true } -Verifiable
            Mock New-ScheduledTaskTrigger { return $true } -Verifiable
            Mock New-ScheduledTask { return $true } -Verifiable
            Mock Register-ScheduledTask { return $true } -Verifiable
            $TestPath = Join-Path $env:TMPDIR -ChildPath "Dirk"
        }
        'Windows' {
            Mock Invoke-ElevatedProcess { return $true } -Verifiable
            Mock Register-ScheduledTask { return $true } -Verifiable
            $TestPath = Join-Path $env:TEMP -ChildPath "Dirk"
        }
    }
    #$TestPath = Join-Path $env:TMPDIR -ChildPath "Dirk"
    Describe "Install-Dirk to Path: $TestPath" {
        $env:DirkRoot = $null
        $profile = @{AllUsersAllHosts = 'c:\Projects\dirk\profile.ps1'}

        $ToddPath = Join-Path -Path $TestPath -ChildPath 'Todd'
        if (Test-Path $ToddPath) {
            Remove-Item -Path $ToddPath -Force
        }
        Mock Get-GithubRepo { New-Item -Path (Join-Path -Path $TestPath -ChildPath 'Todd') -ItemType Directory } -Verifiable
        Mock Get-Content { return @('$env:DirkRoot = "c:\lockstep"') } -Verifiable

        Install-Dirk -Path $TestPath -Force -GithubCredential $TestCredential -ScheduledTaskCredential $TestCredential

        It "Should set env:DirkRoot" {
            $env:DirkRoot | Should -Be $TestPath
        }

        Assert-VerifiableMock
    }
}