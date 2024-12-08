param name string
param location string = resourceGroup().location

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

var credentials = containerRegistry.listCredentials()
output adminUsername string = credentials.username
output adminPassword string = credentials.passwords[0].value
