try {
    Get-PSSnapin -Registered -Name 'Citrix.Broker.Admin.V2'
} catch {
    Throw "Citrix.Broker.Admin.V2 PSSnapin not found."
}

$TableData = Get-BrokerSession -MaxRecordCount 1500 -AdminAddres $DeviceConfig.Hostname