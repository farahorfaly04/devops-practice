param name string
param location string = resourceGroup().location

param keyVaultResourceId string
@secure()
param keyVaultSecretNameAdminUsername string
@secure()
param keyVaultSecretNameAdminPassword0 string
@secure()
param keyVaultSecretNameAdminPassword1 string

resource containerRegistry 'Microsoft.ContainerRegistry/registries@2023-01-01-preview' = {
  name: name
  location: location
  sku: {
    name: 'Basic'
  }
  properties: {
    adminUserEnabled: true
  }
}

resource adminCredentialsKeyVault 'Microsoft.KeyVault/vaults@2021-10-01' existing = {
  name: last(split(keyVaultResourceId, '/'))
}

// Create a secret to store the container registry admin username
resource secretAdminUserName 'Microsoft.KeyVault/vaults/secrets@2023-02-01' = {
  name: keyVaultSecretNameAdminUsername // Use parameter for flexibility
  parent: adminCredentialsKeyVault
  properties: {
    value: containerRegistry.listCredentials().username
  }
}

// Create a secret to store the container registry admin password
resource secretAdminUserPassword0 'Microsoft.KeyVault/vaults/secrets@2023-02-01' = {
  name: keyVaultSecretNameAdminPassword0 // Use parameter for flexibility
  parent: adminCredentialsKeyVault
  properties: {
    value: containerRegistry.listCredentials().passwords[0].value
  }
}

// Create a secret to store the container registry admin password
resource secretAdminUserPassword1 'Microsoft.KeyVault/vaults/secrets@2023-02-01' = {
  name: keyVaultSecretNameAdminPassword1 // Use parameter for flexibility
  parent: adminCredentialsKeyVault
  properties: {
    value: containerRegistry.listCredentials().passwords[1].value
  }
}
