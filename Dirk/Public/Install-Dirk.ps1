function Install-Dirk {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $false, Position = 0)]
        [string]$Path = 'c:\Lockstep',

        [Parameter(Mandatory = $false)]
        [System.Management.Automation.PSCredential]
        [System.Management.Automation.Credential()]
        $GithubCredential = $global:GithubCredential,

        [Parameter(Mandatory = $false)]
        [switch]$Force,

        [Parameter(Mandatory = $false)]
        [string]$Branch = 'master'
    )

    BEGIN {
        $VerbosePrefix = "Install-Dirk:"
    }

    PROCESS {
        if ($null -eq $GithubCredential) {
            try {
                Throw
            } catch {
                $PSCmdlet.ThrowTerminatingError([HelperProcessError]::throwCustomError(1002, "GithubCredential"))
            }
        }

        if (Test-Path $Path) {
            Write-Verbose "$VerbosePrefix Path exists: $Path"
        } else {
            Write-Verbose "$VerbosePrefix Path does not exist, creating: $Path"
            New-Item -Path $Path -ItemType Directory | Out-Null
        }

        $ResolvedPath = (Resolve-Path -Path $Path).Path

        ###########################################################################
        # Setup Enviroment Variable

        # Check to see if environment variable is already set in $profile.AllUsersAllHosts
        $LineToAdd = '$env:DirkRoot = "' + ($ResolvedPath) + '"'
        $EnvIsSet = $false
        $EnvIsSetRx = '^\$env:DirkRoot\ ?=.+'
        $EnvIsSet = Select-String -Pattern $EnvIsSetRx -Path $profile.AllUsersAllHosts
        if ($EnvIsSet -and !($Force)) {
            if ($LineToAdd -ne $EnvIsSet.Line) {
                try {
                    Throw
                } catch {
                    $PSCmdlet.ThrowTerminatingError([HelperProcessError]::throwCustomError(1000, $profile.AllUsersAllHosts))
                }
            }
        }

        # set for current environment
        Write-Verbose "$VerbosePrefix setting `$env:DirkRoot to $ResolvedPath"
        $env:DirkRoot = $ResolvedPath

        # set permanently
        if ($LineToAdd -ne $EnvIsSet.Line) {
            # only update $profile.AllUsersAllHosts if $env:DirkRoot is not already correct
            switch -Regex (Get-OsVersion) {
                'MacOS' {
                    Write-Verbose "$VerbosePrefix OS: MacOS: Adding `$env:DirkRoot to `$profile.AllUsersAllHosts"
                    if ($EnvIsSet) {
                        $FullContent = (Get-Content $profile.AllUsersAllHosts) -replace $EnvIsSetRx, $LineToAdd
                        Write-Output $FullContent | sudo tee $profile.AllUsersAllHosts > /dev/null
                    } else {
                        Write-Output $LineToAdd | sudo tee -a $profile.AllUsersAllHosts > /dev/null
                    }

                }
                'Windows' {
                    Write-Verbose "$VerbosePrefix OS: Windows: Adding `$env:DirkRoot to `$profile.AllUsersAllHosts"
                    if ($EnvIsSet) {
                        $Command = "(Get-Content `$profile.AllUsersAllHosts) -replace '$EnvIsSetRx','$LineToAdd' | Set-Content `$profile.AllUsersAllHosts"
                    } else {
                        $Command = "Add-Content -Path `$profile.AllUsersAllHosts -Value '$LineToAdd'"
                    }
                    $Bytes = [System.Text.Encoding]::Unicode.GetBytes($Command)
                    $EncodedCommand = [Convert]::ToBase64String($Bytes)
                    Invoke-ElevatedProcess -Arguments "-EncodedCommand $encodedCommand" | Out-Null
                }
            }
        }


        ###########################################################################
        # Download repo to desired path
        Get-GithubRepo -Owner 'LockstepGroup' -Repository 'Todd' -TargetPath $ResolvedPath -Credential $GithubCredential -Branch $Branch
    }

    END {
    }
}