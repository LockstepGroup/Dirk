#requires -module Az

#To push csv to Azure blob storage

############################################################################
#Create parameters for the account name and account key
$StorageAccountName = $OutputConfig.StorageAccountName
$StorageAccountKey = ConvertTo-SecureString $OutputConfig.StorageAccountKey -Key $DirkConfig.AesKey
$StorageCredential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $StorageAccountName, $StorageAccountKey

############################################################################
#When you access a storage account from PowerShell, you need to use what’s called a context.
#You create this using the storage account name and key, and pass it in with each PowerShell command so it knows which account to use when running the command.
$StorageContext = New-AzStorageContext -StorageAccountName $StorageCredential.UserName -StorageAccountKey $StorageCredential.GetNetworkCredential().Password -Verbose:$false

############################################################################
# Specify which container the blob is in.
# ContainerName Rules
# Container names must start with a letter or number, and can contain only letters, numbers, and the dash (-) character.
# Every dash (-) character must be immediately preceded and followed by a letter or number; consecutive dashes are not permitted in container names.
# All letters in a container name must be lowercase.
# Container names must be from 3 through 63 characters long.

if ($CheckConfig.ContainerName) {
    $ContainerName = $CheckConfig.ContainerName
} else {
    $ContainerName = $DeviceConfig.Hostname
}

# Sanitize name
$ContainerName = $ContainerName.ToLower()
$ContainerName = $ContainerName -replace '\.', '-'

############################################################################
#To create a new container with public access to the blobs
#New-AzureStorageContainer -Name $ContainerName -Context $ctx -Permission Blob

############################################################################
# Point to local directory for the file to pass to Azure Blob
if ($env:TMP) {
    $LocalDirectory = $env:TMP
} else {
    $LocalDirectory = $env:TMPDIR
}
$LocalFileName = $in.Name + '-' + $checkid + '-' + (Get-Date -Format "yyyy-MM-dd.HH:mm:ss.fffff").ToString() + '.csv'

$LocalFile = Join-Path -Path $LocalDirectory -ChildPath $LocalFileName

############################################################################
# Create Csv
$TableData | Export-Csv -Path $LocalFile -NoTypeInformation

############################################################################
#Push to azure blob
$BlobName = $LocalFileName
Set-AzStorageBlobContent -File $LocalFile -Container $ContainerName -Blob $BlobName -Context $StorageContext -Verbose:$false

############################################################################
# Remove Csv File
Remove-Item -Path $LocalFile -Force