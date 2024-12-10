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

#disable-next-line outputs-should-not-contain-secrets
var credentials = containerRegistry.listCredentials()
#disable-next-line outputs-should-not-contain-secrets
output adminUsername string = credentials.username
#disable-next-line outputs-should-not-contain-secrets
output adminPassword string = credentials.passwords[0].value
