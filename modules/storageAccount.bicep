// Deploy storage account and blob container

param environmentType string
param prefix string
param tags object

var location = resourceGroup().location
var storageAccountName = (environmentType == 'prod') ? '${take('${toLower(prefix)}prod${uniqueString(resourceGroup().id)}',24)}' : '${take('${toLower(prefix)}test${uniqueString(resourceGroup().id)}',24)}'
var storageAccountSkuName = (environmentType == 'prod') ? 'Standard_GRS' : 'Standard_LRS'
var allowBlobPublicAccess = (environmentType == 'prod') ? false : true
var containername = (environmentType == 'prod') ? '${toLower(prefix)}-prod-${uniqueString(resourceGroup().id)}' : '${toLower(prefix)}-test-${uniqueString(resourceGroup().id)}'

resource storage 'Microsoft.Storage/storageAccounts@2021-04-01' = {
  name: storageAccountName
  location: location
  sku: {
    name: storageAccountSkuName
  }
  kind: 'StorageV2'
  tags: tags
  properties: {
    supportsHttpsTrafficOnly: true
    allowBlobPublicAccess: allowBlobPublicAccess
  } 
}

resource blob 'Microsoft.Storage/storageAccounts/blobServices@2021-06-01' = {
  parent:storage
  name: 'default'
}

resource container 'Microsoft.Storage/storageAccounts/blobServices/containers@2021-06-01' = {
  parent:blob
  name: containername
}

output storageaccountid string = storage.id
output blobendpoint string = storage.properties.primaryEndpoints.blob
output containerurl string = '${storage.properties.primaryEndpoints.blob}${container.name}?'



