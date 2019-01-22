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



        Write-Verbose "$VerbosePrefix setting `$env:DirkRoot to $Path"
        $ResolvedPath = $Path

        ###########################################################################
        # Setup Enviroment Variable

        # set for current environment
        $env:DirkRoot = $ResolvedPath

        # set permanently
        $LineToAdd = '$env:DirkRoot = "' + ($ResolvedPath) + '"' + "'"
        switch -Regex (Get-OsVersion) {
            'MacOS' {
                Write-Output $LineToAdd | sudo tee -a $profile.AllUsersAllHosts > /dev/null
            }
            'Windows' {
                $Command = "Add-Content -Path `$profile.AllUsersAllHosts -Value '$LineToAdd'"
                $Bytes = [System.Text.Encoding]::Unicode.GetBytes($Command)
                $EncodedCommand = [Convert]::ToBase64String($Bytes)
                Invoke-ElevatedProcess -Arguments "-EncodedCommand $encodedCommand" | Out-Null
            }
        }


        ###########################################################################
        # Download repo to desired path

        New-Item -Path $ResolvedPath -ItemType Directory | Out-Null
        Get-GithubRepo -Owner 'LockstepGroup' -Repository 'Todd' -TargetPath $ResolvedPath -Credential $Credential

    }

    END {
    }
}