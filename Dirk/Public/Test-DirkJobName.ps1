function Test-DirkJobName {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $true, Position = 0)]
        [string]$ToddJobName,

        [Parameter(Mandatory = $true, Position = 1)]
        [string]$ConfigJobName
    )

    BEGIN {
        $VerbosePrefix = "Test-DirkJobName:"
    }

    PROCESS {
        if ($ConfigJobName -eq 'all') {
            $ReturnObject = $true
        } elseif ($ToddJobName -match $ConfigJobName) {
            $ReturnObject = $true
        } else {
            $ReturnObject = $false
        }
    }

    END {
        $ReturnObject
    }
}