terraform {
  backend "azurerm" {}
}

data "azurerm_subscription" "current" {}

data "azurerm_virtual_network" "itds_vnet" {
  name = "${var.vnet_name}"
  resource_group_name = "${var.vnet_rg_name}"
}

resource "azurerm_resource_group" "itds_hdi_sprk_rg" {
  name = "${var.env_prefix_hypon}-hdi-${var.hdi_sprk_clus_nm_unq_pfx}-rg"
  location = "${var.env_location}"
}

resource "azurerm_management_lock" "itds_rg_lk" {
  name = "${var.env_prefix_hypon}-hdi-${var.hdi_sprk_clus_nm_unq_pfx}-rg-lk"
  scope = "${azurerm_resource_group.itds_hdi_sprk_rg.id}"
  lock_level = "CanNotDelete"
  notes = "${azurerm_resource_group.itds_hdi_sprk_rg.name} resource group can not be deleted"
  count = "${var.env_disable_lk}"
}

resource "azurerm_user_assigned_identity" "itds_hdi_sprk_mid" {
  resource_group_name = "${azurerm_resource_group.itds_hdi_sprk_rg.name}"
  location            = "${azurerm_resource_group.itds_hdi_sprk_rg.location}"
  name = "${var.hdi_sprk_clus_mid}"
}

resource "azurerm_network_security_group" "itds_hdi_sprk_nsg" {
  name = "${var.env_prefix_hypon}-hdi-${var.hdi_sprk_clus_nm_unq_pfx}-nsg"
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
  name = "${var.env_prefix_hypon}-hdi-${var.hdi_sprk_clus_nm_unq_pfx}-snet"
  virtual_network_name = "${var.vnet_name}"
  resource_group_name = "${var.vnet_rg_name}"
  address_prefix = "${var.hdi_sprk_snet_addr_pfx}"
}

resource "azurerm_subnet_network_security_group_association" "itds_hdi_sprk_snet_nsg_asso" {
  subnet_id = "${azurerm_subnet.itds_hdi_sprk_snet.id}"
  network_security_group_id = "${azurerm_network_security_group.itds_hdi_sprk_nsg.id}"
}


resource "null_resource" "itds_hdi_sprk_sa" {
  provisioner "local-exec" {
    command = "az extension add --name storage-preview && az storage account create --name ${var.hdi_sprk_strj_acc} --resource-group ${azurerm_resource_group.itds_hdi_sprk_rg.name} --kind StorageV2 --hierarchical-namespace --https-only true --assign-identity --sku Standard_LRS"
  }
  depends_on = [
    "azurerm_resource_group.itds_hdi_sprk_rg"
  ]
}


resource "azurerm_role_assignment" "itds_hdi_sprk_sa" {
  scope                = "${data.azurerm_subscription.current.id}"
  role_definition_id = "/subscriptions/f0a049d7-bb54-4698-89a3-04b140a152c0/providers/Microsoft.Authorization/roleDefinitions/ba92f5b4-2d11-453d-a403-e96b0029c9fe"
  principal_id         = "${azurerm_user_assigned_identity.itds_hdi_sprk_mid.principal_id}"
}



resource "null_resource" "itds_hdi_sprk" {
  provisioner "local-exec" {
    command = "az hdinsight create --name ${var.hdi_sprk_clus_nm} --resource-group ${azurerm_resource_group.itds_hdi_sprk_rg.name} --type spark --assign-identity ${azurerm_user_assigned_identity.itds_hdi_sprk_mid.name} --cluster-tier ${var.hdi_sprk_clus_tir} --edgenode-size ${var.hdi_sprk_eg_nd_sz} --esp false --headnode-size ${var.hdi_sprk_hd_nd_sz} --http-password ${var.hdi_sprk_htp_psswd} --http-user ${var.hdi_sprk_htp_usr} --location ${azurerm_resource_group.itds_hdi_sprk_rg.location} --size ${var.hdi_sprk_wrk_nd_sz} --ssh-user ${var.hdi_sprk_ssh_usr} --ssh-password ${var.hdi_sprk_ssh_psswd} --storage-account ${var.hdi_sprk_strj_acc} --storage-default-container ${var.hdi_sprk_strj_acc_def_cnt} --subnet ${azurerm_subnet.itds_hdi_sprk_snet.name} --subscription ${data.azurerm_subscription.current.display_name} --version ${var.hdi_sprk_ver} --vnet-name ${var.hdi_sprk_vnet_nm} --workernode-data-disk-size ${var.hdi_sprk_wrk_nd_dd_sz} --workernode-data-disk-storage-account-type ${var.hdi_sprk_wrk_nd_dd_sa_ty} --workernode-data-disks-per-node ${var.hdi_sprk_wrk_nd_dd_cnt} --workernode-size ${var.hdi_sprk_wrk_nd_sz} --zookeepernode-size ${var.hdi_sprk_zk_nd_sz}"
  }
  depends_on = [
    "azurerm_user_assigned_identity.itds_hdi_sprk_mid",
    "azurerm_resource_group.itds_hdi_sprk_rg",
    "azurerm_subnet_network_security_group_association.itds_hdi_sprk_snet_nsg_asso",
    "azurerm_subnet.itds_hdi_sprk_snet",
    "null_resource.itds_hdi_sprk_sa"

  ]
}

