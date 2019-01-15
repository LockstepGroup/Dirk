#requires -Modules VMware.VimAutomation.Core
#requires -Modules VMware.VimAutomation.Common

# Output type for this Check
$OutputType = $null

# Create credential object
$DeviceUsername = $InputConfig.Global.UserName
$DevicePassword = ConvertTo-SecureString $InputConfig.Global.Password -Key $DirkConfig.AesKey
$DeviceCredential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $DeviceUsername, $DevicePassword

# Setup connection parameters
$VSphereConnectionParameters = @{}
$VSphereConnectionParameters.Server = $DeviceConfig.Hostname
$VSphereConnectionParameters.Port = 443
$VSphereConnectionParameters.Protocol = 'https'
$VSphereConnectionParameters.Force = $true
$VSphereConnectionParameters.Credential = $DeviceCredential

Set-PowerCLIConfiguration -DefaultVIServerMode Multiple -InvalidCertificateAction Ignore -ParticipateInCeip $false -DisplayDeprecationWarnings $false -Scope Session -Confirm:$false | Out-Null

# Connect and get info we'll use later on
$Connection = Connect-VIServer @VSphereConnectionParameters -Verbose:$false
$EsxHosts = Get-VmHost -Verbose:$false
