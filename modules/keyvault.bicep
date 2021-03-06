//deploy key vault, blob container and storage account SAS token. The sas token is stored in the key vault 

param environmentType string
param prefix string
param storageaccountid string
param tags object
param objectId string

//param todaydate string = utcNow()

@description('The permissions that the SAS will contain')
param accountSasProperties object = {
  signedServices : 'b'
  signedPermission: 'rwdlacup'
  signedExpiry: '2021-12-29T00:00:01Z'
  signedResourceTypes: 'sco'
}

var keyvaultname = (environmentType == 'prod') ? '${toLower(prefix)}${uniqueString(resourceGroup().id)}' : '${toLower(prefix)}${uniqueString(resourceGroup().id)}'

//keyvault that will hold the secret(sas token)
resource keyvault 'Microsoft.KeyVault/vaults@2021-06-01-preview' = {
  name: keyvaultname
  location: resourceGroup().location
  tags: tags
  properties: {
    enabledForDeployment: true
    enabledForTemplateDeployment: true
    enabledForDiskEncryption: true
    tenantId: subscription().tenantId
    softDeleteRetentionInDays: 7
    accessPolicies: [
      {
        objectId:objectId
        tenantId:subscription().tenantId
        permissions: {
          secrets: [
            'list'
            'get'
          ]
        }
      }
    ]
    sku: {
      name: 'standard'
      family: 'A'
    }
  }
}

resource storageSaSToken 'Microsoft.KeyVault/vaults/secrets@2021-06-01-preview' = {
  parent: keyvault
  name: 'StorageSaSToken'
  properties: {
    value: listAccountSas(storageaccountid,'2021-04-01',accountSasProperties).accountSasToken
  }
}

output keyvaultname string = keyvault.name
output sastokenname string = storageSaSToken.name
