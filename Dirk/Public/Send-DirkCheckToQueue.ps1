function Send-DirkCheckToQueue {
    [CmdletBinding()]
    Param (
    )

    BEGIN {
        $VerbosePrefix = "Send-DirkCheckToQueue:"
    }

    PROCESS {
        $global:DirkQueue.Enqueue(
            @{
                Severity    = $Severity
                Facility    = 'user'
                Application = $Application
                Message     = $Message
            }
        )
    }

    END {
    }
}