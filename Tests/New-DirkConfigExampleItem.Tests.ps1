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

    Describe "New-DirkConfigExampleItem" {

        $NewExampleItemParams = @{
            RequiredType = 'int'
            Prompt       = 'This is a prompt'
            Example      = '999'
            Required     = $true
        }

        $NewExampleItem = New-DirkConfigExampleItem @NewExampleItemParams

        It "RequiredType should be correct" {
            $NewExampleItem.RequiredType | Should -Be $NewExampleItemParams.RequiredType
        }
        It "Prompt should be correct" {
            $NewExampleItem.Prompt | Should -Be $NewExampleItemParams.Prompt
        }
        It "Example should be correct" {
            $NewExampleItem.Example | Should -Be $NewExampleItemParams.Example
        }
        It "Required should be correct" {
            $NewExampleItem.Required | Should -Be $NewExampleItemParams.Required
        }

        Assert-VerifiableMock
    }
}