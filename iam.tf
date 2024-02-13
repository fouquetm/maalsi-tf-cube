# droits de manipuler le storage account
resource "azurerm_role_assignment" "aks_sa_main_contrib" {
  scope                = azurerm_storage_account.main.id
  role_definition_name = "Storage Account Contributor"
  principal_id         = azurerm_kubernetes_cluster.main.identity[0].principal_id
}

# droits de manipuler des objets de type blob dans le storage account
resource "azurerm_role_assignment" "aks_sa_main_blob_contrib" {
  scope                = azurerm_storage_account.main.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = azurerm_kubernetes_cluster.main.identity[0].principal_id
}

# droits de manipuler des objets de type fileshare dans le storage account
resource "azurerm_role_assignment" "aks_sa_main_fs_contrib" {
  scope                = azurerm_storage_account.main.id
  role_definition_name = "Storage File Data Privileged Contributor"
  principal_id         = azurerm_kubernetes_cluster.main.identity[0].principal_id
}

# droits d'aller chercher des secrets dans le key vault
resource "azurerm_key_vault_access_policy" "aks_secrets_get_list" {
  key_vault_id = azurerm_key_vault.main.id
  tenant_id    = azurerm_kubernetes_cluster.main.identity[0].tenant_id
  object_id    = azurerm_kubernetes_cluster.main.key_vault_secrets_provider[0].secret_identity[0].object_id

  secret_permissions = [
    "Get"
  ]
}