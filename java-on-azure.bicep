@description('Specifies region of all resources.')
param location string = resourceGroup().location

@description('Suffix for function app, storage account, and key vault names.')
param appNameSuffix string = uniqueString(resourceGroup().id)

var storageAccountName = 'fnstor${replace(appNameSuffix, '-', '')}'

resource storageAccount 'Microsoft.Storage/storageAccounts@2021-04-01' = {
  name: storageAccountName
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
  properties: {
    supportsHttpsTrafficOnly: true
    encryption: {
      services: {
        file: {
          keyType: 'Account'
          enabled: true
        }
        blob: {
          keyType: 'Account'
          enabled: true
        }
      }
      keySource: 'Microsoft.Storage'
    }
    accessTier: 'Hot'
  }
}

resource logAnalytics 'Microsoft.OperationalInsights/workspaces@2021-06-01' = {
  name: 'law-${appNameSuffix}'
  location: location
  properties: {
    sku: {
      name: 'PerGB2018'
    }
  }
}

resource appInsights 'Microsoft.Insights/components@2020-02-02' = {
  name: 'appi-${appNameSuffix}'
  location: location
  kind: 'web'
  properties: {
    Application_Type: 'web'
    publicNetworkAccessForIngestion: 'Enabled'
    publicNetworkAccessForQuery: 'Enabled'
    WorkspaceResourceId: logAnalytics.id
    IngestionMode: 'LogAnalytics'
  }
}

resource funcPlan 'Microsoft.Web/serverfarms@2020-12-01' = {
  name: 'asp-func-${appNameSuffix}'
  location: location
  kind: 'functionapp'
  sku: {
    name: 'Y1'
  }
  properties: {
    reserved: true
  }
}

resource webappPlan 'Microsoft.Web/serverfarms@2020-12-01' = {
  name: 'asp-webapp-${appNameSuffix}'
  location: location
  sku: {
    name: 'P1V2'
  }
  properties: {
    reserved: true
  }
}

resource functionApp 'Microsoft.Web/sites@2020-12-01' = {
  name: 'fn-${appNameSuffix}'
  location: location
  kind: 'functionapp'
  properties: {
    serverFarmId: funcPlan.id
    siteConfig: {
      appSettings: [
        {
          name: 'AzureWebJobsStorage'
          value: 'DefaultEndpointsProtocol=https;AccountName=${storageAccount.name};EndpointSuffix=${environment().suffixes.storage};AccountKey=${listKeys(storageAccount.id, storageAccount.apiVersion).keys[0].value}'
        }
        {
          name: 'WEBSITE_CONTENTAZUREFILECONNECTIONSTRING'
          value: 'DefaultEndpointsProtocol=https;AccountName=${storageAccount.name};EndpointSuffix=${environment().suffixes.storage};AccountKey=${listKeys(storageAccount.id, storageAccount.apiVersion).keys[0].value}'
        }
        {
          name: 'APPINSIGHTS_INSTRUMENTATIONKEY'
          value: appInsights.properties.InstrumentationKey
        }
        {
          name: 'APPLICATIONINSIGHTS_CONNECTION_STRING'
          value: 'InstrumentationKey=${appInsights.properties.InstrumentationKey}'
        }
        {
          name: 'FUNCTIONS_WORKER_RUNTIME'
          value: 'custom'
        }
        {
          name: 'FUNCTIONS_EXTENSION_VERSION'
          value: '~4'
        }
      ]
    }
    httpsOnly: true
  }
}

resource app 'Microsoft.Web/sites@2020-12-01' = {
  name: 'webapp-java-${appNameSuffix}'
  location: location
  properties: {
    serverFarmId: webappPlan.id
    siteConfig: {
      linuxFxVersion: 'JAVA|17-java17'
      appSettings: [
        {
          name: 'APPINSIGHTS_INSTRUMENTATIONKEY'
          value: appInsights.properties.InstrumentationKey
        }
        {
          name: 'APPLICATIONINSIGHTS_CONNECTION_STRING'
          value: 'InstrumentationKey=${appInsights.properties.InstrumentationKey};IngestionEndpoint=https://westeurope-5.in.applicationinsights.azure.com/;LiveEndpoint=https://westeurope.livediagnostics.monitor.azure.com/'
        }
        {
          name: 'ApplicationInsightsAgent_EXTENSION_VERSION'
          value: '~3'
        }
      ]
    }
    httpsOnly: true
  }
}

resource appDocker 'Microsoft.Web/sites@2020-12-01' = {
  name: 'webapp-docker-${appNameSuffix}'
  location: location
  properties: {
    serverFarmId: webappPlan.id
    siteConfig: {
      linuxFxVersion: 'DOCKER|ghcr.io/derkoe/azure-java-realworld-app:latest'
      appSettings: [
        {
          name: 'APPINSIGHTS_INSTRUMENTATIONKEY'
          value: appInsights.properties.InstrumentationKey
        }
        {
          name: 'APPLICATIONINSIGHTS_CONNECTION_STRING'
          value: 'InstrumentationKey=${appInsights.properties.InstrumentationKey};IngestionEndpoint=https://westeurope-5.in.applicationinsights.azure.com/;LiveEndpoint=https://westeurope.livediagnostics.monitor.azure.com/'
        }
        {
          name: 'ApplicationInsightsAgent_EXTENSION_VERSION'
          value: '~3'
        }
        {
          name: 'WEBSITES_PORT'
          value: '8080'
        }
      ]
    }
    httpsOnly: true
  }
}

// replace with 'Microsoft.Web/kubeEnvironments@2021-03-01' when it works
resource containerappEnvironment 'Microsoft.App/managedEnvironments@2022-01-01-preview' = {
  name: 'cae-${appNameSuffix}'
  location: location
  properties: {
    #disable-next-line BCP037
    type: 'Managed'
    appLogsConfiguration: {
      destination: 'log-analytics'
      logAnalyticsConfiguration: {
        customerId: logAnalytics.properties.customerId
        sharedKey: logAnalytics.listKeys().primarySharedKey
      }
    }
  }
}

// TODO replace with 'Microsoft.Web/containerApps@2021-03-01' when it works
resource containerapp 'Microsoft.App/containerApps@2022-01-01-preview' = {
  name: 'capp-${appNameSuffix}'
  location: location
  properties: {
    managedEnvironmentId: containerappEnvironment.id
    configuration: {
      activeRevisionsMode: 'single'
      secrets: []
      registries: []
      ingress: {
        external: true
        targetPort: 8080
        transport: 'auto'
      }
    }
    template: {
      containers: [
        {
          name: 'realworld-app'
          image: 'ghcr.io/derkoe/azure-java-realworld-app:latest'
          command: []
          env: [
            {
              name: 'APPINSIGHTS_INSTRUMENTATIONKEY'
              value: appInsights.properties.InstrumentationKey
            }
            {
              name: 'APPLICATIONINSIGHTS_CONNECTION_STRING'
              value: 'InstrumentationKey=${appInsights.properties.InstrumentationKey};IngestionEndpoint=https://westeurope-5.in.applicationinsights.azure.com/;LiveEndpoint=https://westeurope.livediagnostics.monitor.azure.com/'
            }    
          ]
          resources: {
            #disable-next-line BCP036
            cpu: '.5'
            memory: '1Gi'
          }
        }
      ]
      scale: {
        minReplicas: 1
        maxReplicas: 1
      }
    }
  }
}
