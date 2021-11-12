function Test-DirkJobName {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $true, Position = 0)]
        [string]$ToddJobName,

        [Parameter(Mandatory = $true, Position = 1)]
        [hashtable]$Config
    )

    BEGIN {
        $VerbosePrefix = "Test-DirkJobName:"
    }

    PROCESS {
        if ($Config.JobName) {
            if ($Config.JobName -eq 'all') {
                $ReturnObject = $true
            } elseif ($ToddJobName -match $Config.JobName) {
                $ReturnObject = $true
            } else {
                $ReturnObject = $false
            }
        } else {
            $ReturnObject = $false
        }
    }

    END {
        $ReturnObject
    }
}