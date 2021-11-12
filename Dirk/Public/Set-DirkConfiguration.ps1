function Set-DirkConfiguration {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $false, Position = 0)]
        [string]$Path = (Join-Path -Path $env:DirkRoot -ChildPath Todd),

        [Parameter(Mandatory = $false)]
        [switch]$Recurse
    )

    BEGIN {
        $VerbosePrefix = "Set-DirkConfiguration:"
    }

    PROCESS {

        if (Test-Path $Path) {
            Write-Verbose "$VerbosePrefix Path exists: $Path"
        } else {
            try {
                Throw
            } catch {
                # TODO: need to account for if Path is not set to $env:DirkRoot as well.
                $PSCmdlet.ThrowTerminatingError([HelperProcessError]::throwCustomError(1001, $Path))
            }
        }

        $ResolvedPath = (Resolve-Path -Path $Path).Path


        $NewConfig = @{}

        ###########################################################################
        # ingest config example files in given Path(s)
        if ($Recurse) {
            Throw "Not Supported Yet"
            # TODO: make this work
            $ConfigExampleFiles = Get-ChildItem -Path $ResolvedPath -Recurse -Filter '*.example.json'
        } else {
            $ConfigExampleFiles = Get-ChildItem -Path $ResolvedPath -Recurse -Filter '*.example.json'
        }

        foreach ($configexamplefile in $ConfigExampleFiles) {
            Write-Verbose "$VerbosePrefix getting $($configexamplefile.FullName)"
            $OutputPath = Join-Path -Path (Split-Path $configexamplefile) -ChildPath 'config.json'
            $thisExample = $configExampleFile | Get-Content -Raw | ConvertFrom-Json
            $properties = $thisExample | Get-Member -MemberType NoteProperty
            foreach ($property in $properties) {
                $propertyName = $property.Name
                $element = $thisExample.$propertyName
                $prompt = $element.Prompt + ' (' + $element.Example + ')'
                $ReadFromHost = Read-Host -Prompt $prompt
                if ($ReadFromHost -eq "") {
                    if ($element.Required) {
                        # TODO: either make a valid error code for this, or a loop to ask repeatedly
                        Throw "This is a required value"
                    }
                } else {
                    switch ($element.RequiredType) {
                        'int' {
                            $NewConfig.$propertyName = [int]$ReadFromHost
                        }
                    }
                }

            }
            $NewConfig | ConvertTo-Json -Depth 5 | Out-File -FilePath $OutputPath
        }

    }

    END {
    }
}