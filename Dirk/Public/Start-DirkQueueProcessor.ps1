function Start-DirkQueueProcessor {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $true, Position = 0)]
        $ToddConfig
    )

    BEGIN {
        $VerbosePrefix = "Start-DirkQueueProcessor:"
    }

    PROCESS {
        # Initial Dirk Queue object
        $Global:DirkQueue = [System.Collections.Queue]::Synchronized(@())

        # Dirk Settings
        $Global:DirkQueueSettings = [hashtable]::Synchronized(@{})
        $Global:DirkQueueSettings.Enabled = $True
        $Global:DirkQueueSettings.Host = $host
        $Global:DirkQueueSettings.Verbose = $false
        $Global:DirkQueueSettings.ToddConfig = $ToddConfig

        # Create Runspace
        $Runspace = [runspacefactory]::CreateRunspace()
        $Runspace.Open()

        # Add synchronized variables to Runspace
        $Runspace.SessionStateProxy.SetVariable('DirkQueueSettings', $Global:DirkQueueSettings)
        $Runspace.SessionStateProxy.SetVariable('DirkQueue', $Global:DirkQueue)

        # Setup PowerShell instance
        $Global:DirkQueuePowerShell = [powershell]::Create()
        $Global:DirkQueuePowerShell.Runspace = $Runspace

        # Add Script to PowerShell instance
        $Global:DirkQueuePowerShell.AddScript( {
                While ($DirkQueueSettings.Enabled) {
                    # Dequeue an item to process
                    $CurrentEntry = $DirkQueue.Dequeue()
                    if ($CurrentEntry) {
                        $InputConfig = $CurrentEntry.InputConfig
                        $CheckConfig = $CurrentEntry.CheckConfig


                        <#
                        if ($DirkQueueSettings.Verbose) {
                            $DirkQueueSettings.host.ui.WriteVerboseLine($VerboseMessage)
                        } #>
                    }
                    $CurrentEntry = $null
                }
            }) | Out-Null

        # Start Runspace
        $Global:DirkQueueRunspace = $Global:CsLoggerPowerShell.BeginInvoke()
    }

    END {
    }
}