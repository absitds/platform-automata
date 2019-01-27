terraform {
  backend "azurerm" {}
}

data "azurerm_subscription" "current" {}

resource "azurerm_resource_group" "itds_shrd_srv_lgx_rg" {
  name = "${var.env_prefix_hypon}-shrd-srv-lgx-rg"
  location = "${var.env_location_wus1}"
}

/*
resource "azurerm_management_lock" "itds_shrd_srv_lgx_lk" {
  name = "${var.env_prefix_hypon}-shrd-srv-lgx-rg-lk"
  scope = "${azurerm_resource_group.itds_shrd_srv_lgx_rg.id}"
  lock_level = "CanNotDelete"
  notes = "${azurerm_resource_group.itds_shrd_srv_lgx_rg.name} resource group can not be deleted"
}
*/

resource "azurerm_log_analytics_workspace" "itds_shrd_srv_lgx_wksp" {
  name                = "${var.env_prefix_hypon}-shrd-srv-lgx-wksp"
  location            = "${azurerm_resource_group.itds_shrd_srv_lgx_rg.location}"
  resource_group_name = "${azurerm_resource_group.itds_shrd_srv_lgx_rg.name}"
  sku                 = "${var.shrd_srv_lgx_sku}"
  retention_in_days   = "${var.shrd_srv_lgx_rtn_dys}"
}