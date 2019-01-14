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
$StorageContext = New-AzureStorageContext -StorageAccountName $StorageCredential.UserName -StorageAccountKey $StorageCredential.GetNetworkCredential().Password

############################################################################
#Specify which container the blob is in.
$ContainerName = $OutputConfig.ContainerName 

############################################################################
#To create a new container with public access to the blobs
#New-AzureStorageContainer -Name $ContainerName -Context $ctx -Permission Blob

############################################################################
#Point to local directory for the file to pass to Azure Blob
$localFileDirectory = "REDACTED"


############################################################################
#Push to azure blob
$BlobName = "REDACTED" 
$localFile = $localFileDirectory + $BlobName 
Set-AzureStorageBlobContent -File $localFile -Container $ContainerName -Blob $BlobName -Context $ctx
