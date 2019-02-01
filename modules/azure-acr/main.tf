terraform {
  backend "azurerm" {}
}

data "azurerm_subscription" "current" {}

resource "azurerm_resource_group" "itds_shrd_srv_acr_rg" {
  name = "${var.env_prefix_hypon}-shrd-srv-acr-rg"
  location = "${var.env_location}"
}

resource "azurerm_management_lock" "itds_shrd_srv_acr_lk" {
  name = "${var.env_prefix_hypon}-shrd-srv-acr-rg-lk"
  scope = "${azurerm_resource_group.itds_shrd_srv_acr_rg.id}"
  lock_level = "CanNotDelete"
  notes = "${azurerm_resource_group.itds_shrd_srv_acr_rg.name} resource group can not be deleted"
  count = "${var.env_disable_lk}"
}

resource "azurerm_container_registry" "itds_shrd_srv_acr" {
  name                     = "${var.shsrv_acr}"
  resource_group_name      = "${azurerm_resource_group.itds_shrd_srv_acr_rg.name}"
  location                 = "${azurerm_resource_group.itds_shrd_srv_acr_rg.location}"
  sku                      = "Standard"
  admin_enabled            = true
}