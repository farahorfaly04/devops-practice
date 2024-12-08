metadata name = 'App Service Plan'
metadata description = 'This module deploys an App Service Plan.'
metadata owner = 'Azure/module-maintainers'

param name string
param location string = resourceGroup().location
param sku object = {
  capacity: 1
  family: 'B'
  name: 'B1'
  size: 'B1'
  tier: 'Basic'
}

param kind string = 'Linux'
param reserved bool = true

resource appServicePlan 'Microsoft.Web/serverfarms@2022-09-01' = {
  name: name
  kind: kind
  location: location
  sku: {
    name: sku.name
    capacity: sku.capacity
    tier: sku.tier
    family: sku.family
    size: sku.size
  }
  properties: {
    reserved: reserved
  }
}

output id string = appServicePlan.id
