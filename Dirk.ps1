#requires -module CorkScrew
[CmdletBinding(SupportsShouldProcess = $True)]
Param ()

# Setup Paths
$ScriptPath = $MyInvocation.MyCommand.Path | Split-Path
$LogFile = Join-Path -Path $ScriptPath -ChildPath "$(Get-Date -Format `"yyyyMMdd-HHmm`")-ltgreport.log"
$InputsPath = Join-Path -Path $ScriptPath -ChildPath "Inputs"
$GlobalConfigPath = Join-Path -Path $ScriptPath -ChildPath 'config.json'
$TsPath = Join-Path -Path $ScriptPath -ChildPath "ts.xml"
$OutputsPath = Join-Path -Path $ScriptPath -ChildPath "Outputs"

# Inputs and Outputs
$Inputs = Get-ChildItem -Path $InputsPath
$Outputs = Get-ChildItem -Path $OutputsPath

# Load main config
$DirkConfig = Get-CsConfiguration -Path $GlobalConfigPath

try {
    # loop through all the Input folders
    :inputs foreach ($in in $Inputs) {
        log 1 "Starting Input: $($in.Name)" -LogHeader
        $LogPrefixInput = "$($in.Name):"
        $LogPrefix = $LogPrefixInput
        $InputPath = $in.FullName

        $InputConfigPath = Join-Path $InputPath -ChildPath 'config.json'
        if (Test-Path $InputConfigPath -Verbose:$false) {
            log 3 "$LogPrefix config file found"
            $InputConfig = Get-CsConfiguration -Path $InputConfigPath -Verbose:$false
            if ($InputConfig.Global.Disable) {
                log 1 "$LogPrefix input disabled, skipping..."
                continue inputs
            }
        } else {
            log 1 "$LogPrefix config file not found, skipping..."
            continue inputs
        }

        :device foreach ($device in $InputConfig.Device) {
            $DeviceConfig = $device

            $LogPrefixDevice = $DeviceConfig.Hostname
            $LogPrefix = "$LogPrefixInput $LogPrefixDevice`:"

            if ($DeviceConfig.Disable) {
                log 1 "$LogPrefix device disabled, skipping..."
                continue device
            } else {
                log 1 "$LogPrefix starting device $($DeviceConfig.Hostname)"
            }

            $Checks = Get-ChildItem -Path $InputPath -Filter *.ps1

            # loop through all the checks in the Input folder
            :check foreach ($check in $Checks) {
                $CheckIdRx = [regex] '^\d+'
                $CheckId = ($CheckIdRx.Match($check.Name).Value)
                $CheckConfig = $InputConfig.Checks.$CheckId

                log 2 "$LogPrefix starting check: $($check.Name)"
                $LogPrefix = "$LogPrefixInput $LogPrefixDevice`: $CheckId`:"
                if ($CheckConfig.Disable) {
                    log 1 "$LogPrefix check disabled, skipping..."
                    continue check
                }
                . $check.FullName
                log 2 "$LogPrefix check complete"
            }

            # Process Output

            if ($CheckConfig.OutputType) {
                $OutputType = $CheckConfig.OutputType
                $OutputLookup = $Outputs | Where-Object { $_.Name -eq $OutputType}
                $OutputConfigPath = Join-Path -Path $OutputLookup.FullName -ChildPath 'config.json'
                $OutputConfig = Get-CsConfiguration -Path $OutputConfigPath
                if ($null -eq $OutputLookup) {
                    log 1 "$LogPrefix output not found: $OutputType, skipping..."
                    continue check
                } else {
                    $LogPrefix = $LogPrefix + ' ' + $OutputType + ':'
                }

                $OutputScripts = Get-ChildItem -Path $OutputLookup.FullName -Filter *.ps1
                :output foreach ($out in $OutputScripts) {
                    log 2 "$LogPrefix running output"
                    . $out.FullName
                    log 2 "$LogPrefix output complete"
                }
            }

        }
    }
} catch {
    throw $PSItem
}