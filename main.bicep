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
module containerRegistry 'modules/container-registry.bicep' = {
  name: containerRegistryName
  params: {
    name: containerRegistryName
    location: location
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


@sys.description('static web app name')
param StaticWebAppName string
param containerRegistryImageVersion string = 'latest'
param containerRegistryImageName string

module StaticWebApp 'modules/web-app.bicep' = {
  name: StaticWebAppName
  params: {
    staticWebAppName: StaticWebAppName
    location: location
    appServicePlanId: appServicePlan.outputs.id
    dockerRegistryName : containerRegistryName
    dockerRegistryImageName: containerRegistryImageName
    dockerRegistryImageVersion: containerRegistryImageVersion
    dockerRegistryServerUserName: containerRegistry.outputs.adminUsername
    dockerRegistryServerPassword: containerRegistry.outputs.adminPassword
  }
}
