terraform {
  backend "azurerm" {}
}

data "azurerm_subscription" "current" {}

data "azurerm_virtual_network" "itds_vnet" {
  name = "${var.vnet_name}"
  resource_group_name = "${var.vnet_rg_name}"
}

resource "azurerm_resource_group" "itds_hdi_sprk_rg" {
  name = "${var.env_prefix_hypon}-hdi-sprk-rg"
  location = "${var.env_location}"
}

resource "azurerm_management_lock" "itds_rg_lk" {
  name = "${var.env_prefix_hypon}-shrd-rg-lk"
  scope = "${azurerm_resource_group.itds_hdi_sprk_rg.id}"
  lock_level = "CanNotDelete"
  notes = "${azurerm_resource_group.itds_hdi_sprk_rg.name} resource group can not be deleted"
  count = "${var.env_disable_lk}"
}

resource "azurerm_user_assigned_identity" "itds_hdi_sprk_mid" {
  resource_group_name = "${azurerm_resource_group.itds_hdi_sprk_rg.name}"
  location            = "${azurerm_resource_group.itds_hdi_sprk_rg.location}"
  name = "${var.env_prefix_hypon}-hdi-sprk-mid"
}

resource "azurerm_network_security_group" "itds_hdi_sprk_nsg" {
  name = "${var.env_prefix_hypon}-hdi-sprk-nsg"
  resource_group_name = "${azurerm_resource_group.itds_hdi_sprk_rg.name}"
  location = "${azurerm_resource_group.itds_hdi_sprk_rg.location}"

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

resource "azurerm_subnet" "itds_hdi_sprk_snet" {
  name = "${var.env_prefix_hypon}-hdi-sprk-snet"
  virtual_network_name = "${var.vnet_name}"
  resource_group_name = "${var.vnet_rg_name}"
  address_prefix = "${var.hdi_sprk_snet_addr_pfx}"
}

resource "azurerm_subnet_network_security_group_association" "itds_hdi_sprk_snet_nsg_asso" {
  subnet_id = "${azurerm_subnet.itds_hdi_sprk_snet.id}"
  network_security_group_id = "${azurerm_network_security_group.itds_hdi_sprk_nsg.id}"
}


resource "null_resource" "itds_hdi_sprk" {
  provisioner "local-exec" {
    command = "az account set --subscription ${data.azurerm_subscription.current.id} && az group deployment create --name "$deploymentName" --resource-group ${azurerm_resource_group.itds_hdi_sprk_rg} --template-file "$templateFilePath" --parameters "@${parametersFilePath}""
  }
  depends_on = [
    "azurerm_resource_group.itds_shrd_rg"
  ]
}
