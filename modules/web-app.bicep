param staticWebAppName string
param location string = resourceGroup().location
param appServicePlanId string

param dockerRegistryName string
param dockerRegistryServerUserName string
param dockerRegistryServerPassword string
param dockerRegistryImageName string
param dockerRegistryImageVersion string = 'latest'

param appSettings array = []

var dockerAppSettings = [
  { name: 'DOCKER_REGISTRY_SERVER_URL', value: 'https://${dockerRegistryName}.azurecr.io' }
  { name: 'DOCKER_REGISTRY_SERVER_USERNAME', value: dockerRegistryServerUserName }
  { name: 'DOCKER_REGISTRY_SERVER_PASSWORD', value: dockerRegistryServerPassword }
  { name: 'WEBSITES_ENABLE_APP_SERVICE_STORAGE', value: 'false'}
]

resource staticWebApp 'Microsoft.Web/sites@2022-03-01' = {
  name: staticWebAppName
  location: location
  kind: 'app'
  properties: {
    serverFarmId: appServicePlanId
    siteConfig: {
      linuxFxVersion: 'DOCKER|${dockerRegistryName}.azurecr.io/${dockerRegistryImageName}:${dockerRegistryImageVersion}'
      appCommandLine: ''
      appSettings: union(appSettings, dockerAppSettings)
  
    }
  }
}
