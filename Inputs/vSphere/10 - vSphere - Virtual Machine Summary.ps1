$vCenterStatusMap = @{}
$vCenterStatusMap.green = "Normal"
$vCenterStatusMap.yellow = "Warning"
$vCenterStatusMap.red = "Alert"
$vCenterStatusMap.gray = "Unknown"

$TableData = Get-VM | Select-Object `
@{ Name = "Timestamp"; Expression = { Get-Date } },
Name,
@{ Name = "State"; Expression = { $_.PowerState } },
@{ Name = "Status"; Expression = { $vCenterStatusMap[$_.ExtensionData.Summary.OverallStatus.ToString()] } },
@{ Name = "Host"; Expression = { $_.VMHost } },
@{ Name = "SpaceProvisionedGB"; Expression = { [int]$_.ProvisionedSpaceGB } },
@{ Name = "SpaceUsedGB"; Expression = { [int]$_.UsedSpaceGB } },
@{ Name = "HostCPUMHz"; Expression = { $_.ExtensionData.Summary.QuickStats.OverallCpuUsage } },
@{ Name = "HostMemMB"; Expression = { $_.ExtensionData.Summary.QuickStats.HostMemoryUsage } },
@{ Name = "GuestMemPercent"; Expression = { ($_.ExtensionData.Summary.QuickStats.GuestMemoryUsage / $_.MemoryMB) * 100 } },
@{ Name = "GuestOS"; Expression = { $_.Guest.OSFullName } },
@{ Name = "MemorySizeMB"; Expression = { $_.MemoryMB } },
@{ Name = "CPUCount"; Expression = { $_.NumCpu } },
@{ Name = "IPAddress"; Expression = { $_.Guest.IPAddress[0] } },
@{ Name = "IPAddressDecimal"; Expression = { ConvertTo-DecimalIP $_.Guest.IPAddress[0] } },
@{ Name = "DNSName"; Expression = { $_.Guest.HostName } }

$NullableFields = @()
$NullableFields += 'GuestOS'
$NullableFields += 'IPAddress'
$NullableFields += 'IPAddressDecimal'
$NullableFields += 'DNSName'
$NullableFields += 'Host'