param appServicePlanName string
param location string = resourceGroup().location
param appServicePlanSku object = {
  capacity: 1
  family: 'B'
  name: 'B1'
  size: 'B1'
  tier: 'Basic'
}

param containerRegistryName string
param webAppName string
param containerRegistryImageVersion string = 'latest'
param containerRegistryImageName string
param keyVaultName string
param enableVaultForDeployment bool = true
param roleAssignments array 
param acrAdminUserNameSecretName string = 'acrAdminUserNameSecretName'
param acrAdminPassword0SecretName string = 'acrAdminPassword0SecretName'
param acrAdminPassword1SecretName string = 'acrAdminPassword1SecretName'

module keyVault './modules/key-vault.bicep' = {
  name: 'keyVaultModule'
  params: {
    name: keyVaultName
    location: location
    enableVaultForDeployment: enableVaultForDeployment
    roleAssignments: roleAssignments
    enableSoftDelete: true
  }
}

module containerRegistry 'modules/container-registry.bicep' = {
  name: containerRegistryName
  params: {
    name: containerRegistryName
    location: location
    keyVaultResourceId: keyVault.outputs.resourceId
    keyVaultSecretNameAdminUsername: acrAdminUserNameSecretName
    keyVaultSecretNameAdminPassword0: acrAdminPassword0SecretName
    keyVaultSecretNameAdminPassword1: acrAdminPassword1SecretName
  }
}

module appServicePlan 'modules/app-service-plan.bicep' = {
  name: appServicePlanName
  params: {
    name: appServicePlanName
    location: location
    sku: appServicePlanSku
  }
}

module webApp 'modules/web-app.bicep' = {
  name: webAppName
  params: {
    webAppName: webAppName
    location: location
    appServicePlanId: appServicePlan.outputs.id

    siteConfig: {
      linuxFxVersion: 'DOCKER|${containerRegistryName}.azurecr.io/${containerRegistryImageName}:${containerRegistryImageVersion}'
      appCommandLine: ''      
    }
    appSettingsKeyValuePairs: {
      WEBSITES_ENABLE_APP_SERVICE_STORAGE: 'false'
    }
    
    dockerRegistryServerUrl: 'https://${containerRegistryName}.azurecr.io'
    dockerRegistryServerUserName: keyvault.getSecret(acrAdminUserNameSecretName)
    dockerRegistryServerPassword: keyvault.getSecret(acrAdminPassword0SecretName)
    dockerRegistryServerPassword1: keyvault.getSecret(acrAdminPassword1SecretName)
  }
} 

resource keyvault 'Microsoft.KeyVault/vaults@2023-02-01' existing = {
  name: keyVaultName
}
