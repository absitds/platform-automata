terraform {
  backend "azurerm" {}
}

data "azurerm_subscription" "current" {}

data "azurerm_virtual_network" "itds_vnet" {
  name = "${var.vnet_name}"
  resource_group_name = "${var.vnet_rg_name}"
}

resource "azurerm_resource_group" "itds_hdi_kfka_rg" {
  name = "${var.env_prefix_hypon}-hdi-kfka-rg"
  location = "${var.env_location}"
}

resource "azurerm_management_lock" "itds_rg_lk" {
  name = "${var.env_prefix_hypon}-shrd-rg-lk"
  scope = "${azurerm_resource_group.itds_hdi_kfka_rg.id}"
  lock_level = "CanNotDelete"
  notes = "${azurerm_resource_group.itds_hdi_kfka_rg.name} resource group can not be deleted"
  count = "${var.env_disable_lk}"
}

resource "azurerm_user_assigned_identity" "itds_hdi_kfka_mid" {
  resource_group_name = "${azurerm_resource_group.itds_hdi_kfka_rg.name}"
  location            = "${azurerm_resource_group.itds_hdi_kfka_rg.location}"
  name = "${var.env_prefix_hypon}-hdi-kfka-mid"
}

resource "azurerm_network_security_group" "itds_hdi_kfka_nsg" {
  name = "${var.env_prefix_hypon}-hdi-kfka-nsg"
  resource_group_name = "${azurerm_resource_group.itds_hdi_kfka_rg.name}"
  location = "${azurerm_resource_group.itds_hdi_kfka_rg.location}"

  security_rule {
    name = "port_any_inbound"
    priority = 100
    direction = "Inbound"
    access = "Allow"
    protocol = "Tcp"
    source_port_range = "*"
    destination_port_range = "*"
    source_address_prefix = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name = "port_any_outbound"
    priority = 100
    direction = "Outbound"
    access = "Allow"
    protocol = "Tcp"
    source_port_range = "*"
    destination_port_range = "*"
    source_address_prefix = "*"
    destination_address_prefix = "*"
  }

}

resource "azurerm_subnet" "itds_hdi_kfka_snet" {
  name = "${var.env_prefix_hypon}-hdi-kfka-snet"
  virtual_network_name = "${var.vnet_name}"
  resource_group_name = "${var.vnet_rg_name}"
  address_prefix = "${var.hdi_kfka_snet_addr_pfx}"
}

resource "azurerm_subnet_network_security_group_association" "itds_hdi_kfka_snet_nsg_asso" {
  subnet_id = "${azurerm_subnet.itds_hdi_kfka_snet.id}"
  network_security_group_id = "${azurerm_network_security_group.itds_hdi_kfka_nsg.id}"
}


#HDInsight clusters in the same Virtual Network requires each cluster to have unique first six characters
