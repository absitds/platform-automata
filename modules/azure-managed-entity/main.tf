terraform {
  backend "azurerm" {}
}

data "azurerm_subscription" "current" {}


resource "azurerm_resource_group" "itds_shrd_srv_mid_rg" {
  name = "${var.env_prefix_hypon}-shrd-srv-acr-rg"
  location = "${var.env_location}"
}

