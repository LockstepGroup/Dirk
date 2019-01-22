function Install-Dirk {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $false, Position = 0)]
        [string]$Path = 'c:\Lockstep',

        [Parameter(ParameterSetName = "Credential", Mandatory = $false)]
        [System.Management.Automation.PSCredential]
        [System.Management.Automation.Credential()]
        $Credential = $global:GithubCredential
    )

    BEGIN {
        $VerbosePrefix = "Install-Dirk:"
    }

    PROCESS {

        if (Test-Path $Path) {
            Write-Verbose "$VerbosePrefix Path exists: $Path"
        } else {
            Write-Verbose "$VerbosePrefix Path does not exist, creating: $Path"
            New-Item -Path $Path -ItemType Directory | Out-Null
        }

        $ResolvedPath = (Resolve-Path -Path $Path).Path


        ###########################################################################
        # Setup Enviroment Variable

        # set for current environment
        Write-Verbose "$VerbosePrefix setting `$env:DirkRoot to $ResolvedPath"
        $env:DirkRoot = $ResolvedPath

        # set permanently
        $LineToAdd = '$env:DirkRoot = "' + ($ResolvedPath) + '"'
        switch -Regex (Get-OsVersion) {
            'MacOS' {
                Write-Verbose "$VerbosePrefix OS: MacOS: Adding `$env:DirkRoot to `$profile.AllUsersAllHosts"
                Write-Output $LineToAdd | sudo tee -a $profile.AllUsersAllHosts > /dev/null
            }
            'Windows' {
                Write-Verbose "$VerbosePrefix OS: Windows: Adding `$env:DirkRoot to `$profile.AllUsersAllHosts"
                $Command = "Add-Content -Path `$profile.AllUsersAllHosts -Value '$LineToAdd'"
                $Bytes = [System.Text.Encoding]::Unicode.GetBytes($Command)
                $EncodedCommand = [Convert]::ToBase64String($Bytes)
                Invoke-ElevatedProcess -Arguments "-EncodedCommand $encodedCommand" | Out-Null
            }
        }


        ###########################################################################
        # Download repo to desired path


        Get-GithubRepo -Owner 'LockstepGroup' -Repository 'Todd' -TargetPath $ResolvedPath -Credential $Credential

    }

    END {
    }
}