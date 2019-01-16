try {
    Add-PSSnapin -Name 'Citrix.Broker.Admin.V2'
} catch {
    Throw "Citrix.Broker.Admin.V2 PSSnapin not found. This Check can only run on traditional Window PowerShell."
}

$TableData = Get-BrokerSession -MaxRecordCount 1500 -AdminAddres $DeviceConfig.Hostname