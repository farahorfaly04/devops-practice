using '../main.bicep'

param appServicePlanName = 'farahServicePlan'

param containerRegistryName = 'farahContainerRegistry'

param webAppName = 'farahWebApp'

param containerRegistryImageName = 'farahimage'

param keyVaultName = 'farahKeyVault'

param roleAssignments = [
  {
    principalId: 'a03130df-486f-46ea-9d5c-70522fe056de' // Group.
    roleDefinitionIdOrName: 'Key Vault Administrator'
    principalType: 'Group'
  }

  {
    principalId: '25d8d697-c4a2-479f-96e0-15593a830ae5'
    roleDefinitionIdOrName: 'Key Vault Secrets User'
    principalType: 'ServicePrincipal'
  }
]
