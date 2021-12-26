// main bicep file
// accepting inputs for what type of environment you are creating and a prefix value that all resources will inherit

targetScope = 'subscription'

@allowed([
  'prod'
  'test'
])
@description('type of environment to deploy')
param environmentType string

@minLength(3)
@maxLength(11)
param prefix string

@description('Time and date for tracking last deploy time')
param basetime string = utcNow('yyyy-MM-dd')

@description('tags related to this deployment')
var tags = {
  'environment': environmentType
  'last-provisioned': basetime
  'costcenter': 'CEO'
  'owner': 'team-plattform'
}

var location = deployment().location // set same location as the deployment

// deploy resource group
resource rg 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: '${prefix}-${environmentType}-rg'
  location: location
  tags: tags
}

// deploy storage account to resource group
module BlobService 'modules/storageAccount.bicep' = {
  name: 'storage'
  scope: rg
  params: {
    environmentType: environmentType
    prefix:prefix
    tags: tags
  }
}

//deploy keyvault, blob container and SAS token
module keyvault 'modules/keyvault.bicep' = {
  scope: rg
  name: 'keyvault'
  params: {
    environmentType: environmentType
    prefix: prefix
    storageaccountid: BlobService.outputs.storageaccountid
    tags: tags
  }
}

output keyvaultname string = keyvault.outputs.keyvaultname
output containerurl string = BlobService.outputs.containerurl
output sastokenname string = keyvault.outputs.sastokenname
