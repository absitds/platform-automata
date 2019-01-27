terraform {
  backend "azurerm" {}
}

data "azurerm_subscription" "current" {}

resource "azurerm_resource_group" "itds_shrd_rg" {
  name = "${var.env_prefix_hypon}-shrd-rg"
  location = "${var.env_location}"
}

resource "azurerm_management_lock" "itds_rg_lk" {
  name = "${var.env_prefix_hypon}-shrd-rg-lk"
  scope = "${azurerm_resource_group.itds_shrd_rg.id}"
  lock_level = "CanNotDelete"
  notes = "${azurerm_resource_group.itds_shrd_rg.name} resource group can not be deleted"
}

resource "null_resource" "itds_shrd_sa" {
  provisioner "local-exec" {
    command = "az extension add --name storage-preview && az storage account create --name ${var.shsrv_sa} --resource-group ${azurerm_resource_group.itds_shrd_rg.name} --kind StorageV2 --hierarchical-namespace --https-only true --assign-identity --sku Standard_LRS"
  }
  depends_on = [
    "azurerm_resource_group.itds_shrd_rg"
  ]
}

/*
resource "null_resource" "itds_shrd_sa_lyrs" {
  provisioner "local-exec" {
    command = "az dls fs create --account ${var.shsrv_sa} --folder --path /default"
  }
  provisioner "local-exec" {
    command = "az dls fs create --account ${var.shsrv_sa} --folder --path /default/stage"
  }
  provisioner "local-exec" {
    command = "az dls fs create --account ${var.shsrv_sa} --folder --path /default/stage/in"
  }
  provisioner "local-exec" {
    command = "az dls fs create --account ${var.shsrv_sa} --folder --path /default/stage/out"
  }
  provisioner "local-exec" {
    command = "az dls fs create --account ${var.shsrv_sa} --folder --path /default/raw"
  }
  provisioner "local-exec" {
    command = "az dls fs create --account ${var.shsrv_sa} --folder --path /default/smith"
  }
  provisioner "local-exec" {
    command = "az dls fs create --account ${var.shsrv_sa} --folder --path /default/gold"
  }
  provisioner "local-exec" {
    command = "az dls fs create --account ${var.shsrv_sa} --folder --path /default/trans"
  }
  provisioner "local-exec" {
    command = "az dls fs create --account ${var.shsrv_sa} --folder --path /default/work"
  }
  provisioner "local-exec" {
    command = "az dls fs create --account ${var.shsrv_sa} --folder --path /default/system"
  }

  depends_on = [
    "null_resource.itds_shrd_sa"
  ]
}


resource "null_resource" "itds_shrd_sa_subj_ars" {
  provisioner "local-exec" {
    command = "az dls fs create --account ${var.shsrv_sa} --folder --path /default/raw/finance"
  }
  provisioner "local-exec" {
    command = "az dls fs create --account ${var.shsrv_sa} --folder --path /default/raw/hr"
  }
  provisioner "local-exec" {
    command = "az dls fs create --account ${var.shsrv_sa} --folder --path /default/raw/inventory"
  }
  provisioner "local-exec" {
    command = "az dls fs create --account ${var.shsrv_sa} --folder --path /default/raw/location"
  }
  provisioner "local-exec" {
    command = "az dls fs create --account ${var.shsrv_sa} --folder --path /default/raw/loyalty"
  }
  provisioner "local-exec" {
    command = "az dls fs create --account ${var.shsrv_sa} --folder --path /default/raw/manufacturing"
  }
  provisioner "local-exec" {
    command = "az dls fs create --account ${var.shsrv_sa} --folder --path /default/raw/marketing"
  }
  provisioner "local-exec" {
    command = "az dls fs create --account ${var.shsrv_sa} --folder --path /default/raw/merchandising"
  }
  provisioner "local-exec" {
    command = "az dls fs create --account ${var.shsrv_sa} --folder --path /default/raw/party"
  }
  provisioner "local-exec" {
    command = "az dls fs create --account ${var.shsrv_sa} --folder --path /default/raw/product"
  }
  provisioner "local-exec" {
    command = "az dls fs create --account ${var.shsrv_sa} --folder --path /default/raw/promo_price"
  }
  provisioner "local-exec" {
    command = "az dls fs create --account ${var.shsrv_sa} --folder --path /default/raw/purchasing"
  }
  provisioner "local-exec" {
    command = "az dls fs create --account ${var.shsrv_sa} --folder --path /default/raw/real_estate"
  }
  provisioner "local-exec" {
    command = "az dls fs create --account ${var.shsrv_sa} --folder --path /default/raw/reference"
  }
  provisioner "local-exec" {
    command = "az dls fs create --account ${var.shsrv_sa} --folder --path /default/raw/retail"
  }
  provisioner "local-exec" {
    command = "az dls fs create --account ${var.shsrv_sa} --folder --path /default/raw/risk_mgmt"
  }
  provisioner "local-exec" {
    command = "az dls fs create --account ${var.shsrv_sa} --folder --path /default/raw/scm"
  }
  provisioner "local-exec" {
    command = "az dls fs create --account ${var.shsrv_sa} --folder --path /default/raw/transportation"
  }

  depends_on = [
    "null_resource.itds_shrd_sa_lyrs"
  ]
}

*/