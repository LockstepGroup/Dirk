try {
    Add-PSSnapin -Name 'Citrix.Broker.Admin.V2' -Verbose:$false
} catch {
    Throw "Citrix.Broker.Admin.V2 PSSnapin not found. This Check can only run on traditional Window PowerShell."
}

$TableData = Get-BrokerSession -MaxRecordCount 1500 -AdminAddres $DeviceConfig.Hostname -Verbose:$false
$TableData = $TableData | Select-Object `
@{n = 'ApplicationsInUse'; e = {$_.ApplicationsInUse -join ','}}, `
@{n = 'SmartAccessTags'; e = {$_.SmartAccessTags -join ','}}, `
    * -ExcludeProperty ApplicationsInUse, SmartAccessTags