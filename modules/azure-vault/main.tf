terraform {
  backend "azurerm" {}
}

data "azurerm_subscription" "current" {}

resource "azurerm_resource_group" "itds_shrd_srv_vlt_rg" {
  name = "${var.env_prefix_hypon}-shrd-srv-vlt-rg"
  location = "${var.env_location}"
}

/*
resource "azurerm_management_lock" "itds_shrd_srv_vlt_lk" {
  name = "${var.env_prefix_hypon}-shrd-srv-vlt-rg-lk"
  scope = "${azurerm_resource_group.itds_shrd_srv_vlt_rg.id}"
  lock_level = "CanNotDelete"
  notes = "${azurerm_resource_group.itds_shrd_srv_vlt_rg.name} resource group can not be deleted"
}
*/

resource "azurerm_key_vault" "itds_shrd_srv_vlt" {
  name                        = "${var.shsrv_vlt}"
  location                    = "${azurerm_resource_group.itds_shrd_srv_vlt_rg.location}"
  resource_group_name         = "${azurerm_resource_group.itds_shrd_srv_vlt_rg.name}"
  enabled_for_disk_encryption = true
  enabled_for_deployment = true
  enabled_for_template_deployment = true
  tenant_id                   = "${var.tenant_id}"

  sku {
    name = "premium"
  }

  network_acls {
    default_action = "Deny"
    bypass         = "AzureServices"
    ip_rules = [ "${var.vnet_address_space}"]
  }

}

/*
resource "azurerm_key_vault_access_policy" "test" {
  vault_name          = "${azurerm_key_vault.itds_shrd_srv_vlt.name}"
  resource_group_name = "${azurerm_key_vault.itds_shrd_srv_vlt.resource_group_name}"

  tenant_id = "${var.tenant_id}"
  object_id = "11111111-1111-1111-1111-111111111111"

  key_permissions = [
    "get",
  ]

  secret_permissions = [
    "get",
  ]
}
*/