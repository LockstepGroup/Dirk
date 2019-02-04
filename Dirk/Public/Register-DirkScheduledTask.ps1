function Register-DirkScheduledTask {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        [System.Management.Automation.Credential()]
        $ScheduledTaskCredential,

        [Parameter(Mandatory = $false)]
        [string]$JobName,

        [Parameter(ParameterSetName = "daily", Mandatory = $false)]
        [switch]$Daily,

        [Parameter(ParameterSetName = "hourly", Mandatory = $false)]
        [switch]$Hourly,

        [Parameter(ParameterSetName = "5min", Mandatory = $false)]
        [switch]$Every5Minutes
    )

    BEGIN {
        $VerbosePrefix = "Install-Dirk:"
    }

    PROCESS {
        ###########################################################################
        # Setup Scheduled Task
        # TODO: make this compatible for cron?

        # Verify $env:DirkRoot
        try {
            $ToddPath = Join-Path -Path $env:DirkRoot -ChildPath 'Todd'
            $ToddPathExists = Test-Path -Path $ToddPath
        } catch {
            $PSCmdlet.ThrowTerminatingError([HelperProcessError]::throwCustomError(1001, $env:DirkRoot))
        }

        $ActionParams = @{}
        $ActionParams.Execute = 'C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe'
        $ActionParams.Argument = '-ExecutionPolicy Bypass -Command "& ' + (Join-Path -Path $ToddPath -ChildPath "Todd.ps1")
        if ($JobName) {
            $ActionParams.Argument += " -JobName $JobName"
        }
        $ActionParams.Argument += '"'

        $Action = New-ScheduledTaskAction @ActionParams

        $TriggerParams = @{}
        switch ($PsCmdlet.ParameterSetName) {
            'daily' {
                $TriggerParams.Daily = $true
                $TriggerParams.At = '1am'
            }
            'hourly' {
                $TriggerParams.Once = $true
                $TriggerParams.RepetitionInterval = New-TimeSpan -Hours 1
                $TriggerParams.RepetitionDuration = ([System.TimeSpan]::MaxValue)
                $CurrentDateTime = Get-Date
                $TriggerParams.At = $CurrentDateTime.AddMinutes( - ($CurrentDateTime.Minute % 60) + 60).AddSeconds( - ($CurrentDateTime.Second % 60))
            }
            '5min' {
                $TriggerParams.Once = $true
                $TriggerParams.RepetitionInterval = New-TimeSpan -Minutes 5
                $TriggerParams.RepetitionDuration = ([System.TimeSpan]::MaxValue)
                $CurrentDateTime = Get-Date
                $TriggerParams.At = $CurrentDateTime.AddMinutes( - ($CurrentDateTime.Minute % 5) + 5).AddSeconds( - ($CurrentDateTime.Second % 60))
            }
        }

        $Trigger = New-ScheduledTaskTrigger @TriggerParams

        $TaskParams = @{}
        $TaskParams.Action = $Action
        $TaskParams.Trigger = $Trigger
        $Task = New-ScheduledTask @TaskParams

        $RegisterParams = @{}
        $RegisterParams.TaskName = 'Dirk'
        $RegisterParams.InputObject = $Task
        $RegisterParams.User = $ScheduledTaskCredential.UserName
        $RegisterParams.Password = $ScheduledTaskCredential.GetNetworkCredential().Password
        Register-ScheduledTask @RegisterParams
    }

    END {
    }
}