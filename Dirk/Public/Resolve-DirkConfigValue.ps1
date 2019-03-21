function Resolve-DirkConfigValue {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $true, Position = 0)]
        [string]$Setting,

        [Parameter(Mandatory = $false)]
        [psobject]$ToddConfig = $ToddConfig,

        [Parameter(Mandatory = $false)]
        [psobject]$InputConfig = $InputConfig,

        [Parameter(Mandatory = $false)]
        [psobject]$DeviceConfig = $DeviceConfig,

        [Parameter(Mandatory = $false)]
        [psobject]$CheckConfig = $CheckConfig
    )

    BEGIN {
        $VerbosePrefix = "Resolve-DirkConfigValue:"
    }

    PROCESS {
        if ($CheckConfig.$Setting) {
            $ResolvedValue = $CheckConfig.$Setting
        } elseif ($InputConfig.Global.$Setting) {
            $ResolvedValue = $InputConfig.Global.$Setting
        } elseif ($DeviceConfig.$Setting) {
            $ResolvedValue = $DeviceConfig.$Setting
        } elseif ($CheckConfig.$Setting) {
            $ResolvedValue = $CheckConfig.$Setting
        }
    }

    END {
        $ResolvedValue
    }
}