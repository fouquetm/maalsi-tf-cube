resource "azurerm_resource_group" "main" {
  name = "rg-${var.project_name}"
  location = var.location

  tags = local.tags
}

resource "azurerm_virtual_network" "main" {
  name                = "vnet-${var.project_name}"
  address_space       = ["10.224.0.0/12"]
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  tags = local.tags
}

resource "azurerm_subnet" "aks" {
  name                 = "sn-aks"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.224.0.0/16"]
}

resource "azurerm_kubernetes_cluster" "main" {
  name                = "aks-${var.project_name}"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  dns_prefix          = "aks-${var.project_name}-dns"
  node_resource_group = "rg-aks-${var.project_name}-managed"

  http_application_routing_enabled = true
  image_cleaner_enabled = true
  image_cleaner_interval_hours = 48

  default_node_pool {
    name       = "default"
    vm_size    = var.aks_nodes_vm_size
    enable_auto_scaling = true      # enable nodes auto-scaling
    vnet_subnet_id = azurerm_subnet.aks.id  # attach to aks subnet. prevent from virtual network auto-creation
    temporary_name_for_rotation = "temp"
    node_count = 1
    min_count = 1
    max_count = 5
  }

  key_vault_secrets_provider {
    secret_rotation_enabled = true  # enable key vault use
    secret_rotation_interval = "30s"   # seconds
  }

  oms_agent {   # enable monitoring
    log_analytics_workspace_id = azurerm_log_analytics_workspace.main.id
  }

  identity {    # enable managed identity
    type = "SystemAssigned"
  }

  tags = local.tags
}

resource "azurerm_log_analytics_workspace" "main" {
  name                = "logs-${var.project_name}"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  sku                 = "PerGB2018"
  retention_in_days   = 30

  tags = local.tags
}

resource "azurerm_storage_account" "main" {
  name                     = "st${local.project_name_without_special}"
  resource_group_name      = azurerm_resource_group.main.name
  location                 = azurerm_resource_group.main.location
  account_tier             = "Standard"
  account_replication_type = "ZRS"

  tags = local.tags
}

resource "azurerm_key_vault" "main" {
  name                = "kv-${var.project_name}"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  tenant_id           = azurerm_kubernetes_cluster.main.identity[0].tenant_id
  sku_name            = "standard"

  tags = local.tags
}