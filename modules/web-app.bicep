param webAppName string
param location string = resourceGroup().location
param appServicePlanId string
param siteConfig object

@secure()
param dockerRegistryServerUrl string
@secure()
param dockerRegistryServerUserName string
@secure()
param dockerRegistryServerPassword string
@secure()
param dockerRegistryServerPassword1 string
param appSettingsKeyValuePairs object

var dockerAppSettings = {
  DOCKER_REGISTRY_SERVER_URL: dockerRegistryServerUrl
  DOCKER_REGISTRY_SERVER_USERNAME: dockerRegistryServerUserName
  DOCKER_REGISTRY_SERVER_PASSWORD: dockerRegistryServerPassword
  DOCKER_REGISTRY_SERVER_PASSWORD1: dockerRegistryServerPassword1
}

resource webApp 'Microsoft.Web/sites@2022-03-01' = {
  name: webAppName
  location: location
  kind: 'app'
  properties: {
    serverFarmId: appServicePlanId
    siteConfig: {
      linuxFxVersion: siteConfig.linuxFxVersion
      appCommandLine: siteConfig.appCommandLine
      appSettings: [
        for key in objectKeys(union(appSettingsKeyValuePairs, dockerAppSettings)): {
          name: key
          value: union(appSettingsKeyValuePairs, dockerAppSettings)[key]
        }
      ]
    }
  }
}
